from rest_framework import serializers
from .models import Pulsera

class PulseraSerializer(serializers.ModelSerializer):
    class Meta:
        model = Pulsera
        fields = '__all__'