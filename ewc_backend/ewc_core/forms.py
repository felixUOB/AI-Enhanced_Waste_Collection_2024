from django import forms
from .models import Stops

class StopsForm(forms.ModelForm):
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
