/**
 * Application Constants
 * All string literals and configuration values used across the backend
 */

// API Response Messages
export const API_MESSAGES = {
  // Success Messages
  SUCCESS: {
    REGISTRATION: 'User registered successfully',
    LOGIN: 'Login successful',
    LOGOUT: 'Logout successful',
    TOKEN_REFRESH: 'Token refreshed successfully',
    PASSWORD_RESET_REQUEST: 'Password reset email sent',
    PASSWORD_RESET: 'Password reset successful',
    EMAIL_VERIFIED: 'Email verified successfully',
  },
  
  // Error Messages
  ERROR: {
    INTERNAL_SERVER: 'Internal server error',
    UNAUTHORIZED: 'Unauthorized access',
    FORBIDDEN: 'Access forbidden',
    NOT_FOUND: 'Resource not found',
    VALIDATION_FAILED: 'Validation failed',
    INVALID_CREDENTIALS: 'Invalid email or password',
    EMAIL_EXISTS: 'Email already exists',
    USER_NOT_FOUND: 'User not found',
    INVALID_TOKEN: 'Invalid or expired token',
    WEAK_PASSWORD: 'Password does not meet requirements',
    EMAIL_NOT_VERIFIED: 'Email not verified',
  },
  
  // Info Messages
  INFO: {
    SERVER_RUNNING: 'Server is running on port',
    DB_CONNECTED: 'Database connected successfully',
    DB_DISCONNECTED: 'Database disconnected',
  },
};

// HTTP Status Codes
export const HTTP_STATUS = {
  OK: 200,
  CREATED: 201,
  NO_CONTENT: 204,
  BAD_REQUEST: 400,
  UNAUTHORIZED: 401,
  FORBIDDEN: 403,
  NOT_FOUND: 404,
  CONFLICT: 409,
  UNPROCESSABLE_ENTITY: 422,
  TOO_MANY_REQUESTS: 429,
  INTERNAL_SERVER_ERROR: 500,
};

// JWT Configuration
export const JWT_CONFIG = {
  ALGORITHM: 'HS256' as const,
  ISSUER: 'quickbite-api',
  AUDIENCE: 'quickbite-app',
};

// Password Requirements
export const PASSWORD_REQUIREMENTS = {
  MIN_LENGTH: 8,
  MAX_LENGTH: 128,
  REQUIRE_UPPERCASE: true,
  REQUIRE_LOWERCASE: true,
  REQUIRE_NUMBER: true,
  REQUIRE_SPECIAL: false,
};

// Validation Constants
export const VALIDATION = {
  EMAIL_MAX_LENGTH: 255,
  NAME_MIN_LENGTH: 2,
  NAME_MAX_LENGTH: 50,
  PHONE_MIN_LENGTH: 10,
  PHONE_MAX_LENGTH: 15,
};

// User Roles
export const USER_ROLES = {
  USER: 'user',
  ADMIN: 'admin',
  RESTAURANT_OWNER: 'restaurant_owner',
  DELIVERY_DRIVER: 'delivery_driver',
} as const;

// Token Types
export const TOKEN_TYPES = {
  ACCESS: 'access',
  REFRESH: 'refresh',
  EMAIL_VERIFICATION: 'email_verification',
  PASSWORD_RESET: 'password_reset',
} as const;

// Database Collection Names
export const COLLECTIONS = {
  USERS: 'users',
  REFRESH_TOKENS: 'refresh_tokens',
  RESTAURANTS: 'restaurants',
  ORDERS: 'orders',
  MENU_ITEMS: 'menu_items',
};

// API Routes
export const API_ROUTES = {
  AUTH: {
    BASE: '/auth',
    REGISTER: '/register',
    LOGIN: '/login',
    LOGOUT: '/logout',
    REFRESH: '/refresh',
    VERIFY_EMAIL: '/verify-email',
    FORGOT_PASSWORD: '/forgot-password',
    RESET_PASSWORD: '/reset-password',
  },
  USER: {
    BASE: '/users',
    PROFILE: '/profile',
    UPDATE: '/update',
    DELETE: '/delete',
  },
};

// Environment Variables Keys
export const ENV_KEYS = {
  NODE_ENV: 'NODE_ENV',
  PORT: 'PORT',
  MONGODB_URI: 'MONGODB_URI',
  JWT_SECRET: 'JWT_SECRET',
  JWT_REFRESH_SECRET: 'JWT_REFRESH_SECRET',
  JWT_EXPIRES_IN: 'JWT_EXPIRES_IN',
  JWT_REFRESH_EXPIRES_IN: 'JWT_REFRESH_EXPIRES_IN',
  BCRYPT_SALT_ROUNDS: 'BCRYPT_SALT_ROUNDS',
};

// Rate Limiting
export const RATE_LIMIT = {
  WINDOW_MS: 15 * 60 * 1000, // 15 minutes
  MAX_REQUESTS: 100,
  AUTH_WINDOW_MS: 15 * 60 * 1000, // 15 minutes
  AUTH_MAX_REQUESTS: 5, // 5 login attempts per 15 minutes
};

