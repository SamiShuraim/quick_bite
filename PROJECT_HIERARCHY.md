# QuickBite Project Hierarchy

## Project Structure (Clean Architecture)

```
quick_bite/
├── backend/                                    # Node.js Backend API
│   ├── src/
│   │   ├── config/                            # Configuration
│   │   │   ├── constants.ts
│   │   │   ├── database.ts
│   │   │   └── environment.ts
│   │   ├── controllers/                       # Request handlers
│   │   │   └── authController.ts
│   │   ├── middleware/                        # Express middleware
│   │   │   ├── auth.ts
│   │   │   ├── errorHandler.ts
│   │   │   ├── rateLimiter.ts
│   │   │   └── validation.ts
│   │   ├── models/                            # Database models
│   │   │   ├── User.ts
│   │   │   └── RefreshToken.ts
│   │   ├── routes/                            # API routes
│   │   │   └── authRoutes.ts
│   │   ├── services/                          # Business logic
│   │   │   └── authService.ts
│   │   ├── utils/                             # Utilities
│   │   │   ├── errors.ts
│   │   │   ├── jwt.ts
│   │   │   └── logger.ts
│   │   ├── app.ts                             # Express app
│   │   └── server.ts                          # Server entry point
│   ├── logs/                                  # Log files
│   ├── package.json
│   ├── tsconfig.json
│   └── README.md
│
├── lib/
│   ├── core/                                  # Core functionality shared across features
│   │   ├── constants/
│   │   │   ├── app_constants.dart            # App-wide constants
│   │   │   ├── app_colors.dart               # Color palette
│   │   │   └── api_constants.dart            # API configuration [NEW]
│   │   │
│   │   ├── services/
│   │   │   ├── api_client.dart               # HTTP client [NEW]
│   │   │   └── storage_service.dart          # Secure storage [NEW]
│   │   │
│   │   ├── theme/
│   │   │   └── app_theme.dart                # Material Design 3 theme
│   │   │
│   │   ├── utils/
│   │   │   └── app_logger.dart               # Logging utility
│   │   │
│   │   └── widgets/                          # Reusable widgets
│   │       ├── custom_button.dart
│   │       └── custom_text_field.dart        # Custom text field [NEW]
│   │
│   ├── features/                             # Feature modules (Clean Architecture)
│   │   ├── onboarding/
│   │   │   └── presentation/                 # UI layer
│   │   │       ├── screens/
│   │   │       │   ├── splash_screen.dart
│   │   │       │   └── onboarding_screen.dart
│   │   │       └── widgets/
│   │   │           ├── page_indicator.dart
│   │   │           └── onboarding_content.dart
│   │   │
│   │   └── authentication/
│   │       ├── data/                         # Data layer [NEW]
│   │       │   ├── datasources/
│   │       │   │   ├── auth_remote_datasource.dart
│   │       │   │   └── auth_local_datasource.dart
│   │       │   ├── models/
│   │       │   │   ├── user_model.dart
│   │       │   │   └── auth_response_model.dart
│   │       │   └── repositories/
│   │       │       └── auth_repository_impl.dart
│   │       │
│   │       ├── domain/                       # Business logic layer [NEW]
│   │       │   ├── entities/
│   │       │   │   └── user_entity.dart
│   │       │   ├── repositories/
│   │       │   │   └── auth_repository.dart
│   │       │   └── usecases/
│   │       │       ├── login_usecase.dart
│   │       │       ├── register_usecase.dart
│   │       │       ├── logout_usecase.dart
│   │       │       ├── get_profile_usecase.dart
│   │       │       ├── get_cached_user_usecase.dart
│   │       │       └── check_login_status_usecase.dart
│   │       │
│   │       └── presentation/                 # UI layer
│   │           ├── providers/                # State management [NEW]
│   │           │   └── auth_provider.dart
│   │           └── screens/
│   │               ├── login_screen.dart
│   │               ├── register_screen.dart    [READY]
│   │               └── forgot_password_screen.dart [READY]
│   │
│   └── main.dart                             # Application entry point
│
├── test/                                     # Test files
│   ├── unit/                                # Unit tests
│   │   └── app_logger_test.dart
│   ├── widget/                              # Widget tests
│   │   └── splash_screen_test.dart
│   └── integration/                         # Integration tests
│       └── app_flow_test.dart
│
├── android/                                  # Android platform files
├── ios/                                      # iOS platform files
├── web/                                      # Web platform files
├── windows/                                  # Windows platform files
├── linux/                                    # Linux platform files
├── macos/                                    # macOS platform files
│
├── .env.example                             # Environment variables template
├── pubspec.yaml                             # Package dependencies
├── README.md                                # Project documentation
├── PROJECT_HIERARCHY.md                     # This file
├── AUTHENTICATION_SETUP.md                  # Auth setup guide [NEW]
└── IMPLEMENTATION_STATUS.md                 # Implementation status [NEW]

```

