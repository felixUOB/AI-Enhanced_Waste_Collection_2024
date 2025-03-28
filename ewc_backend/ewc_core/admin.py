from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from .models import UserProfile, StopCollection, Stops, RouteEnvData
from django.urls import path
from django.utils.html import format_html
from .utils import generate_pdf
from .views import stops_list_view

"""
This file registers the application's models with the Django admin interface,  
allowing administrators to manage waste collection data through the Django admin panel.
"""

admin.site.register(UserProfile)
admin.site.register(StopCollection)

class StopAdmin(admin.ModelAdmin):
    """
    This Model Admin class customizes the admin interface for the Stops model.
    It links to custom html which adds a button to redirect to the Stops list view.
    """
    change_list_template = "admin/stops_changelist.html"  # Use custom template for the admin list view

    def get_urls(self):
        urls = super().get_urls()
        custom_urls = [
            path('admin_stops_redirect/', self.admin_site.admin_view(stops_list_view), name="admin_stops_redirect"),
        ]
        return custom_urls + urls
admin.site.register(Stops, StopAdmin)

class RouteEnvDataAdmin(admin.ModelAdmin):
    """
    This Model Admin class customizes the admin interface for the RouteEnvData model.
    It adds a custom button to the admin interface to generate a PDF report.
    """
    list_display = ['route_env_data_id', 'distance', 'mpg', 'date']  # Customize as needed
    change_list_template = "admin/route_env_data_changelist.html"  # Custom template

    def get_urls(self):
        urls = super().get_urls()
        custom_urls = [
            path('generate_pdf/', self.admin_site.admin_view(self.generate_pdf_view), name="generate_pdf"),
        ]
        return custom_urls + urls

    def generate_pdf_view(self, request):
        return generate_pdf()

    def pdf_button(self):
        return format_html('<a class="button" href="generate_pdf/">Download PDF</a>')

    pdf_button.short_description = "Export PDF"

admin.site.register(RouteEnvData, RouteEnvDataAdmin)
