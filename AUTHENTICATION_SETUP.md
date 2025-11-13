# QuickBite Authentication System - Setup Guide

## Overview

This document provides complete setup instructions for the QuickBite authentication system, including both the Node.js backend and Flutter frontend.

## Architecture

### Backend (Node.js + Express + TypeScript + MongoDB)
- JWT-based authentication with refresh tokens
- Clean architecture with separation of concerns
- Comprehensive security middleware
- Input validation and error handling
- Winston logging system

### Frontend (Flutter + Provider)
- Clean architecture (Data, Domain, Presentation layers)
- Provider state management
- Secure token storage
- HTTP client with interceptors
- Form validation

---

## Backend Setup

### Prerequisites
- Node.js v18+
- MongoDB v6+
- npm or yarn

### Installation Steps

1. **Navigate to backend directory**
   ```bash
   cd backend
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Create environment file**
   ```bash
   cp .env.example .env
   ```

4. **Configure `.env` file**
   ```env
   NODE_ENV=development
   PORT=3000
   API_VERSION=v1

   # MongoDB
   MONGODB_URI=mongodb://localhost:27017/quickbite

   # JWT Secrets (CHANGE IN PRODUCTION!)
   JWT_SECRET=your-super-secret-jwt-key-change-this
   JWT_REFRESH_SECRET=your-super-secret-refresh-key-change-this
   JWT_EXPIRES_IN=15m
   JWT_REFRESH_EXPIRES_IN=7d

   # CORS
   ALLOWED_ORIGINS=http://localhost:3000,http://localhost:8080

   # Rate Limiting
   RATE_LIMIT_WINDOW_MS=900000
   RATE_LIMIT_MAX_REQUESTS=100

   # Security
   BCRYPT_SALT_ROUNDS=10
   ```

5. **Start MongoDB**
   ```bash
   # macOS/Linux
   mongod

   # Windows
   net start MongoDB
   ```

6. **Start Development Server**
   ```bash
   npm run dev
   ```

### Production Build

```bash
# Build TypeScript
npm run build

# Start production server
npm start
```

### API Endpoints

#### Health Check
```http
GET http://localhost:3000/health
```

#### Register User
```http
POST http://localhost:3000/api/v1/auth/register
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "Password123",
  "name": "John Doe",
  "phone": "1234567890"
}
```

#### Login User
```http
POST http://localhost:3000/api/v1/auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "Password123"
}
```

#### Get Profile (Protected)
```http
GET http://localhost:3000/api/v1/auth/profile
Authorization: Bearer YOUR_ACCESS_TOKEN
```

#### Refresh Token
```http
POST http://localhost:3000/api/v1/auth/refresh
Content-Type: application/json

{
  "refreshToken": "YOUR_REFRESH_TOKEN"
}
```

#### Logout
```http
POST http://localhost:3000/api/v1/auth/logout
Content-Type: application/json

{
  "refreshToken": "YOUR_REFRESH_TOKEN"
}
```

---

## Flutter Frontend Setup

### Prerequisites
- Flutter SDK 3.9.0+
- Dart SDK 3.9.0+
- Android Studio / Xcode (for mobile development)

### Installation Steps

1. **Install Flutter dependencies**
   ```bash
   flutter pub get
   ```

2. **Generate JSON Serialization Code**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

3. **Configure API Base URL**
   
   Edit `lib/core/constants/api_constants.dart`:
   ```dart
   static const String baseUrl = 'http://YOUR_IP_ADDRESS:3000';
   ```

   **Important:** 
   - For Android Emulator: Use `http://10.0.2.2:3000`
   - For iOS Simulator: Use `http://localhost:3000`
   - For Physical Device: Use your computer's IP address (e.g., `http://192.168.1.100:3000`)

4. **Run the App**
   ```bash
   flutter run
   ```

### Dependencies Added

```yaml
dependencies:
  # State Management
  provider: ^6.1.1
  equatable: ^2.0.5
  
  # HTTP Client
  http: ^1.1.2
  dio: ^5.4.0
  
  # Secure Storage
  flutter_secure_storage: ^9.0.0
  shared_preferences: ^2.2.2
  
  # JSON Serialization
  json_annotation: ^4.8.1
  
  # Connectivity
  connectivity_plus: ^5.0.2
```

---

## Project Structure

### Backend Structure
```
backend/
├── src/
│   ├── config/              # Configuration
│   │   ├── constants.ts
│   │   ├── database.ts
│   │   └── environment.ts
│   │
│   ├── controllers/         # Request handlers
│   │   └── authController.ts
│   │
│   ├── middleware/          # Middleware
│   │   ├── auth.ts
│   │   ├── errorHandler.ts
│   │   ├── rateLimiter.ts
│   │   └── validation.ts
│   │
│   ├── models/              # Database models
│   │   ├── User.ts
│   │   └── RefreshToken.ts
│   │
│   ├── routes/              # API routes
│   │   └── authRoutes.ts
│   │
│   ├── services/            # Business logic
│   │   └── authService.ts
│   │
│   ├── utils/               # Utilities
│   │   ├── errors.ts
│   │   ├── jwt.ts
│   │   └── logger.ts
│   │
│   ├── app.ts
│   └── server.ts
│
├── logs/                    # Log files
├── .env
├── package.json
└── tsconfig.json
```

