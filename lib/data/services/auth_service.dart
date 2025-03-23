import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_fullstack/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Mock user for development
  final UserModel _mockUser = UserModel(
    id: 'mock_user_id',
    name: 'Test User',
    email: 'user@example.com',
    photoUrl: null,
    createdAt: DateTime.now(),
  );
  
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';
  
  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  
  factory AuthService() {
    return _instance;
  }
  
  AuthService._internal();

  // Initialize Firebase
  Future<void> initializeFirebase() async {
    try {
      await Firebase.initializeApp();
    } catch (e) {
      // Firebase initialization is optional for development
    }
  }

  // Mock sign in
  Future<UserModel> signInWithEmailAndPassword(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    
    // Save token and user data
    await _saveAuthData('mock_token_${DateTime.now().millisecondsSinceEpoch}', _mockUser);
    
    return _mockUser;
  }

  // Mock sign up
  Future<UserModel> signUpWithEmailAndPassword(String name, String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    
    final user = UserModel(
      id: 'mock_user_id',
      name: name,
      email: email,
      photoUrl: null,
      createdAt: DateTime.now(),
    );
    
    // Save token and user data
    await _saveAuthData('mock_token_${DateTime.now().millisecondsSinceEpoch}', user);
    
    return user;
  }

  // Sign out
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }

  // Get current user
  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(_userKey);
    
    if (userData != null) {
      try {
        return UserModel.fromJson(Map<String, dynamic>.from(
          Uri.splitQueryString(userData).map((key, value) => MapEntry(key, value))
        ));
      } catch (e) {
        // Return mock user if there's an error parsing stored data
        return _mockUser;
      }
    }
    
    return null;
  }

  // Get auth token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null;
  }

  // Save auth data
  Future<void> _saveAuthData(String token, UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userKey, Uri(queryParameters: user.toJson()).query);
  }
} 