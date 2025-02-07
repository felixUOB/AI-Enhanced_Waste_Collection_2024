from django.test import TestCase
from ewc_core.models import Stops, StopCollection

class EwcCoreModelsTest(TestCase):
    def test_stops_creation(self):
        stop = Stops.objects.create(
            location_name="Test Location",
            latitude=51.5074,
            longitude=-0.1278,
            max_weight=100
        )
        self.assertEqual(str(stop), "Test Location")

    def test_stop_collection_creation(self):
        stop = Stops.objects.create(
            location_name="Test Location",
            latitude=51.5074,
            longitude=-0.1278,
            max_weight=100
        )
        stop_collection = StopCollection.objects.create(
            stop=stop,
            weight_collected=50
        )
        self.assertEqual(stop_collection.weight_collected, 50)
