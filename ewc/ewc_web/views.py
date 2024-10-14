from django.shortcuts import render
from rest_framework import viewsets
from .models import Person
from .serializers import PersonSerializer

# Create your views here.

# Example view
class PersonView(viewsets.ModelViewSet):
    queryset = Person.objects.all().order_by('firstName')
    serializer_class = PersonSerializer