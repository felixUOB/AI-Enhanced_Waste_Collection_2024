# 2024-AIEnhancedWasteCollection

<div align="center">

[![Django Badge](https://img.shields.io/badge/Django-3.2%2B-0C4B33?style=for-the-badge&logo=django&logoColor=white&labelColor=1F2F2C)](https://www.djangoproject.com/)
[![Flutter Badge](https://img.shields.io/badge/Flutter-3.x-4AB3F4?style=for-the-badge&logo=flutter&logoColor=white&labelColor=025B85)](https://docs.flutter.dev/)
[![OpenStreetMap Badge](https://img.shields.io/badge/OpenStreetMap-API-87B649?style=for-the-badge&logo=openstreetmap&logoColor=white&labelColor=546F3F)](https://www.openstreetmap.org/)
[![OpenRouteService Badge](https://img.shields.io/badge/OpenRouteService-Routing-FCA503?style=for-the-badge&labelColor=9B6A00)](https://openrouteservice.org/)
[![Prophet Badge](https://img.shields.io/badge/Prophet-TimeSeries-8A2BE2?style=for-the-badge&labelColor=5B1B8A)](https://facebook.github.io/prophet/)
[![AWS Badge](https://img.shields.io/badge/AWS-EC2%20%7C%20RDS-FEBD69?style=for-the-badge&logo=amazon-aws&logoColor=black&labelColor=6D5324)](https://aws.amazon.com/)
[![SendGrid Badge](https://img.shields.io/badge/SendGrid-Email-0055BA?style=for-the-badge&logo=sendgrid&logoColor=white&labelColor=003A6D)](https://sendgrid.com/)



</div>

---

## **Contents**
1. [Project proposal](#project-proposal)  
2. [Stakeholders](#stakeholders)  
3. [User stories](#user-stories)  
4. [Value Proposition](#value-proposition)  
5. [Flow](#flow)  
6. [Tools and Resources](#tools-and-resources)  
7. [Getting Started](#getting-started)  
   - [Prerequisites](#prerequisites)  
   - [App (Flutter)](#app-flutter)  
   - [Backend (Django)](#backend-django)  
   - [User Instructions](#user-instructions)  
8. [Project Structure](#project-structure)  
9. [Team Members](#team-members)  
10. [Architecture Diagram](#architecture-diagram)  
11. [Database Diagram](#database-diagram)  
12. [Supporting Mentor](#supporting-mentor)  

---

## Project proposal
In the realm of waste management, there is a significant need to optimise systems to streamline waste collection and assess/reduce environmental impact. Current solutions often address either logistics **or** impact reporting, but not both cohesively. This project merges these elements into an AI-driven mobile application (Android/iOS) for **route optimisation** plus a system to quantify environmental performance (carbon footprint, energy savings, etc.). This integrated approach enhances efficiency in waste management and provides valuable ecological insights.

**Core functionality** includes:
- **Real-Time Route Optimisation**: An AI-based algorithm generating personalized routes for each collection truck, adapting to traffic, weather, and waste volume.
- **Historical Data Analysis**: Collecting data on volume/locations to forecast high-waste areas and plan frequencies.
- **Comprehensive Reports**: Fuel consumption, time saved, and carbon/energy savings, compiled into a single view.
- **User Interface**: A mobile map-based route interface, with push notifications and optional audio prompts.

---

## **Stakeholders**

**SpaceNXT (RecycleNXT):**
- Involvement : RecycleNXT is a branch of SpaceNXT, the company patnering with the Computer Science department of University  of Bristol. This stakeholder will provide guidance, help and advise on the creation of the AI Waste Collection Application, such that said application will be in line with their company rules and regulations
- Use for the system: RecycleNXT will utilise the application in a province of India, if this proof of concept is successful. RecycleNXT wants an application that provides an optimal that uses less fuel, collects data regarding user's waste collection , and an AI that could predict results based on previous waste collection. 

**Waste collectors:**
- Involvement: They are the primary users of the app, interacting directly with the mobile applications while on duty collecting waste.
- Use for the system: The waste collectors will follow the routes shown on the maps in order to collect the waste. They will also be logging information about the amount of waste they are collecting.

**City councils/Municipalities:**
- Involvement: City councils are responsible for contracting waste management companies, organising collection and employment and training of the waste collectors. 
- Use of the system: They are likely to want to use the application to plan waste collection in their city to get the most efficient results and save money.

**Waste management companies:**
- Involvement: Private waste managing companies, similarly to the city council, are responsible for organising collection.
- Use of the system: They will be using the system to plan their routes and make sure they are being as efficient as possible.

**Environmental organisations:**
- Involvement: Interested in viewing and using the reports to help monitor waste companies and inform decisions and legislations around waste collection and carbon emissions
- Use of the system: The environmental organisation will access the reports to gather information about the carbon footprint, emissions and carbon and energy saving, which will help them monitor and protect the environment.

**Households and businesses:**
- Involvement: Whilst not directly involved they will be generating the waste and putting it out for collection.
- Use of the system: Whist not directly using the system they will be contributing to the data, patterns and behaviours that allow the prediction algorithms to work. 

---

## User stories
As a **waste collector**, I want to be able to *view the routes easily* so that I can *follow them and collect the waste*.

As a **waste collector,** I want to be able to *log data about waste volume* so that I can *help build a database to aid the predictions*.

As a **city council/municipal**, I want to be able to *enter the area for collection/collection points and get the routes* so that my *employees can follow them and all the waste is collected.*

As a **city council/municipal/waste management company**, I want to be able to have the *most efficient route increase in terms of efficiency and reduction of carbon footprint*, so that we *save money and time*.

As a **city council/municipal/waste management company**, I want to *avoid the areas of most traffic*, so that we *reduce congestion in the busy areas*.

As a **city council/municipal/waste management company**, I want to be able to *see the environmental report*, so that we can *see if we are making a positive impact*.

As an **environmental organisation**, I want to be able to *see the reports on environment impacts*, so I can *view the data and use it in my own decisions*.

As an **environmental organisation**, I want to be able to *see that the routes are reducing the amount of carbon and emissions via the report*, so I can be *sure the company is helping to protect the environment*.

As a **system manager**, I want *well documented and modular code*, so that I can *install and maintain the code easily*.

As a **legislator**, I want *secure code which is compliant with data protection*, so that *data is being handled correctly*.

As a **household/business**, I want an *appropriate frequency of waste collection* so that the *bins are not overflowing*.

As a **household/business**, I want the *waste collection vehicles to have the most efficient routes*, so that they are *off the roads as soon as possible and not contributing to congestion*. 

---

## **Value Proposition**
This project delivers a holistic solution that not only optimises waste collection routes through AI but also provides actionable insights into the environmental impact of recycling activities. By integrating scheduling with impact reporting, the system supports better decision-making and enhances sustainability efforts. The unique combination of real-time optimisation and detailed impact quantification sets this project apart in the market.

---

## **Flow**
- **Normal Flow**: (1) Open app → (2) View route → (3) Follow route → (4) Receive notifications.  
- **Exceptional Flow**: (1) Open app → (2) View route → (3) Deviate → (4) App re-routes.

---

## **Tools and Resources**

- **Python 3.12**  
  Used for server-side logic, machine learning tasks, and Django-based backend.

- **Django (3.2+)**  
  Provides the main backend framework, REST API endpoints, and admin interface.

- **Flutter (3.x)**  
  Drives the cross-platform mobile frontend (Android/iOS) for route display and data input.

- **Docker & Docker Compose**  
  Used to containerise both the Django backend (`ewc_backend`) and the Flutter frontend (`ewc_frontend`) for easy deployment and consistent environments.

- **AWS EC2/RDS**  
  Cloud hosting for production environment; can host the Django server and database.

- **OpenStreetMap & OpenRouteService**  
  Provides map data and routing APIs for calculating optimised routes.

- **Prophet**  
  Used in the backend for time-series predictions on waste generation or other metrics.

- **SendGrid**  
  Handles password-reset emails and other email notifications.

- **GitHub**  
  Version control, pull requests, continuous integration (via GitHub Actions), and project management.

---

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

---

### App (Flutter)
- Navigate to the Flutter root directory: `cd 2024-AIEnhancedWasteCollection/ewc_frontend`
- Install all the necessary dependencies: `flutter pub get`
- Configure .env in ewc_frontend/.env for the Flutter app (e.g. API_KEY for route calculations, ):

  ```bash
  API_KEY="YOUR_ORS_SECRET_KEY"
  ENCRYPTION_KEY="YOUR_ENCRYPTION_KEY"
  ```
If you also need anything like ENCRYPTION_KEY on the front-end side, you can place them here.

- Launch an iOS or Android emulator.
- Run the application:`flutter run` 
- Or run on specify a device: `flutter run -d <DEVICE_ID>`

---

### Backend (Django)
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
```

- Run Migrations and Start the Django server:
  ```bash 
  python manage.py migrate
  python manage.py runserver
  ```

You can now access the backend at http://127.0.0.1:8000.

---

## **User Instructions**

1. **Registration**
   - Open the app and tap **“Register”**.
   - Enter your *username, password, email, phone number*, etc.
   - Upon success, the Django backend creates an account in the database.

2. **Login**
   - On the **“Sign In”** screen, provide your username/password.
   - If you check **“Remember Me,”** your credentials are encrypted with `ENCRYPTION_KEY` and stored locally, so you won’t have to re-enter them next time.

3. **Password Reset**
   - From the **“Forgot Password?”** link, you’ll go to a page (or external link) that sends an email via **SendGrid** using `SENDGRID_SECRET_KEY`.
   - Follow the link in the email to reset your password.

4. **Viewing Routes**
   - Once logged in, you’ll see a map with an **optimised waste collection route**.
   - Tap **“Start Journey”** to begin the route guidance.

5. **Logging Waste Collection**
   - In the app, input the **waste volume** at each stop.
   - This data is sent to the backend for analytics and future route optimisations.

---

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
---

## **Team Members**
| Members                      | Email                                                 |
| ---------------------------- | ----------------------------------------------------- |
| Alex Gordon                  | [em23081@bristol.ac.uk](mailto:em23081@bristol.ac.uk) |
| Ezen Tan                     | [mo23274@bristol.ac.uk](mailto:mo23274@bristol.ac.uk) |
| Felix Coupe                  | [zx23695@bristol.ac.uk](mailto:zx23695@bristol.ac.uk) |
| Henry Shin                   | [bg22915@bristol.ac.uk](mailto:bg22915@bristol.ac.uk) |
| Katie Pambakian              | [yj23812@bristol.ac.uk](mailto:yj23812@bristol.ac.uk) |
| Marek Janiec                 | [qx23239@bristol.ac.uk](mailto:qx23239@bristol.ac.uk) |

---

## **Architecture Diagram**

<div align="center">
  <img src="docs/images/ArchitectureDiagram.png" alt="Architecture Diagram" width="900" />
</div>

---

# **Database Diagram**

<img width="900" alt="image" src="https://github.com/user-attachments/assets/063dae5e-0fce-4dff-956f-77c55aae6129" />

---

## **Supporting Mentor**
- Matthew Cudby