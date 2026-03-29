import 'package:flutter/material.dart';

/// An unlockable ability tied to a role's quest progression.
///
/// Runes represent features that become available as the user
/// completes quest scrolls. Each rune is tied to a specific scroll
/// and becomes usable once that scroll is sealed.
class AbilityRune {
  const AbilityRune({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.unlocksAfterScrollId,
    this.unlocksAtTierId,
  });

  final String id;
  final String title;
  final String description;
  final IconData icon;

  /// The quest scroll ID that must be completed to unlock this rune.
  final String unlocksAfterScrollId;

  /// The skill tree tier ID where this rune is unlocked, if any.
  final String? unlocksAtTierId;
}
