/**
 * Payment Routes
 * Define routes for payment and card operations
 */

import { Router } from 'express';
import {
  getSavedCards,
  addSavedCard,
  deleteSavedCard,
  setDefaultCard,
  processPayment,
} from '../controllers/paymentController';
import { authenticate } from '../middleware/auth';

const router = Router();

// All routes require authentication
router.use(authenticate);

// Payment routes
router.post('/payment/process', processPayment);

// Saved cards routes
router.get('/payment/cards', getSavedCards);
router.post('/payment/cards', addSavedCard);
router.delete('/payment/cards/:id', deleteSavedCard);
router.patch('/payment/cards/:id/default', setDefaultCard);

export default router;

