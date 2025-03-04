# 2024-AIEnhancedWasteCollection

<div align="center">

[![Django Badge](https://img.shields.io/badge/Django-3.2%2B-brightgreen?style=flat-square&logo=django&logoColor=white)](https://www.djangoproject.com/)
[![Flutter Badge](https://img.shields.io/badge/Flutter-3.x-02569B?style=flat-square&logo=flutter&logoColor=white)](https://docs.flutter.dev/)
[![OpenStreetMap Badge](https://img.shields.io/badge/OpenStreetMap-API-7EBC6F?style=flat-square&logo=OpenStreetMap&logoColor=white)](https://www.openstreetmap.org/)
[![OpenRouteService Badge](https://img.shields.io/badge/OpenRouteService-Routing-FF7600?style=flat-square)](https://openrouteservice.org/)
[![Prophet Badge](https://img.shields.io/badge/Prophet-TimeSeries-blue?style=flat-square)](https://facebook.github.io/prophet/)
[![AWS Badge](https://img.shields.io/badge/AWS-EC2%20%7C%20RDS-orange?style=flat-square&logo=amazon-aws&logoColor=white)](https://aws.amazon.com/)
[![SendGrid Badge](https://img.shields.io/badge/SendGrid-Email-blue?style=flat-square&logo=sendgrid&logoColor=white)](https://sendgrid.com/)

</div>

## **Contents**
- [Project proposal](#project-proposal)
- [Stakeholders](#stakeholders)
- [User stories](#user-stories)
- [Value Proposition](#value-Proposition)
- [Flow](#flow)
- [Tools and Resources](#tools-and-Resources)
- [**Getting Started**](#getting-started)
  - [Prerequisites](#prerequisites)
  - [App (Flutter)](#app)
  - [Backend (Django)](#backend)
  - [User Instructions](#User-Instructions)
- [Project Structure](#project-structure)
- [Kanban Chart](#kanban-Chart)
- [Gantte Chart](#gantte-Chart)
- [User Stories](#user-stories)
- [Team Members](#team-Members)
- [Supporting Mentor](#supporting-Mentor)
- [Architecture Diagram ](#architecture-Diagram)
- [Database Diagram](#database-diagram)


## **Project proposal**
In the realm of waste management, there is significant need to optimise systems to streamline waste collection as well as assess and reduce the environmental impact. Current solutions focus on either the logistics of waste collection or reporting the impact, but there is a lack of integration between the two. This project aims to combine these two elements and create a comprehensive AI-driven mobile application, compatible with both Android and iOS platforms, for optimizing waste collection and a comprehensive system for quantifying environmental impacts (including carbon footprint reduction and energy savings). This integrated approach will enhance efficiency in waste management and provide valuable insights into environmental performance.

**The core functionality of this application revolves around:**

- **Real-Time Route Optimization**: An AI-based algorithm that creates personalized routes per collection truck, updating dynamically based on traffic, weather, and volume of waste.  
- **Historical Data Analysis**: Collecting historical data for predictions on waste volume and location, influencing routes and frequency.  
- **Generating Reports**: Detailed ecological metric analysis, including fuel consumption, time saved, and carbon/energy savings.  
- **User Interface**: The route is displayed in a mobile app (map-based), with notifications/audio prompts. Relevant reports are accessible to certain user roles.

## **Stakeholders**

**SpaceNXT (RecycleNXT):**
- Involvement : RecycleNXT is a branch of SpaceNXT, the company patnering with the Computer Science department of University  of Bristol. This stakeholder will provide guidance, help and advise on the creation of the AI Waste Collection Application, such that said application will be in line with their company rules and regulations
- Use for the system: RecycleNXT will utilise the application in a province of India, if this proof of concept is successful. RecycleNXT wants an application that provides an optimal that uses less fuel, collects data regarding user's waste collection , and an AI that could predict results based on previous waste collection. 

**Waste collectors:**
* Involvement: They are the primary users of the app, interacting directly with the mobile applications while on duty collecting waste.
* Use for the system: The waste collectors will follow the routes shown on the maps in order to collect the waste. They will also be logging information about the amount of waste they are collecting.

**City councils/Municipalities:**
* Involvement: City councils are responsible for contracting waste management companies, organising collection and employment and training of the waste collectors. 
* Use of the system: They are likely to want to use the application to plan waste collection in their city to get the most efficient results and save money.

**Waste management companies:**
* Involvement: Private waste managing companies, similarly to the city council, are responsible for organising collection.
* Use of the system: They will be using the system to plan their routes and make sure they are being as efficient as possible.

**Environmental organisations:**
* Involvement: Interested in viewing and using the reports to help monitor waste companies and inform decisions and legislations around waste collection and carbon emissions
* Use of the system: The environmental organisation will access the reports to gather information about the carbon footprint, emissions and carbon and energy saving, which will help them monitor and protect the environment.

**Households and businesses:**
* Involvement: Whilst not directly involved they will be generating the waste and putting it out for collection.
* Use of the system: Whist not directly using the system they will be contributing to the data, patterns and behaviours that allow the prediction algorithms to work. 

## User stories
As a **waste collector**, I want to be able to **view the routes easily** so that I can **follow them and collect the waste**.

As a **waste collector,** I want to be able to **log data about waste volume** so that I can **help build a database to aid the predictions**.

As a **city council/municipal**, I want to be able to **enter the area for collection/collection points and get the routes** so that my **employees can follow them and all the waste is collected.**

As a **city council/municipal/waste management company**, I want to be able to have the **most efficient route increase in terms of efficiency and reduction of carbon footprint**, so that we **save money and time**.

As a **city council/municipal/waste management company**, I want to **avoid the areas of most traffic**, so that we **reduce congestion in the busy areas**.

As a **city council/municipal/waste management company**, I want to be able to **see the environmental report**, so that we can **see if we are making a positive impact**.

As an **environmental organization**, I want to be able to **see the reports on environment impacts**, so I can **view the data and use it in my own decisions**.

As an **environmental organization**, I want to be able to **see that the routes are reducing the amount of carbon and emissions via the report**, so I can be **sure the company is helping to protect the environment**.

As a **system manager**, I want **well documented and modular code**, so that I can **install and maintain the code easily**.

As a **legislator**, I want **secure code which is compliant with data protection**, so that **data is being handled correctly**.

As a **household/business**, I want an **appropriate frequency of waste collection** so that the **bins are not overflowing**.

As a **household/business**, I want the **waste collection vehicles to have the most efficient routes**, so that they are **off the roads as soon as possible and not contributing to congestion**. 


## **Value Proposition**
This project delivers a holistic solution that not only optimizes waste collection routes through AI but also provides actionable insights into the environmental impact of recycling activities. By integrating scheduling with impact reporting, the system supports better decision-making and enhances sustainability efforts. The unique combination of real-time optimization and detailed impact quantification sets this project apart in the market.

## **Flow**
- **Normal Flow**: (1) Open app → (2) View route → (3) Follow route → (4) Receive notifications.  
- **Exceptional Flow**: (1) Open app → (2) View route → (3) Deviate → (4) App re-routes.

## **Tools and Resources**
- Development Tools: **Python**, machine learning libraries, and app development
frameworks.
- Infrastructure: **Azure VM** for hosting and computation.
- Collaboration and Documentation: **GitHub** for version control and project management.

## Getting Started


### Prerequisites

To build this application, you’ll need the following tools:

- Android Studio (for Android App) [Offical Documentation](https://developer.android.com/studio/install)
- XCode (for iOS App) [Offical Documentation](https://developer.apple.com/documentation/safari-developer-tools/installing-xcode-and-simulators)
- Flutter SDK [Offical Documentation](https://docs.flutter.dev/get-started/install)
- Python 3.12 [Offical Documentation](https://wiki.python.org/moin/BeginnersGuide/Download)

Clone the repository using:
```bash
git clone https://github.com/spe-uob/2024-AIEnhancedWasteCollection.git
```


### App
1. Navigate to the Flutter root directory: `cd 2024-AIEnhancedWasteCollection/ewc_frontend`
2. Install all the necessary dependencies: `flutter pub get`
3. Configure .env in ewc_frontend/.env for the Flutter app (e.g. API_KEY for route calculations, ):

  ```bash
  API_KEY="YOUR_ORS_SECRET_KEY"
  SENDGRID_SECRET_KEY="YOUR_SENDGRID_SECRET_KEY"
  ENCRYPTION_KEY="YOUR_ENCRYPTION_KEY"
  ```
If you also need anything like SENDGRID_SECRET_KEY or ENCRYPTION_KEY on the front-end side, you can place them here.
4. Launch an iOS or Android emulator.
5.	Run the application:`flutter run` 
Or specify a device: `flutter run -d <DEVICE_ID>`

      

### Backend
- Move to the ewc directory by running `cd 2024-AIEnhancedWasteCollection/ewc_backend`
- Install Python dependencies:
  ```bash
  pip install --upgrade pip
  pip install -r requirements.txt
  ```
- Configure environment variables in .env (which should be located under ewc_backend/.env).

  - DJANGO_SECRET_KEY
  - DATABASE_USERNAME
  - DATABASE_PASSWORD
  - DATABASE_HOST
  - DATABASE_PORT

  
Example `.env` file:

```python
DJANGO_SECRET_KEY = "YOUR_DJANGO_SECRET_KEY"
POSTGRES_USER = "YOUR_DATABASE_USERNAME"
POSTGRES_PASSWORD = "YOUR_DATABASE_PASSWORD"
POSTGRES_HOST = "YOUR_DATABASE_HOST"
POSTGRES_PORT = "YOUR_DATABASE_PORT"

# Additional ENV for password reset & encryption
SENDGRID_SECRET_KEY="YOUR_SENDGRID_API_KEY"    # for password reset email
ENCRYPTION_KEY="YOUR_ENCRYPTION_KEY"           # for 'Remember Me' functionality
```

- Run Migrations and Start the Django server:
  ```bash 
  python manage.py migrate
  python manage.py runserver
  ```

You can now access the backend at http://127.0.0.1:8000.
  


## **User Instructions**

1.	Registration
	•	Open the app and tap “Register.”
	•	Enter your username, password, email, phone number, etc.
	•	Upon success, the Django backend creates an account in the database.

2. Login
	•	On the “Sign In” screen, provide your username/password.
	•	If you check “Remember Me,” your credentials will be encrypted with ENCRYPTION_KEY and stored locally, so you don’t have to re-enter them next time.

3. Password Reset
	•	From the “Forgot Password?” link, you’ll be taken to a page (or external link) that sends an email via SendGrid using SENDGRID_SECRET_KEY.
	•	Follow the link in the email to reset your password.

4. Viewing Routes
	•	Once logged in, you’ll see a map with an optimised waste collection route.
	•	Tap “Start Journey” to begin the route guidance.

5.	Logging Waste Collection
	•	In the app, input the waste volume at each stop. This data is sent to the backend for analytics and future route optimisations.


## **Project Structure**

```bash
2024-AIEnhancedWasteCollection
├── .github/                       # GitHub Actions, Issue/PR Templates, etc.
├── docs/                          # Documentation or design docs
├── ewc_backend/                   # Django-based backend
│   ├── ewc_admin/                 # Django project-level config
│   │   ├── __init__.py
│   │   ├── asgi.py                # ASGI entry point
│   │   ├── settings.py            # Django settings (DB config, installed apps)
│   │   ├── urls.py                # Root URL routes
│   │   └── wsgi.py                # WSGI entry point
│   ├── ewc_core/                  # Core Django app containing actual logic
│   │   ├── migrations/            # DB migration files (auto-generated)
│   │   ├── ml_model/              # ML-related code (Prophet, model training)
│   │   ├── tests/                 # Django unit tests
│   │   ├── admin.py               # Django admin site configurations
│   │   ├── apps.py                # Django app config
│   │   ├── forms.py               # Django forms
│   │   ├── models.py              # Django models (UserProfile, Stops, etc.)
│   │   ├── serializers.py         # DRF serializers
│   │   └── views.py               # DRF views / endpoints
│   ├── templates/                 # Django HTML templates
│   ├── .dockerignore
│   ├── .gitignore
│   ├── docker-compose.yml         # Docker Compose for the backend
│   ├── dockerfile                 # Docker build for the backend
│   ├── manage.py                  # Django CLI entry point
│   └── requirements.txt           # Python dependencies
├── ewc_frontend/                  # Flutter-based mobile frontend
│   ├── android/                   # Android-specific config (Gradle, Manifest)
│   ├── assets/                    # Images, logos, etc.
│   ├── build/                     # Generated build files
│   ├── fonts/                     # Custom font files
│   ├── ios/                       # iOS-specific config (Info.plist, Xcode)
│   ├── lib/                       # Main Flutter/Dart source
│   │   ├── models/                # Data models (Dart side)
│   │   ├── notifiers/             # ChangeNotifier classes
│   │   ├── screens/               # Flutter UI screens (login, register, etc.)
│   │   ├── services/              # API services, AuthService, etc.
│   │   ├── theme/                 # App-wide theme settings
│   │   └── widgets/               # Reusable widgets (buttons, textfields, dialogs)
│   ├── linux/
│   ├── macos/
│   ├── test/                      # Flutter widget/unit tests
│   ├── web/
│   ├── windows/
│   ├── .dockerignore
│   ├── .gitignore
│   ├── analysis_options.yaml      # Lint rules
│   ├── devtools_options.yaml
│   ├── docker-compose.yml         # Docker Compose for frontend
│   ├── dockerfile                 # Docker build for the frontend
│   ├── pubspec.lock               # Locked Flutter package versions
│   ├── pubspec.yaml               # Flutter dependencies & project config
│   └── main.dart                  # main entry for the Flutter app
├── LICENSE
├── README.md                      # Project readme
└── ... (others like EWC-ReleaseChecklist.pdf, etc.)
```

## **Team Members**
| Members                      | Email                                                 |
| ---------------------------- | ----------------------------------------------------- |
| Alex Gordon                  | [em23081@bristol.ac.uk](mailto:em23081@bristol.ac.uk) |
| Ezen Tan                     | [mo23274@bristol.ac.uk](mailto:mo23274@bristol.ac.uk) |
| Felix Coupe                  | [zx23695@bristol.ac.uk](mailto:zx23695@bristol.ac.uk) |
| Henry Shin                   | [bg22915@bristol.ac.uk](mailto:bg22915@bristol.ac.uk) |
| Katie Pambakian              | [yj23812@bristol.ac.uk](mailto:yj23812@bristol.ac.uk) |
| Marek Janiec                 | [qx23239@bristol.ac.uk](mailto:qx23239@bristol.ac.uk) |

## **Supporting Mentor**
- Matthew Cudby

## **Architecture Diagram**

![Screenshot 2025-03-04 at 10.01.37 pm.png](../../../../var/folders/9g/30t_4t0s17v7zw1kw48zbmy00000gn/T/TemporaryItems/NSIRD_screencaptureui_jpAWXf/Screenshot%202025-03-04%20at%2010.01.37%E2%80%AFpm.png)

# **Database Diagram**

<img width="900" alt="image" src="https://github.com/user-attachments/assets/063dae5e-0fce-4dff-956f-77c55aae6129" />

