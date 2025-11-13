#!/bin/bash

# QuickBite Backend Setup Script
# This script sets up the backend environment

echo "🍔 QuickBite Backend Setup"
echo "=========================="
echo ""

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install Node.js v18+ first."
    exit 1
fi

echo "✅ Node.js found: $(node --version)"
echo ""

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    echo "❌ npm is not installed. Please install npm first."
    exit 1
fi

echo "✅ npm found: $(npm --version)"
echo ""

# Install dependencies
echo "📦 Installing dependencies..."
npm install

if [ $? -ne 0 ]; then
    echo "❌ Failed to install dependencies"
    exit 1
fi

echo "✅ Dependencies installed successfully"
echo ""

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
    echo "📝 Creating .env file..."
    cat > .env << 'EOF'
# Server Configuration
NODE_ENV=development
PORT=3000
API_VERSION=v1

# Database Configuration - MongoDB Atlas
MONGODB_URI=mongodb+srv://samshuraim_db_user:1m7vrYiepghAY42P@cluster0.2f0edjv.mongodb.net/quickbite?retryWrites=true&w=majority&appName=Cluster0

# JWT Configuration
JWT_SECRET=quickbite-super-secret-jwt-key-2024-change-in-production
JWT_REFRESH_SECRET=quickbite-super-secret-refresh-key-2024-change-in-production
JWT_EXPIRES_IN=15m
JWT_REFRESH_EXPIRES_IN=7d

# CORS Configuration
ALLOWED_ORIGINS=http://localhost:3000,http://localhost:8080,http://10.0.2.2:3000

# Rate Limiting
RATE_LIMIT_WINDOW_MS=900000
RATE_LIMIT_MAX_REQUESTS=100

# Security
BCRYPT_SALT_ROUNDS=10

# Email Configuration (for future use)
EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_USER=your-email@example.com
EMAIL_PASSWORD=your-email-password
EMAIL_FROM=noreply@quickbite.com
EOF
    echo "✅ .env file created successfully"
else
    echo "⚠️  .env file already exists, skipping..."
fi

echo ""
echo "✅ Setup completed successfully!"
echo ""
echo "🚀 To start the server, run:"
echo "   npm run dev"
echo ""
echo "📚 For more information, see:"
echo "   - README.md"
echo "   - MONGODB_SETUP.md"
echo ""