## Clean Architecture Layers

### Core Layer (`/core`)
Shared functionality and resources used across all features:
- **Constants**: Immutable configuration values
- **Theme**: UI styling and theming
- **Utils**: Helper functions and utilities
- **Widgets**: Reusable UI components

### Feature Layer (`/features`)
Independent, self-contained feature modules following Clean Architecture:

```
feature_name/
├── data/                    # Data layer
│   ├── datasources/        # API, local database
│   ├── models/             # Data models
│   └── repositories/       # Repository implementations
│
├── domain/                 # Business logic layer
│   ├── entities/          # Business objects
│   ├── repositories/      # Repository interfaces
│   └── usecases/          # Business use cases
│
└── presentation/          # UI layer
    ├── screens/          # Full screen widgets
    ├── widgets/          # Feature-specific widgets
    └── state/            # State management (BLoC/Provider)
```

## Current Features

### 0. Backend API
**Location**: `backend/`

**Purpose**: RESTful API for authentication and data management

**Tech Stack**:
- Node.js + Express + TypeScript
- MongoDB + Mongoose
- JWT Authentication
- Winston Logger

**Components**:
- **Authentication API**: Register, login, logout, refresh token, profile
- **User Model**: MongoDB schema with password hashing
- **Refresh Token Model**: Token management with TTL
- **Security Middleware**: Rate limiting, CORS, Helmet
- **Validation Middleware**: Input validation with express-validator
- **Error Handling**: Custom error classes and global error handler
- **Logging**: Comprehensive Winston logger

**API Endpoints**:
- `POST /api/v1/auth/register` - User registration
- `POST /api/v1/auth/login` - User login
- `POST /api/v1/auth/logout` - User logout
- `POST /api/v1/auth/refresh` - Refresh access token
- `GET /api/v1/auth/profile` - Get user profile (protected)
- `GET /health` - Health check

### 1. Onboarding Feature
**Location**: `lib/features/onboarding/`

**Purpose**: Introduction flow for new users

**Components**:
- **Splash Screen**: Animated app branding
- **Onboarding Screen**: 4-page feature introduction
- **Page Indicator**: Animated navigation dots
- **Onboarding Content**: Reusable page template

**Navigation**: SplashScreen → OnboardingScreen → LoginScreen

### 2. Authentication Feature
**Location**: `lib/features/authentication/`

**Purpose**: User authentication and account management

**Components**:
- **Data Layer**: API client, storage service, data sources, repositories
- **Domain Layer**: Entities, use cases, repository interfaces
- **Presentation Layer**: Auth provider (state management), screens
- **Screens**: Login, Register, Forgot Password (structure ready)

**Features**:
- User registration with validation
- User login with credentials
- Secure token storage
- Auto token refresh
- User profile management
- Logout functionality

## Architecture Principles

### 1. Separation of Concerns
Each layer has a single, well-defined responsibility:
- **Data**: Fetching and caching data
- **Domain**: Business logic
- **Presentation**: UI and user interaction

### 2. Dependency Rule
Dependencies point inward:
- Presentation depends on Domain
- Domain is independent
- Data depends on Domain (through interfaces)

