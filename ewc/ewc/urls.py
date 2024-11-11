"""
URL configuration for ewc project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/5.1/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""

from django.contrib import admin
from django.urls import include, path
from rest_framework import routers
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView
from ewc_web.views import UserProfileViewSet, CollectionPointViewSet, JourneyMetricViewSet, WastePredictionViewSet

# Router configuration for REST API endpoints
router = routers.DefaultRouter()
router.register(r'user_profiles', UserProfileViewSet, basename='userprofile')
router.register(r'collection_points', CollectionPointViewSet, basename='collectionpoint')
router.register(r'journey_metrics', JourneyMetricViewSet, basename='journeymetric')
router.register(r'waste_predictions', WastePredictionViewSet, basename='wasteprediction')

# URL patterns for the application
urlpatterns = [
    path('admin/', admin.site.urls),  # Admin site route
    path('api/', include(router.urls)),  # REST API route
    path('api/token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),  # Issue JWT tokens
    path('api/token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),  # Refresh JWT tokens
    path('ewc_web/', include('rest_framework.urls', namespace='rest_framework')),  # Include authentication views
]