from django.shortcuts import render
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from cuentas.models import Usuario
from .serializers import RegistroSerializer, LoginSerializer
from rest_framework_simplejwt.views import TokenRefreshView
from rest_framework_simplejwt.tokens import RefreshToken
from django.utils.timezone import now
from datetime import timedelta
from rest_framework.permissions import AllowAny

class RegistroView(APIView):
    permission_classes = [AllowAny]
    def post(self, request):
        serializer = RegistroSerializer(data=request.data)
        if serializer.is_valid():
            usuario = serializer.save()
            return Response(
                {
                    "message": "Usuario registrado exitosamente"
                },
                status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
class LoginView(APIView):
    permission_classes = [AllowAny]

    def post(self, request):
        serializer = LoginSerializer(data=request.data)
        if serializer.is_valid():
            usuario = serializer.validated_data
            refresh = RefreshToken.for_user(usuario)
            access = refresh.access_token

            return Response({
                "data": {
                    "refresh": str(refresh),
                    "access": str(access),
                    "token_type": "Bearer",
                    "expires_in": 3600
                } 
            }, status=status.HTTP_200_OK)

        return Response(serializer.errors, status=status.HTTP_401_UNAUTHORIZED)
    
class RefreshView(TokenRefreshView):
    pass