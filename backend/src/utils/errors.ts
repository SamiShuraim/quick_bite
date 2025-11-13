/**
 * Custom Error Classes
 * Application-specific error types for better error handling
 */

import { HTTP_STATUS } from '../config/constants';

/**
 * Base API Error class
 */
export class ApiError extends Error {
  statusCode: number;
  isOperational: boolean;

  constructor(
    message: string,
    statusCode: number = HTTP_STATUS.INTERNAL_SERVER_ERROR,
    isOperational = true
  ) {
    super(message);
    this.statusCode = statusCode;
    this.isOperational = isOperational;
    
    // Maintains proper stack trace for where error was thrown
    Error.captureStackTrace(this, this.constructor);
    
    // Set the prototype explicitly
    Object.setPrototypeOf(this, ApiError.prototype);
  }
}

/**
 * Bad Request Error (400)
 */
export class BadRequestError extends ApiError {
  constructor(message: string) {
    super(message, HTTP_STATUS.BAD_REQUEST);
    Object.setPrototypeOf(this, BadRequestError.prototype);
  }
}

/**
 * Unauthorized Error (401)
 */
export class UnauthorizedError extends ApiError {
  constructor(message: string) {
    super(message, HTTP_STATUS.UNAUTHORIZED);
    Object.setPrototypeOf(this, UnauthorizedError.prototype);
  }
}

/**
 * Forbidden Error (403)
 */
export class ForbiddenError extends ApiError {
  constructor(message: string) {
    super(message, HTTP_STATUS.FORBIDDEN);
    Object.setPrototypeOf(this, ForbiddenError.prototype);
  }
}

/**
 * Not Found Error (404)
 */
export class NotFoundError extends ApiError {
  constructor(message: string) {
    super(message, HTTP_STATUS.NOT_FOUND);
    Object.setPrototypeOf(this, NotFoundError.prototype);
  }
}

/**
 * Conflict Error (409)
 */
export class ConflictError extends ApiError {
  constructor(message: string) {
    super(message, HTTP_STATUS.CONFLICT);
    Object.setPrototypeOf(this, ConflictError.prototype);
  }
}

/**
 * Validation Error (422)
 */
export class ValidationError extends ApiError {
  errors: object;

  constructor(message: string, errors: object = {}) {
    super(message, HTTP_STATUS.UNPROCESSABLE_ENTITY);
    this.errors = errors;
    Object.setPrototypeOf(this, ValidationError.prototype);
  }
}

