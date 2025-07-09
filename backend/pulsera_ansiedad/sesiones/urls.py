from rest_framework import routers
from .views import SesionViewSet, DatosFisiologicosViewSet, EventoAnsiedadViewSet

router = routers.DefaultRouter()

router.register('api/sesiones', SesionViewSet, 'sesion')
router.register('api/datos-fisiologicos', DatosFisiologicosViewSet, 'datos-fisiologicos')
router.register('api/eventos-ansiedad', EventoAnsiedadViewSet, 'evento-ansiedad')

urlpatterns = router.urls