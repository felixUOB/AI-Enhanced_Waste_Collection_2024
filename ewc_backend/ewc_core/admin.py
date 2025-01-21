from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from .models import UserProfile, StopCollection, Stops, RouteEnvData

# Register your models here
admin.site.register(UserProfile)
admin.site.register(StopCollection)
admin.site.register(Stops)
admin.site.register(RouteEnvData)
