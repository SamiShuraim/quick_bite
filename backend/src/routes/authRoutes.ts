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
  verifyEmail,
  resendVerification,
  forgotPassword,
  resetPassword,
} from '../controllers/authController';
import {
  validateRegister,
  validateLogin,
  validateRefreshToken,
  handleValidationErrors,
} from '../middleware/validation';
import { authenticate } from '../middleware/auth';
import { authLimiter } from '../middleware/rateLimiter';
import { body } from 'express-validator';

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

/**
 * @route   POST /api/v1/auth/verify-email
 * @desc    Verify email with code
 * @access  Public
 */
router.post(
  '/verify-email',
  authLimiter,
  body('email').isEmail().withMessage('Valid email is required'),
  body('code').isLength({ min: 4, max: 4 }).withMessage('4-digit code is required'),
  handleValidationErrors,
  verifyEmail
);

/**
 * @route   POST /api/v1/auth/resend-verification
 * @desc    Resend verification code
 * @access  Public
 */
router.post(
  '/resend-verification',
  authLimiter,
  body('email').isEmail().withMessage('Valid email is required'),
  handleValidationErrors,
  resendVerification
);

/**
 * @route   POST /api/v1/auth/forgot-password
 * @desc    Request password reset
 * @access  Public
 */
router.post(
  '/forgot-password',
  authLimiter,
  body('email').isEmail().withMessage('Valid email is required'),
  handleValidationErrors,
  forgotPassword
);

/**
 * @route   POST /api/v1/auth/reset-password
 * @desc    Reset password with code
 * @access  Public
 */
router.post(
  '/reset-password',
  authLimiter,
  body('email').isEmail().withMessage('Valid email is required'),
  body('code').isLength({ min: 4, max: 4 }).withMessage('4-digit code is required'),
  body('newPassword')
    .isLength({ min: 8 })
    .withMessage('Password must be at least 8 characters'),
  handleValidationErrors,
  resetPassword
);

export default router;

