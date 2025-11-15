/**
 * Order Model
 * MongoDB schema for orders
 */

import mongoose, { Document, Schema } from 'mongoose';
import { COLLECTIONS } from '../config/constants';

// Order Item Interface
export interface IOrderItem {
  menuItemId: mongoose.Types.ObjectId;
  name: string;
  price: number;
  quantity: number;
  imageUrl: string;
  customizations?: {
    optionName: string;
    choices: string[];
  }[];
  subtotal: number;
}

// Delivery Address Interface
export interface IDeliveryAddress {
  street: string;
  city: string;
  state: string;
  zipCode: string;
  country: string;
  fullAddress: string;
  latitude?: number;
  longitude?: number;
}

// Payment Details Interface
export interface IPaymentDetails {
  method: 'cash' | 'card' | 'online';
  cardLast4?: string;
  cardBrand?: string;
  transactionId?: string;
  paymentStatus: 'pending' | 'completed' | 'failed' | 'refunded';
  paidAt?: Date;
}

// Order Interface
export interface IOrder extends Document {
  _id: mongoose.Types.ObjectId;
  orderNumber: string;
  userId: mongoose.Types.ObjectId;
  restaurantId: mongoose.Types.ObjectId;
  restaurantName: string;
  items: IOrderItem[];
  deliveryAddress: IDeliveryAddress;
  paymentDetails: IPaymentDetails;
  subtotal: number;
  deliveryFee: number;
  tax: number;
  total: number;
  status: 'pending' | 'confirmed' | 'preparing' | 'on_the_way' | 'delivered' | 'cancelled';
  estimatedDeliveryTime: Date;
  specialInstructions?: string;
  createdAt: Date;
  updatedAt: Date;
}

// Order Item Schema
const orderItemSchema = new Schema<IOrderItem>({
  menuItemId: {
    type: Schema.Types.ObjectId,
    ref: 'MenuItem',
    required: true,
  },
  name: {
    type: String,
    required: true,
  },
  price: {
    type: Number,
    required: true,
    min: 0,
  },
  quantity: {
    type: Number,
    required: true,
    min: 1,
  },
  imageUrl: {
    type: String,
    required: true,
  },
  customizations: [{
    optionName: String,
    choices: [String],
  }],
  subtotal: {
    type: Number,
    required: true,
    min: 0,
  },
}, { _id: false });

// Delivery Address Schema
const deliveryAddressSchema = new Schema<IDeliveryAddress>({
  street: { type: String, required: true },
  city: { type: String, required: true },
  state: { type: String, required: true },
  zipCode: { type: String, required: true },
  country: { type: String, required: true, default: 'USA' },
  fullAddress: { type: String, required: true },
  latitude: Number,
  longitude: Number,
}, { _id: false });

// Payment Details Schema
const paymentDetailsSchema = new Schema<IPaymentDetails>({
  method: {
    type: String,
    enum: ['cash', 'card', 'online'],
    required: true,
  },
  cardLast4: String,
  cardBrand: String,
  transactionId: String,
  paymentStatus: {
    type: String,
    enum: ['pending', 'completed', 'failed', 'refunded'],
    default: 'pending',
  },
  paidAt: Date,
}, { _id: false });

// Order Schema
const orderSchema = new Schema<IOrder>(
  {
    orderNumber: {
      type: String,
      required: true,
      unique: true,
      index: true,
    },
    userId: {
      type: Schema.Types.ObjectId,
      ref: 'User',
      required: true,
      index: true,
    },
    restaurantId: {
      type: Schema.Types.ObjectId,
      ref: 'Restaurant',
      required: true,
      index: true,
    },
    restaurantName: {
      type: String,
      required: true,
    },
    items: {
      type: [orderItemSchema],
      required: true,
      validate: {
        validator: (items: IOrderItem[]) => items.length > 0,
        message: 'Order must have at least one item',
      },
    },
    deliveryAddress: {
      type: deliveryAddressSchema,
      required: true,
    },
    paymentDetails: {
      type: paymentDetailsSchema,
      required: true,
    },
    subtotal: {
      type: Number,
      required: true,
      min: 0,
    },
    deliveryFee: {
      type: Number,
      required: true,
      min: 0,
    },
    tax: {
      type: Number,
      required: true,
      min: 0,
    },
    total: {
      type: Number,
      required: true,
      min: 0,
    },
    status: {
      type: String,
      enum: ['pending', 'confirmed', 'preparing', 'on_the_way', 'delivered', 'cancelled'],
      default: 'pending',
      index: true,
    },
    estimatedDeliveryTime: {
      type: Date,
      required: true,
    },
    specialInstructions: {
      type: String,
      maxlength: 500,
    },
  },
  {
    timestamps: true,
    collection: COLLECTIONS.ORDERS,
  }
);

// Indexes for performance
orderSchema.index({ userId: 1, createdAt: -1 });
orderSchema.index({ restaurantId: 1, createdAt: -1 });
orderSchema.index({ status: 1, createdAt: -1 });

// Generate order number before save
orderSchema.pre('save', async function (next) {
  if (this.isNew) {
    const count = await mongoose.model('Order').countDocuments();
    this.orderNumber = `ORD${String(count + 1).padStart(8, '0')}`;
  }
  next();
});

// Export model
export const Order = mongoose.model<IOrder>('Order', orderSchema);

