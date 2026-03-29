import 'package:flutter/material.dart';

/// A skill tree representing genre-based progression branches.
///
/// Each branch corresponds to a fantasy genre and contains tiers
/// that unlock as the user gains XP through reading and questing.
class SkillTree {
  const SkillTree({
    required this.branches,
    required this.totalXp,
  });

  final List<SkillBranch> branches;
  final int totalXp;

  factory SkillTree.fromJson(Map<String, dynamic> json) {
    return SkillTree(
      branches: (json['branches'] as List<dynamic>)
          .map((b) => SkillBranch.fromJson(b as Map<String, dynamic>))
          .toList(),
      totalXp: json['totalXp'] as int? ?? 0,
    );
  }
}

/// A single genre branch within the skill tree.
class SkillBranch {
  const SkillBranch({
    required this.id,
    required this.genreId,
    required this.title,
    required this.icon,
    required this.tiers,
    required this.currentXp,
    required this.requiredXp,
  });

  final String id;
  final String genreId;
  final String title;
  final IconData icon;
  final List<SkillTier> tiers;
  final int currentXp;

  /// XP needed for the next tier unlock.
  final int requiredXp;

  factory SkillBranch.fromJson(Map<String, dynamic> json) {
    return SkillBranch(
      id: json['id'] as String,
      genreId: json['genreId'] as String,
      title: json['title'] as String,
      icon: _iconMap[json['icon'] as String? ?? ''] ?? Icons.help_outline,
      tiers: (json['tiers'] as List<dynamic>)
          .map((t) => SkillTier.fromJson(t as Map<String, dynamic>))
          .toList(),
      currentXp: json['currentXp'] as int? ?? 0,
      requiredXp: json['requiredXp'] as int? ?? 0,
    );
  }

  static const _iconMap = <String, IconData>{
    'auto_stories': Icons.auto_stories,
    'favorite': Icons.favorite,
    'dark_mode': Icons.dark_mode,
    'location_city': Icons.location_city,
    'castle': Icons.castle,
    'shield': Icons.shield_rounded,
    'auto_awesome': Icons.auto_awesome_rounded,
    'notifications_active': Icons.notifications_active_rounded,
  };
}

/// A single tier within a skill branch.
class SkillTier {
  const SkillTier({
    required this.id,
    required this.level,
    required this.title,
    required this.description,
    required this.xpRequired,
    required this.isUnlocked,
    this.unlockedRuneId,
  });

  final String id;
  final int level;
  final String title;
  final String description;
  final int xpRequired;
  final bool isUnlocked;

  /// Links to an [AbilityRune] if this tier unlocks one.
  final String? unlockedRuneId;

  factory SkillTier.fromJson(Map<String, dynamic> json) {
    return SkillTier(
      id: json['id'] as String,
      level: json['level'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      xpRequired: json['xpRequired'] as int,
      isUnlocked: json['isUnlocked'] as bool? ?? false,
      unlockedRuneId: json['unlockedRuneId'] as String?,
    );
  }
}
