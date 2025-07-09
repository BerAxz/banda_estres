from django.db import models
from instituciones.models import Institucion, Grupo
from cuentas.models import Usuario

class Reporte_Agregado(models.Model):
    institucion_id = models.ForeignKey(Institucion, on_delete=models.CASCADE)
    grupo_id = models.ForeignKey(Grupo, on_delete=models.CASCADE)
    fecha_reporte = models.DateField(auto_now_add=True, null=False, blank=False)
    periodo = models.CharField(max_length=20, null=False, blank=False)
    total_usuarios = models.IntegerField(default=0, null=True, blank=True)
    total_eventos = models.IntegerField(default=0, null=True, blank=True)
    promedio_bpm = models.DecimalField(max_digits=5, decimal_places=2, null=True, blank=True)
    promedio_spo2 = models.DecimalField(max_digits=5, decimal_places=2, null=True, blank=True)
    promedio_temperatura = models.DecimalField(max_digits=5, decimal_places=2, null=True, blank=True)
    eventos_por_nivel = models.JSONField(default=dict, null=True, blank=True)
    horas_pico = models.JSONField(default=dict, null=True, blank=True)
    datos_agregados = models.JSONField(default=dict, null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    
class Exportar_Datos(models.Model):
    usuario_id = models.ForeignKey(Usuario, on_delete=models.CASCADE)
    fecha_solicitud = models.DateField(auto_now_add=True, null=True, blank=True)
    fecha_desde = models.DateField(null=False, blank=False)
    fecha_hasta = models.DateField(null=False, blank=False)
    tipo_datos = models.CharField(max_length=50, null=False, blank=False)
    formato = models.CharField(max_length=20, null=False, blank=False)
    estado = models.CharField(max_length=20, null=True, blank=True)  
    url_descarga = models.TextField(null=True, blank=True)  
    fecha_expiracion = models.DateTimeField(null=True, blank=True)  
    created_at = models.DateTimeField(auto_now_add=True)
