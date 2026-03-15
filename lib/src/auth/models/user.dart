import 'package:flutter/material.dart';

/// The three account types a user can choose during sign-up.
enum UserRole {
  reader,
  influencer,
  author;

  String get label => switch (this) {
        reader => 'Reader',
        influencer => 'Influencer',
        author => 'Author',
      };

  String get description => switch (this) {
        reader => 'Discover your next favorite fantasy book',
        influencer => 'Share your love of fantasy with the world',
        author => 'Get your books discovered by readers',
      };

  String get apiValue => name;

  IconData get icon => switch (this) {
        reader => Icons.auto_stories_rounded,
        influencer => Icons.campaign_rounded,
        author => Icons.edit_note_rounded,
      };
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
