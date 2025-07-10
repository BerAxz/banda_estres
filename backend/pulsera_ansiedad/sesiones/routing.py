from django.urls import re_path
from . import consumers

websocket_urlpatterns = [
    re_path(r'ws/datos-tiempo-real/(?P<user_id>\w+)/$', consumers.DatosTiempoRealConsumer.as_asgi()),
    re_path(r'ws/eventos-ansiedad/(?P<user_id>\w+)/$', consumers.EventosAnsiedadConsumer.as_asgi()),
    re_path(r'ws/dashboard/(?P<user_id>\w+)/$', consumers.DashboardConsumer.as_asgi()),
]
