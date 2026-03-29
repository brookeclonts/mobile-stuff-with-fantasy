import 'package:flutter/material.dart';
import 'package:swf_app/l10n/app_localizations.dart';
import 'package:swf_app/src/theme/swf_colors.dart';

/// Parchment-styled RPG character sheet with stat rows and ornamental dividers.
class CharacterSheet extends StatelessWidget {
  const CharacterSheet({
    super.key,
    required this.name,
    required this.rank,
    required this.questsCompleted,
    required this.questsTotal,
    required this.relicsCollected,
    required this.relicsTotal,
    required this.signal,
    this.customTitle,
    this.accentColor,
    this.realmRankPosition,
    this.realmRankTotal,
    this.isLeaderboardOptedIn = false,
    this.onJoinLeaderboard,
  });

  final String name;
  final String rank;
  final int questsCompleted;
  final int questsTotal;
  final int relicsCollected;
  final int relicsTotal;
  final String signal;

  /// Optional custom title (e.g. "Keeper of Cozy Fantasy").
  final String? customTitle;

  final Color? accentColor;

  /// Current user's position on the leaderboard (null if not opted in).
  final int? realmRankPosition;

  /// Total participants in the leaderboard.
  final int? realmRankTotal;

  /// Whether the user is opted in to the leaderboard.
  final bool isLeaderboardOptedIn;

  /// Called when the user taps "Join" on the realm rank row.
  final VoidCallback? onJoinLeaderboard;

  static const _parchment = Color(0xFFF4F0E8);
  static const _inkDark = Color(0xFF2A1F1A);
  static const _inkMedium = Color(0xFF5C4F42);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final accent = accentColor ?? SwfColors.secondaryAccent;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: _parchment,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: SwfColors.secondaryAccent.withAlpha(80),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: SwfColors.secondaryAccent.withAlpha(50),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _OrnamentDot(color: accent),
                const SizedBox(width: 12),
                Text(
                  l10n.characterSheetHeaderLabel,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: SwfColors.secondaryAccent,
                    letterSpacing: 2.5,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(width: 12),
                _OrnamentDot(color: accent),
              ],
            ),
          ),

          // Stats
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
            child: Column(
              children: [
                _StatRow(label: l10n.characterSheetStatName, value: name),
                _StatDivider(),
                if (customTitle != null) ...[
                  _StatRow(label: 'Title', value: customTitle!),
                  _StatDivider(),
                ],
                _StatRow(label: l10n.characterSheetStatRank, value: rank),
                _StatDivider(),
                _StatRow(
                  label: l10n.characterSheetStatQuests,
                  value: '$questsCompleted / $questsTotal',
                ),
                _StatDivider(),
                _StatRow(
                  label: l10n.characterSheetStatRelics,
                  value: '$relicsCollected / $relicsTotal',
                ),
                _StatDivider(),
                _RealmRankRow(
                  label: l10n.characterSheetStatRealmRank,
                  position: realmRankPosition,
                  total: realmRankTotal,
                  isOptedIn: isLeaderboardOptedIn,
                  accentColor: accent,
                  onJoin: onJoinLeaderboard,
                  joinLabel: l10n.characterSheetRealmRankJoin,
                ),
                _StatDivider(),
                _StatRow(label: l10n.characterSheetStatSignal, value: signal),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: CharacterSheet._inkMedium,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: CharacterSheet._inkDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: SwfColors.secondaryAccent.withAlpha(25),
    );
  }
}

class _RealmRankRow extends StatelessWidget {
  const _RealmRankRow({
    required this.label,
    required this.position,
    required this.total,
    required this.isOptedIn,
    required this.accentColor,
    required this.joinLabel,
    this.onJoin,
  });

  final String label;
  final int? position;
  final int? total;
  final bool isOptedIn;
  final Color accentColor;
  final String joinLabel;
  final VoidCallback? onJoin;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final String valueText;
    if (isOptedIn && position != null && total != null) {
      valueText = '#$position of ${_formatNumber(total!)}';
    } else {
      valueText = '';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: CharacterSheet._inkMedium,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Expanded(
            child: isOptedIn && valueText.isNotEmpty
                ? Text(
                    valueText,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: CharacterSheet._inkDark,
                    ),
                  )
                : GestureDetector(
                    onTap: onJoin,
                    child: Text(
                      joinLabel,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: accentColor,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                        decorationColor: accentColor,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(int n) {
    if (n >= 1000) {
      final thousands = n ~/ 1000;
      final remainder = n % 1000;
      return '$thousands,${remainder.toString().padLeft(3, '0')}';
    }
    return n.toString();
  }
}

class _OrnamentDot extends StatelessWidget {
  const _OrnamentDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 0.785398, // 45 degrees
      child: Container(
        width: 6,
        height: 6,
        color: color.withAlpha(150),
      ),
    );
  }
}
