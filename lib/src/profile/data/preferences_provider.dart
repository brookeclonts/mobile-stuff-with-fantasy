import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swf_app/src/profile/models/sigil_config.dart';

/// Manages user profile personalization preferences and notifies listeners.
///
/// Persists to SharedPreferences as a JSON map. Server sync is handled
/// separately by [ProfileRepository].
class ProfilePreferencesProvider extends ChangeNotifier {
  ProfilePreferencesProvider() {
    _load();
  }

  static const _key = 'profile_preferences';

  /// The key identifying the user's chosen accent color, or `null` for the
  /// campaign default.
  String? _accentColorKey;
  String? get accentColorKey => _accentColorKey;

  /// The ID of the user's selected title, or `null` for no custom title.
  String? _selectedTitleId;
  String? get selectedTitleId => _selectedTitleId;

  /// The user's composed sigil configuration, or `null` for initials fallback.
  SigilConfig? _sigilConfig;
  SigilConfig? get sigilConfig => _sigilConfig;

  bool _loaded = false;
  bool get loaded => _loaded;

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw != null) {
      try {
        final map = jsonDecode(raw) as Map<String, dynamic>;
        _accentColorKey = map['accentColorKey'] as String?;
        _selectedTitleId = map['selectedTitleId'] as String?;
        final sigilMap = map['sigilConfig'];
        if (sigilMap is Map<String, dynamic>) {
          _sigilConfig = SigilConfig.fromJson(sigilMap);
        }
      } catch (_) {
        // Corrupted data — start fresh.
      }
    }
    _loaded = true;
    notifyListeners();
  }

  Future<void> setAccentColorKey(String? key) async {
    if (_accentColorKey == key) return;
    _accentColorKey = key;
    notifyListeners();
    await _persist();
  }

  Future<void> setSelectedTitleId(String? id) async {
    if (_selectedTitleId == id) return;
    _selectedTitleId = id;
    notifyListeners();
    await _persist();
  }

  Future<void> setSigilConfig(SigilConfig? config) async {
    _sigilConfig = config;
    notifyListeners();
    await _persist();
  }

  /// Merge server state into the provider. Server wins for any non-null value.
  void mergeFromServer(Map<String, dynamic> json) {
    bool changed = false;
    if (json.containsKey('accentColorKey')) {
      final serverKey = json['accentColorKey'] as String?;
      if (serverKey != _accentColorKey) {
        _accentColorKey = serverKey;
        changed = true;
      }
    }
    if (json.containsKey('selectedTitleId')) {
      final serverId = json['selectedTitleId'] as String?;
      if (serverId != _selectedTitleId) {
        _selectedTitleId = serverId;
        changed = true;
      }
    }
    if (json.containsKey('sigilConfig')) {
      final serverSigil = json['sigilConfig'];
      if (serverSigil is Map<String, dynamic>) {
        _sigilConfig = SigilConfig.fromJson(serverSigil);
        changed = true;
      } else if (serverSigil == null) {
        if (_sigilConfig != null) {
          _sigilConfig = null;
          changed = true;
        }
      }
    }
    if (changed) {
      notifyListeners();
      _persist();
    }
  }

  Map<String, dynamic> toJson() => {
        'accentColorKey': _accentColorKey,
        'selectedTitleId': _selectedTitleId,
        'sigilConfig': _sigilConfig?.toJson(),
      };

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(toJson()));
  }
}
