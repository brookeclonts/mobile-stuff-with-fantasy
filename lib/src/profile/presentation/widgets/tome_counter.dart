import 'package:flutter/material.dart';
import 'package:swf_app/l10n/app_localizations.dart';
import 'package:swf_app/src/profile/models/reading_stats.dart';

/// Three stat cards: tomes conquered, pages turned, time in realm.
class TomeCounter extends StatelessWidget {
  const TomeCounter({
    super.key,
    required this.stats,
    required this.accentColor,
  });

  final ReadingStats stats;
  final Color accentColor;

  String _formatTime(int totalSeconds, AppLocalizations l10n) {
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    if (hours > 0) return l10n.tomeCounterHoursMinutes(hours, minutes);
    return l10n.tomeCounterMinutes(minutes);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2235),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: accentColor.withAlpha(60),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withAlpha(20),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
        child: Row(
          children: [
            _StatCard(
              icon: Icons.menu_book_rounded,
              value: '${stats.totalBooksCompleted}',
              label: l10n.tomeCounterBooks,
              accentColor: accentColor,
            ),
            _Divider(accentColor: accentColor),
            _StatCard(
              icon: Icons.import_contacts_rounded,
              value: '~${stats.estimatedPages}',
              label: l10n.tomeCounterPages,
              accentColor: accentColor,
            ),
            _Divider(accentColor: accentColor),
            _StatCard(
              icon: Icons.schedule_rounded,
              value: _formatTime(stats.totalReadingSeconds, l10n),
              label: l10n.tomeCounterTime,
              accentColor: accentColor,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.accentColor,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 24, color: accentColor.withAlpha(180)),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: theme.textTheme.labelSmall?.copyWith(
              color: Colors.white.withAlpha(140),
              fontSize: 10,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider({required this.accentColor});
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 48,
      color: accentColor.withAlpha(40),
    );
  }
}
