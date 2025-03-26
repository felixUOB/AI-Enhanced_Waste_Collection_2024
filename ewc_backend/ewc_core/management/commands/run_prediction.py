# an entry file for django to detect the subdirectories

from django.core.management.base import BaseCommand, CommandParser
from ...models import Stops

from ewc_core.management.commands.prediction_model.import_data import generate_data, get_threshold
from ewc_core.management.commands.prediction_model.profet_model import run_prediction_model

"""
This file defines a custom Django management command for running a waste prediction model  
on a specified waste collection stop.

Command: `run_waste_prediction`

Key Responsibilities:

1. Data Retrieval and Processing:
   - Uses `generate_data(stop_id)` to fetch historical waste collection data.
   - Calls `get_threshold(stop_id)` to determine the waste threshold for prediction.

2. Running the Prediction Model:
   - Executes `run_prediction_model(file_path, threshold)` to generate a predicted  
     collection date based on collected waste data.

3. Database Update:
   - Updates the `next_collection_due_date` for the specified stop in the database.

Methods:

- `write_to_db(stopid, date)`: Saves the predicted collection date to the `Stops` model.
- `model(stopid)`: Runs the entire prediction workflow and stores the result.
- `add_arguments(parser)`: Defines `stop_id` as a required command argument.
- `handle(*args, **kwargs)`: Orchestrates the process, executing the prediction model for  
  the given stop ID.
"""

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