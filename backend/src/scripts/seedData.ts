/**
 * Seed Database Script
 * Populates database with dummy restaurants and menu items
 */

import mongoose from 'mongoose';
import { config } from '../config/environment';
import Restaurant from '../models/Restaurant';
import MenuItem from '../models/MenuItem';
import logger from '../utils/logger';

const restaurants = [
  {
    name: 'Spicy Restaurant',
    description: 'Maecenas sed diam eget risus varius blandit sit amet non magna',
    imageUrl: 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800',
    rating: 4.7,
    reviewCount: 124,
    deliveryTime: 20,
    deliveryFee: 0,
    categories: ['Asian', 'Spicy'],
    isFreeDelivery: true,
    isPopular: true,
    address: '123 Main St, Downtown',
    distance: 1.2,
  },
  {
    name: 'Rose Garden Restaurant',
    description: 'Fresh ingredients and authentic flavors',
    imageUrl: 'https://images.unsplash.com/photo-1552566626-52f8b828add9?w=800',
    rating: 4.3,
    reviewCount: 89,
    deliveryTime: 25,
    deliveryFee: 2.99,
    categories: ['Italian', 'Fine Dining'],
    isFreeDelivery: false,
    isPopular: false,
    address: '456 Oak Ave, Midtown',
    distance: 2.5,
  },
  {
    name: 'Burger Bliss',
    description: 'The best burgers in town with premium ingredients',
    imageUrl: 'https://images.unsplash.com/photo-1550547660-d9450f859349?w=800',
    rating: 4.8,
    reviewCount: 256,
    deliveryTime: 15,
    deliveryFee: 0,
    categories: ['Burger', 'Fast Food'],
    isFreeDelivery: true,
    isPopular: true,
    address: '789 Burger Lane',
    distance: 0.8,
  },
  {
    name: 'Pizza Palace',
    description: 'Wood-fired pizzas made with love',
    imageUrl: 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800',
    rating: 4.6,
    reviewCount: 178,
    deliveryTime: 30,
    deliveryFee: 1.99,
    categories: ['Pizza', 'Italian'],
    isFreeDelivery: false,
    isPopular: true,
    address: '321 Pizza Plaza',
    distance: 3.2,
  },
  {
    name: 'Taco Fiesta',
    description: 'Authentic Mexican street food',
    imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=800',
    rating: 4.5,
    reviewCount: 142,
    deliveryTime: 20,
    deliveryFee: 0,
    categories: ['Mexican', 'Tacos'],
    isFreeDelivery: true,
    isPopular: false,
    address: '654 Taco Street',
    distance: 1.8,
  },
  {
    name: 'Sushi Master',
    description: 'Fresh sushi and Japanese cuisine',
    imageUrl: 'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=800',
    rating: 4.9,
    reviewCount: 312,
    deliveryTime: 35,
    deliveryFee: 3.99,
    categories: ['Asian', 'Japanese'],
    isFreeDelivery: false,
    isPopular: true,
    address: '987 Sushi Ave',
    distance: 4.1,
  },
];

