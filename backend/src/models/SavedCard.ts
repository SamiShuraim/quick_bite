/**
 * Saved Card Model
 * MongoDB schema for saved payment cards
 */

import mongoose, { Document, Schema } from 'mongoose';

export interface ISavedCard extends Document {
  _id: mongoose.Types.ObjectId;
  userId: mongoose.Types.ObjectId;
  cardLast4: string;
  cardBrand: string;
  cardHolderName: string;
  expiryMonth: string;
  expiryYear: string;
  isDefault: boolean;
  createdAt: Date;
  updatedAt: Date;
}

const savedCardSchema = new Schema<ISavedCard>(
  {
    userId: {
      type: Schema.Types.ObjectId,
      ref: 'User',
      required: true,
      index: true,
    },
    cardLast4: {
      type: String,
      required: true,
      match: /^\d{4}$/,
    },
    cardBrand: {
      type: String,
      required: true,
      enum: ['visa', 'mada', 'mastercard', 'amex', 'discover', 'other'],
    },
    cardHolderName: {
      type: String,
      required: true,
      trim: true,
    },
    expiryMonth: {
      type: String,
      required: true,
      match: /^(0[1-9]|1[0-2])$/,
    },
    expiryYear: {
      type: String,
      required: true,
      match: /^\d{4}$/,
    },
    isDefault: {
      type: Boolean,
      default: false,
    },
  },
  {
    timestamps: true,
    collection: 'saved_cards',
  }
);

// Ensure only one default card per user
savedCardSchema.pre('save', async function (next) {
  if (this.isDefault) {
    await mongoose.model('SavedCard').updateMany(
      { userId: this.userId, _id: { $ne: this._id } },
      { $set: { isDefault: false } }
    );
  }
  next();
});

export const SavedCard = mongoose.model<ISavedCard>('SavedCard', savedCardSchema);

