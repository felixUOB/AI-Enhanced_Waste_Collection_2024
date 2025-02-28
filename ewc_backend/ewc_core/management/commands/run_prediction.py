# an entry file for django to detect the subdirectories

from django.core.management.base import BaseCommand

from ewc_core.management.commands.prediction_model.import_data import generate_data
from ewc_core.management.commands.prediction_model.profet_model import run_prediction_model

class Command(BaseCommand):
    help = "Run Waste Prediction"
    
    def handle(self, *args, **kwards):
        self.stdout.write("Starting waste prediction...")
        file_path = generate_data()
        run_prediction_model(file_path, 8)
        self.stdout.write("Waste prediction completed!")