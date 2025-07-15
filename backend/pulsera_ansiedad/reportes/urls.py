from rest_framework import routers
from .views import ReporteAgregadoViewSet, ExportarDatosViewSet

router = routers.DefaultRouter()

router.register('api/reportes-agregados', ReporteAgregadoViewSet, 'reporte-agregado')
router.register('api/exportar-datos', ExportarDatosViewSet, 'exportar-datos')

urlpatterns = router.urls