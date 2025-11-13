/**
 * Error Handling Middleware
 * Centralized error handling for the application
 */

import { Request, Response, NextFunction } from 'express';
import { ApiError, ValidationError } from '../utils/errors';
import { Logger } from '../utils/logger';
import { HTTP_STATUS, API_MESSAGES } from '../config/constants';
import { config } from '../config/environment';

/**
 * Interface for error response
 */
interface ErrorResponse {
  success: false;
  message: string;
  errors?: object;
  stack?: string;
}

/**
 * Global error handler middleware
 */
export const errorHandler = (
  err: Error | ApiError,
  req: Request,
  res: Response,
  _next: NextFunction
): void => {
  // Default error values
  let statusCode = HTTP_STATUS.INTERNAL_SERVER_ERROR;
  let message = API_MESSAGES.ERROR.INTERNAL_SERVER;
  let errors: object | undefined;

  // Handle known API errors
  if (err instanceof ApiError) {
    statusCode = err.statusCode;
    message = err.message;

    // Include validation errors if present
    if (err instanceof ValidationError) {
      errors = err.errors;
    }

    // Log operational errors
    if (err.isOperational) {
      Logger.warn(`Operational error: ${message}`, {
        statusCode,
        path: req.path,
        method: req.method,
      });
    }
  }

  // Handle Mongoose validation errors
  if (err.name === 'ValidationError') {
    statusCode = HTTP_STATUS.BAD_REQUEST;
    message = 'Validation failed';
    errors = (err as any).errors;
  }

  // Handle Mongoose duplicate key errors
  if (err.name === 'MongoServerError' && (err as any).code === 11000) {
    statusCode = HTTP_STATUS.CONFLICT;
    message = 'Resource already exists';
    const field = Object.keys((err as any).keyPattern)[0];
    errors = { [field]: `${field} already exists` };
  }

  // Handle Mongoose cast errors
  if (err.name === 'CastError') {
    statusCode = HTTP_STATUS.BAD_REQUEST;
    message = 'Invalid ID format';
  }

  // Log error
  if (statusCode >= 500) {
    Logger.error('Server error', err, {
      statusCode,
      path: req.path,
      method: req.method,
      body: req.body,
    });
  }

  // Prepare response
  const response: ErrorResponse = {
    success: false,
    message,
    ...(errors && { errors }),
    ...(config.isDevelopment && { stack: err.stack }),
  };

  // Send response
  res.status(statusCode).json(response);
};

/**
 * Handle 404 Not Found errors
 */
export const notFoundHandler = (
  req: Request,
  _res: Response,
  next: NextFunction
): void => {
  const error = new ApiError(
    `Route ${req.originalUrl} not found`,
    HTTP_STATUS.NOT_FOUND
  );
  next(error);
};

/**
 * Async handler wrapper to catch errors in async route handlers
 */
export const asyncHandler = (
  fn: (req: Request, res: Response, next: NextFunction) => Promise<any>
) => {
  return (req: Request, res: Response, next: NextFunction): void => {
    Promise.resolve(fn(req, res, next)).catch(next);
  };
};

