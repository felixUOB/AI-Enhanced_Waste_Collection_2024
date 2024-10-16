# serializers.py
from rest_framework import serializers
from .models import ewc

class ewcSerializer(serializers.ModelSerializer):
    class Meta:
        model = ewc
        fields = ['id', 'name', 'description', 'created_at']