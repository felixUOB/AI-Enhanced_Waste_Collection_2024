from django.apps import AppConfig

"""
This file defines the configuration for the `ewc_core` Django application.

Key Configurations:

- `default_auto_field`: Specifies the default primary key field type as `BigAutoField`,  
  which ensures unique and scalable ID generation for database models.
- `name`: Sets the application name as `ewc_core`, aligning it with the project structure.

This configuration file helps Django recognize and manage the `ewc_core` app within the project.
"""

class EwcWebConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'ewc_core'
