from django import forms
from .models import Stops

class StopsForm(forms.ModelForm):
    class Meta:
        model = Stops
        # Can select field
        fields = ['location_name', 'latitude', 'longitude', 'next_collection_due_date', 'max_weight']
