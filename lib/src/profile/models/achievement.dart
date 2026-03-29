import 'package:flutter/widgets.dart';
import 'package:swf_app/src/profile/models/reading_stats.dart';

class Achievement {
  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.tier,
    required this.isUnlocked,
  });

  final String id;
  final String title;
  final String description;
  final IconData icon;
  final AchievementTier tier;
  final bool Function(ReadingStats stats) isUnlocked;
}

enum AchievementTier {
  bronze,
  silver,
  gold;

  /// Display color per tier.
  int get colorValue => switch (this) {
        AchievementTier.bronze => 0xFFBC8D60,
        AchievementTier.silver => 0xFFC0C0C0,
        AchievementTier.gold => 0xFFF3BD75,
      };
}
