/**
 * MenuItem Model
 * MongoDB schema for menu items
 */

import mongoose, { Document, Schema } from 'mongoose';

interface ICustomizationChoice {
  id: string;
  name: string;
  additionalPrice: number;
}

interface ICustomizationOption {
  id: string;
  name: string;
  choices: ICustomizationChoice[];
  isRequired: boolean;
  maxSelections: number;
}

export interface IMenuItem extends Document {
  restaurantId: string;
  name: string;
  description: string;
  imageUrl: string;
  price: number;
  category: string;
  rating: number;
  reviewCount: number;
  isPopular: boolean;
  isVegetarian: boolean;
  ingredients: string[];
  customizations: ICustomizationOption[];
  createdAt: Date;
  updatedAt: Date;
}

const customizationChoiceSchema = new Schema<ICustomizationChoice>(
  {
    id: { type: String, required: true },
    name: { type: String, required: true },
    additionalPrice: { type: Number, default: 0 },
  },
  { _id: false }
);

const customizationOptionSchema = new Schema<ICustomizationOption>(
  {
    id: { type: String, required: true },
    name: { type: String, required: true },
    choices: [customizationChoiceSchema],
    isRequired: { type: Boolean, default: false },
    maxSelections: { type: Number, default: 1 },
  },
  { _id: false }
);

const menuItemSchema = new Schema<IMenuItem>(
  {
    restaurantId: {
      type: String,
      required: [true, 'Restaurant ID is required'],
      index: true,
    },
    name: {
      type: String,
      required: [true, 'Menu item name is required'],
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
    price: {
      type: Number,
      required: [true, 'Price is required'],
      min: [0, 'Price cannot be negative'],
    },
    category: {
      type: String,
      required: [true, 'Category is required'],
      index: true,
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
    isPopular: {
      type: Boolean,
      default: false,
    },
    isVegetarian: {
      type: Boolean,
      default: false,
    },
    ingredients: {
      type: [String],
      default: [],
    },
    customizations: {
      type: [customizationOptionSchema],
      default: [],
    },
  },
  {
    timestamps: true,
  }
);

// Indexes for better query performance
menuItemSchema.index({ name: 'text', description: 'text' });
menuItemSchema.index({ restaurantId: 1, category: 1 });
menuItemSchema.index({ rating: -1 });
menuItemSchema.index({ isPopular: 1 });

const MenuItem = mongoose.model<IMenuItem>('MenuItem', menuItemSchema);

export default MenuItem;

