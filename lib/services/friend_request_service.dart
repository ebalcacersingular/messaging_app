import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:messaging_app/models/friend_request.dart';

class FriendRequestService {
  final String _baseUrl =
      'https://bbhwwx4n-3010.use2.devtunnels.ms/api/friend-requests';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<bool> areFriends(String userUid) async {
    final token = await _storage.read(key: 'auth_token');
    if (token == null) {
      throw Exception('No auth token found');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/friends/$userUid'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['areFriends'] as bool; // Check if the users are friends
    } else {
      throw Exception('Failed to check friendship status');
    }
  }

  Future<List<FriendRequest>> getPendingFriendRequests() async {
    final token = await _storage.read(key: 'auth_token');
    if (token == null) {
      throw Exception('No auth token found');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/pending'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((requestJson) => FriendRequest.fromJson(requestJson))
          .toList();
    } else {
      throw Exception('Failed to fetch pending friend requests');
    }
  }

  Future<void> sendFriendRequest(String username) async {
    final token = await _storage.read(key: 'auth_token');
    if (token == null) {
      throw Exception('No auth token found');
    }

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'username': username}),
    );

    if (kDebugMode) {
      print(response.body);
    }

    if (response.statusCode != 201) {
      throw Exception('Failed to send friend request');
    }
  }

  Future<void> respondToFriendRequest(int requestId, String status) async {
    final token = await _storage.read(key: 'auth_token');
    if (token == null) {
      throw Exception('No auth token found');
    }

    final response = await http.patch(
      Uri.parse('$_baseUrl/$requestId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'status': status}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to respond to friend request');
    }
  }
}
