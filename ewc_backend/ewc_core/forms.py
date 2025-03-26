from django import forms
from .models import Stops

"""
This file defines Django forms for handling user input related to waste collection stops.

Forms:

1. StopsForm:
   - A `ModelForm` for the `Stops` model, allowing users to create or update stop locations.
   - Includes fields for:
     - `location_name`: Name of the collection stop.
     - `latitude` & `longitude`: Geographical coordinates of the stop.
     - `max_weight`: Maximum waste capacity at the stop.
     - `next_collection_due_date`: The predicted or manually set next collection date.
   - Provides a help text for `next_collection_due_date`, explaining that it is usually  
     set automatically by the system and should only be changed in special cases.
"""

class StopsForm(forms.ModelForm):
    '''
    A form for creating or updating waste collection stops.
    '''
    class Meta:
        model = Stops
        # Can select field
        fields = [
            'location_name',
            'latitude',
            'longitude',
            'max_weight',
            'next_collection_due_date',
        ]
        help_texts = {
            'next_collection_due_date': (
                "This date is usually set automatically by the model's prediction. "
                "Only change this if necessary for unusual scenarios."
            )
        }
        widgets = {
            'location_name': forms.TextInput(attrs={
                'class': 'form-control-modern',
            }),
            'latitude': forms.NumberInput(attrs={
                'class': 'form-control-modern', 
            }),
            'longitude': forms.NumberInput(attrs={
                'class': 'form-control-modern',  
            }),
            'max_weight': forms.NumberInput(attrs={
                'class': 'form-control-modern',  
            }),
            'next_collection_due_date': forms.DateInput(attrs={
                'class': 'form-control-modern',  
                'type': 'date', 
            }),
        }
