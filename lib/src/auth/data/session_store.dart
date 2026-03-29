import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:swf_app/src/auth/models/user.dart';

/// Persisted session state.
///
/// Stores the auth token and user in SharedPreferences so the session
/// survives app restarts. Call [init] at startup before accessing state.
class SessionStore {
  static const _tokenKey = 'session_token';
  static const _userKey = 'session_user';

  String? _token;
  User? _user;

  String? get token => _token;
  User? get user => _user;
  bool get isAuthenticated => _token != null;

  /// Load any persisted session from disk. Call once at startup.
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(_tokenKey);
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      try {
        _user = User.fromJson(jsonDecode(userJson) as Map<String, Object?>);
      } catch (_) {
        // Corrupt data — clear it.
        _token = null;
        await prefs.remove(_tokenKey);
        await prefs.remove(_userKey);
      }
    }
  }

  /// Save the session after sign-up / sign-in.
  Future<void> save({required String token, required User user}) async {
    _token = token;
    _user = user;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userKey, jsonEncode({
      'id': user.id,
      'email': user.email,
      'name': user.name,
      'role': user.role,
    }));
  }

  /// Clear the session (sign out).
  Future<void> clear() async {
    _token = null;
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }
}
