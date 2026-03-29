import 'package:flutter/material.dart';
import 'package:swf_app/l10n/app_localizations.dart';
import 'package:swf_app/src/profile/models/quest_campaign.dart';

/// A subsection for the relic vault showing seasonal relics with a countdown.
///
/// Uses a 2-column grid matching the permanent relic vault layout, but adds
/// a seasonal accent border and section header with remaining time.
class SeasonalRelicSection extends StatelessWidget {
  const SeasonalRelicSection({
    super.key,
    required this.campaign,
    required this.unlockedRewardIds,
  });

  final QuestCampaign campaign;
  final Set<String> unlockedRewardIds;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final rewards = <QuestReward>[
      ...campaign.scrolls.map((scroll) => scroll.reward),
      if (campaign.finalReward != null) campaign.finalReward!,
    ];

    if (rewards.isEmpty) return const SizedBox.shrink();

    final countdownText = campaign.endDate != null
        ? _formatCountdown(campaign.endDate!, l10n)
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(
            children: [
              Icon(
                Icons.auto_awesome_rounded,
                size: 16,
                color: campaign.accentColor,
              ),
              const SizedBox(width: 8),
              Text(
                l10n.seasonalRelicSectionTitle.toUpperCase(),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: campaign.accentColor,
                  letterSpacing: 1.5,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (countdownText != null) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: campaign.accentColor.withAlpha(20),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: campaign.accentColor.withAlpha(60),
                    ),
                  ),
                  child: Text(
                    countdownText,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: campaign.accentColor,
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),

        // Grid
        Padding(
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

              return _SeasonalAlcove(
                reward: reward,
                accentColor: campaign.accentColor,
                isUnlocked: isUnlocked,
                isFinalReward: isFinal,
              );
            },
          ),
        ),
      ],
    );
  }

  String _formatCountdown(DateTime endDate, AppLocalizations l10n) {
    final now = DateTime.now();
    if (now.isAfter(endDate)) return l10n.seasonalCampaignExpired;

    final diff = endDate.difference(now);
    final days = diff.inDays;

    if (days > 0) {
      return l10n.seasonalCampaignCountdownDays(days);
    }
    return l10n.seasonalCampaignLastDay;
  }
}

class _SeasonalAlcove extends StatelessWidget {
  const _SeasonalAlcove({
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
        color: isUnlocked ? const Color(0xFF2A2235) : const Color(0xFF1E1A24),
        border: Border.all(
          color: isUnlocked
              ? accentColor.withAlpha(120)
              : accentColor.withAlpha(40),
          width: isUnlocked ? 1.5 : 1,
        ),
        boxShadow: isUnlocked
            ? <BoxShadow>[
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
          // Glow for unlocked
          if (isUnlocked)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 0.7,
                    colors: <Color>[
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
                        ? <BoxShadow>[
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
                Text(
                  isUnlocked
                      ? (isFinalReward
                          ? l10n.relicVaultLegendRelic
                          : l10n.relicVaultClaimed)
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
