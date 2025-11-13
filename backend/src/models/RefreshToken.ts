/**
 * Refresh Token Model
 * MongoDB schema for managing refresh tokens
 */

import mongoose, { Document, Schema } from 'mongoose';
import { COLLECTIONS } from '../config/constants';

// Refresh token interface
export interface IRefreshToken extends Document {
  userId: mongoose.Types.ObjectId;
  token: string;
  expiresAt: Date;
  createdAt: Date;
}

// Refresh token schema
const refreshTokenSchema = new Schema<IRefreshToken>(
  {
    userId: {
      type: Schema.Types.ObjectId,
      ref: 'User',
      required: true,
      index: true,
    },
    
    token: {
      type: String,
      required: true,
      unique: true,
      index: true,
    },
    
    expiresAt: {
      type: Date,
      required: true,
      index: true,
    },
  },
  {
    timestamps: { createdAt: true, updatedAt: false },
    collection: COLLECTIONS.REFRESH_TOKENS,
  }
);

// Index for automatic deletion of expired tokens
refreshTokenSchema.index({ expiresAt: 1 }, { expireAfterSeconds: 0 });

// Create and export model
const RefreshToken = mongoose.model<IRefreshToken>(
  'RefreshToken',
  refreshTokenSchema
);

export default RefreshToken;

