/// Remote data source for restaurant data
library;

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../../../../core/utils/app_logger.dart';
import '../models/restaurant_model.dart';
import '../models/menu_item_model.dart';

abstract class RestaurantRemoteDataSource {
  Future<List<RestaurantModel>> getRestaurants({
    String? category,
    String? search,
    double? minRating,
    double? maxDistance,
  });

  Future<RestaurantModel> getRestaurantById(String id);

  Future<List<MenuItemModel>> getMenuItems({
    required String restaurantId,
    String? category,
  });

  Future<MenuItemModel> getMenuItemById(String id);
}

class RestaurantRemoteDataSourceImpl implements RestaurantRemoteDataSource {
  final http.Client client;

  RestaurantRemoteDataSourceImpl({required this.client});

  @override
  Future<List<RestaurantModel>> getRestaurants({
    String? category,
    String? search,
    double? minRating,
    double? maxDistance,
  }) async {
    try {
      // Build query parameters
      final queryParams = <String, String>{};
      if (category != null && category != 'All') {
        queryParams[ApiConstants.categoryParam] = category;
      }
      if (search != null && search.isNotEmpty) {
        queryParams[ApiConstants.searchParam] = search;
      }
      if (minRating != null) {
        queryParams[ApiConstants.minRatingParam] = minRating.toString();
      }
      if (maxDistance != null) {
        queryParams[ApiConstants.maxDistanceParam] = maxDistance.toString();
      }

      final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.restaurantsEndpoint}')
          .replace(queryParameters: queryParams.isEmpty ? null : queryParams);

      AppLogger.info('Fetching restaurants from: $uri');

      final response = await client.get(
        uri,
        headers: ApiConstants.defaultHeaders,
      ).timeout(ApiConstants.connectionTimeout);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final List<dynamic> data = jsonData['data'] as List<dynamic>;
        
        final restaurants = data.map((json) => RestaurantModel.fromJson(json)).toList();
        
        AppLogger.info('Successfully fetched ${restaurants.length} restaurants');
        return restaurants;
      } else {
        AppLogger.error('Failed to fetch restaurants: ${response.statusCode}');
        throw Exception('Failed to load restaurants: ${response.statusCode}');
      }
    } catch (e) {
      AppLogger.error('Error fetching restaurants', error: e);
      rethrow;
    }
  }

  @override
  Future<RestaurantModel> getRestaurantById(String id) async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.restaurantByIdEndpoint(id)}');

      AppLogger.info('Fetching restaurant by ID: $id');

      final response = await client.get(
        uri,
        headers: ApiConstants.defaultHeaders,
      ).timeout(ApiConstants.connectionTimeout);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final restaurant = RestaurantModel.fromJson(jsonData['data']);
        
        AppLogger.info('Successfully fetched restaurant: ${restaurant.name}');
        return restaurant;
      } else {
        AppLogger.error('Failed to fetch restaurant: ${response.statusCode}');
        throw Exception('Failed to load restaurant: ${response.statusCode}');
      }
    } catch (e) {
      AppLogger.error('Error fetching restaurant', error: e);
      rethrow;
    }
  }

  @override
  Future<List<MenuItemModel>> getMenuItems({
    required String restaurantId,
    String? category,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (category != null && category != 'All') {
        queryParams[ApiConstants.categoryParam] = category;
      }

      final uri = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.restaurantMenuEndpoint(restaurantId)}',
      ).replace(queryParameters: queryParams.isEmpty ? null : queryParams);

      AppLogger.info('Fetching menu items from: $uri');

      final response = await client.get(
        uri,
        headers: ApiConstants.defaultHeaders,
      ).timeout(ApiConstants.connectionTimeout);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final List<dynamic> data = jsonData['data'] as List<dynamic>;
        
        final menuItems = data.map((json) => MenuItemModel.fromJson(json)).toList();
        
        AppLogger.info('Successfully fetched ${menuItems.length} menu items');
        return menuItems;
      } else {
        AppLogger.error('Failed to fetch menu items: ${response.statusCode}');
        throw Exception('Failed to load menu items: ${response.statusCode}');
      }
    } catch (e) {
      AppLogger.error('Error fetching menu items', error: e);
      rethrow;
    }
  }

  @override
  Future<MenuItemModel> getMenuItemById(String id) async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.menuItemByIdEndpoint(id)}');

      AppLogger.info('Fetching menu item by ID: $id');

      final response = await client.get(
        uri,
        headers: ApiConstants.defaultHeaders,
      ).timeout(ApiConstants.connectionTimeout);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final menuItem = MenuItemModel.fromJson(jsonData['data']);
        
        AppLogger.info('Successfully fetched menu item: ${menuItem.name}');
        return menuItem;
      } else {
        AppLogger.error('Failed to fetch menu item: ${response.statusCode}');
        throw Exception('Failed to load menu item: ${response.statusCode}');
      }
    } catch (e) {
      AppLogger.error('Error fetching menu item', error: e);
      rethrow;
    }
  }
}

