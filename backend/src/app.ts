/**
 * Express Application Setup
 * Configure Express app with middleware and routes
 */

import express, { Application } from 'express';
import cors from 'cors';
import helmet from 'helmet';
import compression from 'compression';
import morgan from 'morgan';
import { config } from './config/environment';
import { errorHandler, notFoundHandler } from './middleware/errorHandler';
import { apiLimiter } from './middleware/rateLimiter';
import authRoutes from './routes/authRoutes';
import { Logger } from './utils/logger';

/**
 * Create and configure Express application
 */
export const createApp = (): Application => {
  const app = express();

  // Security middleware
  app.use(helmet());

  // CORS configuration
  app.use(
    cors({
      origin: config.cors.allowedOrigins,
      credentials: true,
      methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH'],
      allowedHeaders: ['Content-Type', 'Authorization'],
    })
  );

  // Body parsing middleware
  app.use(express.json({ limit: '10mb' }));
  app.use(express.urlencoded({ extended: true, limit: '10mb' }));

  // Compression middleware
  app.use(compression());

  // HTTP request logging
  if (config.isDevelopment) {
    app.use(morgan('dev'));
  } else {
    app.use(
      morgan('combined', {
        stream: {
          write: (message: string) => Logger.http(message.trim()),
        },
      })
    );
  }

  // API rate limiting
  app.use('/api/', apiLimiter);

  // Health check endpoint
  app.get('/health', (_req, res) => {
    res.status(200).json({
      success: true,
      message: 'Server is healthy',
      timestamp: new Date().toISOString(),
      environment: config.env,
    });
  });

  // API Routes
  app.use(`/api/${config.apiVersion}/auth`, authRoutes);

  // 404 handler
  app.use(notFoundHandler);

  // Global error handler (must be last)
  app.use(errorHandler);

  return app;
};

