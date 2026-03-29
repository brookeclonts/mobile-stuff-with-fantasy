import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages the user's locale preference and notifies listeners on change.
///
/// A `null` locale means "follow the system default".
class LocaleProvider extends ChangeNotifier {
  LocaleProvider() {
    _load();
  }

  static const _key = 'locale_override';

  Locale? _locale;

  /// The current locale override, or `null` for system default.
  Locale? get locale => _locale;

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_key);
    if (code != null) {
      _locale = Locale(code);
      notifyListeners();
    }
  }

  /// Set the locale override. Pass `null` to revert to system default.
  Future<void> setLocale(Locale? locale) async {
    if (_locale == locale) return;
    _locale = locale;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    if (locale == null) {
      await prefs.remove(_key);
    } else {
      await prefs.setString(_key, locale.languageCode);
    }
  }
}
