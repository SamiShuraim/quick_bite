/**
 * JWT Utility Functions
 * Token generation and verification
 */

import jwt, { SignOptions } from 'jsonwebtoken';
import { config } from '../config/environment';
import { JWT_CONFIG, TOKEN_TYPES } from '../config/constants';
import { UnauthorizedError } from './errors';

// Token payload interface
export interface TokenPayload {
  userId: string;
  email: string;
  role: string;
  type: string;
}

/**
 * Generate access token
 */
export const generateAccessToken = (
  userId: string,
  email: string,
  role: string
): string => {
  const payload: TokenPayload = {
    userId,
    email,
    role,
    type: TOKEN_TYPES.ACCESS,
  };

  const options = {
    expiresIn: config.jwt.expiresIn,
    issuer: JWT_CONFIG.ISSUER,
    audience: JWT_CONFIG.AUDIENCE,
  };
  
  console.log('🔑 GENERATING TOKEN with secret:', config.jwt.secret?.substring(0, 20) + '...');
  console.log('🔑 Token expires in:', config.jwt.expiresIn);
  
  return jwt.sign(payload, config.jwt.secret, options as SignOptions);
};

/**
 * Generate refresh token
 */
export const generateRefreshToken = (
  userId: string,
  email: string,
  role: string
): string => {
  const payload: TokenPayload = {
    userId,
    email,
    role,
    type: TOKEN_TYPES.REFRESH,
  };

  const options = {
    expiresIn: config.jwt.refreshExpiresIn,
    issuer: JWT_CONFIG.ISSUER,
    audience: JWT_CONFIG.AUDIENCE,
  };
  
  return jwt.sign(payload, config.jwt.refreshSecret, options as SignOptions);
};

/**
 * Verify access token
 */
export const verifyAccessToken = (token: string): TokenPayload => {
  try {
    const decoded = jwt.verify(token, config.jwt.secret, {
      issuer: JWT_CONFIG.ISSUER,
      audience: JWT_CONFIG.AUDIENCE,
    }) as TokenPayload;

    if (decoded.type !== TOKEN_TYPES.ACCESS) {
      throw new UnauthorizedError('Invalid token type');
    }

    return decoded;
  } catch (error) {
    if (error instanceof jwt.JsonWebTokenError) {
      throw new UnauthorizedError('Invalid token');
    }
    if (error instanceof jwt.TokenExpiredError) {
      throw new UnauthorizedError('Token expired');
    }
    throw error;
  }
};

/**
 * Verify refresh token
 */
export const verifyRefreshToken = (token: string): TokenPayload => {
  try {
    const decoded = jwt.verify(token, config.jwt.refreshSecret, {
      issuer: JWT_CONFIG.ISSUER,
      audience: JWT_CONFIG.AUDIENCE,
    }) as TokenPayload;

    if (decoded.type !== TOKEN_TYPES.REFRESH) {
      throw new UnauthorizedError('Invalid token type');
    }

    return decoded;
  } catch (error) {
    if (error instanceof jwt.JsonWebTokenError) {
      throw new UnauthorizedError('Invalid refresh token');
    }
    if (error instanceof jwt.TokenExpiredError) {
      throw new UnauthorizedError('Refresh token expired');
    }
    throw error;
  }
};

/**
 * Extract token from Authorization header
 */
export const extractTokenFromHeader = (authHeader?: string): string => {
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    throw new UnauthorizedError('No token provided');
  }

  const token = authHeader.substring(7).trim(); // Remove 'Bearer ' prefix and trim whitespace
  return token;
};

/**
 * Calculate token expiration date
 */
export const getTokenExpirationDate = (expiresIn: string): Date => {
  const match = expiresIn.match(/^(\d+)([mhd])$/);
  if (!match) {
    throw new Error('Invalid expiration format');
  }

  const value = parseInt(match[1], 10);
  const unit = match[2];

  const now = new Date();

  switch (unit) {
    case 'm': // minutes
      return new Date(now.getTime() + value * 60 * 1000);
    case 'h': // hours
      return new Date(now.getTime() + value * 60 * 60 * 1000);
    case 'd': // days
      return new Date(now.getTime() + value * 24 * 60 * 60 * 1000);
    default:
      throw new Error('Invalid time unit');
  }
};

