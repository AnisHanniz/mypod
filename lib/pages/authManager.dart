import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthManager {
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  static const _passwordKey = 'user_password';

  Future<bool> isUserAuthenticated() async {
    String? storedPassword = await _storage.read(key: _passwordKey);
    return storedPassword != null;
  }

  Future<void> setPassword(String password) async {
    await _storage.write(key: _passwordKey, value: password);
  }

  Future<bool> authenticateUser(String password) async {
    String? storedPassword = await _storage.read(key: _passwordKey);
    return storedPassword == password;
  }
}
