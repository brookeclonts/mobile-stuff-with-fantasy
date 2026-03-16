import 'package:flutter/material.dart';
import 'package:swf_app/src/theme/swf_colors.dart';

/// Parchment-styled RPG character sheet with stat rows and ornamental dividers.
class CharacterSheet extends StatelessWidget {
  const CharacterSheet({
    super.key,
    required this.name,
    required this.guild,
    required this.rank,
    required this.questsCompleted,
    required this.questsTotal,
    required this.relicsCollected,
    required this.relicsTotal,
    required this.signal,
    this.accentColor,
  });

  final String name;
  final String guild;
  final String rank;
  final int questsCompleted;
  final int questsTotal;
  final int relicsCollected;
  final int relicsTotal;
  final String signal;
  final Color? accentColor;

  static const _parchment = Color(0xFFF4F0E8);
  static const _inkDark = Color(0xFF2A1F1A);
  static const _inkMedium = Color(0xFF5C4F42);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                  'CHARACTER SHEET',
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
                _StatRow(label: 'Name', value: name),
                _StatDivider(),
                _StatRow(label: 'Guild', value: guild),
                _StatDivider(),
                _StatRow(label: 'Rank', value: rank),
                _StatDivider(),
                _StatRow(
                  label: 'Quests',
                  value: '$questsCompleted / $questsTotal',
                ),
                _StatDivider(),
                _StatRow(
                  label: 'Relics',
                  value: '$relicsCollected / $relicsTotal',
                ),
                _StatDivider(),
                _StatRow(label: 'Signal', value: signal),
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
