# AI-Enhanced Waste Collection Handover Document

## Contents
- Introduction [#Introduction]
- Build [#Build]
- Execution [#Execution]
- System Architecture [#System_Architecture]
- Project Structure [#Project_Structure]
- Database Structure [#Database_Structure]
- AWS Setup [#AWS_Setup]
- Further Documentation [#Further_Documentation]

## Introduction 
This document contains all the essential information required for handover. Including the structure of our project and everything required to takeover development.
Additional information can be found in the README.md in the root directory and under the Further Documentation section.

## Build

### Requirements/Prerequisites 

| Requirements | Download Instruction | Version | Notes|
| ---------- | -------------------- | ----- | 
| Flutter SDK | https://docs.flutter.dev/get-started/install | Use latest version. | Use for frontend development, follow the install instructions on the flutter website to install the SDK correctly. |
| Python | https://www.python.org/downloads/ | 3.12 or later | Used backend development. | 
| Android Studios | https://developer.android.com/studio/install | | Used to create android emulators for Android app development. |
| Android SDK and Command Line Tools | SDK manager in android studios. | Version 14 and later. | Required to build android apps. |
| XCode | https://apps.apple.com/gb/app/xcode/id497799835?mt=12 | Latest | Used for iOS development and running iOS simulator. |
| Python dependencies | pip install -r requirements.txt | Defined in requirements.txt | This will get all the python packages needed. |
| Flutter dependencies | flutter pub get | Defined in pubspec.yaml | This will get all the flutter dependencies needed. |  

For more information on flutter and android sdk set up view our set up guide view here.[#docs/set-up-guide/fronend-flutter.md]

# Building the emulator

## Execution

## System Architecture 

## Project Structure
```bash
2024-AIEnhancedWasteCollection
├── .github/                       # GitHub Actions, Issue/PR Templates, etc.
├── docs/                          # Contains documentation, meeting minuets, research etc.
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
├── requirements.txt               # Backend requirements (used for CD)
└── ... (others like EWC-ReleaseChecklist.pdf,  etc.)
```

## Database Structure


## AWS Setup

## Further Documentation
