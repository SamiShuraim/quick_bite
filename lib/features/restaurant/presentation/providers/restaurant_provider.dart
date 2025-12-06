/// Restaurant provider for QuickBite application
/// Manages restaurant state and data
library;

import 'package:flutter/foundation.dart';
import '../../domain/entities/restaurant_entity.dart';
import '../../domain/entities/menu_item_entity.dart';
import '../../data/repositories/restaurant_repository_impl.dart';
import '../../../../core/utils/app_logger.dart';

class RestaurantProvider with ChangeNotifier {
  final RestaurantRepository repository;

  List<RestaurantEntity> _restaurants = [];
  List<RestaurantEntity> _filteredRestaurants = [];
  final List<MenuItemEntity> _menuItems = [];
  RestaurantEntity? _selectedRestaurant;
  bool _isLoading = false;
  String? _errorMessage;
  String _selectedCategory = 'All';
  String _searchQuery = '';
  
  // Filter state
  double _minPrice = 0;
  double _maxPrice = 100;
  double _maxDistance = 20;
  Set<String> _selectedPaymentMethods = {};
  Set<String> _selectedFilters = {};

  List<RestaurantEntity> get restaurants => _filteredRestaurants;
  List<MenuItemEntity> get menuItems => _menuItems;
  RestaurantEntity? get selectedRestaurant => _selectedRestaurant;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  double get minPrice => _minPrice;
  double get maxPrice => _maxPrice;
  double get maxDistance => _maxDistance;
  Set<String> get selectedPaymentMethods => _selectedPaymentMethods;
  Set<String> get selectedFilters => _selectedFilters;

  List<String> get categories => [
        'All',
        'Burger',
        'Pizza',
        'Asian',
        'Mexican',
        'Italian',
        'Dessert',
        'Drinks',
      ];

  RestaurantProvider({required this.repository}) {
    _loadRestaurants();
  }

  Future<void> _loadRestaurants() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _restaurants = await repository.getRestaurants();
      _filteredRestaurants = _restaurants;
      _isLoading = false;
      _errorMessage = null;
      AppLogger.info('Loaded ${_restaurants.length} restaurants');
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load restaurants. Please try again.';
      AppLogger.error('Error loading restaurants', error: e);
      
