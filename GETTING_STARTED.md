# Getting Started with QuickBite

## 🎉 Complete Setup Guide

This guide will walk you through setting up the complete QuickBite authentication system with MongoDB Atlas.

---

## 📋 Prerequisites

Before you begin, ensure you have:

- ✅ **Node.js** v18 or higher ([Download](https://nodejs.org/))
- ✅ **Flutter** 3.9.0 or higher ([Install](https://docs.flutter.dev/get-started/install))
- ✅ **Git** ([Download](https://git-scm.com/))
- ✅ **Code Editor** (VS Code recommended)

**Note:** You do NOT need to install MongoDB locally - we're using MongoDB Atlas (cloud)!

---

## 🚀 Quick Setup (5 Minutes)

### Step 1: Backend Setup

#### Option A: Automatic Setup (Recommended)

**On Windows:**
```bash
cd backend
setup.bat
npm run dev
```

**On macOS/Linux:**
```bash
cd backend
chmod +x setup.sh
./setup.sh
npm run dev
```

#### Option B: Manual Setup

```bash
cd backend
npm install
```

Create a file named `.env` in the `backend` directory with this content:

```env
NODE_ENV=development
PORT=3000
API_VERSION=v1

MONGODB_URI=mongodb+srv://samshuraim_db_user:1m7vrYiepghAY42P@cluster0.2f0edjv.mongodb.net/quickbite?retryWrites=true&w=majority&appName=Cluster0

JWT_SECRET=quickbite-super-secret-jwt-key-2024
JWT_REFRESH_SECRET=quickbite-super-secret-refresh-key-2024
JWT_EXPIRES_IN=15m
JWT_REFRESH_EXPIRES_IN=7d

ALLOWED_ORIGINS=http://localhost:3000,http://localhost:8080,http://10.0.2.2:3000

RATE_LIMIT_WINDOW_MS=900000
RATE_LIMIT_MAX_REQUESTS=100

BCRYPT_SALT_ROUNDS=10
```

Then start the server:
```bash
npm run dev
```

**Expected Output:**
```
🍔 QuickBite | INFO | Connecting to database...
🍔 QuickBite | INFO | Database connected successfully
🍔 QuickBite | INFO | Connected to database: quickbite
🍔 QuickBite | INFO | Server is running on port 3000
```

✅ **Backend is ready!**

---

### Step 2: Flutter Setup

```bash
# Install dependencies
flutter pub get

# Generate JSON serialization code
flutter pub run build_runner build --delete-conflicting-outputs

# Run the app
flutter run
```

---

### Step 3: Configure API Connection

Edit `lib/core/constants/api_constants.dart` and update the `baseUrl`:

**For Android Emulator:**
```dart
static const String baseUrl = 'http://10.0.2.2:3000';
```

**For iOS Simulator:**
```dart
static const String baseUrl = 'http://localhost:3000';
```

**For Physical Device:**
```dart
// Replace with your computer's IP address
static const String baseUrl = 'http://192.168.1.100:3000';
```

**To find your IP address:**
- **Windows:** Run `ipconfig` in Command Prompt
- **macOS/Linux:** Run `ifconfig` or `ip addr` in Terminal

---

## ✅ Verify Setup

### 1. Test Backend API

```bash
curl http://localhost:3000/health
```

Expected response:
```json
{
  "success": true,
  "message": "Server is healthy",
  "timestamp": "2024-11-13T...",
  "environment": "development"
}
```

### 2. Test Registration

```bash
curl -X POST http://localhost:3000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@quickbite.com",
    "password": "Test123456",
    "name": "Test User"
  }'
```

### 3. Test Flutter App

1. Launch the app on your device/emulator
2. Navigate through the onboarding screens
3. Click "Sign Up" on the login screen
4. Fill in the registration form
5. Submit and verify successful registration

---

## 📁 Project Structure

```
quick_bite/
├── backend/              # Node.js Backend
│   ├── src/             # Source code
│   │   ├── config/      # Configuration
│   │   ├── controllers/ # Request handlers
│   │   ├── middleware/  # Middleware
│   │   ├── models/      # Database models
│   │   ├── routes/      # API routes
│   │   ├── services/    # Business logic
│   │   └── utils/       # Utilities
│   ├── logs/            # Log files
│   ├── .env             # Environment variables (create this)
│   ├── package.json
│   └── README.md
│
├── lib/                 # Flutter Frontend
│   ├── core/           # Shared functionality
│   │   ├── constants/  # Constants
│   │   ├── services/   # API client, storage
│   │   ├── theme/      # App themes
│   │   ├── utils/      # Utilities
│   │   └── widgets/    # Reusable widgets
│   │
│   ├── features/       # Feature modules
│   │   ├── onboarding/
│   │   └── authentication/
│   │       ├── data/       # Data layer
│   │       ├── domain/     # Business logic
│   │       └── presentation/ # UI layer
│   │
│   └── main.dart
│
└── docs/                # Documentation
    ├── AUTHENTICATION_SETUP.md
    ├── MONGODB_SETUP.md
    ├── QUICKSTART.md
    └── GETTING_STARTED.md (this file)
```

---

## 🔧 Common Issues & Solutions

### Issue 1: Backend Connection Failed

**Problem:** Cannot connect to MongoDB Atlas

**Solutions:**

1. **Check your internet connection**
   ```bash
   ping google.com
   ```

2. **Verify MongoDB Atlas Network Access**
   - Go to [MongoDB Atlas](https://cloud.mongodb.com/)
   - Click "Network Access" in left sidebar
   - Ensure your IP is whitelisted
   - Or click "Allow Access from Anywhere" (for development)

3. **Check .env file**
   - Ensure the file is named exactly `.env` (not `.env.txt`)
   - Verify the MongoDB URI is correct
   - No extra spaces or line breaks

### Issue 2: Flutter Cannot Connect to Backend

**Problem:** Network error in Flutter app

**Solutions:**

1. **For Android Emulator:**
   - Use `http://10.0.2.2:3000` (not `localhost`)
   - This is Android Emulator's special IP for host machine

2. **For iOS Simulator:**
   - Use `http://localhost:3000`

3. **For Physical Device:**
   - Ensure phone and computer are on same WiFi network
   - Use your computer's local IP address
   - Find IP: `ipconfig` (Windows) or `ifconfig` (Mac/Linux)
   - Example: `http://192.168.1.100:3000`

4. **Firewall:**
   - Ensure port 3000 is not blocked by firewall
   - On Windows: Allow Node.js through Windows Firewall
   - On Mac: System Preferences → Security → Firewall

### Issue 3: Build Runner Errors

**Problem:** JSON serialization errors

**Solution:**
```bash
# Clean and regenerate
flutter clean
flutter pub get
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### Issue 4: Port Already in Use

**Problem:** `Error: listen EADDRINUSE: address already in use :::3000`

**Solutions:**

1. **Change port in `.env`:**
   ```env
   PORT=3001
   ```

2. **Kill the process using port 3000:**
   
   **Windows:**
   ```bash
   netstat -ano | findstr :3000
   taskkill /PID <PID> /F
   ```
   
   **Mac/Linux:**
   ```bash
   lsof -i :3000
   kill -9 <PID>
   ```

---

## 🎯 Testing the Complete Flow

### Backend Test

```bash
# 1. Health check
curl http://localhost:3000/health

# 2. Register user
curl -X POST http://localhost:3000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "demo@quickbite.com",
    "password": "Demo123456",
    "name": "Demo User"
  }'

# 3. Login
curl -X POST http://localhost:3000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "demo@quickbite.com",
    "password": "Demo123456"
  }'

# 4. Get profile (use access token from login response)
curl -X GET http://localhost:3000/api/v1/auth/profile \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

### Flutter Test

1. **Start the app**
   ```bash
   flutter run
   ```

2. **Complete onboarding**
   - Navigate through 4 screens
   - Click "GET STARTED"

3. **Register a new account**
   - Click "Sign Up"
   - Fill form with valid data
   - Submit

4. **Login**
   - Enter registered credentials
   - Click "SIGN IN"

5. **Verify authentication**
   - App should navigate to home screen
   - Profile data should be loaded

---

## 📊 What's Included

### Backend Features ✅
- ✅ User registration with validation
- ✅ User login with JWT
- ✅ Token refresh mechanism
- ✅ Secure logout
- ✅ User profile retrieval
- ✅ Password hashing (bcrypt)
- ✅ Rate limiting
- ✅ CORS protection
- ✅ Input validation
- ✅ Error handling
- ✅ Comprehensive logging

### Frontend Features ✅
- ✅ Clean architecture
- ✅ State management (Provider)
- ✅ Secure token storage
- ✅ HTTP client with error handling
- ✅ Form validation
- ✅ Loading states
- ✅ Error messages
- ✅ Auto token refresh
- ✅ Cached user data

---

## 🔐 Security Features

- ✅ **JWT Authentication** - Secure token-based auth
- ✅ **Password Hashing** - bcrypt with 10 salt rounds
- ✅ **Token Refresh** - Automatic token rotation
- ✅ **Rate Limiting** - Protection against brute force
- ✅ **Input Validation** - Server-side validation
- ✅ **CORS Protection** - Whitelist origins
- ✅ **Secure Storage** - FlutterSecureStorage for tokens
- ✅ **Environment Vars** - Sensitive data in .env

---

## 📚 Next Steps

Now that you're set up, explore:

1. **Add More Features**
   - Password reset
   - Email verification
   - Social authentication
   - User profile updates

2. **Customize UI**
   - Edit authentication screens
   - Add your branding
   - Customize colors and themes

3. **Deploy**
   - Backend to Heroku/Render/Railway
   - Frontend to App Store/Play Store

4. **Learn More**
   - Read [AUTHENTICATION_SETUP.md](AUTHENTICATION_SETUP.md)
   - Check [IMPLEMENTATION_STATUS.md](IMPLEMENTATION_STATUS.md)
   - Explore [PROJECT_HIERARCHY.md](PROJECT_HIERARCHY.md)

---

## 💡 Tips

1. **Development Workflow**
   - Keep backend running in one terminal
   - Run Flutter in another terminal
   - Check logs for debugging

2. **Debugging**
   - Backend logs: `backend/logs/combined.log`
   - Flutter logs: In terminal where `flutter run` is running
   - MongoDB data: View in MongoDB Atlas dashboard

3. **Testing**
   - Use Postman/Insomnia for API testing
   - Use Flutter DevTools for Flutter debugging

---

## 🆘 Need Help?

1. **Check the Logs**
   - Backend: `backend/logs/`
   - Flutter: Terminal output

2. **Read the Documentation**
   - [AUTHENTICATION_SETUP.md](AUTHENTICATION_SETUP.md)
   - [MONGODB_SETUP.md](backend/MONGODB_SETUP.md)
   - [backend/README.md](backend/README.md)

3. **Common Issues**
   - Network connectivity
   - Firewall blocking ports
   - MongoDB Atlas IP whitelist
   - Wrong API URL in Flutter

---

## ✨ You're All Set!

Your QuickBite authentication system is ready to use. Start building amazing features! 🚀

**Happy Coding! 🍔**

