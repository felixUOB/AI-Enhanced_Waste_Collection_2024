from django.db import models

# Create your models here.

# Example model
class Person(models.Model):
  firstName = models.CharField(max_length=30)
  lastName = models.CharField(max_length=30)