import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:messaging_app/models/user.dart';

class UserService {
  final String _baseUrl = 'https://bbhwwx4n-3010.use2.devtunnels.ms/api/users';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<User> getUserDetails() async {
    final token = await _storage.read(key: 'auth_token');
    if (token == null) {
      throw Exception('No auth token found');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final userData = jsonDecode(response.body);
      return User.fromJson(userData);
    } else {
      throw Exception('Failed to fetch user details');
    }
  }

  Future<void> updateUserProfile(String email, String username) async {
    final token = await _storage.read(key: 'auth_token');
    if (token == null) {
      throw Exception('No auth token found');
    }

    final response = await http.patch(
      Uri.parse('$_baseUrl/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'email': email, 'username': username}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update user profile');
    }
  }
}
