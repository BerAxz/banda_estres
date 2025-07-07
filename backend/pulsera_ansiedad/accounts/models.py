from django.db import models

class Usuario(models.Model):
    email = models.EmailField(unique=True, max_length=254, null=False, blank=False)
    password_hash = models.CharField(max_length=255, null=False, blank=False)
    nombre = models.CharField(max_length=255, null=False, blank=False)
    apellido = models.CharField(max_length=255, null=False, blank=False)
    fecha_nacimiento = models.DateField()
    genero = models.CharField(max_length=20)
    telefono = models.CharField(max_length=20)
    tipo_usuario = models.CharField(max_length=20, null=False, blank=False)

    institucion_id = models.ForeignKey('Instituciones', on_delete=models.CASCADE)
    grupo_id = models.ForeignKey('Grupos', on_delete=models.CASCADE)
    pulsera_id = models.ForeignKey('Pulseras', on_delete=models.CASCADE, null=True, blank=True)
    
    codigo_activacion_usado = models.CharField(max_length=20)
    consentimiento_datos = models.BooleanField(default=False)
    configuracion_privacidad = models.JSONField(default=dict)
    activo = models.BooleanField(default=True)
    ultimo_acceso = models.DateTimeField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    

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
    
    
    