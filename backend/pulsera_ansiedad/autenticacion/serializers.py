from rest_framework import serializers
from cuentas.models import Usuario, ConfiguracionesUsuario
from dispositivos.models import Pulsera
from sesiones.models import Sesion
import uuid
from django.utils import timezone

class RegistroSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)

    class Meta:
        model = Usuario
        fields = ['email', 'password', 'nombre', 'apellido', 'fecha_nacimiento', 'genero', 'telefono','tipo_usuario']

    def create(self, validated_data):
        password = validated_data.pop('password')
        usuario = Usuario(**validated_data)
        usuario.set_password(password)
        usuario.save()
        
        # Si es un usuario personal (sin institución), crear y asignar una pulsera automáticamente
        if usuario.tipo_usuario == Usuario.USER and not usuario.institucion_id:
            pulsera = Pulsera.objects.create(
                numero_serie=f"FAKE-{uuid.uuid4().hex[:8].upper()}",
                modelo="Pulsera Virtual",
                estado="activa",
                fecha_activacion=timezone.now().date(),
                version_firmware="1.0.0",
                configuracion_hardware={
                    "tipo": "virtual",
                    "usuario_vinculado": usuario.id,
                    "token_thingsboard": "Izv20eKxVGH8YNcTmQkg"  # Token del dispositivo fake
                }
            )
            
            # Vincular la pulsera al usuario
            usuario.pulsera_id = pulsera
            usuario.save()
            
            # Crear configuraciones predeterminadas para el usuario
            ConfiguracionesUsuario.objects.create(
                usuario=usuario,
                notificaciones_push=True,
                notificaciones_email=True,
                umbral_personalizado_bpm=100,
                umbral_personalizado_spo2=95,
                umbral_personalizado_temp=37.5,
                modo_privado=False,
                compartir_datos_investigacion=True
            )
            
            # Crear una sesión inicial activa para recibir datos
            Sesion.objects.create(
                usuario_id=usuario,
                pulsera_id=pulsera,
                estado="activa",
                notas="Sesión inicial creada automáticamente"
            )
        
        return usuario
    
    
class LoginSerializer(serializers.Serializer):
    email = serializers.EmailField()
    password = serializers.CharField()

    def validate(self, data):
        from django.utils import timezone
        from sesiones.models import Sesion
        
        try:
            usuario = Usuario.objects.get(email=data['email'])
        except Usuario.DoesNotExist:
            raise serializers.ValidationError("Credenciales inválidas")

        if not usuario.check_password(data['password']):
            raise serializers.ValidationError("Credenciales inválidas")

        # Actualizar último acceso
        usuario.ultimo_acceso = timezone.now()
        usuario.save()
        
        # Si es un usuario personal con pulsera, asegurar que tenga una sesión activa
        if (usuario.tipo_usuario == Usuario.USER and 
            usuario.pulsera_id and 
            not usuario.institucion_id):
            
            # Verificar si existe una sesión activa
            sesion_activa = Sesion.objects.filter(
                usuario_id=usuario,
                pulsera_id=usuario.pulsera_id,
                estado="activa",
                fecha_fin__isnull=True
            ).first()
            
            # Si no hay sesión activa, crear una nueva
            if not sesion_activa:
                Sesion.objects.create(
                    usuario_id=usuario,
                    pulsera_id=usuario.pulsera_id,
                    estado="activa",
                    notas="Sesión creada al hacer login"
                )

        return usuario