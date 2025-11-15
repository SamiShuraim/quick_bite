/// Local data source for restaurant data caching
library;

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/utils/app_logger.dart';
import '../models/restaurant_model.dart';
import '../models/menu_item_model.dart';

abstract class RestaurantLocalDataSource {
  Future<List<RestaurantModel>> getCachedRestaurants();
  Future<void> cacheRestaurants(List<RestaurantModel> restaurants);
  Future<void> clearRestaurantsCache();
  
  Future<List<MenuItemModel>> getCachedMenuItems(String restaurantId);
  Future<void> cacheMenuItems(String restaurantId, List<MenuItemModel> menuItems);
  Future<void> clearMenuItemsCache(String restaurantId);
  
  bool isCacheValid(String key);
}

class RestaurantLocalDataSourceImpl implements RestaurantLocalDataSource {
  final SharedPreferences sharedPreferences;

  RestaurantLocalDataSourceImpl({required this.sharedPreferences});

  static const String _restaurantsCacheKey = 'cached_restaurants';
  static const String _restaurantsTimestampKey = 'restaurants_timestamp';
  static const String _menuItemsCachePrefix = 'cached_menu_items_';
  static const String _menuItemsTimestampPrefix = 'menu_items_timestamp_';

  @override
  Future<List<RestaurantModel>> getCachedRestaurants() async {
    try {
      final jsonString = sharedPreferences.getString(_restaurantsCacheKey);
      
      if (jsonString == null) {
        AppLogger.info('No cached restaurants found');
        return [];
      }

      if (!isCacheValid(_restaurantsTimestampKey)) {
        AppLogger.info('Restaurants cache expired');
        await clearRestaurantsCache();
        return [];
      }

      final List<dynamic> jsonList = json.decode(jsonString);
      final restaurants = jsonList.map((json) => RestaurantModel.fromJson(json)).toList();
      
      AppLogger.info('Loaded ${restaurants.length} restaurants from cache');
      return restaurants;
    } catch (e) {
      AppLogger.error('Error loading cached restaurants', error: e);
      return [];
    }
  }

  @override
  Future<void> cacheRestaurants(List<RestaurantModel> restaurants) async {
    try {
      final jsonString = json.encode(restaurants.map((r) => r.toJson()).toList());
      await sharedPreferences.setString(_restaurantsCacheKey, jsonString);
      await sharedPreferences.setInt(
        _restaurantsTimestampKey,
        DateTime.now().millisecondsSinceEpoch,
      );
      
      AppLogger.info('Cached ${restaurants.length} restaurants');
    } catch (e) {
      AppLogger.error('Error caching restaurants', error: e);
    }
  }

  @override
  Future<void> clearRestaurantsCache() async {
    try {
      await sharedPreferences.remove(_restaurantsCacheKey);
      await sharedPreferences.remove(_restaurantsTimestampKey);
      AppLogger.info('Cleared restaurants cache');
    } catch (e) {
      AppLogger.error('Error clearing restaurants cache', error: e);
    }
  }

  @override
  Future<List<MenuItemModel>> getCachedMenuItems(String restaurantId) async {
    try {
      final cacheKey = '$_menuItemsCachePrefix$restaurantId';
      final timestampKey = '$_menuItemsTimestampPrefix$restaurantId';
      
      final jsonString = sharedPreferences.getString(cacheKey);
      
      if (jsonString == null) {
        AppLogger.info('No cached menu items found for restaurant: $restaurantId');
        return [];
      }

      if (!isCacheValid(timestampKey)) {
        AppLogger.info('Menu items cache expired for restaurant: $restaurantId');
        await clearMenuItemsCache(restaurantId);
        return [];
      }

      final List<dynamic> jsonList = json.decode(jsonString);
      final menuItems = jsonList.map((json) => MenuItemModel.fromJson(json)).toList();
      
      AppLogger.info('Loaded ${menuItems.length} menu items from cache for restaurant: $restaurantId');
      return menuItems;
    } catch (e) {
      AppLogger.error('Error loading cached menu items', error: e);
      return [];
    }
  }

  @override
  Future<void> cacheMenuItems(String restaurantId, List<MenuItemModel> menuItems) async {
    try {
      final cacheKey = '$_menuItemsCachePrefix$restaurantId';
      final timestampKey = '$_menuItemsTimestampPrefix$restaurantId';
      
      final jsonString = json.encode(menuItems.map((m) => m.toJson()).toList());
      await sharedPreferences.setString(cacheKey, jsonString);
      await sharedPreferences.setInt(
        timestampKey,
        DateTime.now().millisecondsSinceEpoch,
      );
      
      AppLogger.info('Cached ${menuItems.length} menu items for restaurant: $restaurantId');
    } catch (e) {
      AppLogger.error('Error caching menu items', error: e);
    }
  }

  @override
  Future<void> clearMenuItemsCache(String restaurantId) async {
    try {
      final cacheKey = '$_menuItemsCachePrefix$restaurantId';
      final timestampKey = '$_menuItemsTimestampPrefix$restaurantId';
      
      await sharedPreferences.remove(cacheKey);
      await sharedPreferences.remove(timestampKey);
      AppLogger.info('Cleared menu items cache for restaurant: $restaurantId');
    } catch (e) {
      AppLogger.error('Error clearing menu items cache', error: e);
    }
  }

  @override
  bool isCacheValid(String timestampKey) {
    final timestamp = sharedPreferences.getInt(timestampKey);
    
    if (timestamp == null) {
      return false;
    }

    final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    
    // Determine cache duration based on key
    final cacheDuration = timestampKey.contains('menu_items')
        ? ApiConstants.menuItemsCacheDuration
        : ApiConstants.restaurantsCacheDuration;
    
    final isValid = now.difference(cacheTime) < cacheDuration;
    
    if (!isValid) {
      AppLogger.info('Cache expired for: $timestampKey');
    }
    
    return isValid;
  }
}

