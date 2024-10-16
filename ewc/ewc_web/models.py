from django.db import models

# Create model
class Login(models.Model):
    username = models.CharField(max_length=50, unique=True)
    password_hash = models.CharField(max_length=255)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.username


class CollectionPoint(models.Model):
    location_name = models.CharField(max_length=100)
    address = models.TextField(blank=True, null=True)
    latitude = models.DecimalField(max_digits=9, decimal_places=6, blank=True, null=True)
    longitude = models.DecimalField(max_digits=9, decimal_places=6, blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.location_name


class JourneyMetric(models.Model):
    collection_point = models.ForeignKey(
        CollectionPoint,
        on_delete=models.SET_NULL,
        null=True
    )
    co2_emissions = models.DecimalField(max_digits=10, decimal_places=2)
    fuel_consumption = models.DecimalField(max_digits=10, decimal_places=2)
    journey_date = models.DateField()
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Journey on {self.journey_date} at {self.collection_point}"


class Prediction(models.Model):
    collection_point = models.ForeignKey(
        CollectionPoint,
        on_delete=models.SET_NULL,
        null=True
    )
    waste_weight = models.DecimalField(max_digits=10, decimal_places=2)
    prediction_date = models.DateField()
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Prediction on {self.prediction_date} at {self.collection_point}"