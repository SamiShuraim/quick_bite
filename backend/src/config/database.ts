/**
 * Database Configuration
 * MongoDB connection setup
 */

import mongoose from 'mongoose';
import { config } from './environment';
import { Logger } from '../utils/logger';
import { API_MESSAGES } from './constants';

/**
 * Connect to MongoDB
 */
export const connectDatabase = async (): Promise<void> => {
  try {
    // MongoDB connection options
    const options = {
      maxPoolSize: 10,
      serverSelectionTimeoutMS: 5000,
      socketTimeoutMS: 45000,
    };

    // Connect to database
    await mongoose.connect(config.database.uri, options);

    Logger.info(API_MESSAGES.INFO.DB_CONNECTED);

    // Log database name
    const dbName = mongoose.connection.db?.databaseName;
    Logger.debug(`Connected to database: ${dbName}`);
  } catch (error) {
    Logger.error('Database connection failed', error as Error);
    process.exit(1);
  }
};

/**
 * Disconnect from MongoDB
 */
export const disconnectDatabase = async (): Promise<void> => {
  try {
    await mongoose.disconnect();
    Logger.info(API_MESSAGES.INFO.DB_DISCONNECTED);
  } catch (error) {
    Logger.error('Database disconnection failed', error as Error);
  }
};

/**
 * Handle database connection events
 */
mongoose.connection.on('connected', () => {
  Logger.debug('Mongoose connected to MongoDB');
});

mongoose.connection.on('error', (err) => {
  Logger.error('Mongoose connection error', err);
});

mongoose.connection.on('disconnected', () => {
  Logger.debug('Mongoose disconnected from MongoDB');
});

// Handle process termination
process.on('SIGINT', async () => {
  await disconnectDatabase();
  process.exit(0);
});

