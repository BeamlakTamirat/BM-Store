import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';
import '../models/product.dart';
import '../models/user.dart';

class ApiService {
  Future<List<Product>> getProducts() async {
    try {
      debugPrint('Fetching products from API...');
      final response = await http
          .get(
            Uri.parse('${AppConstants.baseUrl}${AppConstants.productsEndpoint}'),
          )
          .timeout(const Duration(seconds: 15)); // Increased timeout

      if (response.statusCode == 200) {
        debugPrint('Products fetched successfully');
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        debugPrint('Failed to load products: ${response.statusCode}');
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } on SocketException {
      debugPrint('No internet connection');
      throw Exception('No internet connection. Please check your network.');
    } on http.ClientException catch (e) {
      debugPrint('HTTP client error: $e');
      throw Exception('Network error. Please try again.');
    } on FormatException {
      debugPrint('Invalid response format');
      throw Exception('Server returned invalid data. Please try again.');
    } catch (e) {
      debugPrint('Error fetching products: $e');
      throw Exception('Failed to load products. Please try again.');
    }
  }

  Future<Product> getProductById(int id) async {
    try {
      final response = await http
          .get(
            Uri.parse(
              '${AppConstants.baseUrl}${AppConstants.productsEndpoint}/$id',
            ),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        return Product.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load product: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection. Please check your network.');
    } catch (e) {
      throw Exception('Failed to load product: $e');
    }
  }

  Future<List<String>> getCategories() async {
    try {
      final response = await http
          .get(
            Uri.parse(
              '${AppConstants.baseUrl}${AppConstants.categoriesEndpoint}',
            ),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((category) => category.toString()).toList();
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection. Please check your network.');
    } catch (e) {
      throw Exception('Failed to load categories: $e');
    }
  }

  Future<List<Product>> getProductsByCategory(String category) async {
    try {
      final response = await http
          .get(
            Uri.parse(
              '${AppConstants.baseUrl}${AppConstants.productsEndpoint}/category/$category',
            ),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products by category: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection. Please check your network.');
    } catch (e) {
      throw Exception('Failed to load products by category: $e');
    }
  }

  Future<User> login(String username, String password) async {
    final response = await http
        .post(
          Uri.parse('${AppConstants.baseUrl}${AppConstants.loginEndpoint}'),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: jsonEncode(<String, String>{
            'username': username,
            'password': password,
          }),
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: username,
        token: data['token'],
      );
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<User> register(String email, String username, String password) async {
    final response = await http
        .post(
          Uri.parse('${AppConstants.baseUrl}${AppConstants.usersEndpoint}'),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: jsonEncode(<String, String>{
            'email': email,
            'username': username,
            'password': password,
            'name': {'firstname': 'User', 'lastname': ''}.toString(),
            'address':
                {
                  'city': '',
                  'street': '',
                  'number': 0,
                  'zipcode': '',
                  'geolocation': {'lat': '0', 'long': '0'}.toString(),
                }.toString(),
            'phone': '',
          }),
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return User(
        id: data['id'].toString(),
        email: email,
        token: 'fake-token-${DateTime.now().millisecondsSinceEpoch}',
      );
    } else {
      throw Exception('Failed to register user');
    }
  }
}
 