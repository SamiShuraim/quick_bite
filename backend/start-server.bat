@echo off
echo Starting QuickBite Backend Server...
echo.

REM Set NODE_ENV
set NODE_ENV=development

REM Check for .env file
if not exist .env (
    echo ERROR: .env file not found!
    echo Please create .env file with MongoDB credentials
    pause
    exit /b 1
)

echo ✅ .env file found
echo.

REM Create logs directory if it doesn't exist
if not exist logs mkdir logs

echo Starting server on port 3000...
echo.

REM Start the server
npx ts-node --transpile-only src/server.ts

pause