      // Load dummy data as fallback
      _loadFallbackData();
      notifyListeners();
    }
  }

  void _loadFallbackData() {
    AppLogger.info('Loading fallback dummy data');
    _restaurants = _getDummyRestaurants();
    _filteredRestaurants = _restaurants;
  }

  List<RestaurantEntity> _getDummyRestaurants() {
    return [
      const RestaurantEntity(
        id: '1',
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
        hasVegetarianOptions: true,
        address: '123 Main St, Downtown',
        distance: 1.2,
      ),
      const RestaurantEntity(
        id: '2',
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
        hasVegetarianOptions: true,
        address: '456 Oak Ave, Midtown',
        distance: 2.5,
      ),
      const RestaurantEntity(
        id: '3',
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
        hasVegetarianOptions: true,
        address: '789 Burger Lane',
        distance: 0.8,
      ),
      const RestaurantEntity(
        id: '4',
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
        hasVegetarianOptions: true,
        address: '321 Pizza Plaza',
        distance: 3.2,
      ),
      const RestaurantEntity(
        id: '5',
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
        hasVegetarianOptions: true,
        address: '654 Taco Street',
        distance: 1.8,
      ),
      const RestaurantEntity(
        id: '6',
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
        hasVegetarianOptions: true,
        address: '987 Sushi Ave',
        distance: 4.1,
      ),
    ];
  }

  Future<List<MenuItemEntity>> getMenuItemsForRestaurant(String restaurantId) async {
    try {
      AppLogger.info('Fetching menu items for restaurant: $restaurantId');
      final menuItems = await repository.getMenuItems(restaurantId: restaurantId);
      AppLogger.info('Loaded ${menuItems.length} menu items');
      return menuItems;
    } catch (e) {
      AppLogger.error('Error loading menu items', error: e);
      // Return dummy data as fallback
      return _getDummyMenuItems(restaurantId);
    }
  }

  Future<RestaurantEntity> getRestaurantById(String restaurantId) async {
    try {
      AppLogger.info('Fetching restaurant by ID: $restaurantId');
      final restaurant = await repository.getRestaurantById(restaurantId);
      AppLogger.info('Loaded restaurant: ${restaurant.name}');
      return restaurant;
    } catch (e) {
      AppLogger.error('Error loading restaurant by ID', error: e);
      rethrow;
    }
  }

  Future<MenuItemEntity> getMenuItemById(String menuItemId) async {
    try {
      AppLogger.info('Fetching menu item by ID: $menuItemId');
      final menuItem = await repository.getMenuItemById(menuItemId);
      AppLogger.info('Loaded menu item: ${menuItem.name}');
      return menuItem;
    } catch (e) {
      AppLogger.error('Error loading menu item by ID', error: e);
      rethrow;
    }
  }

  List<MenuItemEntity> _getDummyMenuItems(String restaurantId) {
    // Burger items
    if (restaurantId == '3') {
      return [
        MenuItemEntity(
          id: 'b1',
          restaurantId: '3',
          name: 'Classic Burger',
          description: 'Juicy beef patty with lettuce, tomato, onion, and special sauce',
          imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=800',
          price: 12.99,
          category: 'Burgers',
          rating: 4.8,
          reviewCount: 89,
          isPopular: true,
          isVegetarian: false,
          ingredients: const ['Beef Patty', 'Lettuce', 'Tomato', 'Onion', 'Special Sauce', 'Brioche Bun'],
          customizations: const [
            CustomizationOption(
              id: 'size',
              name: 'Size',
              isRequired: true,
              choices: [
                CustomizationChoice(id: 'regular', name: 'Regular', additionalPrice: 0),
                CustomizationChoice(id: 'large', name: 'Large', additionalPrice: 2.99),
              ],
            ),
            CustomizationOption(
              id: 'cheese',
              name: 'Cheese',
              isRequired: false,
              maxSelections: 2,
              choices: [
                CustomizationChoice(id: 'cheddar', name: 'Cheddar', additionalPrice: 1.50),
                CustomizationChoice(id: 'swiss', name: 'Swiss', additionalPrice: 1.50),
                CustomizationChoice(id: 'blue', name: 'Blue Cheese', additionalPrice: 2.00),
              ],
            ),
            CustomizationOption(
              id: 'extras',
              name: 'Extras',
              isRequired: false,
              maxSelections: 5,
              choices: [
                CustomizationChoice(id: 'bacon', name: 'Bacon', additionalPrice: 2.50),
                CustomizationChoice(id: 'avocado', name: 'Avocado', additionalPrice: 2.00),
                CustomizationChoice(id: 'egg', name: 'Fried Egg', additionalPrice: 1.50),
                CustomizationChoice(id: 'mushroom', name: 'Mushrooms', additionalPrice: 1.50),
              ],
            ),
          ],
        ),
        MenuItemEntity(
          id: 'b2',
          restaurantId: '3',
          name: 'BBQ Bacon Burger',
          description: 'Smoky BBQ sauce, crispy bacon, and cheddar cheese',
          imageUrl: 'https://images.unsplash.com/photo-1553979459-d2229ba7433b?w=800',
          price: 15.99,
          category: 'Burgers',
          rating: 4.9,
          reviewCount: 124,
          isPopular: true,
          isVegetarian: false,
          ingredients: const ['Beef Patty', 'BBQ Sauce', 'Bacon', 'Cheddar', 'Onion Rings'],
          customizations: const [
            CustomizationOption(
              id: 'size',
              name: 'Size',
              isRequired: true,
              choices: [
                CustomizationChoice(id: 'regular', name: 'Regular', additionalPrice: 0),
                CustomizationChoice(id: 'large', name: 'Large', additionalPrice: 2.99),
              ],
            ),
          ],
        ),
        const MenuItemEntity(
          id: 'b3',
          restaurantId: '3',
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
        ),
        const MenuItemEntity(
          id: 'b4',
          restaurantId: '3',
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
        ),
      ];
    }

    // Pizza items
    if (restaurantId == '4') {
      return [
        MenuItemEntity(
          id: 'p1',
          restaurantId: '4',
          name: 'Margherita Pizza',
          description: 'Classic pizza with tomato sauce, mozzarella, and basil',
          imageUrl: 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=800',
          price: 14.99,
          category: 'Pizza',
          rating: 4.8,
          reviewCount: 156,
          isPopular: true,
          isVegetarian: true,
          ingredients: const ['Tomato Sauce', 'Mozzarella', 'Fresh Basil', 'Olive Oil'],
          customizations: const [
            CustomizationOption(
              id: 'size',
              name: 'Size',
              isRequired: true,
              choices: [
                CustomizationChoice(id: 'small', name: 'Small (10")', additionalPrice: 0),
                CustomizationChoice(id: 'medium', name: 'Medium (12")', additionalPrice: 3.00),
                CustomizationChoice(id: 'large', name: 'Large (14")', additionalPrice: 6.00),
              ],
            ),
            CustomizationOption(
              id: 'crust',
              name: 'Crust',
              isRequired: true,
              choices: [
                CustomizationChoice(id: 'thin', name: 'Thin Crust', additionalPrice: 0),
                CustomizationChoice(id: 'thick', name: 'Thick Crust', additionalPrice: 1.50),
                CustomizationChoice(id: 'stuffed', name: 'Stuffed Crust', additionalPrice: 3.00),
              ],
            ),
          ],
        ),
        const MenuItemEntity(
          id: 'p2',
          restaurantId: '4',
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
        ),
      ];
    }

    // Default items for other restaurants
    return [
      MenuItemEntity(
        id: 'm1',
        restaurantId: restaurantId,
        name: 'House Special',
        description: 'Our signature dish made with premium ingredients',
        imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800',
        price: 18.99,
        category: 'Main Course',
        rating: 4.7,
        reviewCount: 85,
        isPopular: true,
        isVegetarian: false,
        ingredients: const ['Fresh Ingredients', 'Special Sauce'],
        customizations: const [],
      ),
      MenuItemEntity(
        id: 'm2',
        restaurantId: restaurantId,
        name: 'Appetizer Platter',
        description: 'A variety of delicious starters',
        imageUrl: 'https://images.unsplash.com/photo-1541529086526-db283c563270?w=800',
        price: 12.99,
        category: 'Appetizer',
        rating: 4.5,
        reviewCount: 62,
        isPopular: false,
        isVegetarian: true,
        ingredients: const ['Various Appetizers'],
        customizations: const [],
      ),
    ];
  }

  void setCategory(String category) {
    AppLogger.userAction('Category Selected', details: {'category': category});
    _selectedCategory = category;
    _applyFilters();
  }

  void setSearchQuery(String query) {
    AppLogger.userAction('Search Query', details: {'query': query});
    _searchQuery = query;
    _applyFilters();
  }

  void _applyFilters() {
    _filteredRestaurants = _restaurants.where((restaurant) {
      // Category filter
      final matchesCategory = _selectedCategory == 'All' ||
          restaurant.categories.contains(_selectedCategory);
      
      // Search filter
      final matchesSearch = _searchQuery.isEmpty ||
          restaurant.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          restaurant.description.toLowerCase().contains(_searchQuery.toLowerCase());
      
      // Price range filter - check if restaurant's delivery fee is within range
      // (In a real app, you might filter by average menu item price)
      final matchesPriceRange = restaurant.deliveryFee >= _minPrice && 
                                 restaurant.deliveryFee <= _maxPrice;
      
      // Distance filter
      final matchesDistance = restaurant.distance <= _maxDistance;
      
      // Free delivery filter
      final matchesFreeDelivery = !_selectedFilters.contains('Free Delivery') ||
          restaurant.isFreeDelivery;
      
      // Popular filter
      final matchesPopular = !_selectedFilters.contains('Popular') ||
          restaurant.isPopular;
      
      // Top rated filter
      final matchesTopRated = !_selectedFilters.contains('Top Rated') ||
          restaurant.rating >= 4.5;
      
      // Fast delivery filter
      final matchesFastDelivery = !_selectedFilters.contains('Fast Delivery') ||
          restaurant.deliveryTime <= 25;
      
      // Vegetarian filter - now uses the hasVegetarianOptions field from backend
      final matchesVegetarian = !_selectedFilters.contains('Vegetarian') ||
          restaurant.hasVegetarianOptions;
      
      // Open now filter (assume all restaurants are open)
      final matchesOpenNow = !_selectedFilters.contains('Open Now') || true;
      
      return matchesCategory && 
             matchesSearch && 
             matchesPriceRange &&
             matchesDistance &&
             matchesFreeDelivery &&
             matchesPopular &&
             matchesTopRated &&
             matchesFastDelivery &&
             matchesVegetarian &&
             matchesOpenNow;
    }).toList();
    notifyListeners();
  }

  Future<void> refreshRestaurants() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _restaurants = await repository.getRestaurants(forceRefresh: true);
      _applyFilters();
      _isLoading = false;
      _errorMessage = null;
      AppLogger.info('Refreshed ${_restaurants.length} restaurants');
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to refresh restaurants. Please try again.';
      AppLogger.error('Error refreshing restaurants', error: e);
      notifyListeners();
    }
  }

  void selectRestaurant(RestaurantEntity restaurant) {
    _selectedRestaurant = restaurant;
    AppLogger.userAction('Restaurant Selected', details: {'restaurantId': restaurant.id, 'name': restaurant.name});
    notifyListeners();
  }

  void clearSelectedRestaurant() {
    _selectedRestaurant = null;
    notifyListeners();
  }
  
  void applyAdvancedFilters({
    required double minPrice,
    required double maxPrice,
    required double maxDistance,
    required Set<String> paymentMethods,
    required Set<String> filters,
  }) {
    AppLogger.userAction('Advanced Filters Applied', details: {
      'minPrice': minPrice,
      'maxPrice': maxPrice,
      'maxDistance': maxDistance,
      'paymentMethods': paymentMethods.toList(),
      'filters': filters.toList(),
    });
    
    _minPrice = minPrice;
    _maxPrice = maxPrice;
    _maxDistance = maxDistance;
    _selectedPaymentMethods = paymentMethods;
    _selectedFilters = filters;
    
    _applyFilters();
  }
  
  void resetFilters() {
    AppLogger.userAction('Filters Reset');
    _minPrice = 0;
    _maxPrice = 100;
    _maxDistance = 20;
    _selectedPaymentMethods = {};
    _selectedFilters = {};
    _applyFilters();
  }
}

