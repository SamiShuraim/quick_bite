/**
 * Order Controller
 * Handle order-related operations
 */

import { Request, Response } from 'express';
import { Order, IOrder } from '../models/Order';
import mongoose from 'mongoose';
import { Logger } from '../utils/logger';

// Import models dynamically to avoid circular dependencies
const Restaurant = mongoose.model('Restaurant');
const MenuItem = mongoose.model('MenuItem');

/**
 * Create a new order
 * POST /api/v1/orders
 */
export const createOrder = async (req: Request, res: Response): Promise<void> => {
  try {
    const userId = req.user?.userId; // From auth middleware
    
    const {
      restaurantId,
      items,
      deliveryAddress,
      paymentDetails,
      subtotal,
      deliveryFee,
      tax,
      total,
      specialInstructions,
    } = req.body;

    // Validate restaurant exists
    const restaurant = await Restaurant.findById(restaurantId);
    if (!restaurant) {
      res.status(404).json({
        success: false,
        message: 'Restaurant not found',
      });
      return;
    }

    // Validate menu items exist and prices match
    for (const item of items) {
      const menuItem = await MenuItem.findById(item.menuItemId);
      if (!menuItem) {
        res.status(404).json({
          success: false,
          message: `Menu item ${item.name} not found`,
        });
        return;
      }
    }

    // Calculate estimated delivery time (30-45 minutes from now)
    const estimatedDeliveryTime = new Date();
    estimatedDeliveryTime.setMinutes(
      estimatedDeliveryTime.getMinutes() + 30 + Math.floor(Math.random() * 15)
    );

    // Create order
    const order = await Order.create({
      userId,
      restaurantId,
      restaurantName: restaurant.name,
      items,
      deliveryAddress,
      paymentDetails: {
        ...paymentDetails,
        paymentStatus: paymentDetails.method === 'cash' ? 'pending' : 'completed',
        paidAt: paymentDetails.method !== 'cash' ? new Date() : undefined,
      },
      subtotal,
      deliveryFee,
      tax,
      total,
      status: 'pending',
      estimatedDeliveryTime,
      specialInstructions,
    });

    Logger.info(`Order created: ${order.orderNumber} for user: ${userId}`);

    res.status(201).json({
      success: true,
      message: 'Order placed successfully',
      data: {
        order: {
          _id: order._id,
          orderNumber: order.orderNumber,
          restaurantName: order.restaurantName,
          total: order.total,
          status: order.status,
          estimatedDeliveryTime: order.estimatedDeliveryTime,
          createdAt: order.createdAt,
        },
      },
    });
  } catch (error) {
    Logger.error('Error creating order:', error as Error);
    res.status(500).json({
      success: false,
      message: 'Failed to create order',
      error: error instanceof Error ? error.message : 'Unknown error',
    });
  }
};

/**
 * Get all orders for the authenticated user
 * GET /api/v1/orders
 */
export const getUserOrders = async (req: Request, res: Response): Promise<void> => {
  try {
    const userId = req.user?.userId;
    const { status, page = '1', limit = '10' } = req.query;

    const query: any = { userId };
    if (status) {
      query.status = status;
    }

    const pageNum = parseInt(page as string);
    const limitNum = parseInt(limit as string);
    const skip = (pageNum - 1) * limitNum;

    const orders = await Order.find(query)
      .sort({ createdAt: -1 })
      .skip(skip)
      .limit(limitNum)
      .select('-__v');

    const total = await Order.countDocuments(query);

    res.status(200).json({
      success: true,
      data: {
        orders,
        pagination: {
          total,
          page: pageNum,
          limit: limitNum,
          totalPages: Math.ceil(total / limitNum),
        },
      },
    });
  } catch (error) {
    Logger.error('Error fetching user orders:', error as Error);
    res.status(500).json({
      success: false,
      message: 'Failed to fetch orders',
      error: error instanceof Error ? error.message : 'Unknown error',
    });
  }
};

/**
 * Get order by ID
 * GET /api/v1/orders/:id
 */
export const getOrderById = async (req: Request, res: Response): Promise<void> => {
  try {
    const userId = req.user?.userId;
    const { id } = req.params;

    const order = await Order.findOne({ _id: id, userId }).select('-__v');

    if (!order) {
      res.status(404).json({
        success: false,
        message: 'Order not found',
      });
      return;
    }

    res.status(200).json({
      success: true,
      data: { order },
    });
  } catch (error) {
    Logger.error('Error fetching order:', error as Error);
    res.status(500).json({
      success: false,
      message: 'Failed to fetch order',
      error: error instanceof Error ? error.message : 'Unknown error',
    });
  }
};

/**
 * Cancel order
 * PATCH /api/v1/orders/:id/cancel
 */
export const cancelOrder = async (req: Request, res: Response): Promise<void> => {
  try {
    const userId = req.user?.userId;
    const { id } = req.params;

    const order = await Order.findOne({ _id: id, userId });

    if (!order) {
      res.status(404).json({
        success: false,
        message: 'Order not found',
      });
      return;
    }

    // Can only cancel pending or confirmed orders
    if (!['pending', 'confirmed'].includes(order.status)) {
      res.status(400).json({
        success: false,
        message: 'Cannot cancel order in current status',
      });
      return;
    }

    order.status = 'cancelled';
    await order.save();

    Logger.info(`Order cancelled: ${order.orderNumber}`);

    res.status(200).json({
      success: true,
      message: 'Order cancelled successfully',
      data: { order },
    });
  } catch (error) {
    Logger.error('Error cancelling order:', error as Error);
    res.status(500).json({
      success: false,
      message: 'Failed to cancel order',
      error: error instanceof Error ? error.message : 'Unknown error',
    });
  }
};

/**
 * Update order status (Admin/Restaurant)
 * PATCH /api/v1/orders/:id/status
 */
export const updateOrderStatus = async (req: Request, res: Response): Promise<void> => {
  try {
    const { id } = req.params;
    const { status } = req.body;

    const validStatuses = ['pending', 'confirmed', 'preparing', 'on_the_way', 'delivered', 'cancelled'];
    
    if (!validStatuses.includes(status)) {
      res.status(400).json({
        success: false,
        message: 'Invalid status',
      });
      return;
    }

    const order = await Order.findById(id);

    if (!order) {
      res.status(404).json({
        success: false,
        message: 'Order not found',
      });
      return;
    }

    order.status = status;
    
    // Update payment status if delivered
    if (status === 'delivered' && order.paymentDetails.method === 'cash') {
      order.paymentDetails.paymentStatus = 'completed';
      order.paymentDetails.paidAt = new Date();
    }
    
    await order.save();

    Logger.info(`Order status updated: ${order.orderNumber} -> ${status}`);

    res.status(200).json({
      success: true,
      message: 'Order status updated',
      data: { order },
    });
  } catch (error) {
    Logger.error('Error updating order status:', error as Error);
    res.status(500).json({
      success: false,
      message: 'Failed to update order status',
      error: error instanceof Error ? error.message : 'Unknown error',
    });
  }
};

