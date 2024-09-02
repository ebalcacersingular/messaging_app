import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:messaging_app/services/friend_request_service.dart';
import 'package:messaging_app/models/friend_request.dart';

final friendRequestProvider =
    StateNotifierProvider<FriendRequestNotifier, FriendRequestState>((ref) {
  return FriendRequestNotifier();
});

class FriendRequestState {
  final List<FriendRequest> pendingRequests;
  final String? errorMessage;

  FriendRequestState({this.pendingRequests = const [], this.errorMessage});

  FriendRequestState copyWith(
      {List<FriendRequest>? pendingRequests, String? errorMessage}) {
    return FriendRequestState(
      pendingRequests: pendingRequests ?? this.pendingRequests,
      errorMessage: errorMessage,
    );
  }
}

class FriendRequestNotifier extends StateNotifier<FriendRequestState> {
  FriendRequestNotifier() : super(FriendRequestState());

  final FriendRequestService _friendRequestService = FriendRequestService();

  Future<void> fetchPendingRequests() async {
    try {
      final requests = await _friendRequestService.getPendingFriendRequests();
      state = state.copyWith(pendingRequests: requests, errorMessage: null);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> sendFriendRequest(String username) async {
    try {
      await _friendRequestService.sendFriendRequest(username);
      state = state.copyWith(errorMessage: null);
      fetchPendingRequests(); // Refresh pending requests
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> respondToFriendRequest(int requestId, String status) async {
    try {
      await _friendRequestService.respondToFriendRequest(requestId, status);
      state = state.copyWith(errorMessage: null);
      fetchPendingRequests(); // Refresh pending requests
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }
}
