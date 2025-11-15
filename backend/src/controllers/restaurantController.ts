/**
 * Restaurant Controller
 * Handles restaurant-related requests
 */

import { Request, Response, NextFunction } from 'express';
import Restaurant from '../models/Restaurant';
import MenuItem from '../models/MenuItem';
import { ApiError } from '../utils/errors';
import logger from '../utils/logger';

/**
 * Get all restaurants
 */
export const getRestaurants = async (
  req: Request,
  res: Response,
  next: NextFunction
): Promise<void> => {
  try {
    const { category, search, minRating, maxDistance } = req.query;

    // Build query
    const query: any = {};

    if (category && category !== 'All') {
      query.categories = category;
    }

    if (search) {
      query.$text = { $search: search as string };
    }

    if (minRating) {
      query.rating = { $gte: parseFloat(minRating as string) };
    }

    if (maxDistance) {
      query.distance = { $lte: parseFloat(maxDistance as string) };
    }

    const restaurants = await Restaurant.find(query).sort({ rating: -1 });

    logger.info('Restaurants retrieved', {
      count: restaurants.length,
      query,
    });

    res.status(200).json({
      success: true,
      count: restaurants.length,
      data: restaurants,
    });
  } catch (error) {
    logger.error('Error getting restaurants', { error });
    next(error);
  }
};

/**
 * Get restaurant by ID
 */
export const getRestaurantById = async (
  req: Request,
  res: Response,
  next: NextFunction
): Promise<void> => {
  try {
    const { id } = req.params;

    const restaurant = await Restaurant.findById(id);

    if (!restaurant) {
      throw new ApiError('Restaurant not found', 404);
    }

    logger.info('Restaurant retrieved', { restaurantId: id });

    res.status(200).json({
      success: true,
      data: restaurant,
    });
  } catch (error) {
    logger.error('Error getting restaurant', { error });
    next(error);
  }
};

/**
 * Get menu items for a restaurant
 */
export const getMenuItems = async (
  req: Request,
  res: Response,
  next: NextFunction
): Promise<void> => {
  try {
    const { restaurantId } = req.params;
    const { category } = req.query;

    // Build query
    const query: any = { restaurantId };

    if (category && category !== 'All') {
      query.category = category;
    }

    const menuItems = await MenuItem.find(query).sort({ isPopular: -1, rating: -1 });

    logger.info('Menu items retrieved', {
      restaurantId,
      count: menuItems.length,
    });

    res.status(200).json({
      success: true,
      count: menuItems.length,
      data: menuItems,
    });
  } catch (error) {
    logger.error('Error getting menu items', { error });
    next(error);
  }
};

/**
 * Get menu item by ID
 */
export const getMenuItemById = async (
  req: Request,
  res: Response,
  next: NextFunction
): Promise<void> => {
  try {
    const { id } = req.params;

    const menuItem = await MenuItem.findById(id);

    if (!menuItem) {
      throw new ApiError('Menu item not found', 404);
    }

    logger.info('Menu item retrieved', { menuItemId: id });

    res.status(200).json({
      success: true,
      data: menuItem,
    });
  } catch (error) {
    logger.error('Error getting menu item', { error });
    next(error);
  }
};

/**
 * Create restaurant (admin only - for seeding)
 */
export const createRestaurant = async (
  req: Request,
  res: Response,
  next: NextFunction
): Promise<void> => {
  try {
    const restaurant = await Restaurant.create(req.body);

    logger.info('Restaurant created', { restaurantId: restaurant._id });

    res.status(201).json({
      success: true,
      data: restaurant,
    });
  } catch (error) {
    logger.error('Error creating restaurant', { error });
    next(error);
  }
};

/**
 * Create menu item (admin only - for seeding)
 */
export const createMenuItem = async (
  req: Request,
  res: Response,
  next: NextFunction
): Promise<void> => {
  try {
    const menuItem = await MenuItem.create(req.body);

    logger.info('Menu item created', { menuItemId: menuItem._id });

    res.status(201).json({
      success: true,
      data: menuItem,
    });
  } catch (error) {
    logger.error('Error creating menu item', { error });
    next(error);
  }
};

