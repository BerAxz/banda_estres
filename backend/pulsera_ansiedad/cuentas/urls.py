from rest_framework import routers
from .views import UsuarioViewSet, ConfiguracionesUsuarioViewSet

router = routers.DefaultRouter()

router.register('api/usuarios', UsuarioViewSet, 'usuario')
router.register('api/configuraciones-usuario', ConfiguracionesUsuarioViewSet, 'configuracion-usuario')

urlpatterns = router.urls
