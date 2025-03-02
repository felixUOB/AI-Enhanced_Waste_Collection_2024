# 2024-AIEnhancedWasteCollection

## **Contents**
- [Project proposal](#project-proposal)
- [Stakeholders](#stakeholders)
- [User stories](#user-stories)
- [Value Proposition](#value-Proposition)
- [Flow](#flow)
- [Tools and Resources](#tools-and-Resources)
- [**Getting Started**](#getting-started)
  - [Prerequisites](#prerequisites)
  - [App (Flutter)](#app-flutter)
  - [Backend (Django)](#backend-django)
- [Project Structure](#project-structure)
- [Kanban Chart](#kanban-Chart)
- [Gantte Chart](#gantte-Chart)
- [User Stories](#user-stories)
- [Team Members](#team-Members)
- [Supporting Mentor](#supporting-Mentor)
- [Architecture Diagram ](#architecture-Diagram)
- [Database Diagram](#database-diagram)


## **Project proposal**
In the realm of waste management, there is significant need to optimise systems to streamline waste collection as well as assess and reduce the environmental impact. 
Current solution focus on either the logistics of waste collection or reporting the impact but there is a lack of integration between the two. 
This project aims to combine these two elements and create a comprehensive AI-driven mobile application, compatible with both Android and iOS platforms for optimizing waste collection and a comprehensive system for quantifying environmental impacts, including carbon footprint reduction and energy savings. This integrated approach will enhance efficiency in waste management and provide valuable insights into environmental performance.



**The core functionality of this application revolves around:**

**Real-Time Route Optimization:** An AI based algorithms that creates personalised routes per collection truck. The route will update dynamically based on traffic, weather and volume of waste. The aim of the route is to be as efficient as possible in both time, cost, fuel and environmental impact.

**Historical Data Analysis:** Historical data from waste collection, such as volume and locations, is analysed to create predictions of where the most waste will be which will influence routes and frequency of waste collection.

**Generating reports:** In depth analysis of relevant ecological metrics, performed using AI analysis, collated into a comprehensive report. These will involve fuel consumption, time saved, carbon footprint, carbon and energy saving.

**The user interface:** This route will be displayed to specific users via the mobile application on a map. The user will receive notifications and audio prompts enabling hands-free use whilst driving. The report will also be available in the app to certain account types. 

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
Normal FLow:
1. Open app
2. Navigate to the screen showing the route
3. Follow the map
4. Receive notification if something changes

Exceptional Flow:
1. Open app
2. Navigate to the screen showing the route
3. Go the wrong way
4. Get diverted

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

First, clone the repository using:
```bash
https://github.com/spe-uob/2024-AIEnhancedWasteCollection.git
```


### App
- Navigate to the Flutter root directory: `cd 2024-AIEnhancedWasteCollection/ewc_frontend`
- Install all the necessary dependencies: `flutter pub get`
- Launch an iOS or Android emulator.
- Start the application: `flutter run` or, to specify a platform: `flutter run -d <DEVICE_ID>`

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
    DATABASE_USERNAME = "YOUR_DATABASE_USERNAME"
    DATABASE_PASSWORD = "YOUR_DATABASE_PASSWORD"
    DATABASE_HOST = "YOUR_DATABASE_HOST"
    DATABASE_PORT = "YOUR_DATABASE_PORT"
    ```

- Run Migrations and Start the Django server:
  ```bash 
  python manage.py migrate
  python manage.py runserver
  ```

### Flutter APIs
Navigate to the root directory of the Flutter project `cd 2024-AIEnhancedWasteCollection/ewc_frontend`

- Inside ewc_frontend/, you may store environment variables in a .env file for the Flutter app (e.g., an API_KEY for route calculation).


- Example `.env` file: 

  ```bash
  API_KEY = "YOUR_ORS_SECRET_KEY
  ```
  
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

## **Kanban Chart**
[Kanban](https://github.com/orgs/spe-uob/projects/161/views/1)

## **Gantte Chart**
[Gantte Chart](https://uob-my.sharepoint.com/:x:/g/personal/yj23812_bristol_ac_uk/EfdWH23kdE5HvLSvT2PgaNkBh5i5-XZW6Zx429NoYpNWDw?e=cIhVW5)

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

<img width="947" alt="Screenshot 2024-10-09 at 15 10 10" src="https://github.com/user-attachments/assets/47126bfd-216d-4ed0-af83-25c644637679">

# **Database Diagram**

<img width="900" alt="image" src="https://github.com/user-attachments/assets/063dae5e-0fce-4dff-956f-77c55aae6129" />

