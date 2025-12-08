# QuickBite - Food Delivery Flutter Application

QuickBite is a modern food delivery mobile application built with Flutter for the SWE 463 Mobile Application Development course at King Fahd University of Petroleum & Minerals.

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

### Running the Application

1. **Unzip the project folder**

2. **Open terminal and navigate to the project:**
   ```bash
   cd path/to/quick_bite
   ```

3. **Install dependencies:**
   ```bash
   flutter pub get
   ```

4. **Run the app:**
   ```bash
   flutter run
   ```

That's it! The app will connect to our deployed backend automatically.

> **Note**: On first launch, you may see a loading screen for 30-60 seconds while the backend server wakes up (free hosting). The app will proceed automatically.

### Test Account

When you open the app, you'll see a test account dialog with pre-filled credentials.


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

## 👥 Course Information

**Course:** SWE 463 - Mobile Application Development  
**Institution:** King Fahd University of Petroleum & Minerals (KFUPM)  
**Semester:** Fall 2024
