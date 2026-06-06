# 🎓 IPU Ranks – Flutter

A modern student result portal built using Flutter for GGSIPU students. The app allows students to log in securely using their enrollment number, password, and captcha, fetch academic records from the backend API, and view semester-wise results with SGPA, CGPA, credits, and subject details in a clean and responsive interface.

## 📲 Try the App

Download and try the latest APK from the Releases section:

🔗 **APK Download:**
https://github.com/Kanan-saini/ipuranks-copy/releases/tag/v.1

## ✅ Features

* 🔐 Secure student authentication
* 🤖 Captcha-based login verification
* 📊 Semester-wise result dashboard
* 🎯 Automatic SGPA calculation
* 📈 Weighted CGPA calculation
* 📚 Credit tracking and aggregation
* 💾 Session persistence using SharedPreferences
* 🎨 Modern and responsive UI
* 📱 Cross-platform support (Android, iOS, Web, Windows)

## ⚙️ How It Works

```text
Student Login
      ↓
API Request
      ↓
JSON Response
      ↓
Result Parsing
      ↓
Semester Grouping
      ↓
SGPA / CGPA Calculation
      ↓
Dashboard Display
```

## 🏗️ Project Architecture

The project follows a simple layered architecture:

```text
UI Layer
    ↓
Service Layer
    ↓
Model Layer
```

### 🎨 UI Layer

Handles user interaction and result visualization.

* Enrollment Screen
* Result Dashboard
* Logout Screen
* Custom Widgets

### 🔧 Service Layer

Handles API communication, storage, and business logic.

* AuthService
* SessionStorage
* CreditCatalogService

### 📦 Model Layer

Responsible for parsing and managing result data.

* LoginResponse
* StudentResult
* FlatResultRecord
* GroupedResult
* SemesterResult

## 📊 SGPA Calculation

The application calculates SGPA using a credit-based grading system:

```text
SGPA =
Σ(Grade Point × Credits)
------------------------
Σ(Credits)
```

### Grade Mapping

| Marks    | Grade Point |
| -------- | ----------- |
| 90+      | 10          |
| 75-89    | 9           |
| 65-74    | 8           |
| 55-64    | 7           |
| 50-54    | 6           |
| 45-49    | 5           |
| 40-44    | 4           |
| Below 40 | 0           |

## 📈 CGPA Calculation

Weighted CGPA is calculated using semester credits:

```text
CGPA =
Σ(SGPA × Semester Credits)
--------------------------
Σ(Semester Credits)
```

## 🛠️ Technologies Used

### Frontend

* Flutter
* Dart

### Networking

* HTTP Package

### Local Storage

* SharedPreferences

### Configuration

* Flutter Dotenv

### State Management

* StatefulWidget
* setState()

## 📦 Dependencies

```yaml
http
flutter_dotenv
shared_preferences
cupertino_icons
```

## 📂 Project Structure

```text
lib/
│
├── config/
│   └── env.dart
│
├── models/
│   ├── login_response.dart
│   └── result_model.dart
│
├── services/
│   ├── auth_service.dart
│   ├── session_storage.dart
│   ├── credit_catalog_service.dart
│   └── http_client_factory.dart
│
├── screens/
│   ├── enrollment_screen.dart
│   ├── result_dashboard.dart
│   └── logout_screen.dart
│
├── widgets/
│   ├── custom_button.dart
│   ├── input_field.dart
│   ├── semester_card.dart
│   └── student_info_card.dart
│
└── main.dart
```

## 🔒 Security Features

* Captcha-protected login
* Session-based authentication
* Secure API communication
* Automatic session cleanup during logout

## 📚 What I Learned

While building this project, I learned:

* Working with REST APIs in Flutter using the HTTP package
* Parsing and managing complex JSON responses
* Implementing secure login flows with captcha validation
* Using SharedPreferences for local data persistence
* Structuring Flutter projects using layered architecture
* Calculating SGPA and CGPA using academic grading logic
* Creating reusable widgets for a clean UI
* Managing application state using StatefulWidget and setState()
* Building responsive interfaces for multiple platforms

## 🚀 Future Improvements

* 🌙 Dark/Light theme support
* 📄 PDF result export
* 📊 Performance analytics charts
* 🔔 Push notifications
* 📱 Offline result access
* ⚡ State management using Riverpod or Bloc

## 👨‍💻 Author

Developed using Flutter & Dart.

💡 Feel free to use, modify, or improve this project for learning purposes.

⭐ If you like this project, consider starring the repository!
