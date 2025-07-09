from django.db import models
from instituciones.models import Institucion, Grupo
from dispositivos.models import Pulsera
from django.contrib.auth.hashers import make_password, check_password
class Usuario(models.Model):
    USER = 'USER'
    INSTITUTIONAL_USER = 'INSTITUTIONAL_USER'
    INSTITUTION_ADMIN = 'INSTITUTION_ADMIN'
    SUPER_ADMIN = 'SUPER_ADMIN'

    TIPO_USUARIO_CHOICES = [
        (USER, 'Usuario Personal'),
        (INSTITUTIONAL_USER, 'Usuario Institucional'),
        (INSTITUTION_ADMIN, 'Administrador Institucional'),
        (SUPER_ADMIN, 'Super Administrador'),
    ]

    email = models.EmailField(unique=True, max_length=254, null=False, blank=False)
    password_hash = models.CharField(max_length=255, null=False, blank=False)
    nombre = models.CharField(max_length=255, null=False, blank=False)
    apellido = models.CharField(max_length=255, null=False, blank=False)
    fecha_nacimiento = models.DateField( null=True, blank=True)
    genero = models.CharField(max_length=20, null=True, blank=True)
    telefono = models.CharField(max_length=20, null=True, blank=True)
    tipo_usuario = models.CharField(
        max_length=20,
        choices=TIPO_USUARIO_CHOICES,
        default=USER,
        null=False,
        blank=False
    )

    institucion_id = models.ForeignKey(Institucion, on_delete=models.CASCADE, null=True, blank=True)
    grupo_id = models.ForeignKey(Grupo, on_delete=models.CASCADE, null=True, blank=True)
    pulsera_id = models.ForeignKey(Pulsera, on_delete=models.CASCADE, null=True, blank=True)

    codigo_activacion_usado = models.CharField(max_length=20, null=True, blank=True)
    consentimiento_datos = models.BooleanField(default=False, null=True, blank=True)
    configuracion_privacidad = models.JSONField(default=dict, null=True, blank=True)
    activo = models.BooleanField(default=True, null=True, blank=True)
    ultimo_acceso = models.DateTimeField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    def set_password(self, raw_password):
        self.password_hash = make_password(raw_password)
        
    def check_password(self, raw_password):
        return check_password(raw_password, self.password_hash)
    

class ConfiguracionesUsuario(models.Model):
    usuario = models.ForeignKey(Usuario, on_delete=models.CASCADE)
    notificaciones_push = models.BooleanField(default=True)
    notificaciones_email = models.BooleanField(default=True)
    umbral_personalizado_bpm = models.IntegerField(null=True, blank=True)
    umbral_personalizado_spo2 = models.IntegerField(null=True, blank=True)
    umbral_personalizado_temp = models.DecimalField(max_digits=5, decimal_places=2, null=True, blank=True)
    modo_privado = models.BooleanField(default=False)
    compartir_datos_investigacion = models.BooleanField(default=False)
    configuracion_avanzada = models.JSONField(default=dict)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    
    