from django.test import TestCase
from datetime import datetime
from reportlab.graphics.shapes import Drawing
from django.http import HttpResponse
from ewc_core import utils

class UtilsTest(TestCase):
    def test_get_last_6_months(self):
        """Should return a list of 6 entries in the format 'MMM YYYY'."""
        months = utils.get_last_6_months()
        self.assertEqual(len(months), 6)
        # Check if data is in the format 'MMM YYYY'
        for m in months:
            self.assertRegex(m, r'^[A-Z][a-z]{2} \d{4}$')
    
    def test_calculate_percentage_change(self):
        """Tests percentage change calculation."""
        # If the old_value is zero, it should return 0
        self.assertEqual(utils.calculate_percentage_change(0, 100), 0)
        # Calculation to be performed: (new - old)/old * 100 rounded to 2 decimal places
        self.assertEqual(utils.calculate_percentage_change(50, 75), 50.0)
        self.assertEqual(utils.calculate_percentage_change(100, 80), -20.0)
    
    def test_calculate_carbon_emissions_per_route(self):
        """Tests carbon emissions calculation."""
        # Test values: distance=100, mpg=25, emissions = 100/25 * 8.89041
        expected = (100 / 25) * 8.89041
        self.assertAlmostEqual(utils.calculate_carbon_emissions_per_route(100, 25), expected, places=5)
    
    def test_calculate_energy_consumption_per_route(self):
        """Tests energy consumption calculation."""
        # energy consumption = distance/mpg
        expected = 120 / 30
        self.assertEqual(utils.calculate_energy_consumption_per_route(120, 30), expected)
    
    def test_calculate_cost_per_route(self):
        """Tests cost calculation given a cost per gallon."""
        # Test values: distance=100, mpg=20, cost_per_gallon = 3.0, cost = 100/20*3 = 15
        expected = (100 / 20) * 3.0
        self.assertEqual(utils.calculate_cost_per_route(100, 20, 3.0), expected)
    

    def test_create_line_chart_returns_drawing(self):
        """Tests that create_line_chart returns a Drawing instance.
           Simulate db_data with a test object with the following attributes 'date', 'distance', 'mpg'.
        """
        TestObj = lambda date, distance, mpg: type("Test", (), {"date": date, "distance": distance, "mpg": mpg})
        today = datetime.today().date()
        db_data = [TestObj(today, 100 + i * 10, 20 + i) for i in range(6)]
        drawing = utils.create_line_chart(db_data)
        self.assertIsInstance(drawing, Drawing)
    

    def test_generate_pdf_returns_httpresponse(self):
        """Tests that generate_pdf returns an HttpResponse with PDF content.
           Patched RouteEnvData.objects.filter so it return an empty list.
        """
        from unittest.mock import patch
        with patch('ewc_core.utils.RouteEnvData.objects.filter', return_value=[]):
            response = utils.generate_pdf()
            self.assertIsInstance(response, HttpResponse)
            self.assertEqual(response['Content-Type'], 'application/pdf')