### Flutter Structure
```
lib/
├── core/
│   ├── constants/
│   │   ├── api_constants.dart
│   │   ├── app_constants.dart
│   │   └── app_colors.dart
│   │
│   ├── services/
│   │   ├── api_client.dart
│   │   └── storage_service.dart
│   │
│   ├── theme/
│   │   └── app_theme.dart
│   │
│   ├── utils/
│   │   └── app_logger.dart
│   │
│   └── widgets/
│       ├── custom_button.dart
│       └── custom_text_field.dart
│
├── features/
│   └── authentication/
│       ├── data/
│       │   ├── datasources/
│       │   │   ├── auth_local_datasource.dart
│       │   │   └── auth_remote_datasource.dart
│       │   │
│       │   ├── models/
│       │   │   ├── user_model.dart
│       │   │   └── auth_response_model.dart
│       │   │
│       │   └── repositories/
│       │       └── auth_repository_impl.dart
│       │
│       ├── domain/
│       │   ├── entities/
│       │   │   └── user_entity.dart
│       │   │
│       │   ├── repositories/
│       │   │   └── auth_repository.dart
│       │   │
│       │   └── usecases/
│       │       ├── login_usecase.dart
│       │       ├── register_usecase.dart
│       │       ├── logout_usecase.dart
│       │       └── get_profile_usecase.dart
│       │
│       └── presentation/
│           ├── providers/
│           │   └── auth_provider.dart
│           │
│           └── screens/
│               ├── login_screen.dart
│               ├── register_screen.dart
│               └── forgot_password_screen.dart
│
└── main.dart
```

---

## Testing the Authentication Flow

### 1. Start Backend Server
```bash
cd backend
npm run dev
```

You should see:
```
🍔 QuickBite | 2024-01-15T10:00:00.000Z | INFO    | Database connected successfully
🍔 QuickBite | 2024-01-15T10:00:00.000Z | INFO    | Server is running on port 3000
```

### 2. Test Backend API

Using curl or Postman:

**Register a user:**
```bash
curl -X POST http://localhost:3000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "Password123",
    "name": "Test User"
  }'
```

Expected response:
```json
{
  "success": true,
  "message": "User registered successfully",
  "data": {
    "user": {
      "id": "...",
      "email": "test@example.com",
      "name": "Test User",
      "role": "user"
    },
    "tokens": {
      "accessToken": "...",
      "refreshToken": "..."
    }
  }
}
```

### 3. Run Flutter App
```bash
flutter run
```

### 4. Test Authentication in App

1. **Navigate through Onboarding**
2. **Click "Sign Up" on Login Screen**
3. **Fill registration form and submit**
4. **Verify successful registration**
5. **Test login functionality**
6. **Test logout**

---

## Common Issues & Solutions

### Backend Issues

**Issue:** `Port 3000 already in use`
**Solution:**
```bash
# Find process using port 3000
# macOS/Linux
lsof -i :3000

# Windows
netstat -ano | findstr :3000

# Kill the process or change PORT in .env
```

**Issue:** `MongoDB connection failed`
**Solution:**
- Ensure MongoDB is running
- Check MONGODB_URI in `.env`
- Verify MongoDB is accessible

**Issue:** `JWT_SECRET is required`
**Solution:**
- Ensure `.env` file exists
- Verify all required environment variables are set

### Flutter Issues

**Issue:** `Connection refused` on Android Emulator
**Solution:**
- Use `http://10.0.2.2:3000` instead of `localhost`

**Issue:** `JSON serialization error`
**Solution:**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

**Issue:** `FlutterSecureStorage not working on Android**
**Solution:**
- Minimum SDK version should be 18 or higher
- Check `android/app/build.gradle`

---

## Security Considerations

### Backend
- ✅ JWT tokens with expiration
- ✅ Refresh token rotation
- ✅ Password hashing with bcrypt
- ✅ Rate limiting on auth endpoints
- ✅ CORS configuration
- ✅ Helmet security headers
- ✅ Input validation
- ✅ SQL injection protection (Mongoose)

### Frontend
- ✅ Secure token storage (FlutterSecureStorage)
- ✅ No sensitive data in SharedPreferences
- ✅ Automatic token refresh
- ✅ Secure HTTP communication
- ✅ Input validation before API calls

---

## Next Steps

1. ✅ **Implement complete authentication screens** (Login, Register, Forgot Password)
2. ✅ **Add form validation on Flutter side**
3. ✅ **Connect Flutter to backend API**
4. ✅ **Test end-to-end authentication flow**
5. ⏳ **Add email verification** (future enhancement)
6. ⏳ **Add social authentication** (future enhancement)
7. ⏳ **Add biometric authentication** (future enhancement)

---

## Support & Documentation

### Backend Documentation
- See `backend/README.md` for detailed API documentation
- Logs are stored in `backend/logs/`

### Flutter Documentation
- See `PROJECT_HIERARCHY.md` for architecture details
- See `README.md` for app overview

---

**Last Updated:** 2024-11-13
**Version:** 1.0.0

