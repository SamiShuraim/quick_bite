/// Restaurant repository implementation
library;

import '../../domain/entities/restaurant_entity.dart';
import '../../domain/entities/menu_item_entity.dart';
import '../../../../core/utils/app_logger.dart';
import '../datasources/restaurant_remote_datasource.dart';
import '../datasources/restaurant_local_datasource.dart';

abstract class RestaurantRepository {
  Future<List<RestaurantEntity>> getRestaurants({
    String? category,
    String? search,
    double? minRating,
    double? maxDistance,
    bool forceRefresh = false,
  });

  Future<RestaurantEntity> getRestaurantById(String id);

  Future<List<MenuItemEntity>> getMenuItems({
    required String restaurantId,
    String? category,
    bool forceRefresh = false,
  });

  Future<MenuItemEntity> getMenuItemById(String id);
}

class RestaurantRepositoryImpl implements RestaurantRepository {
  final RestaurantRemoteDataSource remoteDataSource;
  final RestaurantLocalDataSource localDataSource;

  RestaurantRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<RestaurantEntity>> getRestaurants({
    String? category,
    String? search,
    double? minRating,
    double? maxDistance,
    bool forceRefresh = false,
  }) async {
    try {
      // If no filters and not forcing refresh, try cache first
      if (!forceRefresh &&
          category == null &&
          search == null &&
          minRating == null &&
          maxDistance == null) {
        final cachedRestaurants = await localDataSource.getCachedRestaurants();
        
        if (cachedRestaurants.isNotEmpty) {
          AppLogger.info('Returning ${cachedRestaurants.length} restaurants from cache');
          return cachedRestaurants;
        }
      }

      // Fetch from API
      AppLogger.info('Fetching restaurants from API');
      final restaurants = await remoteDataSource.getRestaurants(
        category: category,
        search: search,
        minRating: minRating,
        maxDistance: maxDistance,
      );

      // Cache only if no filters (full list)
      if (category == null &&
          search == null &&
          minRating == null &&
          maxDistance == null) {
        await localDataSource.cacheRestaurants(restaurants);
      }

      return restaurants;
    } catch (e) {
      AppLogger.error('Error in getRestaurants', error: e);
      
      // Try to return cached data as fallback
      try {
        final cachedRestaurants = await localDataSource.getCachedRestaurants();
        if (cachedRestaurants.isNotEmpty) {
          AppLogger.info('Returning cached restaurants as fallback');
          return cachedRestaurants;
        }
      } catch (cacheError) {
        AppLogger.error('Error loading cache fallback', error: cacheError);
      }
      
      rethrow;
    }
  }

  @override
  Future<RestaurantEntity> getRestaurantById(String id) async {
    try {
      AppLogger.info('Fetching restaurant by ID: $id');
      final restaurant = await remoteDataSource.getRestaurantById(id);
      return restaurant;
    } catch (e) {
      AppLogger.error('Error in getRestaurantById', error: e);
      rethrow;
    }
  }

  @override
  Future<List<MenuItemEntity>> getMenuItems({
    required String restaurantId,
    String? category,
    bool forceRefresh = false,
  }) async {
    try {
      // If no category filter and not forcing refresh, try cache first
      if (!forceRefresh && category == null) {
        final cachedMenuItems = await localDataSource.getCachedMenuItems(restaurantId);
        
        if (cachedMenuItems.isNotEmpty) {
          AppLogger.info('Returning ${cachedMenuItems.length} menu items from cache');
          return cachedMenuItems;
        }
      }

      // Fetch from API
      AppLogger.info('Fetching menu items from API for restaurant: $restaurantId');
      final menuItems = await remoteDataSource.getMenuItems(
        restaurantId: restaurantId,
        category: category,
      );

      // Cache only if no category filter (full list)
      if (category == null) {
        await localDataSource.cacheMenuItems(restaurantId, menuItems);
      }

      return menuItems;
    } catch (e) {
      AppLogger.error('Error in getMenuItems', error: e);
      
      // Try to return cached data as fallback
      try {
        final cachedMenuItems = await localDataSource.getCachedMenuItems(restaurantId);
        if (cachedMenuItems.isNotEmpty) {
          AppLogger.info('Returning cached menu items as fallback');
          return cachedMenuItems;
        }
      } catch (cacheError) {
        AppLogger.error('Error loading cache fallback', error: cacheError);
      }
      
      rethrow;
    }
  }

  @override
  Future<MenuItemEntity> getMenuItemById(String id) async {
    try {
      AppLogger.info('Fetching menu item by ID: $id');
      final menuItem = await remoteDataSource.getMenuItemById(id);
      return menuItem;
    } catch (e) {
      AppLogger.error('Error in getMenuItemById', error: e);
      rethrow;
    }
  }
}

