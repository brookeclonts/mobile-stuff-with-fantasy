import 'package:flutter/material.dart';
import 'package:swf_app/src/profile/models/quest_campaign.dart';
import 'package:swf_app/src/theme/swf_colors.dart';

/// The unauthenticated guild hall — shows campaign previews and a CTA
/// to create an account. Styled to match the dark guild hall aesthetic.
class GuestGuildState extends StatelessWidget {
  const GuestGuildState({
    super.key,
    required this.campaigns,
    required this.onCreateAccount,
  });

  final List<QuestCampaign> campaigns;
  final VoidCallback onCreateAccount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
      children: [
        // Hero banner
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [SwfColors.brandDark, SwfColors.primaryBackground],
            ),
            border: Border.all(
              color: SwfColors.secondaryAccent.withAlpha(80),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.shield_rounded,
                    size: 20,
                    color: SwfColors.secondaryAccent,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'GUILD HALL',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: SwfColors.secondaryAccent,
                      letterSpacing: 2.0,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                'Choose your path',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Every guild has its own quests, ranks, and relics. '
                'Pick a role and begin your journey through the realm.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withAlpha(180),
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onCreateAccount,
                  child: const Text('Create account to begin'),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Campaign previews
        ...campaigns.map(
          (campaign) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _CampaignPreviewCard(campaign: campaign),
          ),
        ),
      ],
    );
  }
}

class _CampaignPreviewCard extends StatelessWidget {
  const _CampaignPreviewCard({required this.campaign});

  final QuestCampaign campaign;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFF2A2235),
        border: Border.all(
          color: campaign.accentColor.withAlpha(50),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: campaign.accentColor.withAlpha(40),
                  border: Border.all(
                    color: campaign.accentColor.withAlpha(100),
                  ),
                ),
                child: Icon(
                  _roleIcon(campaign.role),
                  size: 16,
                  color: Colors.white.withAlpha(220),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  campaign.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white.withAlpha(220),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            campaign.headline,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white.withAlpha(180),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: campaign.rankTitles
                .map(
                  (rank) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: campaign.accentColor.withAlpha(35),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: campaign.accentColor.withAlpha(90),
                      ),
                    ),
                    child: Text(
                      rank,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.white.withAlpha(200),
                        fontSize: 10,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  static IconData _roleIcon(String role) {
    return switch (role) {
      'author' => Icons.edit_note_rounded,
      'influencer' => Icons.campaign_rounded,
      _ => Icons.auto_stories_rounded,
    };
  }
}
