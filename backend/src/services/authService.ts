/**
 * Authentication Service
 * Business logic for user authentication
 */

import User, { IUser } from '../models/User';
import RefreshToken from '../models/RefreshToken';
import {
  generateAccessToken,
  generateRefreshToken,
  verifyRefreshToken,
  getTokenExpirationDate,
} from '../utils/jwt';
import {
  UnauthorizedError,
  ConflictError,
  NotFoundError,
  BadRequestError,
} from '../utils/errors';
import { API_MESSAGES } from '../config/constants';
import { Logger } from '../utils/logger';
import { config } from '../config/environment';
import { EmailService } from './emailService';
import crypto from 'crypto';

/**
 * Register response interface
 */
export interface RegisterResponse {
  user: {
    id: string;
    email: string;
    name: string;
    role: string;
  };
  tokens: {
    accessToken: string;
    refreshToken: string;
  };
}

/**
 * Login response interface
 */
export interface LoginResponse {
  user: {
    id: string;
    email: string;
    name: string;
    role: string;
  };
  tokens: {
    accessToken: string;
    refreshToken: string;
  };
}

export class AuthService {
  /**
   * Register new user
   */
  static async register(
    email: string,
    password: string,
    name: string,
    phone?: string
  ): Promise<RegisterResponse> {
    // Check if user already exists
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      Logger.warn(`Registration attempt with existing email: ${email}`);
      throw new ConflictError(API_MESSAGES.ERROR.EMAIL_EXISTS);
    }

    // TODO: Email verification disabled for now - re-enable later if needed
    // Generate verification code
    // const verificationCode = EmailService.generateVerificationCode();
    // const hashedCode = crypto
    //   .createHash('sha256')
    //   .update(verificationCode)
    //   .digest('hex');

    // Create new user
    const user = await User.create({
      email,
      password,
      name,
      phone,
      // emailVerificationToken: hashedCode, // Disabled verification
    });

    Logger.auth('User registered', user._id.toString(), { email });

    // TODO: Email verification disabled for now - re-enable later if needed
    // Send verification email
    // try {
    //   await EmailService.sendVerificationEmail(email, verificationCode);
    // } catch (error) {
    //   Logger.error('Failed to send verification email', error as Error);
    //   // Continue even if email fails
    // }

    // Generate tokens
    const accessToken = generateAccessToken(
      user._id.toString(),
      user.email,
      user.role
    );
    const refreshToken = generateRefreshToken(
      user._id.toString(),
      user.email,
      user.role
    );

    // Save refresh token to database
    await RefreshToken.create({
      userId: user._id,
      token: refreshToken,
      expiresAt: getTokenExpirationDate(config.jwt.refreshExpiresIn),
    });

