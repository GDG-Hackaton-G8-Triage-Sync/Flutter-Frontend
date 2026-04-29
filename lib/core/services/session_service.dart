import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const _secureStorage = FlutterSecureStorage();

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _roleKey = 'role';
  static const _emailKey = 'email';
  static const _nameKey = 'name';
  static const _bioEmailKey = 'bio_email';
  static const _bioPasswordKey = 'bio_password';
  static const _consentAcceptedPrefix = 'consent_accepted_';

  Future<void> _writeSessionValue(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  Future<String?> _readSessionValue(String key) async {
    final secureValue = await _secureStorage.read(key: key);
    if (secureValue != null && secureValue.isNotEmpty) {
      return secureValue;
    }

    // Backward-compatibility migration from SharedPreferences.
    final prefs = await SharedPreferences.getInstance();
    final legacyValue = prefs.getString(key);
    if (legacyValue != null && legacyValue.isNotEmpty) {
      await _secureStorage.write(key: key, value: legacyValue);
      await prefs.remove(key);
      return legacyValue;
    }

    return null;
  }

  String _consentKey(String? email) {
    final normalizedEmail = (email ?? '').trim().toLowerCase();
    if (normalizedEmail.isEmpty) {
      return '${_consentAcceptedPrefix}default';
    }
    return '$_consentAcceptedPrefix$normalizedEmail';
  }

  Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    required String role,
    required String email,
    required String name,
  }) async {
    await _writeSessionValue(_accessTokenKey, accessToken);
    await _writeSessionValue(_refreshTokenKey, refreshToken);
    await _writeSessionValue(_roleKey, role);
    await _writeSessionValue(_emailKey, email);
    await _writeSessionValue(_nameKey, name);
  }

  Future<String?> getAccessToken() async {
    return _readSessionValue(_accessTokenKey);
  }

  Future<String?> getRefreshToken() async {
    return _readSessionValue(_refreshTokenKey);
  }

  Future<void> updateAccessToken(String accessToken) async {
    await _writeSessionValue(_accessTokenKey, accessToken);
  }

  Future<String?> getRole() async {
    return _readSessionValue(_roleKey);
  }

  Future<String?> getName() async {
    return _readSessionValue(_nameKey);
  }

  Future<String?> getEmail() async {
    return _readSessionValue(_emailKey);
  }

  Future<void> updateProfile({
    required String name,
    required String email,
    String? role,
  }) async {
    await _writeSessionValue(_nameKey, name);
    await _writeSessionValue(_emailKey, email);
    if (role != null && role.isNotEmpty) {
      await _writeSessionValue(_roleKey, role);
    }
  }

  Future<bool> getDataConsentAccepted({String? email}) async {
    final key = _consentKey(email);
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }

  Future<void> setDataConsentAccepted(bool accepted, {String? email}) async {
    final key = _consentKey(email);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, accepted);
  }

  Future<void> clear() async {
    await _secureStorage.delete(key: _accessTokenKey);
    await _secureStorage.delete(key: _refreshTokenKey);
    await _secureStorage.delete(key: _roleKey);
    await _secureStorage.delete(key: _emailKey);
    await _secureStorage.delete(key: _nameKey);

    // Cleanup any legacy values from older builds.
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_roleKey);
    await prefs.remove(_emailKey);
    await prefs.remove(_nameKey);
  }

  // --- Biometric Enclave Handling ---
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
