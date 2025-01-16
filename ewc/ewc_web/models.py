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
        max_length=100,
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

    class Meta:
        db_table = 'ewc_web_stop_collection'
        constraints = [
            models.UniqueConstraint(
                fields=['stop_collection_id'],
                name='ewc_web_stop_collection_pkey'
            )
        ]
    
# Stops
class Stops(models.Model):
    stop_id = models.BigAutoField(primary_key=True)
    location_name = models.CharField(max_length=255, blank=True, null=True)
    latitude = models.FloatField()
    longitude = models.FloatField()
    collection_date = models.DateField(blank=True, null=True)
    max_weight = models.IntegerField()

    class Meta:
        db_table = 'ewc_web_stops'
        constraints = [
            models.UniqueConstraint(
                fields=['stop_id'], name='ewc_web_collectionpoint_pkey'
            )
        ]


# Route Env Data

class RouteEnvData(models.Model):
    route_env_data_id = models.BigAutoField(primary_key=True)
    distance = models.FloatField(null=False)
    mpg = models.FloatField(null=False)
    collection_date = models.FloatField(null=False)

    class Meta:
        db_table = 'ewc_web_route_env_data'
        constraints = [
            models.UniqueConstraint(fields=['route_env_data_id'], name='route_env_data_pkey'),
        ]

# # Collection Points
# class CollectionPoint(models.Model):
#     location_name = models.CharField(max_length=255)  # Name of the collection point
#     latitude = models.FloatField()  # Latitude
#     longitude = models.FloatField()  # Longitude
#     address = models.CharField(max_length=255)  # Address

#     def __str__(self):
#         return self.location_name

# # Journey Metrics
# class JourneyMetric(models.Model):
#     user = models.ForeignKey(User, on_delete=models.CASCADE)  # Associated user
#     collection_point = models.ForeignKey(CollectionPoint, on_delete=models.CASCADE)  # Related collection point
#     co2_emissions = models.FloatField()  # CO2 emissions (kg)
#     fuel_used = models.FloatField()  # Fuel used (liters)
#     distance_traveled = models.FloatField()  # Distance traveled (kilometers)
#     journey_date = models.DateTimeField(auto_now_add=True)  # Date of the journey

#     def __str__(self):
#         return f"Journey by {self.user.username} on {self.journey_date.date()}"

# # Waste Predictions
# class WastePrediction(models.Model):
#     collection_point = models.ForeignKey(CollectionPoint, on_delete=models.CASCADE)  # Related collection point
#     predicted_weight = models.FloatField()  # Predicted waste weight (kg)
#     predicted_date = models.DateField()  # Date for the prediction
#     actual_weight = models.FloatField(null=True, blank=True)  # Actual waste weight (optional)

#     def __str__(self):
#         return f"Prediction for {self.collection_point.location_name} on {self.predicted_date}"
