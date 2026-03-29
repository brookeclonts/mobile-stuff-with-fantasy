import 'package:flutter/material.dart';
import 'package:swf_app/l10n/app_localizations.dart';
import 'package:swf_app/src/profile/models/quest_campaign.dart';
import 'package:swf_app/src/theme/swf_colors.dart';

/// A gradient banner card displayed above the quest log when a seasonal
/// campaign is active. Shows the campaign name, countdown, progress bar,
/// and expands to reveal the seasonal quest scrolls.
class SeasonalCampaignBanner extends StatelessWidget {
  const SeasonalCampaignBanner({
    super.key,
    required this.campaign,
    required this.completedObjectiveCount,
    required this.totalObjectiveCount,
    required this.isExpanded,
    required this.onToggleExpand,
  });

  final QuestCampaign campaign;
  final int completedObjectiveCount;
  final int totalObjectiveCount;
  final bool isExpanded;
  final VoidCallback onToggleExpand;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final progress = totalObjectiveCount > 0
        ? completedObjectiveCount / totalObjectiveCount
        : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: campaign.heroGradient.isNotEmpty
                ? campaign.heroGradient
                : <Color>[
                    SwfColors.secondaryAccent,
                    SwfColors.orange,
                  ],
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: campaign.accentColor.withAlpha(50),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onToggleExpand,
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header row: icon + title + chevron
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withAlpha(35),
                        ),
                        child: const Icon(
                          Icons.auto_awesome_rounded,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.seasonalCampaignLabel.toUpperCase(),
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: Colors.white.withAlpha(200),
                                letterSpacing: 1.5,
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              campaign.title,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      AnimatedRotation(
                        duration: const Duration(milliseconds: 200),
                        turns: isExpanded ? 0.5 : 0,
                        child: Icon(
                          Icons.expand_more_rounded,
                          color: Colors.white.withAlpha(200),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Countdown text
                  if (campaign.endDate != null)
                    Text(
                      _formatCountdown(campaign.endDate!, l10n),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withAlpha(220),
                      ),
                    ),

                  const SizedBox(height: 10),

                  // Progress bar
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 6,
                            backgroundColor: Colors.white.withAlpha(50),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '$completedObjectiveCount / $totalObjectiveCount',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white.withAlpha(220),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatCountdown(DateTime endDate, AppLocalizations l10n) {
    final now = DateTime.now();
    if (now.isAfter(endDate)) return l10n.seasonalCampaignExpired;

    final diff = endDate.difference(now);
    final days = diff.inDays;
    final months = days ~/ 30;
    final remainingDays = days % 30;

    if (months > 0 && remainingDays > 0) {
      return l10n.seasonalCampaignCountdownMonthsDays(months, remainingDays);
    } else if (months > 0) {
      return l10n.seasonalCampaignCountdownMonths(months);
    } else if (days > 0) {
      return l10n.seasonalCampaignCountdownDays(days);
    } else {
      return l10n.seasonalCampaignLastDay;
    }
  }
}
