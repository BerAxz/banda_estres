from django.db import models
from cuentas.models import Usuario
from dispositivos.models import Pulsera
from django.utils import timezone

class Sesion(models.Model):
    ESTADO_CHOICES = [
        ('activa', 'Activa'),
        ('pausada', 'Pausada'),
        ('finalizada', 'Finalizada'),
        ('cancelada', 'Cancelada'),
    ]
    
    usuario_id = models.ForeignKey(Usuario, on_delete=models.CASCADE)
    pulsera_id = models.ForeignKey(Pulsera, on_delete=models.CASCADE)
    fecha_inicio = models.DateTimeField(auto_now_add=True, null=False, blank=False)
    fecha_fin = models.DateTimeField(null=True, blank=True)
    duracion_minutos = models.IntegerField(null=True, blank=True)
    estado = models.CharField(max_length=20, choices=ESTADO_CHOICES, default='activa')
    ubicacion_lat = models.DecimalField(max_digits=10, decimal_places=8, null=True, blank=True)
    ubicacion_lon = models.DecimalField(max_digits=11, decimal_places=8, null=True, blank=True)
    notas = models.TextField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    def finalizar_sesion(self):
        """Finaliza la sesión calculando la duración"""
        if self.estado == 'activa':
            self.fecha_fin = timezone.now()
            self.estado = 'finalizada'
            if self.fecha_inicio:
                duracion = self.fecha_fin - self.fecha_inicio
                self.duracion_minutos = int(duracion.total_seconds() / 60)
            self.save()
    
    def __str__(self):
        return f"Sesión {self.id} - {self.usuario_id.email} - {self.get_estado_display()}"
    
    class Meta:
        db_table = 'sesiones_sesion'
        verbose_name = 'Sesión'
        verbose_name_plural = 'Sesiones'
    
class DatosFisiologicos(models.Model):
    sesion_id = models.ForeignKey(Sesion, on_delete=models.CASCADE, null=True, blank=True)
    usuario_id = models.ForeignKey(Usuario, on_delete=models.CASCADE, null=True, blank=True)
    pulsera_id = models.ForeignKey(Pulsera, on_delete=models.CASCADE, null=True, blank=True)
    timestamp = models.DateTimeField(auto_now_add=True, null=False, blank=False)
    bpm = models.IntegerField(null=True, blank=True)
    spo2 = models.IntegerField(null=True, blank=True)
    temperatura = models.DecimalField(max_digits=4, decimal_places=2, null=True, blank=True)
    calidad_senal = models.IntegerField(null=True, blank=True)
    datos_raw = models.JSONField(default=dict, null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    
class EventoAnsiedad(models.Model):
    sesion_id = models.ForeignKey(Sesion, on_delete=models.CASCADE, null=True, blank=True)
    usuario_id = models.ForeignKey(Usuario, on_delete=models.CASCADE, null=True, blank=True)
    timestamp = models.DateTimeField(auto_now_add=True, null=False, blank=False)
    nivel_ansiedad = models.IntegerField(null=True, blank=True)
    bpm_momento = models.IntegerField(null=True, blank=True)
    spo2_momento = models.IntegerField(null=True, blank=True)
    temperatura_momento = models.DecimalField(max_digits=4, decimal_places=2, null=True, blank=True)
    duracion_minutos = models.IntegerField(null=True, blank=True)
    factores_detectados = models.JSONField(default=list, null=True, blank=True)
    accion_tomada = models.CharField(max_length=50, null=True, blank=True)
    resuelto = models.BooleanField(default=False)
    notas_usuario = models.TextField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    
