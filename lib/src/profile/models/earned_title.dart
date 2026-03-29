import 'package:flutter/material.dart';

/// A displayable title a user can earn and equip on their profile.
class EarnedTitle {
  const EarnedTitle({
    required this.id,
    required this.label,
    required this.category,
    required this.description,
    required this.icon,
    this.unlockHint,
  });

  /// Unique identifier, persisted in preferences and sent to the server.
  final String id;

  /// Display label shown on the profile, e.g. "Keeper of Cozy Fantasy".
  final String label;

  /// Grouping category: `genre`, `quest`, or `special`.
  final String category;

  /// Flavor text explaining what the title represents.
  final String description;

  /// Icon shown alongside the title in the picker.
  final IconData icon;

  /// Hint shown when the title is locked, e.g. "Favorite 3 cozy fantasy books".
  final String? unlockHint;
}
