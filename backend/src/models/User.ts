/**
 * User Model
 * MongoDB schema for user authentication and profile
 */

import mongoose, { Document, Schema } from 'mongoose';
import bcrypt from 'bcryptjs';
import { USER_ROLES, COLLECTIONS } from '../config/constants';
import { config } from '../config/environment';

// User interface
export interface IUser extends Document {
  _id: mongoose.Types.ObjectId;
  email: string;
  password: string;
  name: string;
  phone?: string;
  role: string;
  isEmailVerified: boolean;
  emailVerificationToken?: string;
  passwordResetToken?: string;
  passwordResetExpires?: Date;
  createdAt: Date;
  updatedAt: Date;
  
  // Methods
  comparePassword(candidatePassword: string): Promise<boolean>;
}

// User schema
const userSchema = new Schema<IUser>(
  {
    email: {
      type: String,
      required: [true, 'Email is required'],
      unique: true,
      lowercase: true,
      trim: true,
      match: [
        /^\w+([.-]?\w+)*@\w+([.-]?\w+)*(\.\w{2,3})+$/,
        'Please provide a valid email',
      ],
      index: true,
    },
    
    password: {
      type: String,
      required: [true, 'Password is required'],
      minlength: [8, 'Password must be at least 8 characters'],
      select: false, // Don't return password by default
    },
    
    name: {
      type: String,
      required: [true, 'Name is required'],
      trim: true,
      minlength: [2, 'Name must be at least 2 characters'],
      maxlength: [50, 'Name cannot exceed 50 characters'],
    },
    
    phone: {
      type: String,
      trim: true,
      match: [/^\d{10,15}$/, 'Please provide a valid phone number'],
    },
    
    role: {
      type: String,
      enum: Object.values(USER_ROLES),
      default: USER_ROLES.USER,
    },
    
    isEmailVerified: {
      type: Boolean,
      default: false,
    },
    
    emailVerificationToken: {
      type: String,
      select: false,
    },
    
    passwordResetToken: {
      type: String,
      select: false,
    },
    
    passwordResetExpires: {
      type: Date,
      select: false,
    },
  },
  {
    timestamps: true,
    collection: COLLECTIONS.USERS,
  }
);

// Pre-save hook: Hash password before saving
userSchema.pre('save', async function (next) {
  // Only hash if password is modified
  if (!this.isModified('password')) {
    return next();
  }

  try {
    // Generate salt and hash password
    const salt = await bcrypt.genSalt(config.security.bcryptSaltRounds);
    this.password = await bcrypt.hash(this.password, salt);
    next();
  } catch (error) {
    next(error as Error);
  }
});

// Method: Compare password
userSchema.methods.comparePassword = async function (
  candidatePassword: string
): Promise<boolean> {
  return bcrypt.compare(candidatePassword, this.password);
};

// Indexes for performance
userSchema.index({ email: 1 });
userSchema.index({ createdAt: -1 });

// Create and export model
const User = mongoose.model<IUser>('User', userSchema);

export default User;

