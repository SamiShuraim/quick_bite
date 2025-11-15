/**
 * Restaurant Routes
 * API endpoints for restaurant operations
 */

import express from 'express';
import {
  getRestaurants,
  getRestaurantById,
  getMenuItems,
  getMenuItemById,
  createRestaurant,
  createMenuItem,
} from '../controllers/restaurantController';

const router = express.Router();

// Public routes
router.get('/restaurants', getRestaurants);
router.get('/restaurants/:id', getRestaurantById);
router.get('/restaurants/:restaurantId/menu', getMenuItems);
router.get('/menu-items/:id', getMenuItemById);

// Admin routes (for seeding data)
router.post('/restaurants', createRestaurant);
router.post('/menu-items', createMenuItem);

export default router;

