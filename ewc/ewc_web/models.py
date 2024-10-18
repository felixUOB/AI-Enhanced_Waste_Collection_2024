from django.db import models
from django.contrib.auth.models import User

# 1. Collection Points
class CollectionPoint(models.Model):
    location_name = models.CharField(max_length=255)  # Name of the collection point
    latitude = models.FloatField()  # Latitude
    longitude = models.FloatField()  # Longitude
    address = models.CharField(max_length=255)  # Address

    def __str__(self):
        return self.location_name

# 2. Journey Metrics
class JourneyMetric(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)  # Associated user
    collection_point = models.ForeignKey(CollectionPoint, on_delete=models.CASCADE)  # Related collection point
    co2_emissions = models.FloatField()  # CO2 emissions (kg)
    fuel_used = models.FloatField()  # Fuel used (liters)
    distance_traveled = models.FloatField()  # Distance traveled (kilometers)
    journey_date = models.DateTimeField(auto_now_add=True)  # Date of the journey

    def __str__(self):
        return f"Journey by {self.user.username} on {self.journey_date.date()}"

# 3. Waste Predictions
class WastePrediction(models.Model):
    collection_point = models.ForeignKey(CollectionPoint, on_delete=models.CASCADE)  # Related collection point
    predicted_weight = models.FloatField()  # Predicted waste weight (kg)
    predicted_date = models.DateField()  # Date for the prediction
    actual_weight = models.FloatField(null=True, blank=True)  # Actual waste weight (optional)

    def __str__(self):
        return f"Prediction for {self.collection_point.location_name} on {self.predicted_date}"
