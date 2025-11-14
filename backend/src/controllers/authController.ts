/**
 * Authentication Controller
 * Handles HTTP requests for authentication endpoints
 */

import { Request, Response } from 'express';
import { AuthService } from '../services/authService';
import { API_MESSAGES, HTTP_STATUS } from '../config/constants';
import { asyncHandler } from '../middleware/errorHandler';

/**
 * Register new user
 * POST /api/v1/auth/register
 */
export const register = asyncHandler(
  async (req: Request, res: Response): Promise<void> => {
    const { email, password, name, phone } = req.body;

    const result = await AuthService.register(email, password, name, phone);

    res.status(HTTP_STATUS.CREATED).json({
      success: true,
      message: API_MESSAGES.SUCCESS.REGISTRATION,
      data: result,
    });
  }
);

/**
 * Login user
 * POST /api/v1/auth/login
 */
export const login = asyncHandler(
  async (req: Request, res: Response): Promise<void> => {
    const { email, password } = req.body;

    const result = await AuthService.login(email, password);

    res.status(HTTP_STATUS.OK).json({
      success: true,
      message: API_MESSAGES.SUCCESS.LOGIN,
      data: result,
    });
  }
);

/**
 * Logout user
 * POST /api/v1/auth/logout
 */
export const logout = asyncHandler(
  async (req: Request, res: Response): Promise<void> => {
    const { refreshToken } = req.body;

    await AuthService.logout(refreshToken);

    res.status(HTTP_STATUS.OK).json({
      success: true,
      message: API_MESSAGES.SUCCESS.LOGOUT,
    });
  }
);

/**
 * Refresh access token
 * POST /api/v1/auth/refresh
 */
export const refresh = asyncHandler(
  async (req: Request, res: Response): Promise<void> => {
    const { refreshToken } = req.body;

    const tokens = await AuthService.refreshAccessToken(refreshToken);

    res.status(HTTP_STATUS.OK).json({
      success: true,
      message: API_MESSAGES.SUCCESS.TOKEN_REFRESH,
      data: tokens,
    });
  }
);

/**
 * Get current user profile
 * GET /api/v1/auth/profile
 */
export const getProfile = asyncHandler(
  async (req: Request, res: Response): Promise<void> => {
    if (!req.user) {
      res.status(HTTP_STATUS.UNAUTHORIZED).json({
        success: false,
        message: API_MESSAGES.ERROR.UNAUTHORIZED,
      });
      return;
    }

    const user = await AuthService.getProfile(req.user.userId);

    res.status(HTTP_STATUS.OK).json({
      success: true,
      data: {
        user: {
          id: user?._id.toString(),
          email: user?.email,
          name: user?.name,
          phone: user?.phone,
          role: user?.role,
          isEmailVerified: user?.isEmailVerified,
          createdAt: user?.createdAt,
        },
      },
    });
  }
);

/**
 * Verify email with code
 * POST /api/v1/auth/verify-email
 */
export const verifyEmail = asyncHandler(
  async (req: Request, res: Response): Promise<void> => {
    const { email, code } = req.body;

    await AuthService.verifyEmail(email, code);

    res.status(HTTP_STATUS.OK).json({
      success: true,
      message: 'Email verified successfully',
    });
  }
);

/**
 * Resend verification code
 * POST /api/v1/auth/resend-verification
 */
export const resendVerification = asyncHandler(
  async (req: Request, res: Response): Promise<void> => {
    const { email } = req.body;

    await AuthService.resendVerificationCode(email);

    res.status(HTTP_STATUS.OK).json({
      success: true,
      message: 'Verification code sent',
    });
  }
);

/**
 * Request password reset
 * POST /api/v1/auth/forgot-password
 */
export const forgotPassword = asyncHandler(
  async (req: Request, res: Response): Promise<void> => {
    const { email } = req.body;

    await AuthService.requestPasswordReset(email);

    res.status(HTTP_STATUS.OK).json({
      success: true,
      message: 'Password reset code sent to your email',
    });
  }
);

/**
 * Reset password with code
 * POST /api/v1/auth/reset-password
 */
export const resetPassword = asyncHandler(
  async (req: Request, res: Response): Promise<void> => {
    const { email, code, newPassword } = req.body;

    await AuthService.resetPassword(email, code, newPassword);

    res.status(HTTP_STATUS.OK).json({
      success: true,
      message: 'Password reset successfully',
    });
  }
);

