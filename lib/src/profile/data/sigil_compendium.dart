import 'package:flutter/material.dart';
import 'package:swf_app/src/profile/models/sigil_config.dart';
import 'package:swf_app/src/profile/models/sigil_part.dart';

// ---------------------------------------------------------------------------
// Default sigil config (used when user has not customized)
// ---------------------------------------------------------------------------

const SigilConfig defaultSigilConfig = SigilConfig(
  shieldId: 'shield-circle',
  fieldId: 'field-solid',
  chargeId: 'charge-book',
  borderId: 'border-plain',
);

// ---------------------------------------------------------------------------
// Shield shapes (background silhouette)
// ---------------------------------------------------------------------------

const List<SigilPart> _shields = [
  SigilPart(
    id: 'shield-circle',
    layer: SigilLayer.shield,
    name: 'Circle',
    icon: Icons.circle_outlined,
  ),
  SigilPart(
    id: 'shield-heater',
    layer: SigilLayer.shield,
    name: 'Heater',
    icon: Icons.shield_outlined,
  ),
  SigilPart(
    id: 'shield-diamond',
    layer: SigilLayer.shield,
    name: 'Diamond',
    icon: Icons.diamond_outlined,
  ),
  SigilPart(
    id: 'shield-hexagon',
    layer: SigilLayer.shield,
    name: 'Hexagon',
    icon: Icons.hexagon_outlined,
  ),
  // Quest unlock: complete Chapter I
  SigilPart(
    id: 'shield-star',
    layer: SigilLayer.shield,
    name: 'Star',
    icon: Icons.star_outline_rounded,
    unlocksAfter: 'reader-taste-reward',
  ),
];

// ---------------------------------------------------------------------------
// Field fills (background color treatment)
// ---------------------------------------------------------------------------

const List<SigilPart> _fields = [
  SigilPart(
    id: 'field-solid',
    layer: SigilLayer.field,
    name: 'Solid',
    icon: Icons.format_color_fill_rounded,
  ),
  SigilPart(
    id: 'field-gradient',
    layer: SigilLayer.field,
    name: 'Gradient',
    icon: Icons.gradient_rounded,
  ),
  // Quest unlock: complete Chapter II
  SigilPart(
    id: 'field-split',
    layer: SigilLayer.field,
    name: 'Split',
    icon: Icons.vertical_split_rounded,
    unlocksAfter: 'reader-hunt-reward',
  ),
];

// ---------------------------------------------------------------------------
// Charges (central icon/symbol)
// ---------------------------------------------------------------------------

const List<SigilPart> _charges = [
  SigilPart(
    id: 'charge-book',
    layer: SigilLayer.charge,
    name: 'Book',
    icon: Icons.menu_book_rounded,
  ),
  SigilPart(
    id: 'charge-sword',
    layer: SigilLayer.charge,
    name: 'Sword',
    icon: Icons.gpp_good_rounded,
  ),
  SigilPart(
    id: 'charge-crown',
    layer: SigilLayer.charge,
    name: 'Crown',
    icon: Icons.workspace_premium_rounded,
  ),
  SigilPart(
    id: 'charge-tree',
    layer: SigilLayer.charge,
    name: 'Tree',
    icon: Icons.park_rounded,
  ),
  SigilPart(
    id: 'charge-moon',
    layer: SigilLayer.charge,
    name: 'Moon',
    icon: Icons.nightlight_round,
  ),
  SigilPart(
    id: 'charge-flame',
    layer: SigilLayer.charge,
    name: 'Flame',
    icon: Icons.local_fire_department_rounded,
  ),
  // Quest unlock: complete Chapter III
  SigilPart(
    id: 'charge-rune',
    layer: SigilLayer.charge,
    name: 'Rune',
    icon: Icons.auto_fix_high_rounded,
    unlocksAfter: 'reader-hoard-reward',
  ),
  // Grand reward unlock: all quests complete
  SigilPart(
    id: 'charge-dragon',
    layer: SigilLayer.charge,
    name: 'Dragon',
    icon: Icons.whatshot_rounded,
    unlocksAfter: 'reader-grand-reward',
  ),
];

// ---------------------------------------------------------------------------
// Borders (decorative frame)
// ---------------------------------------------------------------------------

const List<SigilPart> _borders = [
  SigilPart(
    id: 'border-plain',
    layer: SigilLayer.border,
    name: 'Plain',
    icon: Icons.crop_square_rounded,
  ),
  SigilPart(
    id: 'border-ornate',
    layer: SigilLayer.border,
    name: 'Ornate',
    icon: Icons.filter_frames_rounded,
  ),
  // Quest unlock: any scroll complete
  SigilPart(
    id: 'border-stars',
    layer: SigilLayer.border,
    name: 'Stars',
    icon: Icons.auto_awesome_rounded,
    unlocksAfter: 'reader-taste-reward',
  ),
  // Grand reward unlock
  SigilPart(
    id: 'border-runes',
    layer: SigilLayer.border,
    name: 'Runes',
    icon: Icons.blur_circular_rounded,
    unlocksAfter: 'reader-grand-reward',
  ),
];

// ---------------------------------------------------------------------------
// Public API
// ---------------------------------------------------------------------------

/// Returns all parts for a given layer.
List<SigilPart> partsForLayer(SigilLayer layer) {
  switch (layer) {
    case SigilLayer.shield:
      return _shields;
    case SigilLayer.field:
      return _fields;
    case SigilLayer.charge:
      return _charges;
    case SigilLayer.border:
      return _borders;
  }
}

/// Returns parts for a layer filtered to those the user has unlocked.
///
/// A part is unlocked if its [SigilPart.unlocksAfter] is `null` (default)
/// or if [revealedRewardIds] contains the required reward ID.
List<SigilPart> unlockedPartsForLayer(
  SigilLayer layer, {
  required Set<String> revealedRewardIds,
}) {
  return partsForLayer(layer)
      .where((p) =>
          p.unlocksAfter == null ||
          revealedRewardIds.contains(p.unlocksAfter))
      .toList();
}

/// Whether a specific part is unlocked.
bool isPartUnlocked(SigilPart part, {required Set<String> revealedRewardIds}) {
  return part.unlocksAfter == null ||
      revealedRewardIds.contains(part.unlocksAfter);
}

/// Finds a part by ID across all layers, or `null`.
SigilPart? partById(String id) {
  for (final list in [_shields, _fields, _charges, _borders]) {
    for (final part in list) {
      if (part.id == id) return part;
    }
  }
  return null;
}
