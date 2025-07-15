from rest_framework import serializers
from .models import Sesion, DatosFisiologicos, EventoAnsiedad

class SesionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Sesion
        fields = '__all__'

class DatosFisiologicosSerializer(serializers.ModelSerializer):
    class Meta:
        model = DatosFisiologicos
        fields = '__all__'

class EventoAnsiedadSerializer(serializers.ModelSerializer):
    class Meta:
        model = EventoAnsiedad
        fields = '__all__'