from django.shortcuts import render
from rest_framework import viewsets
from .models import Sesion, DatosFisiologicos, EventoAnsiedad
from .serializer import SesionSerializer, DatosFisiologicosSerializer, EventoAnsiedadSerializer

class SesionViewSet(viewsets.ModelViewSet):
    queryset = Sesion.objects.all()
    serializer_class = SesionSerializer

class DatosFisiologicosViewSet(viewsets.ModelViewSet):
    queryset = DatosFisiologicos.objects.all()
    serializer_class = DatosFisiologicosSerializer

class EventoAnsiedadViewSet(viewsets.ModelViewSet):
    queryset = EventoAnsiedad.objects.all()
    serializer_class = EventoAnsiedadSerializer
