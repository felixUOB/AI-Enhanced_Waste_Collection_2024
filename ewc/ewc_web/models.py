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

# Collection Points
class CollectionPoint(models.Model):
    location_name = models.CharField(max_length=255)  # Name of the collection point
    latitude = models.FloatField()  # Latitude
    longitude = models.FloatField()  # Longitude
    address = models.CharField(max_length=255)  # Address

    def __str__(self):
        return self.location_name

# Journey Metrics
class JourneyMetric(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)  # Associated user
    collection_point = models.ForeignKey(CollectionPoint, on_delete=models.CASCADE)  # Related collection point
    co2_emissions = models.FloatField()  # CO2 emissions (kg)
    fuel_used = models.FloatField()  # Fuel used (liters)
    distance_traveled = models.FloatField()  # Distance traveled (kilometers)
    journey_date = models.DateTimeField(auto_now_add=True)  # Date of the journey

    def __str__(self):
        return f"Journey by {self.user.username} on {self.journey_date.date()}"

# Waste Predictions
class WastePrediction(models.Model):
    collection_point = models.ForeignKey(CollectionPoint, on_delete=models.CASCADE)  # Related collection point
    predicted_weight = models.FloatField()  # Predicted waste weight (kg)
    predicted_date = models.DateField()  # Date for the prediction
    actual_weight = models.FloatField(null=True, blank=True)  # Actual waste weight (optional)

    def __str__(self):
        return f"Prediction for {self.collection_point.location_name} on {self.predicted_date}"
