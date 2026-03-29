import 'package:flutter/material.dart';
import 'package:swf_app/l10n/app_localizations.dart';
import 'package:swf_app/src/profile/models/quest_campaign.dart';


/// Shows the reward reveal dialog with ceremony animation.
Future<void> showRewardReveal(
  BuildContext context, {
  required QuestReward reward,
  required Color accentColor,
  required bool isGrandReward,
}) {
  final l10n = AppLocalizations.of(context)!;

  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: l10n.rewardRevealBarrierLabel,
    barrierColor: Colors.black87,
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (_, _, _) => _RewardRevealDialog(
      reward: reward,
      accentColor: accentColor,
      isGrandReward: isGrandReward,
    ),
    transitionBuilder: (_, animation, _, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutBack,
        reverseCurve: Curves.easeIn,
      );
      return FadeTransition(
        opacity: animation,
        child: ScaleTransition(scale: curved, child: child),
      );
    },
  );
}

class _RewardRevealDialog extends StatelessWidget {
  const _RewardRevealDialog({
    required this.reward,
    required this.accentColor,
    required this.isGrandReward,
  });

  final QuestReward reward;
  final Color accentColor;
  final bool isGrandReward;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.fromLTRB(28, 32, 28, 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: const Color(0xFF2A2235),
              border: Border.all(
                color: accentColor.withAlpha(100),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: accentColor.withAlpha(40),
                  blurRadius: 40,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Glowing relic icon
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.7, end: 1),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.elasticOut,
                  builder: (context, scale, child) {
                    return Transform.scale(scale: scale, child: child);
                  },
                  child: Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: accentColor.withAlpha(30),
                      border: Border.all(
                        color: accentColor.withAlpha(80),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: accentColor.withAlpha(50),
                          blurRadius: 24,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: Icon(
                      reward.icon,
                      size: 40,
                      color: accentColor,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  isGrandReward
                      ? l10n.rewardRevealLegendRelicClaimed
                      : l10n.rewardRevealRelicUnlocked,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: accentColor,
                    letterSpacing: 2.0,
                    fontSize: 11,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  reward.title,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  reward.description,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withAlpha(180),
                    height: 1.45,
                  ),
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(l10n.rewardRevealContinue),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
