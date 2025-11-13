# QuickBite - Quick Start Guide

## 🚀 Get Started in 5 Minutes

This guide will get your QuickBite authentication system up and running quickly.

---

## Prerequisites

- **Node.js** v18+ ([Download](https://nodejs.org/))
- **MongoDB** v6+ ([Download](https://www.mongodb.com/try/download/community))
- **Flutter** 3.9.0+ ([Install](https://docs.flutter.dev/get-started/install))

---

## Step 1: Start the Backend (2 minutes)

### Option A: Using Setup Script (Recommended)

```bash
# Navigate to backend
cd backend

# Run setup script
# On macOS/Linux:
chmod +x setup.sh
./setup.sh

# On Windows:
setup.bat

# Start the server
npm run dev
```

### Option B: Manual Setup

```bash
# 1. Navigate to backend
cd backend

# 2. Install dependencies
npm install

# 3. Create .env file
# Copy the content from backend/MONGODB_SETUP.md into a new .env file

# 4. Start the backend server
npm run dev
```

You should see:
```
🍔 QuickBite | INFO | Connecting to database...
🍔 QuickBite | INFO | Database connected successfully
🍔 QuickBite | INFO | Connected to database: quickbite
🍔 QuickBite | INFO | Server is running on port 3000
```

**Note:** You don't need to install MongoDB locally - we're using MongoDB Atlas (cloud database)!

---

## Step 2: Setup Flutter (2 minutes)

```bash
# 1. Install Flutter dependencies
flutter pub get

# 2. Generate JSON serialization code
flutter pub run build_runner build --delete-conflicting-outputs

# 3. Run the app
flutter run
```

---

## Step 3: Configure API Connection (1 minute)

Edit `lib/core/constants/api_constants.dart`:

```dart
// For Android Emulator
static const String baseUrl = 'http://10.0.2.2:3000';

// For iOS Simulator
static const String baseUrl = 'http://localhost:3000';

// For Physical Device (replace with your computer's IP)
static const String baseUrl = 'http://192.168.1.100:3000';
```

---

## Test the App

1. Launch the Flutter app
2. Navigate through onboarding
3. Click "Sign Up" on the login screen
4. Register a new user
5. Login with your credentials
6. Test the authentication flow

---

## Test the API (Optional)

Using curl or Postman:

**Register:**
```bash
curl -X POST http://localhost:3000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "Password123",
    "name": "Test User"
  }'
```

**Login:**
```bash
curl -X POST http://localhost:3000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "Password123"
  }'
```

---

## Project Structure

```
quick_bite/
├── backend/              # Node.js API
│   ├── src/             # TypeScript source
│   └── .env             # Environment config
│
├── lib/                 # Flutter app
│   ├── core/           # Shared functionality
│   └── features/       # Feature modules
│
└── docs/               # Documentation
    ├── AUTHENTICATION_SETUP.md
    └── IMPLEMENTATION_STATUS.md
```

---

## Troubleshooting

### Backend Issues

**Port already in use:**
```bash
# Change PORT in .env file
PORT=3001
```

**MongoDB not connecting:**
```bash
# Verify MongoDB is running
mongod --version

# Check connection string in .env
MONGODB_URI=mongodb://localhost:27017/quickbite
```

### Flutter Issues

**Connection refused:**
- Use `http://10.0.2.2:3000` for Android Emulator
- Use your computer's IP for physical devices

**Build errors:**
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## Next Steps

1. ✅ **Explore the codebase** - See PROJECT_HIERARCHY.md
2. ✅ **Read documentation** - See AUTHENTICATION_SETUP.md
3. ✅ **Customize the UI** - Edit authentication screens
4. ✅ **Add features** - Follow clean architecture pattern
5. ✅ **Deploy** - See deployment guides

---

## Key Files

### Backend
- `backend/src/server.ts` - Server entry point
- `backend/src/app.ts` - Express configuration
- `backend/.env` - Environment variables

### Flutter
- `lib/main.dart` - App entry point
- `lib/core/constants/api_constants.dart` - API configuration
- `lib/features/authentication/` - Auth feature

---

## Documentation

- **AUTHENTICATION_SETUP.md** - Complete setup guide
- **IMPLEMENTATION_STATUS.md** - Implementation details
- **PROJECT_HIERARCHY.md** - Architecture overview
- **backend/README.md** - Backend API docs
- **README.md** - Project overview

---

## Features

✅ **Backend:**
- JWT Authentication
- User Registration
- User Login
- Token Refresh
- Secure Logout
- User Profile

✅ **Frontend:**
- Clean Architecture
- State Management
- Secure Storage
- Form Validation
- Error Handling
- Auto Token Refresh

---

## Support

For detailed instructions, see:
- [AUTHENTICATION_SETUP.md](AUTHENTICATION_SETUP.md)
- [IMPLEMENTATION_STATUS.md](IMPLEMENTATION_STATUS.md)

---

**Ready to build something amazing? Let's go! 🚀**

