from django.shortcuts import render
from rest_framework import viewsets
from .models import Usuario , ConfiguracionesUsuario
from .serializers import UsuarioSerializer, ConfiguracionesUsuarioSerializer

class UsuarioViewSet(viewsets.ModelViewSet):
    queryset = Usuario.objects.all()
    serializer_class = UsuarioSerializer

class ConfiguracionesUsuarioViewSet(viewsets.ModelViewSet):
    queryset = ConfiguracionesUsuario.objects.all()
    serializer_class = ConfiguracionesUsuarioSerializer