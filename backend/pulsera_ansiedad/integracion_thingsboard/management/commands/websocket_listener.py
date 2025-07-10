from django.core.management.base import BaseCommand
import websocket
import json
import requests
import threading
from datetime import datetime
from sesiones.models import DatosFisiologicos, Sesion, EventoAnsiedad
from dispositivos.models import Pulsera
from cuentas.models import Usuario
from decimal import Decimal
from channels.layers import get_channel_layer
from asgiref.sync import async_to_sync
import asyncio

THINGSBOARD_HOST = "iot.ceisufro.cl:8080"
USERNAME = "b.almonacid01@ufromail.cl"
PASSWORD = "Bastianxd1"
DEVICE_ID = "f69bfc90-47a1-11f0-a76f-af9873efe2ab"
TOKEN_DISPOSITIVO = "Izv20eKxVGH8YNcTmQkg"  # Token del dispositivo fake

# Obtener el layer de channels para WebSockets
channel_layer = get_channel_layer()

def obtener_jwt():
    url = f"http://{THINGSBOARD_HOST}/api/auth/login"
    data = {"username": USERNAME, "password": PASSWORD}
    response = requests.post(url, json=data)
    response.raise_for_status()
    return response.json()['token']

def on_message(ws, message):
    print("Mensaje recibido:", message)
    data = json.loads(message)

    if "data" not in data:
        return

    payload = data["data"]

    try:
        timestamp_ms = int(payload["bpm"][0][0])
        timestamp = datetime.fromtimestamp(timestamp_ms / 1000)

        bpm = int(float(payload["bpm"][0][1]))
        spo2 = int(float(payload["spo2"][0][1]))
        temperatura = Decimal(payload["temperature"][0][1])
        calidad = int(payload.get("calidad_senal", [[0, "0"]])[0][1]) 

        # Buscar la pulsera asociada al token del dispositivo fake
        try:
            pulsera = Pulsera.objects.filter(
                configuracion_hardware__token_thingsboard=TOKEN_DISPOSITIVO
            ).first()
                
            # Buscar el usuario vinculado a esta pulsera
            usuario = Usuario.objects.filter(pulsera_id=pulsera).first()
            
            if not usuario:
                print("No se encontró usuario vinculado a la pulsera")
                return
                
            # Buscar sesión activa para este usuario y pulsera
            sesion_activa = Sesion.objects.filter(
                usuario_id=usuario,
                pulsera_id=pulsera,
                estado="activa",
                fecha_fin__isnull=True
            ).first()
            

            # Guardar los datos fisiológicos vinculados correctamente
            datos_fisio = DatosFisiologicos.objects.create(
                sesion_id=sesion_activa,
                usuario_id=usuario,
                pulsera_id=pulsera,
                timestamp=timestamp,
                bpm=bpm,
                spo2=spo2,
                temperatura=temperatura,
                calidad_senal=calidad,
                datos_raw=data
            )

            # Enviar datos via WebSocket al frontend
            enviar_datos_websocket(usuario, datos_fisio)

            # Detectar posibles eventos de ansiedad basados en umbrales
            evento_ansiedad = detectar_evento_ansiedad(datos_fisio, usuario, sesion_activa)
            
            if evento_ansiedad:
                enviar_evento_ansiedad_websocket(usuario, evento_ansiedad)

            print(f"Datos vinculados guardados - Usuario: {usuario.email}, BPM: {bpm}, SpO2: {spo2}, Temp: {temperatura}")

        except Exception as e:
            print(f"Error al vincular datos: {e}")
            # Como fallback, guardar sin vincular
            DatosFisiologicos.objects.create(
                sesion_id=None,
                usuario_id=None,
                pulsera_id=None,
                timestamp=timestamp,
                bpm=bpm,
                spo2=spo2,
                temperatura=temperatura,
                calidad_senal=calidad,
                datos_raw=data
            )

    except Exception as e:
        print("Error al procesar mensaje:", e)

def detectar_evento_ansiedad(datos_fisio, usuario, sesion):
    """
    Detecta eventos de ansiedad basados en los datos fisiológicos
    """
    try:
        # Obtener configuraciones del usuario
        config = usuario.configuracionesusuario_set.first()
        
        # Umbrales por defecto si no hay configuración
        umbral_bpm = config.umbral_personalizado_bpm if config else 100
        umbral_spo2_min = config.umbral_personalizado_spo2 if config else 95
        umbral_temp = config.umbral_personalizado_temp if config else Decimal('37.5')
        
        # Detectar anomalías
        anomalias = []
        nivel_ansiedad = 0
        
        if datos_fisio.bpm and datos_fisio.bpm > umbral_bpm:
            anomalias.append("bpm_elevado")
            nivel_ansiedad += 2
            
        if datos_fisio.spo2 and datos_fisio.spo2 < umbral_spo2_min:
            anomalias.append("spo2_bajo")
            nivel_ansiedad += 1
            
        if datos_fisio.temperatura and datos_fisio.temperatura > umbral_temp:
            anomalias.append("temperatura_elevada")
            nivel_ansiedad += 1
            
        # Si hay anomalías, crear evento de ansiedad
        if anomalias:
            evento = EventoAnsiedad.objects.create(
                sesion_id=sesion,
                usuario_id=usuario,
                timestamp=datos_fisio.timestamp,
                nivel_ansiedad=min(nivel_ansiedad, 5),  # Máximo nivel 5
                bpm_momento=datos_fisio.bpm,
                spo2_momento=datos_fisio.spo2,
                temperatura_momento=datos_fisio.temperatura,
                factores_detectados=anomalias,
                resuelto=False
            )
            print(f"Evento de ansiedad detectado - Nivel: {nivel_ansiedad}, Factores: {anomalias}")
            return evento
            
    except Exception as e:
        print(f"Error al detectar evento de ansiedad: {e}")
    
    return None

