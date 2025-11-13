/**
 * Logger Utility
 * Centralized logging system using Winston
 */

import winston from 'winston';
import { config } from '../config/environment';

// Define log levels
const levels = {
  error: 0,
  warn: 1,
  info: 2,
  http: 3,
  debug: 4,
};

// Define colors for each level
const colors = {
  error: 'red',
  warn: 'yellow',
  info: 'green',
  http: 'magenta',
  debug: 'white',
};

// Tell winston about our colors
winston.addColors(colors);

// Define log format
const format = winston.format.combine(
  winston.format.timestamp({ format: 'YYYY-MM-DD HH:mm:ss' }),
  winston.format.colorize({ all: true }),
  winston.format.printf(
    (info) => `${info.timestamp} [${info.level}]: ${info.message}`
  )
);

// Define transports
const transports = [
  // Console transport
  new winston.transports.Console({
    format,
  }),
  // File transport for errors
  new winston.transports.File({
    filename: 'logs/error.log',
    level: 'error',
    format: winston.format.combine(
      winston.format.timestamp(),
      winston.format.json()
    ),
  }),
  // File transport for all logs
  new winston.transports.File({
    filename: 'logs/combined.log',
    format: winston.format.combine(
      winston.format.timestamp(),
      winston.format.json()
    ),
  }),
];

// Create logger instance
const logger = winston.createLogger({
  level: config.isDevelopment ? 'debug' : 'info',
  levels,
  transports,
});

// Helper methods for structured logging
export class Logger {
  /**
   * Log info message
   */
  static info(message: string, meta?: object): void {
    logger.info(message, meta);
  }

  /**
   * Log debug message
   */
  static debug(message: string, meta?: object): void {
    logger.debug(message, meta);
  }

  /**
   * Log warning message
   */
  static warn(message: string, meta?: object): void {
    logger.warn(message, meta);
  }

  /**
   * Log error message
   */
  static error(message: string, error?: Error, meta?: object): void {
    const errorMeta = error
      ? {
          ...meta,
          error: {
            message: error.message,
            stack: error.stack,
            name: error.name,
          },
        }
      : meta;

    logger.error(message, errorMeta);
  }

  /**
   * Log HTTP request
   */
  static http(message: string, meta?: object): void {
    logger.http(message, meta);
  }

  /**
   * Log API request
   */
  static apiRequest(
    method: string,
    path: string,
    statusCode: number,
    duration: number
  ): void {
    logger.http(`${method} ${path} ${statusCode} - ${duration}ms`);
  }

  /**
   * Log database operation
   */
  static database(operation: string, collection: string, meta?: object): void {
    logger.debug(`DB ${operation} on ${collection}`, meta);
  }

  /**
   * Log authentication event
   */
  static auth(event: string, userId?: string, meta?: object): void {
    logger.info(`AUTH: ${event}`, { userId, ...meta });
  }

  /**
   * Log section separator for clarity
   */
  static separator(): void {
    logger.info('='.repeat(80));
  }

  /**
   * Log section with title
   */
  static section(title: string): void {
    this.separator();
    logger.info(title);
    this.separator();
  }
}

export default logger;

