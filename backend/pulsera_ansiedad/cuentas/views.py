from django.shortcuts import render
from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from .models import Usuario , ConfiguracionesUsuario
from .serializers import UsuarioSerializer, ConfiguracionesUsuarioSerializer
from sesiones.models import Sesion, DatosFisiologicos
from django.utils import timezone
from datetime import timedelta

class UsuarioViewSet(viewsets.ModelViewSet):
    queryset = Usuario.objects.all()
    serializer_class = UsuarioSerializer
    
    @action(detail=False, methods=['get'], permission_classes=[IsAuthenticated])
    def perfil(self, request):
        """Obtiene el perfil completo del usuario autenticado"""
        usuario = request.user
        serializer = self.get_serializer(usuario)
        
        # Información adicional del perfil
        data = serializer.data
        
        # Información de la pulsera vinculada
        if usuario.pulsera_id:
            data['pulsera'] = {
                'numero_serie': usuario.pulsera_id.numero_serie,
                'modelo': usuario.pulsera_id.modelo,
                'estado': usuario.pulsera_id.estado,
                'fecha_activacion': usuario.pulsera_id.fecha_activacion
            }
            
            # Sesión activa
            sesion_activa = Sesion.objects.filter(
                usuario_id=usuario,
                pulsera_id=usuario.pulsera_id,
                estado='activa',
                fecha_fin__isnull=True
            ).first()
            
            if sesion_activa:
                data['sesion_activa'] = {
                    'id': sesion_activa.id,
                    'fecha_inicio': sesion_activa.fecha_inicio,
                    'estado': sesion_activa.estado
                }
                
                # Últimos datos fisiológicos
                ultimos_datos = DatosFisiologicos.objects.filter(
                    usuario_id=usuario,
                    pulsera_id=usuario.pulsera_id
                ).order_by('-timestamp').first()
                
                if ultimos_datos:
                    data['ultimos_datos'] = {
                        'timestamp': ultimos_datos.timestamp,
                        'bpm': ultimos_datos.bpm,
                        'spo2': ultimos_datos.spo2,
                        'temperatura': ultimos_datos.temperatura,
                        'calidad_senal': ultimos_datos.calidad_senal
                    }
        
        return Response(data)
    
    @action(detail=False, methods=['get'], permission_classes=[IsAuthenticated])
    def datos_recientes(self, request):
        """Obtiene los datos fisiológicos recientes del usuario"""
        usuario = request.user
        
        if not usuario.pulsera_id:
            return Response(
                {'error': 'Usuario no tiene pulsera asignada'}, 
                status=status.HTTP_404_NOT_FOUND
            )
        
        # Obtener datos de las últimas 24 horas
        hace_24h = timezone.now() - timedelta(hours=24)
        datos = DatosFisiologicos.objects.filter(
            usuario_id=usuario,
            pulsera_id=usuario.pulsera_id,
            timestamp__gte=hace_24h
        ).order_by('-timestamp')[:100]  # Últimos 100 registros
        
        datos_serializados = []
        for dato in datos:
            datos_serializados.append({
                'timestamp': dato.timestamp,
                'bpm': dato.bpm,
                'spo2': dato.spo2,
                'temperatura': dato.temperatura,
                'calidad_senal': dato.calidad_senal
            })
        
        return Response({
            'count': len(datos_serializados),
            'datos': datos_serializados
        })

class ConfiguracionesUsuarioViewSet(viewsets.ModelViewSet):
    queryset = ConfiguracionesUsuario.objects.all()
    serializer_class = ConfiguracionesUsuarioSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        """Filtrar configuraciones solo del usuario autenticado"""
        return ConfiguracionesUsuario.objects.filter(usuario=self.request.user)