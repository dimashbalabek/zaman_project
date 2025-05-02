# Flutter Clean Architecture Practice

This project demonstrates the implementation of **Flutter Clean Architecture** with a focus on building a scalable and maintainable mobile application. It includes key features like authentication, onboarding, and navigation, while following best practices for Flutter app development.

## Features

- **Splash Screen**: A welcoming splash screen that transitions into the onboarding flow.
- **Onboarding Flow**: Multiple onboarding screens introducing the app's features.
- **Sign Up Page**: A simple sign-up page for user registration.
- **Navigation**: Smooth navigation with a PageController for onboarding and named routes for screen transitions.
- **Clean Architecture**: The app is built with clean architecture principles to keep the codebase modular and testable.

## Folder Structure

```plaintext
/lib
├── features
│   ├── auth
│   │   ├── presentation
│   │   │   ├── pages
│   │   │   │   ├── auth_gate.dart
│   │   │   │   └── sign_up_page.dart
│   │   └── data
│   ├── onboarding
│   │   └── presentation
│   │       └── pages
│   │           ├── splash_screen.dart
│   │           └── onboarding_screen.dart
└── main.dart
Screenshots

```
