import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:messaging_app/models/user.dart';

class AuthService {
  final String _baseUrl = 'https://bbhwwx4n-3010.use2.devtunnels.ms/api/auth';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<User> register(String email, String username, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
          {'email': email, 'username': username, 'password': password}),
    );

    if (kDebugMode) {
      print('Register API response: ${response.statusCode}');
    } // Debugging line

    if (response.statusCode == 201) {
      final userData = jsonDecode(response.body);
      if (kDebugMode) {
        print('User registered successfully on server');
      } // Debugging line

      return User.fromJson(userData);
    } else {
      if (kDebugMode) {
        print('Failed to register user: ${response.body}');
      } // Debugging line
      throw Exception('Failed to register user');
    }
  }

  Future<User> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (kDebugMode) {
      print('Login API response: ${response.statusCode}');
    } // Debugging line

    if (response.statusCode == 200) {
      final userData = jsonDecode(response.body);
      if (kDebugMode) {
        print('User logged in successfully on server');
      } // Debugging line
      if (kDebugMode) {
        print('userData: $userData');
      } // Debugging line to see the whole response

      // Store the token securely
      await _storage.write(key: 'auth_token', value: userData['token']);

      return User.fromJson(userData); // Parse the user object from the JSON
    } else {
      if (kDebugMode) {
        print('Failed to log in user: ${response.body}');
      } // Debugging line
      throw Exception('Failed to log in user');
    }
  }

  Future<void> logout() async {
    // Clear the token from secure storage
    await _storage.delete(key: 'auth_token');
  }
}