def enviar_datos_websocket(usuario, datos_fisio):
    """
    Envía los nuevos datos fisiológicos al frontend via WebSocket
    """
    try:
        if not channel_layer:
            print("Channel layer no disponible")
            return
            
        # Serializar los datos
        datos_serializados = {
            'id': datos_fisio.id,
            'timestamp': datos_fisio.timestamp.isoformat(),
            'bpm': datos_fisio.bpm,
            'spo2': datos_fisio.spo2,
            'temperatura': float(datos_fisio.temperatura) if datos_fisio.temperatura else None,
            'calidad_senal': datos_fisio.calidad_senal,
            'usuario_id': usuario.id,
            'pulsera_serie': usuario.pulsera_id.numero_serie if usuario.pulsera_id else None
        }
        
        # Enviar a todos los WebSockets del usuario
        room_group_name = f'datos_tiempo_real_{usuario.id}'
        async_to_sync(channel_layer.group_send)(
            room_group_name,
            {
                'type': 'nuevos_datos_fisiologicos',
                'data': datos_serializados
            }
        )
        
        # También enviar al dashboard
        dashboard_group_name = f'dashboard_{usuario.id}'
        async_to_sync(channel_layer.group_send)(
            dashboard_group_name,
            {
                'type': 'actualizar_dashboard',
                'data': {
                    'tipo': 'nuevos_datos',
                    'datos': datos_serializados
                }
            }
        )
        
        print(f"Datos enviados via WebSocket a usuario {usuario.email}")
        
    except Exception as e:
        print(f"Error enviando datos via WebSocket: {e}")

def enviar_evento_ansiedad_websocket(usuario, evento_ansiedad):
    """
    Envía evento de ansiedad al frontend via WebSocket
    """
    try:
        if not channel_layer:
            print("Channel layer no disponible")
            return
            
        # Serializar el evento
        evento_serializado = {
            'id': evento_ansiedad.id,
            'timestamp': evento_ansiedad.timestamp.isoformat(),
            'nivel_ansiedad': evento_ansiedad.nivel_ansiedad,
            'bpm_momento': evento_ansiedad.bpm_momento,
            'spo2_momento': evento_ansiedad.spo2_momento,
            'temperatura_momento': float(evento_ansiedad.temperatura_momento) if evento_ansiedad.temperatura_momento else None,
            'factores_detectados': evento_ansiedad.factores_detectados,
            'resuelto': evento_ansiedad.resuelto,
            'usuario_id': usuario.id
        }
        
        # Enviar a WebSocket de eventos de ansiedad
        room_group_name = f'eventos_ansiedad_{usuario.id}'
        async_to_sync(channel_layer.group_send)(
            room_group_name,
            {
                'type': 'nuevo_evento_ansiedad',
                'data': evento_serializado
            }
        )
        
        # También enviar al dashboard
        dashboard_group_name = f'dashboard_{usuario.id}'
        async_to_sync(channel_layer.group_send)(
            dashboard_group_name,
            {
                'type': 'actualizar_dashboard',
                'data': {
                    'tipo': 'evento_ansiedad',
                    'evento': evento_serializado
                }
            }
        )
        
        print(f"Evento de ansiedad enviado via WebSocket a usuario {usuario.email}")
        
    except Exception as e:
        print(f"Error enviando evento via WebSocket: {e}")

def on_open(ws):
    ws.send(json.dumps({
        "tsSubCmds": [{
            "entityType": "DEVICE",
            "entityId": DEVICE_ID,
            "scope": "LATEST_TELEMETRY",
            "cmdId": 1
        }],
        "historyCmds": [],
        "attrSubCmds": []
    }))

def iniciar_websocket(jwt_token):
    url_ws = f"ws://{THINGSBOARD_HOST}/api/ws/plugins/telemetry?token={jwt_token}"
    ws = websocket.WebSocketApp(url_ws, on_message=on_message, on_open=on_open)
    ws.run_forever()

class Command(BaseCommand):
    help = "Escucha datos en tiempo real desde ThingsBoard"

    def handle(self, *args, **options):
        print("Conectando a ThingsBoard WebSocket...")
        token = obtener_jwt()
        thread = threading.Thread(target=iniciar_websocket, args=(token,))
        thread.start()
        thread.join()