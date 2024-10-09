# Django Setup Video
https://www.youtube.com/watch?v=qN_0EZ8M20Q

## Extra Notes
* If django-admin command does not work, you are not in virtual environment. Run python -m django [command].
* https://www.w3schools.com/django/index.php for extensive use i.e. app creation, table creation etc
* We are coding django using VS Code. We should try to keep this platform uniform in case there are different libraries in VS Code and other coding platforms
* Use pip list to confirm django is installed
* Everone should try to get to the main django webpage to see if their django is working properly.
* I used global python interpreter. However, if it does not work, the virtual environment python interpreter has to be used

## WHat files in app for django does
* models.py: This file defines the data models for the app, including the fields and behavior of the data. It is used to interact with the database using the built-in Django ORM.
* views.py: This file defines the views for the app, which handle specific requests and return a response. A view is a Python function that defines how to handle a specific URL.
* urls.py: This file defines the URLs for the app, including the mapping between URLs and views. It is used to control how URLs are handled by the app.
* forms.py: This file defines the forms for the app, which are used to handle form submissions and validation.
* admin.py: This file defines the admin interface for the app, which is used to manage the data through the built-in Django admin interface.
* migrations/: This directory contains the files related to database migrations. It is used to keep track of changes to the models and apply them to the database.
* templates/: This directory contains the templates for the app, which define the presentation of the data.
* static/: This directory contains the static files for the app, such as CSS, JavaScript, and images.
