from rest_framework import serializers
from .models import Reporte_Agregado, Exportar_Datos

class ReporteAgregadoSerializer(serializers.ModelSerializer):
    class Meta:
        model = Reporte_Agregado
        fields = '__all__'

class ExportarDatosSerializer(serializers.ModelSerializer):
    class Meta:
        model = Exportar_Datos
        fields = '__all__'
