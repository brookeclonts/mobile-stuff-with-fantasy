import 'package:flutter/material.dart';
import 'package:swf_app/l10n/app_localizations.dart';
import 'package:swf_app/src/profile/models/quest_campaign.dart';


/// A 2×2 grid of stone alcoves displaying earned relics.
///
/// Unlocked relics glow on their pedestal with the role accent.
/// Locked relics appear as shadowy silhouettes.
class RelicVault extends StatelessWidget {
  const RelicVault({
    super.key,
    required this.campaign,
    required this.unlockedRewardIds,
  });

  final QuestCampaign campaign;
  final Set<String> unlockedRewardIds;

  @override
  Widget build(BuildContext context) {
    final rewards = <QuestReward>[
      ...campaign.scrolls.map((scroll) => scroll.reward),
      if (campaign.finalReward != null) campaign.finalReward!,
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.1,
        ),
        itemCount: rewards.length,
        itemBuilder: (context, index) {
          final reward = rewards[index];
          final isUnlocked = unlockedRewardIds.contains(reward.id);
          final isFinal = campaign.finalReward?.id == reward.id;

          return _VaultAlcove(
            reward: reward,
            accentColor: campaign.accentColor,
            isUnlocked: isUnlocked,
            isFinalReward: isFinal,
          );
        },
      ),
    );
  }
}

class _VaultAlcove extends StatelessWidget {
  const _VaultAlcove({
    required this.reward,
    required this.accentColor,
    required this.isUnlocked,
    required this.isFinalReward,
  });

  final QuestReward reward;
  final Color accentColor;
  final bool isUnlocked;
  final bool isFinalReward;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isUnlocked
            ? const Color(0xFF2A2235)
            : const Color(0xFF1E1A24),
        border: Border.all(
          color: isUnlocked
              ? accentColor.withAlpha(120)
              : Colors.white.withAlpha(35),
          width: isUnlocked ? 1.5 : 1,
        ),
        boxShadow: isUnlocked
            ? [
                BoxShadow(
                  color: accentColor.withAlpha(30),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Stack(
        children: [
          // Glow effect for unlocked relics
          if (isUnlocked)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 0.7,
                    colors: [
                      accentColor.withAlpha(25),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Pedestal icon
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isUnlocked
                        ? accentColor.withAlpha(35)
                        : Colors.white.withAlpha(15),
                    border: Border.all(
                      color: isUnlocked
                          ? accentColor.withAlpha(100)
                          : Colors.white.withAlpha(40),
                      width: 1.5,
                    ),
                    boxShadow: isUnlocked
                        ? [
                            BoxShadow(
                              color: accentColor.withAlpha(40),
                              blurRadius: 12,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                  child: Icon(
                    isUnlocked ? reward.icon : Icons.help_outline_rounded,
                    size: 24,
                    color: isUnlocked
                        ? accentColor
                        : Colors.white.withAlpha(70),
                  ),
                ),

                const SizedBox(height: 12),

                // Title
                Text(
                  isUnlocked ? reward.title : l10n.relicVaultLockedTitle,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: isUnlocked
                        ? Colors.white.withAlpha(230)
                        : Colors.white.withAlpha(100),
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 4),

                // Status
                Text(
                  isUnlocked
                      ? (isFinalReward ? l10n.relicVaultLegendRelic : l10n.relicVaultClaimed)
                      : l10n.relicVaultSealed,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isUnlocked
                        ? accentColor.withAlpha(180)
                        : Colors.white.withAlpha(70),
                    fontSize: 10,
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
