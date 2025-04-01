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
from django.shortcuts import redirect
from django.urls import include, path, re_path
from rest_framework import routers
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView
from ewc_core.views import UserProfileViewSet, StopsViewSet, StopCollectionViewSet, RouteEnvDataViewSet, UserRegistrationView, run_model_view, DepotViewSet
from ewc_core import views
from django.contrib.auth import views as auth_views
from ewc_core.management.commands.run_prediction import Command
from ewc_core.views import stops_list_view, stops_create_view, stops_edit_view, stops_delete_view, get_coordinates_by_name, get_stops_list, schema_view, reverse_geocode, edit_depot
from django.views.generic import TemplateView
from django.views.generic.base import RedirectView

# Router configuration for REST API endpoints
router = routers.DefaultRouter()
router.register(r'user_profiles', UserProfileViewSet, basename='userprofile')
router.register(r'stops', StopsViewSet, basename='stops')
router.register(r'stop_collection', StopCollectionViewSet, basename='stopcollection')
router.register(r'route_env_data', RouteEnvDataViewSet, basename='routeenvdata')
router.register(r'depot', DepotViewSet, basename='depot')
# URL patterns for the application

def redirect_to_admin(request):
    return redirect('/admin/')

urlpatterns = [
    path('admin/', admin.site.urls),  # Admin site route
    path('api/', include(router.urls)),  # REST API route
    path('api/register/', UserRegistrationView.as_view(), name='user-registration'), # Add a signup endpoint
    path('api/token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),  # Issue JWT tokens
    path('api/token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),  # Refresh JWT tokens
    path('ewc_web/', include('rest_framework.urls', namespace='rest_framework')),  # Include authentication views
    
    # ----- endpoint for route-env-data table ------
    path('api/route-env-data/', RouteEnvDataViewSet.as_view({'get': 'get_route_env_data'})),
    path('api/route-env-data-30-days/', RouteEnvDataViewSet.as_view({'get': 'get_route_env_data_30_days'})),
    
    # ----- endpoint for depo table ------
    path('api/get-depot/', DepotViewSet.as_view({'get' : 'get_depot_location'})),

    # ------- endpoint for model -------- #
    path('api/run-model/', run_model_view ,name='run-model'), #Run Machine Learning Model   
    path("api/docs/", schema_view.with_ui("redoc", cache_timeout=0), name="schema-redoc"),    

# -----------Stops HTML Form URLs------------------

    path('stops/', stops_list_view, name='stops_list'),                # List
    path('stops/new/', stops_create_view, name='stops_create'),        # Create
    path('stops/<int:pk>/edit/', stops_edit_view, name='stops_edit'),  # Edit
    path('stops/<int:pk>/delete/', stops_delete_view, name='stops_delete'), # delete
    path('stops/depot/', edit_depot, name='edit_depot'), # edit depot
    path('stops/get_coordinates/', get_coordinates_by_name, name='get_coordinates_by_name'), # get coordinates by name
    path('stops/reverse_geocode/', reverse_geocode, name='reverse_geocode'), # reverse geocode
    path('stops/get_stops_list/', get_stops_list, name='get_stops_list'), # get stops list

# -----------PASSWORD RESET ENDPOINTS--------------
       
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

    re_path(r'^.*$', redirect_to_admin),  # THIS MUST BE THE LAST URL PATTERN 

    ]
