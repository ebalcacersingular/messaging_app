import 'package:flutter/foundation.dart';

class User {
  final String uid;
  final String? email;
  final String? username;
  final String token;

  User({
    required this.uid,
    this.email,
    this.username,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    if (kDebugMode) {
      print('Parsing user JSON: $json');
    } // Debugging line
    final userData = json['user'] as Map<String, dynamic>?;
    if (userData == null) {
      if (kDebugMode) {
        print('User data is missing in response');
      } // Debugging line
      throw Exception("User data is missing in response");
    }

    return User(
      uid: userData['uid'] as String,
      email: userData['email'] as String?,
      username: userData['username'] as String?,
      token: json['token'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'token': token,
    };
  }
}
