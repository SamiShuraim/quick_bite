/**
 * Authentication Middleware
 * Protects routes and validates JWT tokens
 */

import { Request, Response, NextFunction } from 'express';
import { verifyAccessToken, extractTokenFromHeader } from '../utils/jwt';
import { UnauthorizedError, ForbiddenError } from '../utils/errors';
import { Logger } from '../utils/logger';
import User from '../models/User';

// Extend Express Request type to include user
declare global {
  namespace Express {
    interface Request {
      user?: {
        userId: string;
        email: string;
        role: string;
      };
    }
  }
}

/**
 * Middleware to verify JWT token and authenticate user
 */
export const authenticate = async (
  req: Request,
  _res: Response,
  next: NextFunction
): Promise<void> => {
  try {
    // Extract token from Authorization header
    const token = extractTokenFromHeader(req.headers.authorization);

    // Verify token
    const payload = verifyAccessToken(token);

    // Verify user still exists
    const user = await User.findById(payload.userId);
    if (!user) {
      throw new UnauthorizedError('User not found');
    }

    // Attach user info to request
    req.user = {
      userId: payload.userId,
      email: payload.email,
      role: payload.role,
    };

    Logger.auth('User authenticated', payload.userId);
    next();
  } catch (error) {
    next(error);
  }
};

/**
 * Middleware to check if user has required role
 */
export const authorize = (...allowedRoles: string[]) => {
  return (req: Request, _res: Response, next: NextFunction): void => {
    try {
      if (!req.user) {
        throw new UnauthorizedError('Authentication required');
      }

      if (!allowedRoles.includes(req.user.role)) {
        Logger.warn(`Access denied for role: ${req.user.role}`, {
          userId: req.user.userId,
          requiredRoles: allowedRoles,
        });
        throw new ForbiddenError('Insufficient permissions');
      }

      Logger.auth('User authorized', req.user.userId, {
        role: req.user.role,
      });
      next();
    } catch (error) {
      next(error);
    }
  };
};

/**
 * Optional authentication - doesn't fail if no token
 */
export const optionalAuth = async (
  req: Request,
  _res: Response,
  next: NextFunction
): Promise<void> => {
  try {
    const authHeader = req.headers.authorization;
    
    if (authHeader && authHeader.startsWith('Bearer ')) {
      const token = extractTokenFromHeader(authHeader);
      const payload = verifyAccessToken(token);

      req.user = {
        userId: payload.userId,
        email: payload.email,
        role: payload.role,
      };
    }

    next();
  } catch (error) {
    // Ignore auth errors for optional auth
    next();
  }
};

