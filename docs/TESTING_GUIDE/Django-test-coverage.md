# Testing Guide

This document outlines how to organise and write tests in this Django project.

---

## Directory Structure

- All tests are located in **`ewc_core/tests/`**.
- Each file (e.g., **`test_models.py`**, **`test_api.py`**) focuses on a different aspect of the code.

---

## Test Types

1. **Unit Tests**  
   - Focus on small pieces of logic (e.g., individual model methods).

2. **Integration Tests**  
   - Test multiple parts of the system working together (e.g., an API endpoint that talks to the database).

3. **End-to-End Tests** *(if needed)*  
   - May use additional tools or frameworks to simulate user actions in a browser.

---

## Best Practices

1. **Keep tests small and focused**  
   - Each test should validate a specific behavior or logic.
2. **Name your test methods clearly**  
   - For example, use a descriptive name like `test_stop_creation_succeeds()`.
3. **Use Django’s TestCase for database isolation**  
   - This helps avoid test data leaking between tests, since each test runs within a transaction that’s rolled back.

---

## Writing a Test

1. **Create a test file in `ewc_core/tests/`.**  
   - Use a filename that matches what you are testing.  
   - For example, `test_models.py` for model tests.

2. **Import the necessary Django or pytest modules.**  
   - For Django’s built-in testing framework, you typically do:
     ```python
     from django.test import TestCase
     from ewc_core.models import Stop
     ```

3. **Create a test class that inherits from `django.test.TestCase`.**  
   - Or use `unittest.TestCase` if you prefer.
     ```python
     class StopModelTest(TestCase):
         def test_stop_creation(self):
             stop = Stop.objects.create(latitude=37.0, longitude=127.0)
             self.assertIsNotNone(stop.stop_id)
     ```

4. **Run tests**  
   - In your terminal (in ewc_backend directory):
     ```bash
     python manage.py test ewc_core.tests
     ```
   - This command will automatically discover and run all tests in the `ewc_core/tests/` directory.

## How to View the HTML Coverage Report

1. **Wait for the GitHub Actions workflow to complete.**  
2. **Navigate to the “Artifacts” section** in the workflow run (on GitHub). You should see an artifact named `django-coverage-html`.
3. **Download that artifact** to your local machine.
4. **Locate the `htmlcov/index.html`** file inside the unzipped folder.
5. **Open `index.html` in any web browser** to see a detailed, line-by-line coverage report for each file.