import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:messaging_app/models/message.dart';

class MessageService {
  final String _baseUrl = 'https://bbhwwx4n-3010.use2.devtunnels.ms/api/chats';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<List<Message>> getChatMessages(int chatId) async {
    final token = await _storage.read(key: 'auth_token');
    if (token == null) {
      throw Exception('No auth token found');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/$chatId/messages'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((messageJson) => Message.fromJson(messageJson)).toList();
    } else {
      throw Exception('Failed to fetch chat messages');
    }
  }

  Future<void> sendMessage(int chatId, String content) async {
    final token = await _storage.read(key: 'auth_token');
    if (token == null) {
      throw Exception('No auth token found');
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/$chatId/messages'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'content': content}),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to send message');
    }
  }
}