    return {
      user: {
        id: user._id.toString(),
        email: user.email,
        name: user.name,
        role: user.role,
      },
      tokens: {
        accessToken,
        refreshToken,
      },
    };
  }

  /**
   * Login user
   */
  static async login(email: string, password: string): Promise<LoginResponse> {
    // Find user and include password field
    const user = await User.findOne({ email }).select('+password');
    if (!user) {
      Logger.warn(`Login attempt with non-existent email: ${email}`);
      throw new UnauthorizedError(API_MESSAGES.ERROR.INVALID_CREDENTIALS);
    }

    // Verify password
    const isPasswordValid = await user.comparePassword(password);
    if (!isPasswordValid) {
      Logger.warn(`Failed login attempt for user: ${email}`);
      throw new UnauthorizedError(API_MESSAGES.ERROR.INVALID_CREDENTIALS);
    }

    Logger.auth('User logged in', user._id.toString(), { email });

    // Generate tokens
    const accessToken = generateAccessToken(
      user._id.toString(),
      user.email,
      user.role
    );
    const refreshToken = generateRefreshToken(
      user._id.toString(),
      user.email,
      user.role
    );

    // Save refresh token to database
    await RefreshToken.create({
      userId: user._id,
      token: refreshToken,
      expiresAt: getTokenExpirationDate(config.jwt.refreshExpiresIn),
    });

    return {
      user: {
        id: user._id.toString(),
        email: user.email,
        name: user.name,
        role: user.role,
      },
      tokens: {
        accessToken,
        refreshToken,
      },
    };
  }

  /**
   * Logout user
   */
  static async logout(refreshToken: string): Promise<void> {
    // Delete refresh token from database
    const result = await RefreshToken.deleteOne({ token: refreshToken });

    if (result.deletedCount === 0) {
      Logger.warn('Logout attempt with invalid token');
    } else {
      Logger.auth('User logged out');
    }
  }

  /**
   * Refresh access token
   */
  static async refreshAccessToken(
    refreshToken: string
  ): Promise<{ accessToken: string; refreshToken: string }> {
    // Verify refresh token
    const payload = verifyRefreshToken(refreshToken);

    // Check if refresh token exists in database
    const storedToken = await RefreshToken.findOne({ token: refreshToken });
    if (!storedToken) {
      Logger.warn('Refresh attempt with invalid token');
      throw new UnauthorizedError(API_MESSAGES.ERROR.INVALID_TOKEN);
    }

    // Check if user still exists
    const user = await User.findById(payload.userId);
    if (!user) {
      Logger.warn('Refresh attempt for non-existent user');
      throw new NotFoundError(API_MESSAGES.ERROR.USER_NOT_FOUND);
    }

    Logger.auth('Token refreshed', user._id.toString());

    // Generate new tokens
    const newAccessToken = generateAccessToken(
      user._id.toString(),
      user.email,
      user.role
    );
    const newRefreshToken = generateRefreshToken(
      user._id.toString(),
      user.email,
      user.role
    );

    // Delete old refresh token and save new one
    await RefreshToken.deleteOne({ token: refreshToken });
    await RefreshToken.create({
      userId: user._id,
      token: newRefreshToken,
      expiresAt: getTokenExpirationDate(config.jwt.refreshExpiresIn),
    });

    return {
      accessToken: newAccessToken,
      refreshToken: newRefreshToken,
    };
  }

  /**
   * Get user profile
   */
  static async getProfile(userId: string): Promise<IUser | null> {
    const user = await User.findById(userId);
    if (!user) {
      throw new NotFoundError(API_MESSAGES.ERROR.USER_NOT_FOUND);
    }
    return user;
  }

  /**
   * Verify email with code
   */
  static async verifyEmail(email: string, code: string): Promise<boolean> {
    // Hash the provided code
    const hashedCode = crypto.createHash('sha256').update(code).digest('hex');

    // Find user with matching email and verification token
    const user = await User.findOne({
      email,
      emailVerificationToken: hashedCode,
    }).select('+emailVerificationToken');

    if (!user) {
      Logger.warn(`Email verification failed for: ${email}`);
      throw new BadRequestError('Invalid verification code');
    }

    // Mark email as verified and remove token
    user.isEmailVerified = true;
    user.emailVerificationToken = undefined;
    await user.save();

    Logger.auth('Email verified', user._id.toString(), { email });
    return true;
  }

  /**
   * Resend verification code
   */
  static async resendVerificationCode(email: string): Promise<void> {
    const user = await User.findOne({ email });
    if (!user) {
      throw new NotFoundError(API_MESSAGES.ERROR.USER_NOT_FOUND);
    }

    if (user.isEmailVerified) {
      throw new BadRequestError('Email is already verified');
    }

    // Generate new verification code
    const verificationCode = EmailService.generateVerificationCode();
    const hashedCode = crypto
      .createHash('sha256')
      .update(verificationCode)
      .digest('hex');

    // Update user with new token
    user.emailVerificationToken = hashedCode;
    await user.save();

    // Send verification email
    await EmailService.sendVerificationEmail(email, verificationCode);

    Logger.info(`Verification code resent to: ${email}`);
  }

  /**
   * Request password reset
   */
  static async requestPasswordReset(email: string): Promise<void> {
    const user = await User.findOne({ email });
    if (!user) {
      // Don't reveal that user doesn't exist
      Logger.warn(`Password reset requested for non-existent email: ${email}`);
      return;
    }

    // Generate reset code
    const resetCode = EmailService.generateVerificationCode();
    const hashedCode = crypto.createHash('sha256').update(resetCode).digest('hex');

    // Set reset token and expiry (10 minutes)
    user.passwordResetToken = hashedCode;
    user.passwordResetExpires = new Date(Date.now() + 10 * 60 * 1000);
    await user.save();

    // Send reset email
    await EmailService.sendPasswordResetEmail(email, resetCode);

    Logger.info(`Password reset code sent to: ${email}`);
  }

  /**
   * Reset password with code
   */
  static async resetPassword(
    email: string,
    code: string,
    newPassword: string
  ): Promise<void> {
    // Hash the provided code
    const hashedCode = crypto.createHash('sha256').update(code).digest('hex');

    // Find user with matching email and reset token
    const user = await User.findOne({
      email,
      passwordResetToken: hashedCode,
      passwordResetExpires: { $gt: Date.now() },
    }).select('+passwordResetToken +passwordResetExpires');

    if (!user) {
      Logger.warn(`Password reset failed for: ${email}`);
      throw new BadRequestError('Invalid or expired reset code');
    }

    // Update password and clear reset token
    user.password = newPassword;
    user.passwordResetToken = undefined;
    user.passwordResetExpires = undefined;
    await user.save();

    // Invalidate all refresh tokens for this user
    await RefreshToken.deleteMany({ userId: user._id });

    Logger.auth('Password reset', user._id.toString(), { email });
  }
}

