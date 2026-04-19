import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _roleKey = 'role';
  static const _emailKey = 'email';
  static const _nameKey = 'name';

  Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    required String role,
    required String email,
    required String name,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, accessToken);
    await prefs.setString(_refreshTokenKey, refreshToken);
    await prefs.setString(_roleKey, role);
    await prefs.setString(_emailKey, email);
    await prefs.setString(_nameKey, name);
  }

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  Future<void> updateAccessToken(String accessToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, accessToken);
  }

  Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_roleKey);
  }

  Future<String?> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_nameKey);
  }

  Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey);
  }

  Future<void> updateProfile({
    required String name,
    required String email,
    String? role,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameKey, name);
    await prefs.setString(_emailKey, email);
    if (role != null && role.isNotEmpty) {
      await prefs.setString(_roleKey, role);
    }
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_roleKey);
    await prefs.remove(_emailKey);
    await prefs.remove(_nameKey);
  }

  // --- Biometric Enclave Handling ---
  static const _secureStorage = FlutterSecureStorage();
  static const _bioEmailKey = 'bio_email';
  static const _bioPasswordKey = 'bio_password';

  Future<void> saveBiometricCredentials(String email, String password) async {
    await _secureStorage.write(key: _bioEmailKey, value: email);
    await _secureStorage.write(key: _bioPasswordKey, value: password);
  }

  Future<Map<String, String>?> getBiometricCredentials() async {
    final email = await _secureStorage.read(key: _bioEmailKey);
    final password = await _secureStorage.read(key: _bioPasswordKey);
    if (email != null && password != null) {
      return {'email': email, 'password': password};
    }
    return null;
  }
}
