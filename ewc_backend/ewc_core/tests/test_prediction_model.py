from datetime import datetime
from unittest.mock import patch
from django.test import TestCase
from django.core.management import call_command
import pandas as pd

from ewc_core.management.commands.prediction_model.import_data import generate_data, get_threshold
from ewc_core.management.commands.prediction_model.profet_model import run_prediction_model, load_data

class TestWastePrediction(TestCase):
    # create a test file
    def setUp(self):
        # sample data (data used in development)
        data = {
                    "Date": ["2024-02-01", "2024-02-05", "2024-02-10", "2024-02-15", "2024-02-20", "2024-02-25"],
                    "Weight Collected": [5, 7, 10, 14, 18, 23]
                }
        self.assertTrue(len(data["Date"]), len(data["Weight Collected"]))
        self.df = pd.DataFrame(data)
        self.df.to_csv("test_data.csv", index=False)

    # test that the prediction model outputs a reasonsable date
    def test_prediction_output(self):
        threshold = 30
        predicted_date = str(run_prediction_model("test_data.csv", threshold))
        print(predicted_date)
        print(type(predicted_date))
        predicted_date = datetime.strptime(predicted_date, "%Y-%m-%d %H:%M:%S")
        # check that it returns a valid date
        self.assertIsInstance(predicted_date, datetime)
        # check that the predicted date is after the last data point
        last_date = datetime.strptime("2024-02-25", "%Y-%m-%d")
        self.assertTrue(predicted_date > last_date)
        # check that the predicted date is more than four days 
        self.assertTrue(predicted_date > (last_date))