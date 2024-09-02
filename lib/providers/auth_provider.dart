import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:messaging_app/services/auth_service.dart';
import 'package:messaging_app/models/user.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

class AuthState {
  final User? user;
  final bool isAuthenticated;
  final String? errorMessage;
  final bool isLoading;

  AuthState({
    this.user,
    this.isAuthenticated = false,
    this.errorMessage,
    this.isLoading = false,
  });

  AuthState copyWith({
    User? user,
    bool? isAuthenticated,
    String? errorMessage,
    bool? isLoading,
  }) {
    return AuthState(
      user: user ?? this.user,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState());

  final AuthService _authService = AuthService();

  Future<void> register(String email, String username, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final user = await _authService.register(email, username, password);
      state =
          state.copyWith(user: user, isAuthenticated: true, isLoading: false);
      if (kDebugMode) {
        print('User registered successfully');
      } // Debugging line
    } catch (e) {
      state = state.copyWith(
          errorMessage: e.toString(), isAuthenticated: false, isLoading: false);
      if (kDebugMode) {
        print('Error during registration: $e');
      } // Debugging line
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final user = await _authService.login(email, password);
      state =
          state.copyWith(user: user, isAuthenticated: true, isLoading: false);
      if (kDebugMode) {
        print('User logged in successfully');
      } // Debugging line
    } catch (e) {
      state = state.copyWith(
          errorMessage: e.toString(), isAuthenticated: false, isLoading: false);
      if (kDebugMode) {
        print('Error during login: $e');
      } // Debugging line
    }
  }

  void logout() {
    state = AuthState();
  }
}
