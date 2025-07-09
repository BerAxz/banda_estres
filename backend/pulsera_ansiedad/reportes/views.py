from django.shortcuts import render
from rest_framework import viewsets
from .models import Reporte_Agregado, Exportar_Datos
from .serializer import ReporteAgregadoSerializer, ExportarDatosSerializer

class ReporteAgregadoViewSet(viewsets.ModelViewSet):
    queryset = Reporte_Agregado.objects.all()
    serializer_class = ReporteAgregadoSerializer
    
class ExportarDatosViewSet(viewsets.ModelViewSet):
    queryset = Exportar_Datos.objects.all()
    serializer_class = ExportarDatosSerializer

