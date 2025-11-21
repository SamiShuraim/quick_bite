/**
 * Order Status Cron Service
 * Automatically updates order statuses to simulate real-life order progression
 */

import cron from 'node-cron';
import { Order } from '../models/Order';
import { Logger } from '../utils/logger';

// Saudi Arabian first names for drivers
const DRIVER_NAMES = [
  'Abdullah',
  'Mohammed',
  'Ahmed',
  'Khalid',
  'Fahd',
  'Faisal',
  'Omar',
  'Ali',
  'Hassan',
  'Ibrahim',
  'Yousef',
  'Majed',
  'Saud',
  'Nasser',
  'Saleh',
  'Turki',
  'Bandar',
  'Rayan',
  'Zaid',
  'Saad',
];

// Status transition times in minutes
// confirmed = preparing (restaurant is preparing the food)
const STATUS_TRANSITIONS = {
  pending: {
    nextStatus: 'confirmed', // Order confirmed, restaurant starts preparing
    minMinutes: 0,
    maxMinutes: 5,
  },
  confirmed: {
    nextStatus: 'on_the_way', // Food ready, driver picked up and delivering
    minMinutes: 10,
    maxMinutes: 30,
  },
  on_the_way: {
    nextStatus: 'arriving_soon', // Driver is close, arriving soon
    minMinutes: 10,
    maxMinutes: 30,
  },
  arriving_soon: {
    nextStatus: 'delivered', // Order delivered
    minMinutes: 2,
    maxMinutes: 5,
  },
};

/**
 * Get a random driver name
 */
function getRandomDriverName(): string {
  return DRIVER_NAMES[Math.floor(Math.random() * DRIVER_NAMES.length)];
}

/**
 * Check if order should transition to next status
 */
function shouldTransition(
  statusUpdatedAt: Date,
  minMinutes: number,
  maxMinutes: number
): boolean {
  const now = new Date();
  const minutesSinceUpdate = (now.getTime() - statusUpdatedAt.getTime()) / (1000 * 60);
  
  // Random chance to transition between min and max time
  if (minutesSinceUpdate < minMinutes) {
    return false;
  }
  
  if (minutesSinceUpdate > maxMinutes) {
    return true;
  }
  
  // Gradually increase probability as we approach max time
  const progressRatio = (minutesSinceUpdate - minMinutes) / (maxMinutes - minMinutes);
  const transitionChance = progressRatio * 0.5; // 50% max chance before hitting max time
  
  return Math.random() < transitionChance;
}

/**
 * Update order statuses
 */
async function updateOrderStatuses(): Promise<void> {
  try {
    // Find all active orders (not delivered or cancelled)
    const activeOrders = await Order.find({
      status: { $in: ['pending', 'confirmed', 'on_the_way', 'arriving_soon'] },
    });

    if (activeOrders.length === 0) {
      return;
    }

    Logger.info(`Processing ${activeOrders.length} active orders`);

    for (const order of activeOrders) {
      const currentStatus = order.status;
      const transition = STATUS_TRANSITIONS[currentStatus as keyof typeof STATUS_TRANSITIONS];

      if (!transition) {
        continue;
      }

      // Use statusUpdatedAt if available, otherwise use createdAt
      const lastUpdateTime = order.statusUpdatedAt || order.createdAt;

      if (shouldTransition(lastUpdateTime, transition.minMinutes, transition.maxMinutes)) {
        order.status = transition.nextStatus as any;
        order.statusUpdatedAt = new Date();

        // Assign driver when order goes out for delivery
        if (transition.nextStatus === 'on_the_way' && !order.driverName) {
          order.driverName = getRandomDriverName();
        }

        await order.save();

        Logger.info(
          `Order ${order.orderNumber} transitioned from ${currentStatus} to ${transition.nextStatus}` +
          (order.driverName ? ` - Driver: ${order.driverName}` : '')
        );
      }
    }
  } catch (error) {
    Logger.error('Error updating order statuses:', error as Error);
  }
}

/**
 * Start the cron job
 * Runs every 2 minutes
 */
export function startOrderStatusCron(): void {
  // Run every 2 minutes
  cron.schedule('*/2 * * * *', async () => {
    Logger.debug('Running order status update cron job');
    await updateOrderStatuses();
  });

  // Also run once on startup after a short delay
  setTimeout(() => {
    Logger.info('Running initial order status update');
    updateOrderStatuses();
  }, 5000); // 5 seconds after startup

  Logger.info('Order status cron job started - runs every 2 minutes');
}

/**
 * Manually trigger an order status update (for testing)
 */
export async function triggerOrderStatusUpdate(): Promise<void> {
  Logger.info('Manually triggered order status update');
  await updateOrderStatuses();
}

