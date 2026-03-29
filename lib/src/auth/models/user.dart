import 'package:flutter/material.dart';
import 'package:swf_app/l10n/app_localizations.dart';

/// Account type used during sign-up.
enum UserRole {
  reader;

  String localizedLabel(AppLocalizations l10n) => l10n.userRoleReader;

  String localizedDescription(AppLocalizations l10n) =>
      l10n.userRoleReaderDescription;

  String get apiValue => name;

  IconData get icon => Icons.auto_stories_rounded;
}

/// Minimal user model returned by the sign-up / sign-in endpoints.
class User {
  const User({
    required this.id,
    required this.email,
    this.name,
    this.role,
  });

  final String id;
  final String email;
  final String? name;
  final String? role;

  factory User.fromJson(Object json) {
    final map = json as Map<String, Object?>;
    // The legacy signup response nests user data under a `user` key.
    final userData = map['user'] as Map<String, Object?>? ?? map;
    return User(
      id: (userData['id'] ?? userData['_id'] ?? '').toString(),
      email: userData['email'] as String? ?? '',
      name: userData['name'] as String?,
      role: userData['role'] as String?,
    );
  }
}
