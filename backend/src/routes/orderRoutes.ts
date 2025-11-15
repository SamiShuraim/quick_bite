/**
 * Order Routes
 * Define routes for order operations
 */

import { Router } from 'express';
import {
  createOrder,
  getUserOrders,
  getOrderById,
  cancelOrder,
  updateOrderStatus,
} from '../controllers/orderController';
import { authenticate } from '../middleware/auth';

const router = Router();

// All routes require authentication
router.use(authenticate);

// Order routes
router.post('/orders', createOrder);
router.get('/orders', getUserOrders);
router.get('/orders/:id', getOrderById);
router.patch('/orders/:id/cancel', cancelOrder);
router.patch('/orders/:id/status', updateOrderStatus); // Admin/Restaurant

export default router;

