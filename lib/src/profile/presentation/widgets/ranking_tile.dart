import 'package:flutter/material.dart';
import 'package:swf_app/src/profile/models/leaderboard.dart';
import 'package:swf_app/src/theme/swf_colors.dart';

/// An individual leaderboard row styled as a dark RPG card.
///
/// Top-3 positions get gold/silver/bronze medal badges. The current user's
/// row receives an accent-colored glow border for visibility.
class RankingTile extends StatelessWidget {
  const RankingTile({
    super.key,
    required this.entry,
    this.accentColor,
  });

  final LeaderboardEntry entry;
  final Color? accentColor;

  static const _cardBg = Color(0xFF2A2235);
  static const _gold = Color(0xFFFFD700);
  static const _silver = Color(0xFFC0C0C0);
  static const _bronze = Color(0xFFCD7F32);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = accentColor ?? SwfColors.primaryButton;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(14),
        border: entry.isCurrentUser
            ? Border.all(color: accent.withAlpha(120), width: 1.5)
            : Border.all(color: Colors.white.withAlpha(12)),
        boxShadow: entry.isCurrentUser
            ? [
                BoxShadow(
                  color: accent.withAlpha(40),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          // Position badge
          _PositionBadge(position: entry.position),
          const SizedBox(width: 12),

          // Initials avatar
          _InitialsAvatar(
            name: entry.userName,
            accentColor: accent,
            isCurrentUser: entry.isCurrentUser,
          ),
          const SizedBox(width: 12),

          // Name + rank
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.userName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: entry.isCurrentUser
                        ? Colors.white
                        : Colors.white.withAlpha(220),
                    fontWeight: entry.isCurrentUser
                        ? FontWeight.w700
                        : FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  entry.rankTitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: accent.withAlpha(180),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          // Score
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: entry.isCurrentUser
                  ? accent.withAlpha(20)
                  : Colors.white.withAlpha(8),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: entry.isCurrentUser
                    ? accent.withAlpha(60)
                    : Colors.white.withAlpha(20),
              ),
            ),
            child: Text(
              '${entry.score}',
              style: theme.textTheme.labelMedium?.copyWith(
                color: entry.isCurrentUser
                    ? accent
                    : Colors.white.withAlpha(180),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PositionBadge extends StatelessWidget {
  const _PositionBadge({required this.position});

  final int position;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (position <= 3) {
      final color = switch (position) {
        1 => RankingTile._gold,
        2 => RankingTile._silver,
        _ => RankingTile._bronze,
      };

      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withAlpha(25),
          border: Border.all(color: color.withAlpha(160), width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withAlpha(40),
              blurRadius: 8,
            ),
          ],
        ),
        child: Center(
          child: Text(
            '$position',
            style: theme.textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: 32,
      child: Center(
        child: Text(
          '$position',
          style: theme.textTheme.labelMedium?.copyWith(
            color: Colors.white.withAlpha(120),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _InitialsAvatar extends StatelessWidget {
  const _InitialsAvatar({
    required this.name,
    required this.accentColor,
    required this.isCurrentUser,
  });

  final String name;
  final Color accentColor;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final initials = name
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part.substring(0, 1))
        .join()
        .toUpperCase();

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCurrentUser
            ? accentColor.withAlpha(20)
            : Colors.white.withAlpha(8),
        border: Border.all(
          color: isCurrentUser
              ? accentColor.withAlpha(80)
              : Colors.white.withAlpha(30),
          width: 1.5,
        ),
      ),
      child: Center(
        child: Text(
          initials.isEmpty ? '?' : initials,
          style: theme.textTheme.labelMedium?.copyWith(
            color: isCurrentUser
                ? accentColor
                : Colors.white.withAlpha(160),
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
