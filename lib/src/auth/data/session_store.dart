import 'package:swf_app/src/auth/models/user.dart';

/// In-memory session state.
///
/// Holds the current auth token and user after sign-up / sign-in.
/// A future iteration should persist the token with flutter_secure_storage.
class SessionStore {
  String? _token;
  User? _user;

  String? get token => _token;
  User? get user => _user;
  bool get isAuthenticated => _token != null;

  void save({required String token, required User user}) {
    _token = token;
    _user = user;
  }

  void clear() {
    _token = null;
    _user = null;
  }
}
