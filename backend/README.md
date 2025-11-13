# QuickBite Backend API

RESTful API for QuickBite food delivery application built with Node.js, Express, TypeScript, and MongoDB.

## Features

- 🔐 JWT-based authentication with refresh tokens
- 🛡️ Security middleware (Helmet, CORS, Rate Limiting)
- ✅ Input validation with express-validator
- 📝 Comprehensive logging with Winston
- 🏗️ Clean architecture with separation of concerns
- 🔒 Password hashing with bcrypt
- 📊 MongoDB with Mongoose ODM
- 🚀 TypeScript for type safety
- ⚡ Environment-based configuration

## Tech Stack

- **Runtime**: Node.js
- **Framework**: Express.js
- **Language**: TypeScript
- **Database**: MongoDB
- **ODM**: Mongoose
- **Authentication**: JWT (jsonwebtoken)
- **Validation**: express-validator
- **Logging**: Winston
- **Security**: Helmet, CORS, bcrypt, rate-limit

## Project Structure

```
backend/
├── src/
│   ├── config/              # Configuration files
│   │   ├── constants.ts     # Application constants
│   │   ├── database.ts      # Database connection
│   │   └── environment.ts   # Environment variables
│   │
│   ├── controllers/         # Request handlers
│   │   └── authController.ts
│   │
│   ├── middleware/          # Express middleware
│   │   ├── auth.ts          # Authentication middleware
│   │   ├── errorHandler.ts # Error handling
│   │   ├── rateLimiter.ts  # Rate limiting
│   │   └── validation.ts    # Input validation
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
│   ├── utils/               # Utility functions
│   │   ├── errors.ts        # Custom error classes
│   │   ├── jwt.ts           # JWT utilities
│   │   └── logger.ts        # Logging utility
│   │
│   ├── app.ts               # Express app setup
│   └── server.ts            # Server entry point
│
├── logs/                    # Log files
├── .env.example            # Environment variables template
├── package.json
├── tsconfig.json
└── nodemon.json
```

## Getting Started

### Prerequisites

- Node.js (v18 or higher)
- MongoDB (v6 or higher)
- npm or yarn

### Installation

1. **Install dependencies**
   ```bash
   cd backend
   npm install
   ```

2. **Create environment file**
   ```bash
   cp .env.example .env
   ```

3. **Configure environment variables**
   
   Edit `.env` file with your configuration:
   ```env
   NODE_ENV=development
   PORT=3000
   MONGODB_URI=mongodb://localhost:27017/quickbite
   JWT_SECRET=your-secret-key
   JWT_REFRESH_SECRET=your-refresh-secret-key
   ```

4. **Start MongoDB**
   ```bash
   # Make sure MongoDB is running
   mongod
   ```

5. **Run development server**
   ```bash
   npm run dev
   ```

### Build for Production

```bash
# Build TypeScript to JavaScript
npm run build

# Start production server
npm start
```

## API Endpoints

### Authentication

#### Register User
```http
POST /api/v1/auth/register
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
POST /api/v1/auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "Password123"
}
```

#### Refresh Token
```http
POST /api/v1/auth/refresh
Content-Type: application/json

{
  "refreshToken": "your-refresh-token"
}
```

#### Logout User
```http
POST /api/v1/auth/logout
Content-Type: application/json

{
  "refreshToken": "your-refresh-token"
}
```

#### Get Profile (Protected)
```http
GET /api/v1/auth/profile
Authorization: Bearer your-access-token
```

### Health Check
```http
GET /health
```

## Response Format

### Success Response
```json
{
  "success": true,
  "message": "Operation successful",
  "data": {
    "user": {
      "id": "user-id",
      "email": "user@example.com",
      "name": "John Doe",
      "role": "user"
    },
    "tokens": {
      "accessToken": "jwt-access-token",
      "refreshToken": "jwt-refresh-token"
    }
  }
}
```

### Error Response
```json
{
  "success": false,
  "message": "Error message",
  "errors": {
    "field": "Field-specific error"
  }
}
```

## Security Features

- **Password Hashing**: Bcrypt with configurable salt rounds
- **JWT Tokens**: Secure token generation with expiration
- **Refresh Tokens**: Stored in database for invalidation
- **Rate Limiting**: Protects against brute force attacks
- **Helmet**: Sets security HTTP headers
- **CORS**: Configurable cross-origin resource sharing
- **Input Validation**: Validates all user inputs
- **Error Handling**: Centralized error handling

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `NODE_ENV` | Environment (development/production) | development |
| `PORT` | Server port | 3000 |
| `MONGODB_URI` | MongoDB connection string | - |
| `JWT_SECRET` | JWT signing secret | - |
| `JWT_REFRESH_SECRET` | Refresh token secret | - |
| `JWT_EXPIRES_IN` | Access token expiration | 15m |
| `JWT_REFRESH_EXPIRES_IN` | Refresh token expiration | 7d |
| `BCRYPT_SALT_ROUNDS` | Bcrypt salt rounds | 10 |

## Development

### Scripts

```bash
# Development with auto-reload
npm run dev

# Build TypeScript
npm run build

# Start production server
npm start

# Run linter
npm run lint

# Fix linting issues
npm run lint:fix

# Run tests
npm test
```

### Code Style

- Follow TypeScript best practices
- Use ESLint for code quality
- All string literals in constants file
- Comprehensive logging for debugging
- Error handling with custom error classes

## Logging

Logs are stored in the `logs/` directory:

- `combined.log` - All logs
- `error.log` - Error logs only

Console logs include:
- 🔍 Debug
- ℹ️ Info
- ⚠️ Warning
- ❌ Error
- 🔐 Authentication events

## Error Handling

Custom error classes for different HTTP status codes:

- `BadRequestError` (400)
- `UnauthorizedError` (401)
- `ForbiddenError` (403)
- `NotFoundError` (404)
- `ConflictError` (409)
- `ValidationError` (422)
- `ApiError` (500)

## Best Practices

✅ **Implemented:**
- Clean Architecture
- Separation of Concerns
- Dependency Injection
- Environment Configuration
- Comprehensive Logging
- Input Validation
- Security Middleware
- Error Handling
- Type Safety with TypeScript

## Future Enhancements

- [ ] Email verification
- [ ] Password reset functionality
- [ ] Social authentication (Google, Facebook)
- [ ] Two-factor authentication
- [ ] API documentation with Swagger
- [ ] Unit and integration tests
- [ ] CI/CD pipeline
- [ ] Docker containerization

## License

This project is part of the QuickBite application developed for educational purposes.

