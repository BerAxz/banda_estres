from django.db import models

class Institucion(models.Model):
    nombre = models.CharField(max_length=255, null=False, blank=False)
    direccion = models.TextField(null=True, blank=True)
    telefono = models.CharField(max_length=20, null=True, blank=True)
    email = models.EmailField(null=True, blank=True)
    fecha_registro = models.DateField(auto_now_add=True)
    activa = models.BooleanField(default=True)
    configuracion_global = models.JSONField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
class Administrador(models.Model):
    institucion_id = models.ForeignKey(Institucion, on_delete=models.CASCADE)
    nombre = models.CharField(max_length=255, null=False, blank=False)
    apellido = models.CharField(max_length=255, null=False, blank=False)
    email = models.EmailField(unique=True, null=False, blank=False)
    password_hash = models.CharField(max_length=255, null=False, blank=False)
    rol = models.CharField(max_length=50, null=False, blank=False)
    activo = models.BooleanField(default=True)
    ultimo_acceso = models.DateTimeField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
class Grupo(models.Model):
    institucion_id = models.ForeignKey(Institucion, on_delete=models.CASCADE)
    nombre = models.CharField(max_length=255, null=False, blank=False)
    descripcion = models.TextField(null=True, blank=True)
    codigo_activacion = models.CharField(max_length=20, null= False, blank=False)
    activo = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

class ConfiguracionGrupo(models.Model):
    grupo_id = models.ForeignKey(Grupo, on_delete=models.CASCADE)
    umbral_bpm_min = models.IntegerField(null=True, blank=True)
    umbral_bpm_max = models.IntegerField(null=True, blank=True)
    umbral_spo2_min = models.IntegerField(null=True, blank=True)
    umbral_spo2_max = models.IntegerField(null=True, blank=True)
    umbral_temp_min = models.DecimalField(max_digits=4, decimal_places=2, null=True, blank=True)
    umbral_temp_max = models.DecimalField(max_digits=4, decimal_places=2, null=True, blank=True)
    intervalo_medicion = models.IntegerField(null=True, blank=True)  # Intervalo en minutos
    notificaciones_activas = models.BooleanField(default=True)
    configuraciones_avanzadas = models.JSONField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)