### 3. Feature Independence
Each feature is self-contained and can be developed/tested independently.

### 4. Reusability
Common functionality is extracted to `/core` for reuse across features.

## Design Standards (SWE 463 Requirements)

### ✅ Multiple Pages
- Splash Screen
- 4 Onboarding Pages
- Login Screen
- (More screens to be added)

### ✅ Forms
- Authentication forms ready
- Form validation utilities

### ✅ Dark/Light Themes
- Full theme system with `ThemeMode`
- Light theme (default)
- Dark theme
- Automatic system theme detection

### ✅ Server Communication (Ready)
- Architecture supports repository pattern
- Data layer structure prepared
- HTTP client integration planned

### ✅ Responsive Design
- Mobile-first approach
- Safe area handling
- Adaptive layouts
- Portrait orientation locked

## Testing Strategy

### Unit Tests (`test/unit/`)
Test individual functions and classes:
- Utility functions
- Business logic
- Data transformations

### Widget Tests (`test/widget/`)
Test individual widgets in isolation:
- Screen rendering
- User interactions
- Widget state changes

### Integration Tests (`test/integration/`)
Test complete user flows:
- Navigation flows
- Feature interactions
- End-to-end scenarios

### Coverage Goals
- Minimum 70% code coverage
- 100% coverage for business logic
- All critical paths tested

## Constants Architecture

### String Constants
All UI text defined in `app_constants.dart`:
```dart
class AppConstants {
  static const String appName = 'QuickBite';
  // ... more constants
}

class OnboardingConstants {
  static const String title1 = 'All your favorites';
  // ... more constants
}
```

### Color Constants
All colors defined in `app_colors.dart`:
```dart
class AppColors {
  static const Color primary = Color(0xFFFF7622);
  // Light mode colors
  static const Color background = Color(0xFFFFFFFF);
  // Dark mode colors
  static const Color darkBackground = Color(0xFF121212);
}
```

### Dimension Constants
All spacing and sizing in `app_constants.dart`:
```dart
static const double defaultPadding = 24.0;
static const double buttonHeight = 48.0;
```

## Logger Usage

Comprehensive logging throughout the application:

```dart
// Lifecycle events
AppLogger.lifecycle('ScreenName', 'initState');

// Navigation
AppLogger.navigation('FromScreen', 'ToScreen');

// User actions
AppLogger.userAction('Button Pressed', details: {'id': '123'});

// Errors
AppLogger.error('Error occurred', error: e, stackTrace: st);

// Debug info
AppLogger.debug('Debug information', tag: 'TAG');
```

## Theme System

