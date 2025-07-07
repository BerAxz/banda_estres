from rest_framework import serializers
from .models import Usuario

class UsuarioSerializer(serializers.ModelSerializer):
    class Meta:
        model = Usuario
        fields = ('email','password_hash', 'nombre', 'apellido', 'fecha_nacimiento',
                  'genero', 'telefono', 'tipo_usuario', 'institucion_id', 'grupo_id',
                  'pulsera_id', 'codigo_activacion_usado', 'consentimiento_datos',
                  'configuracion_privacidad', 'activo', 'ultimo_acceso',
                  'created_at', 'updated_at')
        read_only_fields = ('created_at', 'updated_at', 'ultimo_acceso', 'activo')
        
class ConfiguracionesUsuarioSerializer(serializers.ModelSerializer):
    class Meta:
        model = Usuario.configuracionesusuario_set.model
        fields = ('usuario', 'notificaciones_push', 'notificaciones_email',
                  'umbral_personalizado_bpm', 'umbral_personalizado_spo2',
                  'umbral_personalizado_temp', 'modo_privado',
                  'compartir_datos_investigacion', 'configuracion_avanzada',
                  'created_at', 'updated_at')
        read_only_fields = ('created_at', 'updated_at')