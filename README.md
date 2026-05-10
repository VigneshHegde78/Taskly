# Taskly – Flutter Task Manager App

Taskly is a simple and clean task management application built using Flutter and Firebase. The application allows users to create and manage their daily tasks with real-time cloud synchronization and secure authentication.

This project was developed as part of a Flutter Development Internship Assignment to demonstrate practical knowledge of Flutter, Firebase Authentication, Cloud Firestore, REST API integration, and clean mobile UI development.

---

# Features

## Authentication

* User Sign Up
* User Login
* Persistent Authentication
* Logout Functionality

## Task Management

* Add Tasks
* Edit Tasks
* Delete Tasks
* Mark Tasks as Completed
* Real-time Firestore Updates

## Additional Features

* Motivational Quote API Integration
* Responsive and Modern UI
* Form Validation
* Loading Indicators
* Error Handling

---

# Tech Stack

## Frontend

* Flutter
* Dart

## Backend & Services

* Firebase Authentication
* Cloud Firestore
* REST API Integration

## Tools

* Android Studio
* Firebase Console

---

# Project Structure

```text id="x3gc1q"
lib/
│
├── models/
│   └── task_model.dart
│
├── services/
│   ├── auth_service.dart
│   ├── task_service.dart
│   └── quote_service.dart
│
├── screens/
│   ├── splash_screen.dart
│   ├── login_screen.dart
│   ├── signup_screen.dart
│   ├── home_screen.dart
│   └── add_task_screen.dart
│
├── widgets/
│   ├── task_card.dart
│   └── quote_card.dart
│
├── constants/
│   └── app_colors.dart
│
└── main.dart
```

---

# Firebase Setup

## 1. Create Firebase Project

Create a new Firebase project from:

[Firebase Console](https://console.firebase.google.com?utm_source=chatgpt.com)

---

## 2. Enable Authentication

Navigate to:

```text id="eptgxj"
Authentication → Sign-in Method
```

Enable:

* Email/Password Authentication

---

## 3. Enable Firestore Database

Navigate to:

```text id="z5g5t7"
Firestore Database
```

Create database in:

* Test Mode

---

## 4. Add Android App

Register your Android package name and download:

```text id="9t5zdr"
google-services.json
```

Place the file inside:

```text id="f1m7fx"
android/app/
```

---

# Installation & Setup

## Clone Repository

```bash id="dr2vsn"
git clone <your-repository-link>
```

---

## Open Project

```bash id="5snhrz"
cd taskly
```

---

## Install Dependencies

```bash id="2vh0o9"
flutter pub get
```

---

## Run Application

```bash id="r7j65l"
flutter run
```

---

# Dependencies Used

```yaml id="88yc8n"
firebase_core
firebase_auth
cloud_firestore
http
intl
provider
```

---

# API Used

Motivational quotes are fetched from:

[ZenQuotes API](https://zenquotes.io/api/random?utm_source=chatgpt.com)

---

# Video

https://github.com/user-attachments/assets/ae20cb4c-48a6-4a51-bbcf-4464239ed2e1


Example:

* Login Screen
* Signup Screen
* Home Screen
* Add Task Screen

---

# APK Build

Generate APK using:

```bash id="6rmln8"
flutter build apk
```

APK location:

```text id="xjlwmr"
build/app/outputs/flutter-apk/
```

---

# Future Improvements

* Task Categories
* Dark/Light Theme Toggle
* Push Notifications
* Task Priority Levels
* Search and Filter Tasks
* Cloud Backup

---

# Learning Outcomes

This project helped in gaining practical experience with:

* Flutter UI Development
* Firebase Authentication
* Firestore CRUD Operations
* REST API Integration
* Real-time Database Handling
* Mobile App Architecture

---

# Author

Developed by [Your Name]

GitHub:
[GitHub](https://github.com?utm_source=chatgpt.com)

---

# License

This project is developed for educational and internship evaluation purposes.
