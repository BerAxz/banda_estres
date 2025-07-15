import json
from channels.generic.websocket import AsyncWebsocketConsumer
from channels.db import database_sync_to_async
from django.db import models
from cuentas.models import Usuario
from .models import DatosFisiologicos, EventoAnsiedad, Sesion
from dispositivos.models import Pulsera
from django.utils import timezone
from datetime import timedelta

class DatosTiempoRealConsumer(AsyncWebsocketConsumer):
    async def connect(self):
        self.user_id = self.scope['url_route']['kwargs']['user_id']
        self.room_group_name = f'datos_tiempo_real_{self.user_id}'

        # Verificar que el usuario existe y tiene pulsera asignada
        usuario_valido = await self.verificar_usuario()
        
        if not usuario_valido:
            await self.close()
            return

        # Unirse al grupo del usuario
        await self.channel_layer.group_add(
            self.room_group_name,
            self.channel_name
        )

        await self.accept()
        
        # Enviar datos iniciales
        await self.enviar_datos_iniciales()

    async def disconnect(self, close_code):
        # Salir del grupo
        await self.channel_layer.group_discard(
            self.room_group_name,
            self.channel_name
        )

    async def receive(self, text_data):
        # Manejar mensajes del frontend si es necesario
        try:
            text_data_json = json.loads(text_data)
            message_type = text_data_json.get('type', 'ping')
            
            if message_type == 'ping':
                await self.send(text_data=json.dumps({
                    'type': 'pong',
                    'timestamp': timezone.now().isoformat()
                }))
            elif message_type == 'request_latest_data':
                await self.enviar_ultimos_datos()
                
        except json.JSONDecodeError:
            await self.send(text_data=json.dumps({
                'type': 'error',
                'message': 'Invalid JSON format'
            }))

    # Recibir datos del grupo
    async def nuevos_datos_fisiologicos(self, event):
        # Enviar datos al WebSocket
        await self.send(text_data=json.dumps({
            'type': 'nuevos_datos',
            'data': event['data']
        }))

    async def evento_ansiedad_detectado(self, event):
        # Enviar evento de ansiedad al WebSocket
        await self.send(text_data=json.dumps({
            'type': 'evento_ansiedad',
            'data': event['data']
        }))

    @database_sync_to_async
    def verificar_usuario(self):
        try:
            usuario = Usuario.objects.get(id=self.user_id)
            return usuario.pulsera_id is not None
        except Usuario.DoesNotExist:
            return False

    @database_sync_to_async
    def obtener_datos_iniciales(self):
        try:
            usuario = Usuario.objects.get(id=self.user_id)
            if not usuario.pulsera_id:
                return None
                
            # Últimos 10 datos
            ultimos_datos = DatosFisiologicos.objects.filter(
                usuario_id=usuario,
                pulsera_id=usuario.pulsera_id
            ).order_by('-timestamp')[:10]
            
            # Sesión activa
            sesion_activa = Sesion.objects.filter(
                usuario_id=usuario,
                pulsera_id=usuario.pulsera_id,
                estado='activa',
                fecha_fin__isnull=True
            ).first()
            
            datos_serializados = []
            for dato in ultimos_datos:
                datos_serializados.append({
                    'id': dato.id,
                    'timestamp': dato.timestamp.isoformat(),
                    'bpm': dato.bpm,
                    'spo2': dato.spo2,
                    'temperatura': float(dato.temperatura) if dato.temperatura else None,
                    'calidad_senal': dato.calidad_senal
                })
            
            return {
                'usuario': {
                    'id': usuario.id,
                    'email': usuario.email,
                    'nombre': usuario.nombre,
                    'apellido': usuario.apellido
                },
                'pulsera': {
                    'numero_serie': usuario.pulsera_id.numero_serie,
                    'modelo': usuario.pulsera_id.modelo,
                    'estado': usuario.pulsera_id.estado
                },
                'sesion_activa': {
                    'id': sesion_activa.id,
                    'fecha_inicio': sesion_activa.fecha_inicio.isoformat(),
                    'estado': sesion_activa.estado
                } if sesion_activa else None,
                'ultimos_datos': datos_serializados
            }
        except Exception as e:
            print(f"Error obteniendo datos iniciales: {e}")
            return None

    async def enviar_datos_iniciales(self):
        datos_iniciales = await self.obtener_datos_iniciales()
        if datos_iniciales:
            await self.send(text_data=json.dumps({
                'type': 'datos_iniciales',
                'data': datos_iniciales
            }))

    async def enviar_ultimos_datos(self):
        datos = await self.obtener_ultimos_datos()
        if datos:
            await self.send(text_data=json.dumps({
                'type': 'ultimos_datos',
                'data': datos
            }))

    @database_sync_to_async
    def obtener_ultimos_datos(self):
        try:
            usuario = Usuario.objects.get(id=self.user_id)
            if not usuario.pulsera_id:
                return None
                
            # Últimos 5 datos
            ultimos_datos = DatosFisiologicos.objects.filter(
                usuario_id=usuario,
                pulsera_id=usuario.pulsera_id
            ).order_by('-timestamp')[:5]
            
            datos_serializados = []
            for dato in ultimos_datos:
                datos_serializados.append({
                    'id': dato.id,
                    'timestamp': dato.timestamp.isoformat(),
                    'bpm': dato.bpm,
                    'spo2': dato.spo2,
                    'temperatura': float(dato.temperatura) if dato.temperatura else None,
                    'calidad_senal': dato.calidad_senal
                })
            
            return datos_serializados
        except Exception as e:
            print(f"Error obteniendo últimos datos: {e}")
            return None


