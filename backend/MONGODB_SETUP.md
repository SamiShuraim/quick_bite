# MongoDB Atlas Setup for QuickBite

## Database Credentials

**Username:** `samshuraim_db_user`  
**Password:** `1m7vrYiepghAY42P`

**Connection String:**
```
mongodb+srv://samshuraim_db_user:1m7vrYiepghAY42P@cluster0.2f0edjv.mongodb.net/quickbite?retryWrites=true&w=majority&appName=Cluster0
```

---

## Setup Instructions

### 1. Create `.env` File

In the `backend/` directory, create a new file named `.env`:

```bash
cd backend
touch .env
```

### 2. Add Configuration to `.env`

Copy and paste the following into your `.env` file:

```env
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
```

### 3. Install Dependencies

```bash
npm install
```

### 4. Start the Server

```bash
npm run dev
```

You should see:
```
🍔 QuickBite | INFO | Connecting to database...
🍔 QuickBite | INFO | Database connected successfully
🍔 QuickBite | INFO | Connected to database: quickbite
🍔 QuickBite | INFO | Server is running on port 3000
```

---

## Database Structure

The application will automatically create the following collections:

### Collections:

1. **users**
   - Stores user accounts
   - Fields: email, password (hashed), name, phone, role, isEmailVerified
   - Indexes: email (unique)

2. **refresh_tokens**
   - Stores refresh tokens for authentication
   - Fields: userId, token, expiresAt
   - Auto-expires based on TTL index

---

## Testing the Connection

### Method 1: Using the Health Check Endpoint

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

### Method 2: Register a Test User

```bash
curl -X POST http://localhost:3000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@quickbite.com",
    "password": "Test123456",
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
      "email": "test@quickbite.com",
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

---

## MongoDB Atlas Dashboard

You can view your database directly in MongoDB Atlas:

1. Go to [MongoDB Atlas](https://cloud.mongodb.com/)
2. Login with your credentials
3. Navigate to your Cluster0
4. Click "Browse Collections"
5. Select the `quickbite` database
6. View the `users` and `refresh_tokens` collections

---

## Security Notes

### ⚠️ Important Security Practices

1. **Never commit `.env` to Git**
   - The `.env` file is already in `.gitignore`
   - Always keep credentials secure

2. **Change JWT Secrets in Production**
   - Generate strong, random secrets for production
   - Use at least 32 characters

3. **MongoDB Atlas Security**
   - The connection string includes authentication
   - MongoDB Atlas has IP whitelisting enabled
   - Ensure your IP is allowed in Atlas Network Access

4. **Network Access**
   - In MongoDB Atlas, go to Network Access
   - Add your current IP address
   - Or allow access from anywhere (0.0.0.0/0) for development

---

## Troubleshooting

### Issue: Connection Timeout

**Cause:** Your IP address is not whitelisted in MongoDB Atlas

**Solution:**
1. Go to [MongoDB Atlas](https://cloud.mongodb.com/)
2. Navigate to Network Access
3. Click "Add IP Address"
4. Either add your current IP or click "Allow Access from Anywhere" (for development only)
5. Save and try again

### Issue: Authentication Failed

**Cause:** Incorrect credentials

**Solution:**
- Double-check the username and password in your `.env` file
- Ensure there are no extra spaces or characters

### Issue: Database Not Found

**Cause:** The `quickbite` database will be created automatically when you first insert data

**Solution:**
- This is normal behavior
- The database will be created when you register your first user

### Issue: Cannot Connect to Database

**Error:** `MongoServerError: bad auth`

**Solution:**
1. Verify the connection string is correct
2. Check username: `samshuraim_db_user`
3. Check password: `1m7vrYiepghAY42P`
4. Ensure the password doesn't contain special characters that need URL encoding

---

## Environment Variables Explained

| Variable | Description | Example |
|----------|-------------|---------|
| `NODE_ENV` | Environment mode | development, production |
| `PORT` | Server port | 3000 |
| `MONGODB_URI` | MongoDB connection string | mongodb+srv://... |
| `JWT_SECRET` | Secret for access tokens | random-string-32-chars |
| `JWT_REFRESH_SECRET` | Secret for refresh tokens | random-string-32-chars |
| `JWT_EXPIRES_IN` | Access token expiry | 15m, 1h, 1d |
| `JWT_REFRESH_EXPIRES_IN` | Refresh token expiry | 7d, 30d |
| `BCRYPT_SALT_ROUNDS` | Password hashing strength | 10 (recommended) |

---

## Production Deployment

For production deployment:

1. **Update MongoDB URI**
   - Use production database
   - Create separate production cluster

2. **Update JWT Secrets**
   - Generate strong random secrets
   - Use environment variables from hosting platform

3. **Update CORS Origins**
   - Set to your production domain
   - Remove development URLs

4. **Set NODE_ENV to production**
   ```env
   NODE_ENV=production
   ```

5. **Enable MongoDB Atlas Production Features**
   - Set up automated backups
   - Enable monitoring
   - Configure alerts
   - Set up proper network access rules

---

## Quick Start Commands

```bash
# Navigate to backend
cd backend

# Install dependencies
npm install

# Create .env file (copy content from above)
nano .env

# Start development server
npm run dev

# Build for production
npm run build

# Start production server
npm start
```

---

## Support

If you encounter any issues:

1. Check the logs in `backend/logs/combined.log`
2. Verify MongoDB Atlas network access
3. Test connection using MongoDB Compass
4. Ensure all environment variables are set correctly

---

**Database is ready to use! Start the backend server and begin testing.** 🚀

