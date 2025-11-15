/**
 * Restaurant Model
 * MongoDB schema for restaurants
 */

import mongoose, { Document, Schema } from 'mongoose';

export interface IRestaurant extends Document {
  name: string;
  description: string;
  imageUrl: string;
  rating: number;
  reviewCount: number;
  deliveryTime: number;
  deliveryFee: number;
  categories: string[];
  isFreeDelivery: boolean;
  isPopular: boolean;
  address: string;
  distance: number;
  ownerId?: string;
  createdAt: Date;
  updatedAt: Date;
}

const restaurantSchema = new Schema<IRestaurant>(
  {
    name: {
      type: String,
      required: [true, 'Restaurant name is required'],
      trim: true,
      maxlength: [100, 'Name cannot exceed 100 characters'],
    },
    description: {
      type: String,
      required: [true, 'Description is required'],
      maxlength: [500, 'Description cannot exceed 500 characters'],
    },
    imageUrl: {
      type: String,
      required: [true, 'Image URL is required'],
    },
    rating: {
      type: Number,
      default: 0,
      min: [0, 'Rating cannot be less than 0'],
      max: [5, 'Rating cannot exceed 5'],
    },
    reviewCount: {
      type: Number,
      default: 0,
      min: [0, 'Review count cannot be negative'],
    },
    deliveryTime: {
      type: Number,
      required: [true, 'Delivery time is required'],
      min: [0, 'Delivery time cannot be negative'],
    },
    deliveryFee: {
      type: Number,
      required: [true, 'Delivery fee is required'],
      min: [0, 'Delivery fee cannot be negative'],
    },
    categories: {
      type: [String],
      default: [],
    },
    isFreeDelivery: {
      type: Boolean,
      default: false,
    },
    isPopular: {
      type: Boolean,
      default: false,
    },
    address: {
      type: String,
      required: [true, 'Address is required'],
    },
    distance: {
      type: Number,
      required: [true, 'Distance is required'],
      min: [0, 'Distance cannot be negative'],
    },
    ownerId: {
      type: String,
    },
  },
  {
    timestamps: true,
  }
);

// Indexes for better query performance
restaurantSchema.index({ name: 'text', description: 'text' });
restaurantSchema.index({ categories: 1 });
restaurantSchema.index({ rating: -1 });
restaurantSchema.index({ isPopular: 1 });

const Restaurant = mongoose.model<IRestaurant>('Restaurant', restaurantSchema);

export default Restaurant;

