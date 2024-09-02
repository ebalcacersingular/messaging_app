import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:messaging_app/services/user_service.dart';
import 'package:messaging_app/models/user.dart';

final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier();
});

class UserState {
  final User? user;
  final String? errorMessage;
  final bool isLoading;

  UserState({this.user, this.errorMessage, this.isLoading = false});

  UserState copyWith({User? user, String? errorMessage, bool? isLoading}) {
    return UserState(
      user: user ?? this.user,
      errorMessage: errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class UserNotifier extends StateNotifier<UserState> {
  UserNotifier() : super(UserState());

  final UserService _userService = UserService();

  Future<void> fetchUserDetails() async {
    state = state.copyWith(isLoading: true);
    try {
      final user = await _userService.getUserDetails();
      state = state.copyWith(user: user, isLoading: false, errorMessage: null);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
    }
  }

  Future<void> updateUserProfile(String email, String username) async {
    state = state.copyWith(isLoading: true);
    try {
      await _userService.updateUserProfile(email, username);
      await fetchUserDetails(); // Refresh user details after update
      state = state.copyWith(isLoading: false, errorMessage: null);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
    }
  }
}
