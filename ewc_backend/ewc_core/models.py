from django.contrib.auth.models import User
from django.db import models


class UserProfile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)  # Linked User model
    phone_number = models.CharField(max_length=15, blank=True)  # User's phone number
    address = models.TextField(blank=True)  # User's address

    # Waste pickup frequency
    pickup_frequency = models.CharField(
        max_length=20,
        choices=[('weekly', 'Weekly'), ('biweekly', 'Biweekly'), ('monthly', 'Monthly')],
        default='weekly'
    )

    # Type of waste managed
    waste_type_preference = models.CharField(
        max_length=20,
        choices=[('general', 'General'), ('recycling', 'Recycling'), ('organic', 'Organic')],
        default='general'
    )
    carbon_savings = models.FloatField(default=0.0)  # Carbon savings (kg)
    notification_preferences = models.BooleanField(default=True)  # Notification settings

    def __str__(self):
        return self.user.username

# Stop Collection
class StopCollection(models.Model):
    stop_collection_id = models.BigAutoField(primary_key=True)
    stop = models.ForeignKey(
        'Stops',  # referenced table model stops
        on_delete=models.DO_NOTHING,  # Matches the ON DELETE NO ACTION constraint
        db_column='stop_id'
    )
    weight_collected = models.IntegerField()
    date = models.DateField(auto_now_add=True, null=False)

    class Meta:
        db_table = 'ewc_core_stop_collection'
        
    def __str__(self):
        return self.stop_collection_id
    
# Stops
class Stops(models.Model):
    stop_id = models.BigAutoField(primary_key=True)
    location_name = models.CharField(max_length=255, blank=True, null=True)
    latitude = models.FloatField()
    longitude = models.FloatField()
    next_collection_due_date = models.DateField(blank=True, null=True)
    max_weight = models.IntegerField()

    class Meta:
        db_table = 'ewc_core_stops'
        verbose_name = "Stop"
        verbose_name_plural = "Stops"

    def __str__(self):
        return self.location_name 


# Route Env Data

class RouteEnvData(models.Model):
    route_env_data_id = models.BigAutoField(primary_key=True)
    distance = models.FloatField(null=False)
    mpg = models.FloatField(null=False)
    date = models.DateField(null=False)

    class Meta:
        db_table = 'ewc_core_route_env_data'

    def __str__(self):
        return f"Route Data {self.route_env_data_id}"