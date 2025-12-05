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
import restaurantRoutes from './routes/restaurantRoutes';
import orderRoutes from './routes/orderRoutes';
import paymentRoutes from './routes/paymentRoutes';
import { Logger } from './utils/logger';

/**
 * Create and configure Express application
 */
export const createApp = (): Application => {
  const app = express();

  // Trust proxy - Required when behind a reverse proxy (e.g., Render, Nginx, CloudFlare)
  // This allows Express to trust X-Forwarded-* headers for accurate client IP detection
  // and proper rate limiting functionality
  if (config.isProduction) {
    // In production, trust the first proxy (e.g., Render's load balancer)
    app.set('trust proxy', 1);
  } else {
    // In development, also enable trust proxy for consistency
    app.set('trust proxy', true);
  }

  // Security middleware
  app.use(helmet());

  // CORS configuration - ALLOW EVERYTHING (ALL ORIGINS)
  app.use(
    cors({
      origin: true, // Allow ALL origins
      credentials: true,
      methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'OPTIONS'],
      allowedHeaders: ['Content-Type', 'Authorization', 'X-Requested-With', 'Accept'],
      exposedHeaders: ['Content-Length', 'X-Request-Id'],
      maxAge: 86400, // 24 hours
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
  app.use(`/api/${config.apiVersion}`, restaurantRoutes);
  app.use(`/api/${config.apiVersion}`, orderRoutes);
  app.use(`/api/${config.apiVersion}`, paymentRoutes);

  // 404 handler
  app.use(notFoundHandler);

  // Global error handler (must be last)
  app.use(errorHandler);

  return app;
};

