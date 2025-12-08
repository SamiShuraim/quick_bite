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

### Step 1: Unzip the Project

1. Extract the zip file to your desired location
2. Open a terminal/command prompt and navigate to the extracted folder:
   ```bash
   cd path/to/quick_bite
   ```

### Step 2: Install Prerequisites

#### Install Flutter SDK

**Windows:**
1. Download Flutter SDK from [https://docs.flutter.dev/get-started/install/windows](https://docs.flutter.dev/get-started/install/windows)
2. Extract the zip file to a suitable location (e.g., `C:\flutter`)
3. Add Flutter to your PATH:
   - Search for "Environment Variables" in Windows
   - Edit the PATH variable and add the Flutter bin directory (e.g., `C:\flutter\bin`)
4. Open a new terminal and verify:
   ```bash
   flutter --version
   ```

**macOS:**
1. Download Flutter SDK from [https://docs.flutter.dev/get-started/install/macos](https://docs.flutter.dev/get-started/install/macos)
2. Extract and add to PATH:
   ```bash
   cd ~/development
   unzip ~/Downloads/flutter_macos_*.zip
   export PATH="$PATH:`pwd`/flutter/bin"
   ```
3. Add to your shell configuration (`.zshrc` or `.bash_profile`):
   ```bash
   export PATH="$PATH:$HOME/development/flutter/bin"
   ```
4. Verify installation:
   ```bash
   flutter --version
   ```

**Linux:**
1. Download Flutter SDK from [https://docs.flutter.dev/get-started/install/linux](https://docs.flutter.dev/get-started/install/linux)
2. Extract and add to PATH:
   ```bash
   cd ~
   tar xf ~/Downloads/flutter_linux_*.tar.xz
   export PATH="$PATH:$HOME/flutter/bin"
   ```
3. Add to `.bashrc` or `.zshrc`:
   ```bash
   export PATH="$PATH:$HOME/flutter/bin"
   ```
4. Verify installation:
   ```bash
   flutter --version
   ```

#### Run Flutter Doctor
After installing Flutter, run this command to check if you need any additional dependencies:
```bash
flutter doctor
```

Follow any instructions provided to install missing dependencies (Android Studio, Xcode, etc.).

### Step 3: Install Project Dependencies

In the project root directory (`quick_bite`), run:
```bash
flutter pub get
```

This will download all the required Flutter packages.

### Step 4: Run the Application

**Option A: Run on an emulator/simulator**

1. **Android:**
   - Open Android Studio
   - Open AVD Manager (Tools → Device Manager)
   - Create or start an Android emulator
   
2. **iOS (macOS only):**
   - Open Xcode
   - Open Simulator (Xcode → Open Developer Tool → Simulator)

3. Run the app:
   ```bash
   flutter run
   ```

**Option B: Run on a physical device**

1. **Android:**
   - Enable Developer Options on your Android device
   - Enable USB Debugging
   - Connect your device via USB
   - Run: `flutter devices` to verify connection
   
2. **iOS (macOS only):**
   - Connect your iPhone via USB
   - Trust the computer on your iPhone
   - Run: `flutter devices` to verify connection

3. Run the app:
   ```bash
   flutter run
   ```

**Option C: Select device interactively**

If you have multiple devices, you can select which one to run on:
```bash
flutter run
```
Flutter will prompt you to select from available devices.

### That's It! 🎉

The app will start and connect to our deployed backend automatically.

> **Note**: On first launch, the app may show a loading screen for about 30-60 seconds. This is because our backend runs on free cloud hosting (Render.com) which spins down after inactivity. The app will automatically wait for the server to start and then proceed normally.

### Test Account

When you first open the app, you'll see a test account dialog with pre-filled credentials. Feel free to use this account or create your own!

## 🔧 Backend Setup (Optional)

The app connects to a deployed backend automatically, but if you want to run the backend locally:

### Prerequisites
- **Node.js**: Version 16.0 or higher ([Download](https://nodejs.org/))
- **MongoDB**: Local installation or MongoDB Atlas account

### Setup Instructions

1. **Navigate to the backend folder:**
   ```bash
   cd backend
   ```

2. **Install Node.js dependencies:**
   ```bash
   npm install
   ```

3. **Configure environment variables:**
   - Create a `.env` file in the `backend` folder
   - Add your MongoDB connection string:
     ```
     MONGODB_URI=mongodb://localhost:27017/quickbite
     JWT_SECRET=your_jwt_secret_key_here
     PORT=3000
     ```

4. **Seed the database with sample data:**
   ```bash
   npm run seed
   ```

5. **Start the backend server:**
   ```bash
   npm run dev
   ```

The server will run on `http://localhost:3000`

6. **Update the Flutter app to use local backend:**
   - Open `lib/core/constants/api_constants.dart`
   - Change the base URL to `http://localhost:3000` (or `http://10.0.2.2:3000` for Android emulator)

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

## 🐛 Troubleshooting

### Flutter command not found
- Make sure Flutter is added to your system PATH
- Restart your terminal after installation
- Run `flutter doctor` to verify installation

### App won't build
```bash
flutter clean
flutter pub get
flutter run
```

### Gradle build errors (Android)
- Make sure you have JDK 11 or higher installed
- Check your Android SDK installation in Android Studio
- Try: `cd android && ./gradlew clean` then rebuild

### Pod install errors (iOS/macOS)
```bash
cd ios
pod deinstall
pod install
cd ..
flutter run
```

### Images not loading
- Check your internet connection
- Images are loaded from external CDN (Unsplash)
- Wait for the backend to wake up (30-60 seconds on first launch)

### Backend connection issues
- The app uses a deployed backend that may take 30-60 seconds to wake up
- Check the loading screen message
- If running local backend, ensure it's running on the correct port
- For Android emulator, use `10.0.2.2` instead of `localhost`

### Dependencies issues
```bash
flutter pub cache repair
flutter pub get
```

## 📞 Support

For more detailed guides, check:
- `QUICK_START.md` - Quick testing guide
- `TESTING_GUIDE.md` - Comprehensive testing documentation
- `backend/README.md` - Backend setup details

## 👥 Course Information

**Course:** SWE 463 - Mobile Application Development  
**Institution:** King Fahd University of Petroleum & Minerals (KFUPM)  
**Semester:** Fall 2024
