import 'package:flutter/material.dart';
import 'package:swf_app/l10n/app_localizations.dart';
import 'package:swf_app/src/profile/data/achievement_compendium.dart'
    as compendium;
import 'package:swf_app/src/profile/models/achievement.dart';
import 'package:swf_app/src/profile/models/reading_stats.dart';

/// Grid of achievement badges with locked/unlocked states and tier colors.
class AchievementSigils extends StatelessWidget {
  const AchievementSigils({
    super.key,
    required this.stats,
    required this.accentColor,
  });

  final ReadingStats stats;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final all = compendium.achievements(l10n);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.85,
        ),
        itemCount: all.length,
        itemBuilder: (context, index) {
          final achievement = all[index];
          final unlocked = achievement.isUnlocked(stats);
          return _AchievementSigil(
            achievement: achievement,
            unlocked: unlocked,
            onTap: () => _showDetail(context, achievement, unlocked),
          );
        },
      ),
    );
  }

  void _showDetail(
    BuildContext context,
    Achievement achievement,
    bool unlocked,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final tierColor = Color(achievement.tier.colorValue);

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF2A2235),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: unlocked
                      ? tierColor.withAlpha(30)
                      : Colors.white.withAlpha(10),
                  border: Border.all(
                    color: unlocked
                        ? tierColor.withAlpha(160)
                        : Colors.white.withAlpha(30),
                    width: 2,
                  ),
                ),
                child: Icon(
                  unlocked ? achievement.icon : Icons.lock_rounded,
                  size: 28,
                  color: unlocked
                      ? tierColor
                      : Colors.white.withAlpha(60),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                achievement.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                achievement.description,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withAlpha(170),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: unlocked
                      ? tierColor.withAlpha(30)
                      : Colors.white.withAlpha(10),
                ),
                child: Text(
                  unlocked
                      ? l10n.achievementUnlocked
                      : l10n.achievementLocked,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: unlocked
                        ? tierColor
                        : Colors.white.withAlpha(100),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AchievementSigil extends StatelessWidget {
  const _AchievementSigil({
    required this.achievement,
    required this.unlocked,
    required this.onTap,
  });

  final Achievement achievement;
  final bool unlocked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tierColor = Color(achievement.tier.colorValue);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: unlocked
              ? const Color(0xFF2A2235)
              : const Color(0xFF1E1A24),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: unlocked
                ? tierColor.withAlpha(120)
                : Colors.white.withAlpha(25),
            width: 1.5,
          ),
          boxShadow: unlocked
              ? [
                  BoxShadow(
                    color: tierColor.withAlpha(30),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: unlocked
                    ? tierColor.withAlpha(25)
                    : Colors.white.withAlpha(8),
                border: Border.all(
                  color: unlocked
                      ? tierColor.withAlpha(100)
                      : Colors.white.withAlpha(20),
                ),
              ),
              child: Icon(
                unlocked ? achievement.icon : Icons.lock_rounded,
                size: 22,
                color: unlocked
                    ? tierColor
                    : Colors.white.withAlpha(50),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                achievement.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: unlocked
                      ? Colors.white.withAlpha(220)
                      : Colors.white.withAlpha(60),
                  fontWeight: unlocked ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
