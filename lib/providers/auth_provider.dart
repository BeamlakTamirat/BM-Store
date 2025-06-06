import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();
  
  User? _user;
  User? get user => _user;
  
  bool get isAuthenticated => _user != null;
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  AuthProvider() {
    tryAutoLogin();
  }

  Future<void> tryAutoLogin() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _user = await _storageService.getUser();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    
    try {
      _user = await _apiService.login(username, password);
      await _storageService.saveUser(_user!);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to login. Please check your credentials.';
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> register(String email, String username, String password) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    
    try {
      _user = await _apiService.register(email, username, password);
      await _storageService.saveUser(_user!);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to register. Please try again.';
      notifyListeners();
      return false;
    }
  }
  
  Future<void> logout() async {
    _user = null;
    await _storageService.clearUser();
    notifyListeners();
  }
  
  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }
} 