from django.contrib.auth.models import User
from django.db import models

"""
This file defines the backend data models for the Django application, managing user profiles,  
waste collection stops, and environmental data related to routes.

Models:

1. UserProfile:
   - Extends the built-in Django `User` model.
   - Stores additional user details such as email address

2. Stops:
   - Represents collection points with location details (latitude, longitude).
   - Tracks the next collection due date and the maximum weight capacity for waste collection.

3. StopCollection:
   - Links to the `Stops` model to track collected waste.
   - Stores weight collected and the date of collection.

4. RouteEnvData:
   - Records environmental metrics for waste collection routes, including distance traveled and 
     fuel efficiency (miles per gallon).
   - Helps in assessing the environmental impact of waste collection operations.

5. Depot:
   - Records the location of the depot (longitude and latitude).
   - Is a singleton meaning only one instance can be created at once.
"""


class UserProfile(models.Model):
    '''
    This model extends the built-in Django User model to include additional user details
    such as email_Address
    '''
    user = models.OneToOneField(User, on_delete=models.CASCADE)  # Linked User model
    email_address = models.TextField(blank=True)  # User's address

    def __str__(self):
        return self.user.username

# Stop Collection
class StopCollection(models.Model):
    '''
    This model links to the Stops model to track collected waste.
    It stores the weight collected and the date of collection.
    '''
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
        return f"Route Data {self.stop_collection_id}" 
    
# Stops
class Stops(models.Model):
    '''
    This model represents the collection points for waste management.
    It includes location details such as latitude and longitude, the next
    collection due date, and the maximum weight capacity for waste collection.
    '''
    stop_id = models.BigAutoField(primary_key=True)
    location_name = models.CharField(max_length=255, blank=True, null=True)
    latitude = models.FloatField()
    longitude = models.FloatField()
    next_collection_due_date = models.DateField(blank=True, null=True)
    max_weight = models.IntegerField()
    description = models.CharField(max_length=255, null=True)

    class Meta:
        db_table = 'ewc_core_stops'
        verbose_name = "Stop"
        verbose_name_plural = "Stops"

    def __str__(self):
        return self.location_name 


# Route Env Data

class RouteEnvData(models.Model):
    '''
    This model records environmental metrics for waste collection routes,
    including distance traveled and fuel efficiency (miles per gallon).
    It helps in assessing the environmental impact of waste collection operations.
    '''
    route_env_data_id = models.BigAutoField(primary_key=True)
    distance = models.FloatField(null=False)
    mpg = models.FloatField(null=False)
    date = models.DateField(null=False)

    class Meta:
        db_table = 'ewc_core_route_env_data'

    def __str__(self):
        return f"Route Data {self.route_env_data_id}"
    
# singleton model so that only one depot can ever be saved
class Depot(models.Model):
    nickname = models.CharField(max_length=255, blank=True, null=True)
    latitude = models.FloatField(null=False)
    longitude = models.FloatField(null=False)

    # any time you save it will do pk = 1 so will either create it or update it 
    def save(self, *args, **kwargs):
        self.pk = 1
        super().save(*args, **kwargs)
    
    # doesn't let you delete the instance
    def delete(self, *args, **kwargs):
        raise Exception("Deletion not allowed for this model")
    
    class Meta:
        verbose_name = "Depot Location"
        verbose_name_plural = "Depot Location"

    @classmethod
    def load(cls):
        try:
            obj, created = cls.objects.get_or_create(pk=1,defaults={'nickname': 'Default Depot', 'latitude': 0.0, 'longitude': 0.0})
            return obj
        except cls.DoesNotExist:
            return cls()
        
    def __str__(self):
        return self.nickname

