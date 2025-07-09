from django.shortcuts import render
from rest_framework import viewsets
from .models import Pulsera
from .serializer import PulseraSerializer

class PulseraViewSet(viewsets.ModelViewSet):
    queryset = Pulsera.objects.all()
    serializer_class = PulseraSerializer
