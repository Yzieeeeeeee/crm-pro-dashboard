import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:crm_dashboard_app/features/auth/data/auth_model.dart';

/// Immutable authentication state.
class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final UserModel? user;
  final String? errorMessage;

  const AuthState({
    this.isAuthenticated = false,
    this.isLoading = false,
    this.user,
    this.errorMessage,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    UserModel? user,
    String? errorMessage,
    bool clearError = false,
    bool clearUser = false,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      user: clearUser ? null : (user ?? this.user),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

/// Manages authentication state with Hive-backed persistence.
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState()) {
    checkAuthStatus();
  }

  static const _boxName = 'auth';
  static const _loginKey = 'isLoggedIn';

  /// Authenticates with any valid credentials matching form validators and persists session.
  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);

    // Simulate API call
    await Future<void>.delayed(const Duration(seconds: 2));

    final emailVal = email.trim();
    if (emailVal.contains('@') && password.length >= 6) {
      // Build a dynamic name from the email prefix (e.g. alex.johnson@crm.com -> Alex Johnson)
      final namePart = emailVal.split('@')[0];
      final name = namePart
          .replaceAll(RegExp(r'[._-]'), ' ')
          .split(' ')
          .map((word) => word.isNotEmpty
              ? '${word[0].toUpperCase()}${word.substring(1)}'
              : '')
          .join(' ');

      final user = UserModel(
        id: '1',
        name: name.isNotEmpty ? name : 'Alex Johnson',
        email: emailVal,
        role: 'Admin',
      );

      final box = Hive.box(_boxName);
      await box.put(_loginKey, true);
      await box.put('userName', user.name);
      await box.put('userEmail', user.email);

      state = AuthState(
        isAuthenticated: true,
        user: user,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Invalid email or password structure',
      );
    }
  }

  /// Simulates registration with a delay.
  Future<void> register(String name, String email, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);
    await Future<void>.delayed(const Duration(seconds: 2));

    if (email.contains('@') && password.length >= 6) {
      final user = UserModel(
        id: '2',
        name: name,
        email: email,
        role: 'Admin',
      );

      final box = Hive.box(_boxName);
      await box.put(_loginKey, true);
      await box.put('userName', user.name);
      await box.put('userEmail', user.email);

      state = AuthState(
        isAuthenticated: true,
        user: user,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Invalid registration details',
      );
    }
  }

  /// Simulates forgot password email dispatch
  Future<bool> forgotPassword(String email) async {
    state = state.copyWith(isLoading: true, clearError: true);
    await Future<void>.delayed(const Duration(seconds: 2));
    
    if (email.contains('@')) {
      state = state.copyWith(isLoading: false);
      return true;
    } else {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Invalid email format',
      );
      return false;
    }
  }

  /// Clears authentication state and removes persisted session.
  Future<void> logout() async {
    final box = Hive.box(_boxName);
    await box.delete(_loginKey);
    await box.delete('userName');
    await box.delete('userEmail');

    state = const AuthState();
  }

  /// Checks Hive for a persisted login session on app start.
  Future<void> checkAuthStatus() async {
    state = state.copyWith(isLoading: true);

    final box = Hive.box(_boxName);
    final isLoggedIn = box.get(_loginKey, defaultValue: false) as bool;

    if (isLoggedIn) {
      final name =
          box.get('userName', defaultValue: 'Muhammed yasir') as String;
      final email =
          box.get('userEmail', defaultValue: 'test@crm.com') as String;
      final user = UserModel(
        id: '1',
        name: name,
        email: email,
        role: 'Admin',
      );
      state = AuthState(isAuthenticated: true, user: user);
    } else {
      state = const AuthState();
    }
  }
}

/// Global auth state provider.
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
