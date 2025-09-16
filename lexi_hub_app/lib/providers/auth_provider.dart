
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  String? _token;
  bool get isLoggedIn => _token != null;
  String? get token => _token;

  Future<void> login(String email, String password) async {
    try {
      final token = await _authService.login(email, password);
      _token = token;
      // In a real app, you would securely store the token here
      // e.g., using flutter_secure_storage
      notifyListeners();
    } catch (e) {
      // The error will be caught in the UI layer to show a message
      rethrow;
    }
  }

  void logout() {
    _token = null;
    // Also clear the securely stored token
    notifyListeners();
  }
}
