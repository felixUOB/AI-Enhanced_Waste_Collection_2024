# an entry file for django to detect the subdirectories

from django.core.management.base import BaseCommand, CommandParser
from ...models import Stops

from ewc_core.management.commands.prediction_model.import_data import generate_data, get_threshold
from ewc_core.management.commands.prediction_model.profet_model import run_prediction_model

class Command(BaseCommand):
    help = "Run Waste Prediction"

    # save the result to the database
    def write_to_db(self, stopid, date):
        # 
        stop = Stops.objects.get(stop_id=stopid)
        print(stop.location_name)
        stop.next_collection_due_date = date
        stop.save()

    def model(self, stopid):
        # get the data for that stop
        file_path = generate_data(stopid)
        # file_path = 'ewc_core/management/commands/prediction_model/data/data.csv'
        threshold = get_threshold(stopid)
        result = run_prediction_model(file_path, threshold)
        print(result)
        #write it back to the database
        self.write_to_db(stopid, result)
        return result

    def add_arguments(self, parser):
        parser.add_argument('stop_id',type=int)

    def handle(self, *args, **kwards):
        # get the stop given as an argument
        stop_id = kwards['stop_id']
        self.stdout.write("Starting waste prediction...")
        # run the model
        self.model(stop_id)
        self.stdout.write("Waste prediction completed!")