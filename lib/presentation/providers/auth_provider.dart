import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_fullstack/data/models/user_model.dart';
import 'package:flutter_fullstack/data/services/auth_service.dart';

// Auth state
enum AuthState {
  initial,
  authenticated,
  unauthenticated,
  loading,
  error,
}

// Auth state notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService = AuthService();
  UserModel? _user;

  AuthNotifier() : super(AuthState.initial) {
    _initialize();
  }

  UserModel? get user => _user;

  Future<void> _initialize() async {
    state = AuthState.loading;
    try {
      final isAuthenticated = await _authService.isAuthenticated();
      if (isAuthenticated) {
        _user = await _authService.getCurrentUser();
        state = AuthState.authenticated;
      } else {
        state = AuthState.unauthenticated;
      }
    } catch (e) {
      state = AuthState.error;
    }
  }

  Future<void> signIn(String email, String password) async {
    state = AuthState.loading;
    try {
      _user = await _authService.signInWithEmailAndPassword(email, password);
      state = AuthState.authenticated;
    } catch (e) {
      state = AuthState.error;
      rethrow;
    }
  }

  Future<void> signUp(String name, String email, String password) async {
    state = AuthState.loading;
    try {
      _user = await _authService.signUpWithEmailAndPassword(name, email, password);
      state = AuthState.authenticated;
    } catch (e) {
      state = AuthState.error;
      rethrow;
    }
  }

  Future<void> signOut() async {
    state = AuthState.loading;
    try {
      await _authService.signOut();
      _user = null;
      state = AuthState.unauthenticated;
    } catch (e) {
      state = AuthState.error;
      rethrow;
    }
  }
}

// Providers
final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

final userProvider = Provider<UserModel?>((ref) {
  final authNotifier = ref.watch(authStateProvider.notifier);
  return authNotifier.user;
}); 