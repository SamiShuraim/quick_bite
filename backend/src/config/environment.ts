/**
 * Environment Configuration
 * Centralized environment variable management with validation
 */

import dotenv from 'dotenv';
import { ENV_KEYS } from './constants';

// Load environment variables from .env file
dotenv.config();

/**
 * Validate required environment variables
 */
const validateEnv = (): void => {
  const required = [
    ENV_KEYS.MONGODB_URI,
    ENV_KEYS.JWT_SECRET,
    ENV_KEYS.JWT_REFRESH_SECRET,
  ];

  const missing = required.filter((key) => !process.env[key]);

  if (missing.length > 0) {
    throw new Error(
      `Missing required environment variables: ${missing.join(', ')}`
    );
  }
};

// Validate on module load
validateEnv();

/**
 * Environment configuration object
 */
export const config = {
  // Application
  env: process.env[ENV_KEYS.NODE_ENV] || 'development',
  port: parseInt(process.env[ENV_KEYS.PORT] || '3000', 10),
  apiVersion: process.env.API_VERSION || 'v1',
  
  // Database
  database: {
    uri: process.env[ENV_KEYS.MONGODB_URI] as string,
  },
  
  // JWT
  jwt: {
    secret: process.env[ENV_KEYS.JWT_SECRET] as string,
    refreshSecret: process.env[ENV_KEYS.JWT_REFRESH_SECRET] as string,
    expiresIn: process.env[ENV_KEYS.JWT_EXPIRES_IN] || '15m',
    refreshExpiresIn: process.env[ENV_KEYS.JWT_REFRESH_EXPIRES_IN] || '7d',
  },
  
  // Security
  security: {
    bcryptSaltRounds: parseInt(
      process.env[ENV_KEYS.BCRYPT_SALT_ROUNDS] || '10',
      10
    ),
  },
  
  // CORS
  cors: {
    allowedOrigins: process.env.ALLOWED_ORIGINS?.split(',') || [
      'http://localhost:3000',
    ],
  },
  
  // Rate Limiting
  rateLimit: {
    windowMs: parseInt(
      process.env.RATE_LIMIT_WINDOW_MS || '900000',
      10
    ),
    maxRequests: parseInt(
      process.env.RATE_LIMIT_MAX_REQUESTS || '100',
      10
    ),
  },
  
  // Development flags
  isDevelopment: process.env[ENV_KEYS.NODE_ENV] === 'development',
  isProduction: process.env[ENV_KEYS.NODE_ENV] === 'production',
  isTest: process.env[ENV_KEYS.NODE_ENV] === 'test',
};

