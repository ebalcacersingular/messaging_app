import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:messaging_app/models/chat.dart';

class ChatService {
  final String _baseUrl = 'https://bbhwwx4n-3010.use2.devtunnels.ms/api/chats';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<List<Chat>> fetchChats() async {
    final token = await _storage.read(key: 'auth_token');
    if (token == null) {
      throw Exception('No auth token found');
    }

    final response = await http.get(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> chatData = jsonDecode(response.body);
      print(chatData);
      return chatData.map((chatJson) => Chat.fromJson(chatJson)).toList();
    } else {
      throw Exception('Failed to fetch chats');
    }
  }

  Future<Chat> createChat(String userUid) async {
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
      body: jsonEncode({'userUid': userUid}),
    );

    if (response.statusCode == 201) {
      final chatData = jsonDecode(response.body);
      return Chat.fromJson(chatData);
    } else {
      throw Exception('Failed to create chat');
    }
  }

  Future<Chat?> fetchExistingChat(int chatId) async {
    final token = await _storage.read(key: 'auth_token');
    if (token == null) {
      throw Exception('No auth token found');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/$chatId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final chatData = jsonDecode(response.body);
      return Chat.fromJson(chatData);
    } else if (response.statusCode == 404) {
      return null; // No chat exists between these users
    } else {
      throw Exception('Failed to fetch chat');
    }
  }
}