### Light Mode
- Background: White (#FFFFFF)
- Primary: Orange (#FF7622)
- Text: Black (#000000)

### Dark Mode
- Background: Dark Gray (#121212)
- Primary: Orange (#FF7622)
- Text: White (#FFFFFF)

### Switching Themes
```dart
// In main.dart
ThemeMode _themeMode = ThemeMode.system;

MaterialApp(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  themeMode: _themeMode,
)
```

## Navigation Architecture

### Current Flow
```
SplashScreen (3s delay)
    ↓
OnboardingScreen (4 pages with skip)
    ↓
LoginScreen
```

### Future Navigation
Will implement named routes and route guards:
```dart
routes: {
  '/': (context) => SplashScreen(),
  '/onboarding': (context) => OnboardingScreen(),
  '/login': (context) => LoginScreen(),
  '/home': (context) => HomeScreen(),
  '/restaurant/:id': (context) => RestaurantScreen(),
}
```

## State Management (Planned)

### Options Under Consideration
- **Provider**: Simple, recommended by Flutter team
- **BLoC**: Robust, testable, follows reactive programming
- **Riverpod**: Modern alternative to Provider

### Structure
```
presentation/
└── state/
    ├── bloc/          # BLoC files
    ├── provider/      # Provider files
    └── notifier/      # Notifier files
```

## Data Layer (Planned)

### API Integration
```
data/
├── datasources/
│   ├── remote/
│   │   └── api_client.dart
│   └── local/
│       └── cache_client.dart
├── models/
│   └── restaurant_model.dart
└── repositories/
    └── restaurant_repository_impl.dart
```

### Local Storage
- SharedPreferences for simple data
- SQLite/Hive for complex data
- Secure storage for sensitive data

## Dependencies

### Backend
- `express`: Web framework
- `mongoose`: MongoDB ODM
- `typescript`: Type safety
- `jsonwebtoken`: JWT authentication
- `bcryptjs`: Password hashing
- `winston`: Logging
- `express-validator`: Input validation
- `helmet`: Security headers
- `cors`: Cross-origin resource sharing
- `express-rate-limit`: Rate limiting
- `compression`: Response compression
- `morgan`: HTTP request logger
- `dotenv`: Environment variables

### Flutter - Current
- `flutter`: Flutter SDK
- `cupertino_icons`: iOS-style icons
- `flutter_lints`: Linting rules
- `provider`: State management
- `equatable`: Value equality
- `http`: HTTP client
- `dio`: Advanced HTTP client
- `flutter_secure_storage`: Secure token storage
- `shared_preferences`: Local storage
- `json_annotation`: JSON serialization
- `build_runner`: Code generation
- `json_serializable`: JSON serialization
- `connectivity_plus`: Network connectivity

### Flutter - Planned
- `cached_network_image`: Image caching
- `firebase_core`: Firebase integration
- `google_maps_flutter`: Maps integration
- `image_picker`: Image selection
- `geolocator`: Location services

## Development Workflow

### Adding a New Feature
1. Create feature directory: `lib/features/feature_name/`
2. Create layers: `data/`, `domain/`, `presentation/`
3. Implement from domain → data → presentation
4. Add tests for each layer
5. Update this documentation

### Adding a New Screen
1. Create screen in appropriate feature's `presentation/screens/`
2. Add route constant in `app_constants.dart`
3. Import necessary widgets and utilities
4. Add logging for lifecycle and user actions
5. Create widget tests

### Adding Constants
1. Group related constants in a class
2. Add to `app_constants.dart` or `app_colors.dart`
3. Use semantic naming
4. Document purpose

## Code Quality Standards

### Linting
- Uses `flutter_lints` package
- Strict mode enabled
- No warnings allowed in production

### Documentation
- All public APIs documented
- Complex logic explained
- README kept up-to-date

### Testing
- All features tested
- Critical paths have 100% coverage
- Tests run in CI/CD

## Future Enhancements

### Planned Features (Phase 2)
- [ ] Restaurant listing and browsing
- [ ] Menu display and filtering
- [ ] Shopping cart functionality
- [ ] Order placement and tracking
- [ ] User profile management
- [ ] Search and filters
- [ ] Favorites/bookmarks
- [ ] Order history

### Technical Improvements
- [ ] API integration layer
- [ ] State management implementation
- [ ] Local database
- [ ] Push notifications
- [ ] Deep linking
- [ ] Analytics integration
- [ ] Crash reporting
- [ ] Performance monitoring

## Course Compliance Checklist

### Phase 1: Proposal ✅
- [x] Project idea with objectives
- [x] Wireframes (Figma)
- [x] Implementation plan with dates
- [x] Member responsibilities

### Phase 2: Code Submission
- [x] Features-based directory structure
- [x] Clean architecture implementation
- [x] All features under `lib/features/`
- [x] Unit tests
- [x] Widget tests
- [x] Integration tests
- [x] README with setup instructions
- [x] .env.example for environment variables
- [ ] Complete feature implementation
- [ ] Server integration

### Phase 3: Final Report
- [ ] Project overview
- [ ] Features description with screenshots
- [ ] Test coverage visualization
- [ ] Challenges and lessons learned
- [ ] Team contribution table

## Notes

- This structure is optimized for scalability and maintainability
- Follows Flutter and Dart best practices
- Complies with SWE 463 course requirements
- Ready for team collaboration
- Supports CI/CD integration
