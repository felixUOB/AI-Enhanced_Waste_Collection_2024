from rest_framework import serializers
from .models import Person

# Example Serializer
class PersonSerializer(serializers.ModelSerializer):
  class Meta:
    model = Person
    fields = '__all__'