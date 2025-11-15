/**
 * Payment Controller
 * Handle payment and saved card operations
 */

import { Request, Response } from 'express';
import { SavedCard } from '../models/SavedCard';
import { Logger } from '../utils/logger';

/**
 * Get all saved cards for user
 * GET /api/v1/payment/cards
 */
export const getSavedCards = async (req: Request, res: Response): Promise<void> => {
  try {
    const userId = req.user?.userId;

    const cards = await SavedCard.find({ userId }).sort({ isDefault: -1, createdAt: -1 });

    res.status(200).json({
      success: true,
      data: { cards },
    });
  } catch (error) {
    Logger.error('Error fetching saved cards:', error as Error);
    res.status(500).json({
      success: false,
      message: 'Failed to fetch saved cards',
      error: error instanceof Error ? error.message : 'Unknown error',
    });
  }
};

/**
 * Add a new saved card
 * POST /api/v1/payment/cards
 */
export const addSavedCard = async (req: Request, res: Response): Promise<void> => {
  try {
    const userId = req.user?.userId;
    const { cardLast4, cardBrand, cardHolderName, expiryMonth, expiryYear, isDefault } = req.body;

    // Validate expiry date
    const currentYear = new Date().getFullYear();
    const currentMonth = new Date().getMonth() + 1;
    const expYear = parseInt(expiryYear);
    const expMonth = parseInt(expiryMonth);

    if (expYear < currentYear || (expYear === currentYear && expMonth < currentMonth)) {
      res.status(400).json({
        success: false,
        message: 'Card has expired',
      });
      return;
    }

    // Check if this is the first card
    const existingCards = await SavedCard.countDocuments({ userId });
    const shouldBeDefault = existingCards === 0 || isDefault;

    const card = await SavedCard.create({
      userId,
      cardLast4,
      cardBrand: cardBrand.toLowerCase(),
      cardHolderName,
      expiryMonth,
      expiryYear,
      isDefault: shouldBeDefault,
    });

    Logger.info(`Card added for user: ${userId}`);

    res.status(201).json({
      success: true,
      message: 'Card added successfully',
      data: { card },
    });
  } catch (error) {
    Logger.error('Error adding saved card:', error as Error);
    res.status(500).json({
      success: false,
      message: 'Failed to add card',
      error: error instanceof Error ? error.message : 'Unknown error',
    });
  }
};

/**
 * Delete a saved card
 * DELETE /api/v1/payment/cards/:id
 */
export const deleteSavedCard = async (req: Request, res: Response): Promise<void> => {
  try {
    const userId = req.user?.userId;
    const { id } = req.params;

    const card = await SavedCard.findOne({ _id: id, userId });

    if (!card) {
      res.status(404).json({
        success: false,
        message: 'Card not found',
      });
      return;
    }

    const wasDefault = card.isDefault;
    await card.deleteOne();

    // If deleted card was default, make another card default
    if (wasDefault) {
      const nextCard = await SavedCard.findOne({ userId });
      if (nextCard) {
        nextCard.isDefault = true;
        await nextCard.save();
      }
    }

    Logger.info(`Card deleted for user: ${userId}`);

    res.status(200).json({
      success: true,
      message: 'Card deleted successfully',
    });
  } catch (error) {
    Logger.error('Error deleting saved card:', error as Error);
    res.status(500).json({
      success: false,
      message: 'Failed to delete card',
      error: error instanceof Error ? error.message : 'Unknown error',
    });
  }
};

/**
 * Set a card as default
 * PATCH /api/v1/payment/cards/:id/default
 */
export const setDefaultCard = async (req: Request, res: Response): Promise<void> => {
  try {
    const userId = req.user?.userId;
    const { id } = req.params;

    const card = await SavedCard.findOne({ _id: id, userId });

    if (!card) {
      res.status(404).json({
        success: false,
        message: 'Card not found',
      });
      return;
    }

    // Set all cards to not default
    await SavedCard.updateMany({ userId }, { $set: { isDefault: false } });

    // Set this card as default
    card.isDefault = true;
    await card.save();

    Logger.info(`Default card set for user: ${userId}`);

    res.status(200).json({
      success: true,
      message: 'Default card updated',
      data: { card },
    });
  } catch (error) {
    Logger.error('Error setting default card:', error as Error);
    res.status(500).json({
      success: false,
      message: 'Failed to set default card',
      error: error instanceof Error ? error.message : 'Unknown error',
    });
  }
};

/**
 * Process payment (Mock implementation)
 * POST /api/v1/payment/process
 */
export const processPayment = async (req: Request, res: Response): Promise<void> => {
  try {
    const { amount, method, cardId } = req.body;

    // Mock payment processing
    // In production, integrate with Stripe, PayPal, etc.
    
    const transactionId = `TXN${Date.now()}${Math.floor(Math.random() * 1000)}`;

    Logger.info(`Payment processed: ${transactionId} - Amount: $${amount}`);

    res.status(200).json({
      success: true,
      message: 'Payment processed successfully',
      data: {
        transactionId,
        amount,
        method,
        status: 'completed',
        processedAt: new Date(),
      },
    });
  } catch (error) {
    Logger.error('Error processing payment:', error as Error);
    res.status(500).json({
      success: false,
      message: 'Payment processing failed',
      error: error instanceof Error ? error.message : 'Unknown error',
    });
  }
};

