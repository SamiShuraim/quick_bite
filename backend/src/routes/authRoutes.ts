/**
 * Authentication Routes
 * Define all authentication-related endpoints
 */

import { Router } from 'express';
import {
  register,
  login,
  logout,
  refresh,
  getProfile,
} from '../controllers/authController';
import {
  validateRegister,
  validateLogin,
  validateRefreshToken,
  handleValidationErrors,
} from '../middleware/validation';
import { authenticate } from '../middleware/auth';
import { authLimiter } from '../middleware/rateLimiter';

const router = Router();

/**
 * @route   POST /api/v1/auth/register
 * @desc    Register new user
 * @access  Public
 */
router.post(
  '/register',
  authLimiter,
  validateRegister,
  handleValidationErrors,
  register
);

/**
 * @route   POST /api/v1/auth/login
 * @desc    Login user
 * @access  Public
 */
router.post(
  '/login',
  authLimiter,
  validateLogin,
  handleValidationErrors,
  login
);

/**
 * @route   POST /api/v1/auth/logout
 * @desc    Logout user (invalidate refresh token)
 * @access  Public
 */
router.post(
  '/logout',
  validateRefreshToken,
  handleValidationErrors,
  logout
);

/**
 * @route   POST /api/v1/auth/refresh
 * @desc    Refresh access token
 * @access  Public
 */
router.post(
  '/refresh',
  validateRefreshToken,
  handleValidationErrors,
  refresh
);

/**
 * @route   GET /api/v1/auth/profile
 * @desc    Get current user profile
 * @access  Private
 */
router.get('/profile', authenticate, getProfile);

export default router;

