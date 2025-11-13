@echo off
REM QuickBite Backend Setup Script for Windows
REM This script sets up the backend environment

echo 🍔 QuickBite Backend Setup
echo ==========================
echo.

REM Check if Node.js is installed
where node >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Node.js is not installed. Please install Node.js v18+ first.
    exit /b 1
)

echo ✅ Node.js found
node --version
echo.

REM Check if npm is installed
where npm >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ❌ npm is not installed. Please install npm first.
    exit /b 1
)

echo ✅ npm found
npm --version
echo.

REM Install dependencies
echo 📦 Installing dependencies...
call npm install

if %ERRORLEVEL% NEQ 0 (
    echo ❌ Failed to install dependencies
    exit /b 1
)

echo ✅ Dependencies installed successfully
echo.

REM Create .env file if it doesn't exist
if not exist .env (
    echo 📝 Creating .env file...
    (
        echo # Server Configuration
        echo NODE_ENV=development
        echo PORT=3000
        echo API_VERSION=v1
        echo.
        echo # Database Configuration - MongoDB Atlas
        echo MONGODB_URI=mongodb+srv://samshuraim_db_user:1m7vrYiepghAY42P@cluster0.2f0edjv.mongodb.net/quickbite?retryWrites=true^&w=majority^&appName=Cluster0
        echo.
        echo # JWT Configuration
        echo JWT_SECRET=quickbite-super-secret-jwt-key-2024-change-in-production
        echo JWT_REFRESH_SECRET=quickbite-super-secret-refresh-key-2024-change-in-production
        echo JWT_EXPIRES_IN=15m
        echo JWT_REFRESH_EXPIRES_IN=7d
        echo.
        echo # CORS Configuration
        echo ALLOWED_ORIGINS=http://localhost:3000,http://localhost:8080,http://10.0.2.2:3000
        echo.
        echo # Rate Limiting
        echo RATE_LIMIT_WINDOW_MS=900000
        echo RATE_LIMIT_MAX_REQUESTS=100
        echo.
        echo # Security
        echo BCRYPT_SALT_ROUNDS=10
        echo.
        echo # Email Configuration ^(for future use^)
        echo EMAIL_HOST=smtp.gmail.com
        echo EMAIL_PORT=587
        echo EMAIL_USER=your-email@example.com
        echo EMAIL_PASSWORD=your-email-password
        echo EMAIL_FROM=noreply@quickbite.com
    ) > .env
    echo ✅ .env file created successfully
) else (
    echo ⚠️  .env file already exists, skipping...
)

echo.
echo ✅ Setup completed successfully!
echo.
echo 🚀 To start the server, run:
echo    npm run dev
echo.
echo 📚 For more information, see:
echo    - README.md
echo    - MONGODB_SETUP.md
echo.

pause

