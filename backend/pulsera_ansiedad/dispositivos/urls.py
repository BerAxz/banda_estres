from rest_framework import routers
from .views import PulseraViewSet

router = routers.DefaultRouter()

router.register('api/pulseras', PulseraViewSet)

urlpatterns = router.urls
