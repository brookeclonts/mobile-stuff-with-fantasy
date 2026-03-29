import 'package:flutter/material.dart';
import 'package:swf_app/l10n/app_localizations.dart';
import 'package:swf_app/src/theme/swf_colors.dart';

/// Step 2: Ask what else brings them here (author / influencer).
///
/// Everyone signs up as a reader — this captures interest signals
/// for future use without affecting the assigned role.
class InterestStep extends StatelessWidget {
  const InterestStep({
    super.key,
    required this.selectedInterests,
    required this.onToggle,
    required this.onContinue,
  });

  final Set<String> selectedInterests;
  final ValueChanged<String> onToggle;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 32),
          Text(
            l10n.interestStepHeadline,
            style: theme.textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.interestStepSubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          _InterestCard(
            title: l10n.interestCardAuthorTitle,
            description: l10n.interestCardAuthorDescription,
            icon: Icons.edit_note_rounded,
            isSelected: selectedInterests.contains('author'),
            onTap: () => onToggle('author'),
          ),
          const SizedBox(height: 14),
          _InterestCard(
            title: l10n.interestCardInfluencerTitle,
            description: l10n.interestCardInfluencerDescription,
            icon: Icons.campaign_rounded,
            isSelected: selectedInterests.contains('influencer'),
            onTap: () => onToggle('influencer'),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onContinue,
              child: Text(l10n.interestStepContinue),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _InterestCard extends StatelessWidget {
  const _InterestCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final String description;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isSelected ? SwfColors.color4.withAlpha(12) : Colors.white,
          border: Border.all(
            color: isSelected ? SwfColors.color4 : SwfColors.color5,
            width: isSelected ? 2 : 1.5,
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: isSelected
                    ? SwfColors.color4.withAlpha(25)
                    : SwfColors.color5.withAlpha(120),
              ),
              child: Icon(
                icon,
                color: isSelected ? SwfColors.color4 : SwfColors.color1,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? SwfColors.color4 : Colors.transparent,
                border: Border.all(
                  color: isSelected ? SwfColors.color4 : SwfColors.color5,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check_rounded,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
