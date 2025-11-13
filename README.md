# QuickBite - Food Delivery Flutter Application

## Project Overview

QuickBite is a modern food delivery mobile application built with Flutter, designed for the SWE 463 Mobile Application Development course. The app provides users with a seamless experience to browse restaurants, order food, and track deliveries.

### Key Features
- 🎨 Beautiful, modern UI with Material Design 3
- 🌓 Dark and Light theme support
- 🔐 User authentication system
- 📱 Responsive mobile-first design
- 🍔 Restaurant browsing and food ordering
- 📊 Real-time order tracking
- 🎯 Personalized user experience

## 📋 Course Requirements Compliance

### Phase 1: Proposal ✅
- ✅ Multiple pages (Splash, Onboarding, Login, and more)
- ✅ Server communication capabilities (architecture ready)
- ✅ Form handling (authentication forms)
- ✅ Responsive dark/light themes
- ✅ Complete wireframes and implementation plan

### Phase 2: Code Submission
- ✅ Clean Architecture with features-based directory structure
- ✅ All features under `lib/features/`
- ✅ Comprehensive test coverage (unit, widget, integration)
- ✅ Well-documented and organized code
- ✅ README with setup instructions

## 🏗️ Architecture

This project follows **Clean Architecture** principles with a **features-based directory structure**:

```
lib/
├── core/                           # Core functionality
│   ├── constants/                  # App-wide constants
│   │   ├── app_constants.dart      # String literals, dimensions, timing
│   │   └── app_colors.dart         # Color palette (light/dark)
│   ├── theme/                      # Theme configuration
│   │   └── app_theme.dart          # Material Design theme
│   ├── utils/                      # Utility classes
│   │   └── app_logger.dart         # Logging utility
│   └── widgets/                    # Reusable widgets
│       └── custom_button.dart      # Custom button component
│
├── features/                       # Feature modules (Clean Architecture)
│   ├── onboarding/                 # Onboarding feature
│   │   └── presentation/
│   │       ├── screens/
│   │       │   ├── splash_screen.dart
│   │       │   └── onboarding_screen.dart
│   │       └── widgets/
│   │           ├── page_indicator.dart
│   │           └── onboarding_content.dart
│   │
│   └── authentication/             # Authentication feature
│       └── presentation/
│           └── screens/
│               └── login_screen.dart
│
└── main.dart                       # Application entry point

test/
├── unit/                           # Unit tests
├── widget/                         # Widget tests
└── integration/                    # Integration tests
```

### Design Patterns
- **Clean Architecture**: Separation of concerns with clear layers
- **Feature-based Structure**: Each feature is self-contained
- **Repository Pattern**: (Ready for data layer implementation)
- **BLoC/Provider**: (Ready for state management)

## 🚀 Getting Started

### Prerequisites

Before you begin, ensure you have the following installed:
- Flutter SDK (3.9.0 or higher)
- Dart SDK (3.9.0 or higher)
- Android Studio / Xcode (for mobile development)
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/quick_bite.git
   cd quick_bite
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Environment Configuration

If the app requires API keys or authentication credentials in the future, create a `.env` file in the root directory (see `.env.example` for template).

Currently, no environment variables are required to run the app.

## 🧪 Testing

The project includes comprehensive test coverage:

### Run all tests
```bash
flutter test
```

### Run specific test types
```bash
# Unit tests only
flutter test test/unit/

# Widget tests only
flutter test test/widget/

# Integration tests only
flutter test test/integration/
```

### Test Coverage
To generate a test coverage report:
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

View the coverage report by opening `coverage/html/index.html` in a browser.

## 📱 Building for Production

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle
```bash
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## 🎨 Theme System

QuickBite supports both light and dark themes that automatically adapt to system preferences.

### Switching Themes
The app respects system theme settings by default. Users can toggle between themes within the app (feature coming soon).

### Color Palette
- **Primary**: Orange (#FF7622)
- **Background (Light)**: White (#FFFFFF)
- **Background (Dark)**: Dark Gray (#121212)
- **Text (Light)**: Black (#000000)
- **Text (Dark)**: White (#FFFFFF)

## 🔧 Development

### Adding a New Feature

1. Create a new feature directory under `lib/features/`
2. Follow the Clean Architecture structure:
   ```
   features/
   └── your_feature/
       ├── data/              # Data layer (repositories, models)
       ├── domain/            # Business logic layer (entities, use cases)
       └── presentation/      # UI layer (screens, widgets, state)
   ```

3. Import and integrate with the app

### Code Style

This project follows the official [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style) and uses `flutter_lints` for static analysis.

Run linter:
```bash
flutter analyze
```

Format code:
```bash
flutter format lib/ test/
```

## 📦 Dependencies

### Core Dependencies
- `flutter`: Flutter SDK
- `cupertino_icons`: iOS-style icons

### Dev Dependencies
- `flutter_test`: Testing framework
- `flutter_lints`: Linting rules

### Future Dependencies (Planned)
- `http` / `dio`: API communication
- `provider` / `bloc`: State management
- `shared_preferences`: Local storage
- `firebase_core`: Firebase integration

## 📖 Documentation

- [PROJECT_HIERARCHY.md](PROJECT_HIERARCHY.md) - Detailed project structure
- API documentation (coming in Phase 3)
- Feature documentation (coming in Phase 3)

## 👥 Team Members

| Name | Role | Responsibilities |
|------|------|-----------------|
| Member 1 | Team Lead | Project coordination, Architecture design |
| Member 2 | Frontend Developer | UI/UX implementation |
| Member 3 | Backend Developer | API integration, State management |
| Member 4 | QA Engineer | Testing, Documentation |

## 📅 Development Timeline

### Phase 1: Proposal (Completed - Oct 14)
- ✅ Project idea and objectives defined
- ✅ Wireframes created
- ✅ Implementation plan with timeline

### Phase 2: Code Submission (Due - Dec 8)
- ✅ Clean Architecture implementation
- ✅ Core features development
- ✅ Test coverage
- 🔄 Server integration (in progress)
- 🔄 Complete feature set

### Phase 3: Final Report (Due - Dec 13)
- 📝 Project overview
- 📝 Feature documentation
- 📝 Challenges and lessons learned
- 📝 Test coverage visualization

## 🐛 Known Issues

No known issues at this time.

## 📄 License

This project is developed for educational purposes as part of SWE 463 course.

## 📞 Contact & Support

For questions or issues, please contact:
- Email: [your-email@example.com]
- Course: SWE 463 - Mobile Application Development

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Course instructor and TAs
- Team members for their contributions

---

**Note**: This is an academic project developed for SWE 463. All features and implementations follow course requirements and industry best practices.
