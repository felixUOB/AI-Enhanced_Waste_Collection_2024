# an entry file for django to detect the subdirectories

from django.core.management.base import BaseCommand

from ewc_core.management.commands.prediction_model.import_data import generate_data, get_threshold
from ewc_core.management.commands.prediction_model.profet_model import run_prediction_model

class Command(BaseCommand):
    help = "Run Waste Prediction"
    
    def handle(self, *args, **kwards):
        self.stdout.write("Starting waste prediction...")
        # pass into generate_data the stopid of the stop
        stopid = 3
        file_path = generate_data(stopid)
        threshold = get_threshold(stopid)
        run_prediction_model(file_path, threshold)
        self.stdout.write("Waste prediction completed!")