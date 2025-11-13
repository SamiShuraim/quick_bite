/**
 * Validation Middleware
 * Request validation using express-validator
 */

import { body, ValidationChain, validationResult } from 'express-validator';
import { Request, Response, NextFunction } from 'express';
import { ValidationError } from '../utils/errors';
import { PASSWORD_REQUIREMENTS, VALIDATION, API_MESSAGES } from '../config/constants';

/**
 * Middleware to handle validation results
 */
export const handleValidationErrors = (
  req: Request,
  _res: Response,
  next: NextFunction
): void => {
  const errors = validationResult(req);

  if (!errors.isEmpty()) {
    const formattedErrors = errors.array().reduce((acc: any, error) => {
      acc[error.type === 'field' ? (error as any).path : 'general'] = (error as any).msg;
      return acc;
    }, {});

    throw new ValidationError(
      API_MESSAGES.ERROR.VALIDATION_FAILED,
      formattedErrors
    );
  }

  next();
};

/**
 * Validation rules for user registration
 */
export const validateRegister: ValidationChain[] = [
  body('email')
    .trim()
    .isEmail()
    .withMessage('Please provide a valid email')
    .isLength({ max: VALIDATION.EMAIL_MAX_LENGTH })
    .withMessage(`Email cannot exceed ${VALIDATION.EMAIL_MAX_LENGTH} characters`)
    .normalizeEmail(),

  body('password')
    .isLength({ min: PASSWORD_REQUIREMENTS.MIN_LENGTH })
    .withMessage(`Password must be at least ${PASSWORD_REQUIREMENTS.MIN_LENGTH} characters`)
    .matches(/[A-Z]/)
    .withMessage('Password must contain at least one uppercase letter')
    .matches(/[a-z]/)
    .withMessage('Password must contain at least one lowercase letter')
    .matches(/[0-9]/)
    .withMessage('Password must contain at least one number'),

  body('name')
    .trim()
    .isLength({ min: VALIDATION.NAME_MIN_LENGTH, max: VALIDATION.NAME_MAX_LENGTH })
    .withMessage(
      `Name must be between ${VALIDATION.NAME_MIN_LENGTH} and ${VALIDATION.NAME_MAX_LENGTH} characters`
    )
    .matches(/^[a-zA-Z\s]+$/)
    .withMessage('Name can only contain letters and spaces'),

  body('phone')
    .optional()
    .trim()
    .matches(/^\d{10,15}$/)
    .withMessage('Please provide a valid phone number (10-15 digits)'),
];

/**
 * Validation rules for user login
 */
export const validateLogin: ValidationChain[] = [
  body('email')
    .trim()
    .isEmail()
    .withMessage('Please provide a valid email')
    .normalizeEmail(),

  body('password')
    .notEmpty()
    .withMessage('Password is required'),
];

/**
 * Validation rules for password reset request
 */
export const validateForgotPassword: ValidationChain[] = [
  body('email')
    .trim()
    .isEmail()
    .withMessage('Please provide a valid email')
    .normalizeEmail(),
];

/**
 * Validation rules for password reset
 */
export const validateResetPassword: ValidationChain[] = [
  body('token')
    .notEmpty()
    .withMessage('Reset token is required'),

  body('password')
    .isLength({ min: PASSWORD_REQUIREMENTS.MIN_LENGTH })
    .withMessage(`Password must be at least ${PASSWORD_REQUIREMENTS.MIN_LENGTH} characters`)
    .matches(/[A-Z]/)
    .withMessage('Password must contain at least one uppercase letter')
    .matches(/[a-z]/)
    .withMessage('Password must contain at least one lowercase letter')
    .matches(/[0-9]/)
    .withMessage('Password must contain at least one number'),
];

/**
 * Validation rules for refresh token
 */
export const validateRefreshToken: ValidationChain[] = [
  body('refreshToken')
    .notEmpty()
    .withMessage('Refresh token is required'),
];

