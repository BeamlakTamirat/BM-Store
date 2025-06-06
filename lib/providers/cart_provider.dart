import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import '../services/storage_service.dart';

class CartProvider with ChangeNotifier {
  final StorageService _storageService = StorageService();

  List<CartItem> _items = [];
  List<CartItem> get items => _items;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadCartItems() async {
    _isLoading = true;
    notifyListeners();

    try {
      _items = await _storageService.getCartItems();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addItem(Product product) async {
    final existingItemIndex = _items.indexWhere(
      (item) => item.id == product.id,
    );

    if (existingItemIndex >= 0) {
      _items[existingItemIndex].quantity += 1;
    } else {
      _items.add(
        CartItem(
          id: product.id,
          title: product.title,
          price: product.price,
          image: product.image,
          quantity: 1,
        ),
      );
    }

    await _storageService.saveCartItems(_items);
    notifyListeners();
  }

  Future<void> removeItem(int productId) async {
    _items.removeWhere((item) => item.id == productId);
    await _storageService.saveCartItems(_items);
    notifyListeners();
  }

  Future<void> increaseQuantity(int productId) async {
    final existingItemIndex = _items.indexWhere((item) => item.id == productId);

    if (existingItemIndex >= 0) {
      _items[existingItemIndex].quantity += 1;
      await _storageService.saveCartItems(_items);
      notifyListeners();
    }
  }

  Future<void> decreaseQuantity(int productId) async {
    final existingItemIndex = _items.indexWhere((item) => item.id == productId);

    if (existingItemIndex >= 0) {
      if (_items[existingItemIndex].quantity > 1) {
        _items[existingItemIndex].quantity -= 1;
        await _storageService.saveCartItems(_items);
      } else {
        await removeItem(productId);
      }

      notifyListeners();
    }
  }

  Future<void> clearCart() async {
    _items = [];
    await _storageService.saveCartItems(_items);
    notifyListeners();
  }

  int get itemCount {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  double get totalAmount {
    return _items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  bool isInCart(int productId) {
    return _items.any((item) => item.id == productId);
  }
}
