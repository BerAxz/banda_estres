from rest_framework import serializers
from .models import Usuario, ConfiguracionesUsuario
from dispositivos.serializer import PulseraSerializer

class UsuarioSerializer(serializers.ModelSerializer):
    pulsera_info = PulseraSerializer(source='pulsera_id', read_only=True)
    
    class Meta:
        model = Usuario
        fields = ('id', 'email', 'nombre', 'apellido', 'fecha_nacimiento',
                  'genero', 'telefono', 'tipo_usuario', 'institucion_id', 'grupo_id',
                  'pulsera_id', 'pulsera_info', 'codigo_activacion_usado', 'consentimiento_datos',
                  'configuracion_privacidad', 'activo', 'ultimo_acceso',
                  'created_at', 'updated_at')
        read_only_fields = ('created_at', 'updated_at', 'ultimo_acceso', 'activo', 'pulsera_info')
        extra_kwargs = {
            'password_hash': {'write_only': True}
        }

class UsuarioPerfilSerializer(serializers.ModelSerializer):
    """Serializer más completo para el perfil del usuario"""
    pulsera_info = PulseraSerializer(source='pulsera_id', read_only=True)
    configuraciones = serializers.SerializerMethodField()
    
    class Meta:
        model = Usuario
        fields = ('id', 'email', 'nombre', 'apellido', 'fecha_nacimiento',
                  'genero', 'telefono', 'tipo_usuario', 'pulsera_info',
                  'consentimiento_datos', 'configuraciones', 'ultimo_acceso')
    
    def get_configuraciones(self, obj):
        config = obj.configuracionesusuario_set.first()
        if config:
            return ConfiguracionesUsuarioSerializer(config).data
        return None
        
class ConfiguracionesUsuarioSerializer(serializers.ModelSerializer):
    class Meta:
        model = ConfiguracionesUsuario
        fields = ('id', 'usuario', 'notificaciones_push', 'notificaciones_email',
                  'umbral_personalizado_bpm', 'umbral_personalizado_spo2',
                  'umbral_personalizado_temp', 'modo_privado',
                  'compartir_datos_investigacion', 'configuracion_avanzada',
                  'created_at', 'updated_at')
        read_only_fields = ('created_at', 'updated_at')