const seedDatabase = async () => {
  try {
    // Connect to MongoDB
    await mongoose.connect(config.database.uri);
    logger.info('Connected to MongoDB');

    // Clear existing data
    await Restaurant.deleteMany({});
    await MenuItem.deleteMany({});
    logger.info('Cleared existing data');

    // Insert restaurants
    const createdRestaurants = await Restaurant.insertMany(restaurants);
    logger.info(`Created ${createdRestaurants.length} restaurants`);

    // Create menu items for Burger Bliss
    const burgerBliss = createdRestaurants.find((r) => r.name === 'Burger Bliss');
    if (burgerBliss) {
      const burgerMenuItems = [
        {
          restaurantId: (burgerBliss._id as any).toString(),
          name: 'Classic Burger',
          description: 'Juicy beef patty with lettuce, tomato, onion, and special sauce',
          imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=800',
          price: 12.99,
          category: 'Burgers',
          rating: 4.8,
          reviewCount: 89,
          isPopular: true,
          isVegetarian: false,
          ingredients: ['Beef Patty', 'Lettuce', 'Tomato', 'Onion', 'Special Sauce', 'Brioche Bun'],
          customizations: [
            {
              id: 'size',
              name: 'Size',
              isRequired: true,
              maxSelections: 1,
              choices: [
                { id: 'regular', name: 'Regular', additionalPrice: 0 },
                { id: 'large', name: 'Large', additionalPrice: 2.99 },
              ],
            },
            {
              id: 'cheese',
              name: 'Cheese',
              isRequired: false,
              maxSelections: 2,
              choices: [
                { id: 'cheddar', name: 'Cheddar', additionalPrice: 1.5 },
                { id: 'swiss', name: 'Swiss', additionalPrice: 1.5 },
                { id: 'blue', name: 'Blue Cheese', additionalPrice: 2.0 },
              ],
            },
            {
              id: 'extras',
              name: 'Extras',
              isRequired: false,
              maxSelections: 5,
              choices: [
                { id: 'bacon', name: 'Bacon', additionalPrice: 2.5 },
                { id: 'avocado', name: 'Avocado', additionalPrice: 2.0 },
                { id: 'egg', name: 'Fried Egg', additionalPrice: 1.5 },
                { id: 'mushroom', name: 'Mushrooms', additionalPrice: 1.5 },
              ],
            },
          ],
        },
        {
          restaurantId: (burgerBliss._id as any).toString(),
          name: 'BBQ Bacon Burger',
          description: 'Smoky BBQ sauce, crispy bacon, and cheddar cheese',
          imageUrl: 'https://images.unsplash.com/photo-1553979459-d2229ba7433b?w=800',
          price: 15.99,
          category: 'Burgers',
          rating: 4.9,
          reviewCount: 124,
          isPopular: true,
          isVegetarian: false,
          ingredients: ['Beef Patty', 'BBQ Sauce', 'Bacon', 'Cheddar', 'Onion Rings'],
          customizations: [
            {
              id: 'size',
              name: 'Size',
              isRequired: true,
              maxSelections: 1,
              choices: [
                { id: 'regular', name: 'Regular', additionalPrice: 0 },
                { id: 'large', name: 'Large', additionalPrice: 2.99 },
              ],
            },
          ],
        },
        {
          restaurantId: (burgerBliss._id as any).toString(),
          name: 'Veggie Burger',
          description: 'Plant-based patty with fresh vegetables',
          imageUrl: 'https://images.unsplash.com/photo-1520072959219-c595dc870360?w=800',
          price: 11.99,
          category: 'Burgers',
          rating: 4.5,
          reviewCount: 67,
          isPopular: false,
          isVegetarian: true,
          ingredients: ['Veggie Patty', 'Lettuce', 'Tomato', 'Avocado', 'Whole Wheat Bun'],
          customizations: [],
        },
        {
          restaurantId: (burgerBliss._id as any).toString(),
          name: 'Chicken Burger',
          description: 'Crispy chicken breast with mayo and pickles',
          imageUrl: 'https://images.unsplash.com/photo-1606755962773-d324e0a13086?w=800',
          price: 13.99,
          category: 'Burgers',
          rating: 4.7,
          reviewCount: 98,
          isPopular: true,
          isVegetarian: false,
          ingredients: ['Chicken Breast', 'Mayo', 'Pickles', 'Lettuce'],
          customizations: [],
        },
      ];

      await MenuItem.insertMany(burgerMenuItems);
      logger.info(`Created ${burgerMenuItems.length} menu items for Burger Bliss`);
    }

    // Create menu items for Pizza Palace
    const pizzaPalace = createdRestaurants.find((r) => r.name === 'Pizza Palace');
    if (pizzaPalace) {
      const pizzaMenuItems = [
        {
          restaurantId: (pizzaPalace._id as any).toString(),
          name: 'Margherita Pizza',
          description: 'Classic pizza with tomato sauce, mozzarella, and basil',
          imageUrl: 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=800',
          price: 14.99,
          category: 'Pizza',
          rating: 4.8,
          reviewCount: 156,
          isPopular: true,
          isVegetarian: true,
          ingredients: ['Tomato Sauce', 'Mozzarella', 'Fresh Basil', 'Olive Oil'],
          customizations: [
            {
              id: 'size',
              name: 'Size',
              isRequired: true,
              maxSelections: 1,
              choices: [
                { id: 'small', name: 'Small (10")', additionalPrice: 0 },
                { id: 'medium', name: 'Medium (12")', additionalPrice: 3.0 },
                { id: 'large', name: 'Large (14")', additionalPrice: 6.0 },
              ],
            },
            {
              id: 'crust',
              name: 'Crust',
              isRequired: true,
              maxSelections: 1,
              choices: [
                { id: 'thin', name: 'Thin Crust', additionalPrice: 0 },
                { id: 'thick', name: 'Thick Crust', additionalPrice: 1.5 },
                { id: 'stuffed', name: 'Stuffed Crust', additionalPrice: 3.0 },
              ],
            },
          ],
        },
        {
          restaurantId: (pizzaPalace._id as any).toString(),
          name: 'Pepperoni Pizza',
          description: 'Loaded with pepperoni and extra cheese',
          imageUrl: 'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=800',
          price: 16.99,
          category: 'Pizza',
          rating: 4.9,
          reviewCount: 203,
          isPopular: true,
          isVegetarian: false,
          ingredients: ['Tomato Sauce', 'Mozzarella', 'Pepperoni'],
          customizations: [],
        },
      ];

      await MenuItem.insertMany(pizzaMenuItems);
      logger.info(`Created ${pizzaMenuItems.length} menu items for Pizza Palace`);
    }

    // Create generic menu items for other restaurants
    for (const restaurant of createdRestaurants) {
      if (restaurant.name !== 'Burger Bliss' && restaurant.name !== 'Pizza Palace') {
        const genericMenuItems = [
          {
            restaurantId: (restaurant._id as any).toString(),
            name: 'House Special',
            description: 'Our signature dish made with premium ingredients',
            imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800',
            price: 18.99,
            category: 'Main Course',
            rating: 4.7,
            reviewCount: 85,
            isPopular: true,
            isVegetarian: false,
            ingredients: ['Fresh Ingredients', 'Special Sauce'],
            customizations: [],
          },
          {
            restaurantId: (restaurant._id as any).toString(),
            name: 'Appetizer Platter',
            description: 'A variety of delicious starters',
            imageUrl: 'https://images.unsplash.com/photo-1541529086526-db283c563270?w=800',
            price: 12.99,
            category: 'Appetizer',
            rating: 4.5,
            reviewCount: 62,
            isPopular: false,
            isVegetarian: true,
            ingredients: ['Various Appetizers'],
            customizations: [],
          },
        ];

        await MenuItem.insertMany(genericMenuItems);
        logger.info(`Created ${genericMenuItems.length} menu items for ${restaurant.name}`);
      }
    }

    logger.info('Database seeded successfully!');
    process.exit(0);
  } catch (error) {
    logger.error('Error seeding database', { error });
    process.exit(1);
  }
};

// Run seed script
seedDatabase();

