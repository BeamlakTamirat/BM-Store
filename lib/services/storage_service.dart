import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../models/cart_item.dart';
import '../models/user.dart';

class StorageService {
  Future<void> saveCartItems(List<CartItem> cartItems) async {
    final prefs = await SharedPreferences.getInstance();
    final cartItemsJson = cartItems.map((item) => item.toJson()).toList();
    await prefs.setString(
      AppConstants.cartStorageKey,
      jsonEncode(cartItemsJson),
    );
  }

  Future<List<CartItem>> getCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final cartItemsJson = prefs.getString(AppConstants.cartStorageKey);

    if (cartItemsJson == null) {
      return [];
    }

    List<dynamic> decodedData = jsonDecode(cartItemsJson);
    return decodedData.map((item) => CartItem.fromJson(item)).toList();
  }

  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      AppConstants.userStorageKey,
      jsonEncode(user.toJson()),
    );
  }

  Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(AppConstants.userStorageKey);

    if (userJson == null) {
      return null;
    }

    return User.fromJson(jsonDecode(userJson));
  }

  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.userStorageKey);
  }
}
