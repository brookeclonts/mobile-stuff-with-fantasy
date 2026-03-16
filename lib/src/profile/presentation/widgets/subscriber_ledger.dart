import 'package:flutter/material.dart';
import 'package:swf_app/src/profile/data/profile_repository.dart';
import 'package:swf_app/src/theme/swf_colors.dart';

/// Author-specific subscriber count panel styled as a guild hall ledger.
class SubscriberLedger extends StatelessWidget {
  const SubscriberLedger({
    super.key,
    required this.isUnlocked,
    required this.stats,
    required this.isLoading,
    this.errorMessage,
  });

  final bool isUnlocked;
  final SubscriberStats? stats;
  final bool isLoading;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayValue = switch ((isUnlocked, stats, isLoading)) {
      (true, final SubscriberStats stats, _) => '${stats.active}',
      (true, null, true) => '--',
      _ => '???',
    };
    final detailText = switch ((isUnlocked, isLoading, errorMessage, stats)) {
      (true, true, _, _) => 'Counting your active subscribers...',
      (true, false, final String error, _) => error,
      (true, false, _, final SubscriberStats stats) =>
        '${stats.confirmed} confirmed, ${stats.unsubscribed} unsubscribed, ${stats.total} total records',
      _ =>
        'Complete quests to reveal your live subscriber count and ledger tools.',
    };

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: const Color(0xFF2A2235),
        border: Border.all(
          color: SwfColors.secondaryAccent.withAlpha(80),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // Count display
          Container(
            width: 80,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(12),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withAlpha(35)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child: Text(
                    displayValue,
                    key: ValueKey<String>(displayValue),
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: isUnlocked
                          ? SwfColors.secondaryAccent
                          : Colors.white.withAlpha(120),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'followers',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.white.withAlpha(150),
                    fontSize: 9,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Subscriber Ledger',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: Colors.white.withAlpha(220),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: isUnlocked
                            ? SwfColors.secondaryAccent.withAlpha(25)
                            : Colors.white.withAlpha(15),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        isUnlocked ? 'Active' : 'Locked',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: isUnlocked
                              ? SwfColors.secondaryAccent
                              : Colors.white.withAlpha(130),
                          fontSize: 9,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  detailText,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withAlpha(180),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
