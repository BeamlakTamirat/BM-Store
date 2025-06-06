import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Product> _products = [];
  List<Product> get products => _products;

  List<String> _categories = [];
  List<String> get categories => _categories;

  String _selectedCategory = '';
  String get selectedCategory => _selectedCategory;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  bool _isError = false;
  bool get isError => _isError;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  // Add a flag to check if products were loaded at least once
  bool _productsLoaded = false;
  bool get productsLoaded => _productsLoaded;

  ProductProvider() {
    // Try to load products automatically when the provider is created
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    if (_isLoading) return; // Prevent multiple simultaneous requests

    _isLoading = true;
    _isError = false;
    notifyListeners();

    try {
      debugPrint('Fetching all products...');
      _products = await _apiService.getProducts();
      _isLoading = false;
      _productsLoaded = true; // Mark that products were loaded at least once
      notifyListeners();

      // Also fetch categories if they're not loaded yet
      if (_categories.isEmpty) {
        fetchCategories();
      }
    } catch (e) {
      debugPrint('Error in fetchProducts: $e');
      _isLoading = false;
      _isError = true;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> fetchCategories() async {
    if (_isLoading) return; // Prevent multiple simultaneous requests

    _isLoading = true;
    notifyListeners();

    try {
      debugPrint('Fetching categories...');
      _categories = await _apiService.getCategories();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error in fetchCategories: $e');
      _isLoading = false;
      // Don't set _isError here as it would affect the UI for product listing
      notifyListeners();
    }
  }

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();

    if (category.isNotEmpty) {
      fetchProductsByCategory(category);
    } else {
      fetchProducts();
    }
  }

  Future<void> fetchProductsByCategory(String category) async {
    if (_isLoading) return; // Prevent multiple simultaneous requests

    _isLoading = true;
    _isError = false;
    notifyListeners();

    try {
      debugPrint('Fetching products by category: $category');
      _products = await _apiService.getProductsByCategory(category);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error in fetchProductsByCategory: $e');
      _isLoading = false;
      _isError = true;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<Product> fetchProductById(int id) async {
    _isLoading = true;
    _isError = false;
    notifyListeners();

    try {
      debugPrint('Fetching product by id: $id');
      final product = await _apiService.getProductById(id);
      _isLoading = false;
      notifyListeners();
      return product;
    } catch (e) {
      debugPrint('Error in fetchProductById: $e');
      _isLoading = false;
      _isError = true;
      _errorMessage = e.toString();
      notifyListeners();
      throw Exception('Failed to load product details: $e');
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    notifyListeners();
  }

  List<Product> get filteredProducts {
    if (_searchQuery.isEmpty) {
      return _products;
    }

    return _products
        .where(
          (product) =>
              product.title.toLowerCase().contains(_searchQuery) ||
              product.description.toLowerCase().contains(_searchQuery),
        )
        .toList();
  }

  void resetError() {
    _isError = false;
    _errorMessage = '';
    notifyListeners();
  }

  // Add a retry method that can be called from the UI
  Future<void> retry() async {
    if (_selectedCategory.isEmpty) {
      await fetchProducts();
    } else {
      await fetchProductsByCategory(_selectedCategory);
    }
  }
}
