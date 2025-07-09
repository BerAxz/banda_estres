from rest_framework import serializers
from .models import Institucion, Administrador, Grupo, ConfiguracionGrupo

class InstitucionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Institucion
        fields = '__all__'
        
class AdministradorSerializer(serializers.ModelSerializer):
    class Meta:
        model = Administrador
        fields = '__all__'
        
class GrupoSerializer(serializers.ModelSerializer):
    class Meta:
        model = Grupo
        fields = '__all__'
        
class ConfiguracionGrupoSerializer(serializers.ModelSerializer):
    class Meta:
        model = ConfiguracionGrupo
        fields = '__all__'