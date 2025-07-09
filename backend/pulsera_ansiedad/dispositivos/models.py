from django.db import models
from instituciones.models import Institucion

class Pulsera(models.Model):
    numero_serie = models.CharField(max_length=100, unique=True, null=False, blank=False)
    modelo = models.CharField(max_length=100, null=True, blank=True)
    institucion = models.ForeignKey(Institucion, on_delete=models.CASCADE, null=True, blank=True)
    fecha_fabricacion = models.DateField(null=True, blank=True)
    fecha_activacion = models.DateField(null=True, blank=True)
    estado = models.CharField(max_length=20)
    version_firmware = models.CharField(max_length=20, null=True, blank=True)
    configuracion_hardware = models.JSONField(default=dict, null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
