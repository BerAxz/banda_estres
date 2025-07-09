from rest_framework import routers
from .views import InstitucionViewSet, AdministradorViewSet, GrupoViewSet, ConfiguracionGrupoViewSet

router = routers.DefaultRouter()

router.register('api/instituciones', InstitucionViewSet, 'institucion')
router.register('api/administradores', AdministradorViewSet, 'administrador')
router.register('api/grupos', GrupoViewSet, 'grupo')
router.register('api/configuracion-grupos', ConfiguracionGrupoViewSet, 'configuracion-grupo')

urlpatterns = router.urls