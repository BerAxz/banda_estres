from django.shortcuts import render
from rest_framework import viewsets
from .models import Institucion, Administrador, Grupo, ConfiguracionGrupo
from .serializers import InstitucionSerializer, AdministradorSerializer, GrupoSerializer, ConfiguracionGrupoSerializer


class InstitucionViewSet(viewsets.ModelViewSet):
    queryset = Institucion.objects.all()
    serializer_class = InstitucionSerializer

class AdministradorViewSet(viewsets.ModelViewSet):
    queryset = Administrador.objects.all()
    serializer_class = AdministradorSerializer

class GrupoViewSet(viewsets.ModelViewSet):
    queryset = Grupo.objects.all()
    serializer_class = GrupoSerializer
    
class ConfiguracionGrupoViewSet(viewsets.ModelViewSet):
    queryset = ConfiguracionGrupo.objects.all()
    serializer_class = ConfiguracionGrupoSerializer
