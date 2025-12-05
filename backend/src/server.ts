/**
 * Server Entry Point
 * Start the Express server
 */

import { createApp } from './app';
import { connectDatabase } from './config/database';
import { config } from './config/environment';
import { Logger } from './utils/logger';
import { API_MESSAGES } from './config/constants';
import { startOrderStatusCron } from './services/orderStatusCron';

/**
 * Start the server
 */
const startServer = async (): Promise<void> => {
  try {
    Logger.section('QuickBite Backend Server Starting');

    // Connect to database
    Logger.info('Connecting to database...');
    await connectDatabase();

    // Create Express app
    const app = createApp();

    // Start order status cron job
    startOrderStatusCron();

    // Start listening
    const server = app.listen(config.port, () => {
      Logger.info(
        `${API_MESSAGES.INFO.SERVER_RUNNING} ${config.port}`,
        {
          environment: config.env,
          apiVersion: config.apiVersion,
        }
      );
      Logger.separator();
    });

    // Handle server errors
    server.on('error', (error: NodeJS.ErrnoException) => {
      if (error.code === 'EADDRINUSE') {
        Logger.error(`Port ${config.port} is already in use`, error);
      } else {
        Logger.error(`Server error: ${error.message}`, error, {
          code: error.code,
          errno: error.errno,
          syscall: error.syscall,
        });
      }
      process.exit(1);
    });

    // Graceful shutdown
    const shutdown = async (): Promise<void> => {
      Logger.info('Shutting down server gracefully...');
      
      server.close(async () => {
        Logger.info('HTTP server closed');
        process.exit(0);
      });

      // Force shutdown after 10 seconds
      setTimeout(() => {
        Logger.error('Forcing shutdown after timeout');
        process.exit(1);
      }, 10000);
    };

    process.on('SIGTERM', shutdown);
    process.on('SIGINT', shutdown);
  } catch (error) {
    Logger.error('Failed to start server', error as Error);
    process.exit(1);
  }
};

// Start the server
startServer();

