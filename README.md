# QuickBite - Food Delivery Flutter Application

QuickBite is a modern food delivery mobile application built with Flutter for the SWE 463 Mobile Application Development course at KFUPM.

## 🎨 Features

- **Beautiful UI**: Modern Material Design 3 interface
- **Dark & Light Themes**: Automatic theme switching based on system preferences
- **User Authentication**: Secure login and registration system
- **Restaurant Browsing**: Search and filter restaurants by category
- **Food Ordering**: Browse menus, customize items, and add to cart
- **Order Management**: Track orders and view order history
- **Payment Integration**: Multiple payment methods including credit cards
- **Real-time Updates**: Live order tracking and status updates

## 🚀 Getting Started

### Prerequisites

Before you begin, ensure you have Flutter installed:
- **Flutter SDK**: Version 3.9.0 or higher
- **Dart SDK**: Version 3.9.0 or higher

### Running the App

1. **Navigate to folder**

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run
   ```

That's it! The app will start and connect to our deployed backend automatically.

> **Note**: On first launch, the app may show a loading screen for about 30-60 seconds. This is because our backend runs on free cloud hosting (Render.com) which spins down after inactivity. The app will automatically wait for the server to start and then proceed normally.

### Test Account

When you first open the app, you'll see a test account dialog with pre-filled credentials:
Feel free to use this account or create your own!

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

## 🏗️ Project Structure

This project follows **Clean Architecture** with a **features-based directory structure**:

```
lib/
├── core/                    # Shared functionality
│   ├── constants/          # App-wide constants
│   ├── theme/              # Theme configuration
│   ├── services/           # API client, storage
│   ├── utils/              # Utility functions
│   └── widgets/            # Reusable widgets
│
└── features/               # Feature modules (Clean Architecture)
    ├── onboarding/         # Splash & onboarding screens
    ├── authentication/     # Login, signup, verification
    ├── restaurant/         # Restaurant browsing, menu, cart
    ├── order/              # Order tracking & history
    └── profile/            # User profile management

test/
├── unit/                   # Unit tests
├── widget/                 # Widget tests
└── integration/            # Integration tests
```
