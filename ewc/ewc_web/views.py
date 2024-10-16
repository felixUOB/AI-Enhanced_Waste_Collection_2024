from django.shortcuts import render, redirect
from rest_framework import viewsets
from .serializers import ewcSerializer
from.models import ewc

class ewcViewSet(viewsets.ModelViewSet):
    queryset = ewc.objects.all()
    serializer_class = ewcSerializer