class EventosAnsiedadConsumer(AsyncWebsocketConsumer):
    async def connect(self):
        self.user_id = self.scope['url_route']['kwargs']['user_id']
        self.room_group_name = f'eventos_ansiedad_{self.user_id}'

        # Verificar usuario
        usuario_valido = await self.verificar_usuario()
        
        if not usuario_valido:
            await self.close()
            return

        await self.channel_layer.group_add(
            self.room_group_name,
            self.channel_name
        )

        await self.accept()

    async def disconnect(self, close_code):
        await self.channel_layer.group_discard(
            self.room_group_name,
            self.channel_name
        )

    async def nuevo_evento_ansiedad(self, event):
        await self.send(text_data=json.dumps({
            'type': 'nuevo_evento',
            'data': event['data']
        }))

    @database_sync_to_async
    def verificar_usuario(self):
        try:
            usuario = Usuario.objects.get(id=self.user_id)
            return usuario.pulsera_id is not None
        except Usuario.DoesNotExist:
            return False


class DashboardConsumer(AsyncWebsocketConsumer):
    """Consumer para datos del dashboard completo"""
    
    async def connect(self):
        self.user_id = self.scope['url_route']['kwargs']['user_id']
        self.room_group_name = f'dashboard_{self.user_id}'

        usuario_valido = await self.verificar_usuario()
        
        if not usuario_valido:
            await self.close()
            return

        await self.channel_layer.group_add(
            self.room_group_name,
            self.channel_name
        )

        await self.accept()
        
        # Enviar resumen del dashboard
        await self.enviar_resumen_dashboard()

    async def disconnect(self, close_code):
        await self.channel_layer.group_discard(
            self.room_group_name,
            self.channel_name
        )

    async def actualizar_dashboard(self, event):
        await self.send(text_data=json.dumps({
            'type': 'dashboard_update',
            'data': event['data']
        }))

    @database_sync_to_async
    def verificar_usuario(self):
        try:
            usuario = Usuario.objects.get(id=self.user_id)
            return usuario.pulsera_id is not None
        except Usuario.DoesNotExist:
            return False

    @database_sync_to_async
    def obtener_resumen_dashboard(self):
        try:
            usuario = Usuario.objects.get(id=self.user_id)
            if not usuario.pulsera_id:
                return None
            
            # Datos de las últimas 24 horas
            hace_24h = timezone.now() - timedelta(hours=24)
            
            # Estadísticas
            datos_hoy = DatosFisiologicos.objects.filter(
                usuario_id=usuario,
                pulsera_id=usuario.pulsera_id,
                timestamp__gte=hace_24h
            )
            
            eventos_hoy = EventoAnsiedad.objects.filter(
                usuario_id=usuario,
                timestamp__gte=hace_24h
            )
            
            # Promedios
            bpm_promedio = datos_hoy.aggregate(
                promedio=models.Avg('bpm')
            )['promedio']
            
            spo2_promedio = datos_hoy.aggregate(
                promedio=models.Avg('spo2')
            )['promedio']
            
            temp_promedio = datos_hoy.aggregate(
                promedio=models.Avg('temperatura')
            )['promedio']
            
            return {
                'estadisticas_24h': {
                    'total_mediciones': datos_hoy.count(),
                    'total_eventos_ansiedad': eventos_hoy.count(),
                    'bpm_promedio': round(bpm_promedio, 2) if bpm_promedio else None,
                    'spo2_promedio': round(spo2_promedio, 2) if spo2_promedio else None,
                    'temperatura_promedio': round(float(temp_promedio), 2) if temp_promedio else None,
                },
                'eventos_no_resueltos': eventos_hoy.filter(resuelto=False).count(),
                'sesion_activa': Sesion.objects.filter(
                    usuario_id=usuario,
                    estado='activa',
                    fecha_fin__isnull=True
                ).exists()
            }
        except Exception as e:
            print(f"Error obteniendo resumen dashboard: {e}")
            return None

    async def enviar_resumen_dashboard(self):
        resumen = await self.obtener_resumen_dashboard()
        if resumen:
            await self.send(text_data=json.dumps({
                'type': 'resumen_dashboard',
                'data': resumen
            }))
