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
from django.http import JsonResponse
from django.urls import include, path
from rest_framework import routers
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView
from ewc_core.views import UserProfileViewSet, StopsViewSet, StopCollectionViewSet, RouteEnvDataViewSet, UserRegistrationView
from ewc_core import views
from django.contrib.auth import views as auth_views



# Router configuration for REST API endpoints
router = routers.DefaultRouter()
router.register(r'user_profiles', UserProfileViewSet, basename='userprofile')
router.register(r'stops', StopsViewSet, basename='stops')
router.register(r'stop_collection', StopCollectionViewSet, basename='stopcollection')
router.register(r'route_env_data', RouteEnvDataViewSet, basename='routeenvdata')
# URL patterns for the application
urlpatterns = [
    path('admin/', admin.site.urls),  # Admin site route
    path('api/', include(router.urls)),  # REST API route
    path('api/register/', UserRegistrationView.as_view(), name='user-registration'), # Add a signup endpoint
    path('api/token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),  # Issue JWT tokens
    path('api/token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),  # Refresh JWT tokens
    path('ewc_web/', include('rest_framework.urls', namespace='rest_framework')),  # Include authentication views
    path('api/route-env-data/', RouteEnvDataViewSet.get_route_env_data),

# -----------PASSWORD RESET ENDPOINTS--------------
    
    path('check-email/', views.CheckEmailView.as_view(), name='check-email'), #DEPRECATED BUT LEFT IN FOR LATER USE
   
    #Default paths for django.contrib.auth package
    path('reset_password/', 
        auth_views.PasswordResetView.as_view(
        template_name = 'registration/password_reset.html', 
    ), name="password_reset"),
    path('reset_password_sent/', 
        auth_views.PasswordResetDoneView.as_view(
        template_name = 'registration/password_reset_done.html' #Pass in custom HTML template to override default
    ), name="password_reset_done"),
    path('reset/<uidb64>/<token>', auth_views.PasswordResetConfirmView.as_view( #Path to reset password form with authoristion token - all handled by django
        template_name = 'registration/password_reset_confirm.html'              #uid64 = user id
    ), name="password_reset_confirm"),
    path('reset_password_complete/', auth_views.PasswordResetCompleteView.as_view(        
        template_name = 'registration/password_reset_complete.html'
    ), name="password_reset_complete"),
    ]