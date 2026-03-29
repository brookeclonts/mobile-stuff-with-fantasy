import 'package:flutter/material.dart';

/// The four composable layers of a sigil.
enum SigilLayer { shield, field, charge, border }

/// A single selectable piece within one sigil layer.
class SigilPart {
  const SigilPart({
    required this.id,
    required this.layer,
    required this.name,
    required this.icon,
    this.unlocksAfter,
  });

  /// Unique identifier persisted in [SigilConfig].
  final String id;

  /// Which layer this part belongs to.
  final SigilLayer layer;

  /// Display name shown in the builder grid.
  final String name;

  /// Material icon used for rendering (MVP).
  final IconData icon;

  /// The quest objective or reward ID that unlocks this part.
  /// `null` means available by default.
  final String? unlocksAfter;
}
