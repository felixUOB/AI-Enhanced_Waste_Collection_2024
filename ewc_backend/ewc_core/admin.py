from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from .models import UserProfile, StopCollection, Stops, RouteEnvData

"""
This file registers the application's models with the Django admin interface,  
allowing administrators to manage waste collection data through the Django admin panel.
"""

# Register your models here
admin.site.register(UserProfile)
admin.site.register(StopCollection)
admin.site.register(Stops)
admin.site.register(RouteEnvData)
