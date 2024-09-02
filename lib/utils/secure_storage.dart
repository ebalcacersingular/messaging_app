import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final _storage = const FlutterSecureStorage();

  Future<void> storeUserCredentials(String email, String password) async {
    await _storage.write(key: 'email', value: email);
    await _storage.write(key: 'password', value: password);
  }

  Future<Map<String, String?>> getUserCredentials() async {
    String? email = await _storage.read(key: 'email');
    String? password = await _storage.read(key: 'password');
    return {'email': email, 'password': password};
  }

  Future<void> deleteUserCredentials() async {
    await _storage.delete(key: 'email');
    await _storage.delete(key: 'password');
  }
}
