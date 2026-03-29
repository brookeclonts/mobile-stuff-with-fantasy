import 'package:flutter/material.dart';
import 'package:swf_app/l10n/app_localizations.dart';
import 'package:swf_app/src/profile/data/rune_compendium.dart';
import 'package:swf_app/src/profile/models/skill_tree.dart';
import 'package:swf_app/src/theme/swf_colors.dart';

/// Shows the [SkillBranchSheet] bottom sheet for a single skill branch.
///
/// Displays the branch details, XP progress, and all tiers.
Future<void> showSkillBranchSheet(
  BuildContext context, {
  required SkillBranch branch,
  required Color accentColor,
  ValueChanged<String>? onRuneTapped,
}) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => _SkillBranchSheetContent(
      branch: branch,
      accentColor: accentColor,
      onRuneTapped: onRuneTapped,
    ),
  );
}

class _SkillBranchSheetContent extends StatelessWidget {
  const _SkillBranchSheetContent({
    required this.branch,
    required this.accentColor,
    this.onRuneTapped,
  });

  final SkillBranch branch;
  final Color accentColor;
  final ValueChanged<String>? onRuneTapped;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      decoration: const BoxDecoration(
        color: Color(0xFF2A2235),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20, top: 8),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(60),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Branch icon
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accentColor.withAlpha(25),
                border: Border.all(
                  color: accentColor.withAlpha(100),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: accentColor.withAlpha(30),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Icon(
                branch.icon,
                size: 24,
                color: accentColor,
              ),
            ),

            const SizedBox(height: 14),

            // Branch title
            Text(
              branch.title,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 4),

            // Genre label
            Text(
              branch.genreId.replaceAll('-', ' ').toUpperCase(),
              style: theme.textTheme.labelSmall?.copyWith(
                color: accentColor.withAlpha(180),
                letterSpacing: 1.5,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 20),

            // XP progress bar
            _XpProgressBar(
              currentXp: branch.currentXp,
              requiredXp: branch.requiredXp,
              accentColor: accentColor,
            ),

            const SizedBox(height: 8),

            // XP label
            Text(
              l10n.skillTreeXpProgress(branch.currentXp, branch.requiredXp),
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white.withAlpha(140),
              ),
            ),

            const SizedBox(height: 24),

            // Section label
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                l10n.skillTreeTiersLabel.toUpperCase(),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: SwfColors.secondaryAccent,
                  letterSpacing: 1.5,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Tier list
            for (int i = 0; i < branch.tiers.length; i++) ...[
              _TierRow(
                tier: branch.tiers[i],
                isCurrent: !branch.tiers[i].isUnlocked &&
                    (i == 0 || branch.tiers[i - 1].isUnlocked),
                accentColor: accentColor,
                onRuneTapped: onRuneTapped,
              ),
              if (i < branch.tiers.length - 1) const SizedBox(height: 10),
            ],
          ],
        ),
      ),
    );
  }
}

class _XpProgressBar extends StatelessWidget {
  const _XpProgressBar({
    required this.currentXp,
    required this.requiredXp,
    required this.accentColor,
  });

  final int currentXp;
  final int requiredXp;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final progress =
        requiredXp > 0 ? (currentXp / requiredXp).clamp(0.0, 1.0) : 0.0;

    return Container(
      height: 8,
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress,
        child: Container(
          decoration: BoxDecoration(
            color: accentColor,
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: accentColor.withAlpha(60),
                blurRadius: 6,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TierRow extends StatelessWidget {
  const _TierRow({
    required this.tier,
    required this.isCurrent,
    required this.accentColor,
    this.onRuneTapped,
  });

  final SkillTier tier;
  final bool isCurrent;
  final Color accentColor;
  final ValueChanged<String>? onRuneTapped;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    final statusColor = tier.isUnlocked
        ? accentColor
        : isCurrent
            ? accentColor.withAlpha(180)
            : Colors.white.withAlpha(50);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: tier.isUnlocked
            ? accentColor.withAlpha(12)
            : isCurrent
                ? accentColor.withAlpha(8)
                : Colors.white.withAlpha(6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: tier.isUnlocked
              ? accentColor.withAlpha(70)
              : isCurrent
                  ? accentColor.withAlpha(40)
                  : Colors.white.withAlpha(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Level badge
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: tier.isUnlocked
                      ? accentColor
                      : statusColor.withAlpha(20),
                  border: Border.all(color: statusColor, width: 1.5),
                ),
                child: Center(
                  child: tier.isUnlocked
                      ? const Icon(Icons.check_rounded,
                          size: 14, color: Colors.white)
                      : Text(
                          '${tier.level}',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: statusColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                          ),
                        ),
                ),
              ),

              const SizedBox(width: 12),

              // Title + status
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tier.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: tier.isUnlocked
                            ? Colors.white.withAlpha(230)
                            : isCurrent
                                ? Colors.white.withAlpha(200)
                                : Colors.white.withAlpha(120),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      tier.isUnlocked
                          ? l10n.skillTreeTierUnlocked
                          : isCurrent
                              ? l10n.skillTreeTierCurrent
                              : l10n.skillTreeTierLocked,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: statusColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),

              // XP requirement
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withAlpha(15),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  l10n.skillTreeXpLabel(tier.xpRequired),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Description
          Text(
            tier.description,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white.withAlpha(
                  tier.isUnlocked || isCurrent ? 150 : 90),
              height: 1.4,
            ),
          ),

          // Rune unlock badge
          if (tier.unlockedRuneId != null) ...[
            const SizedBox(height: 10),
            _RuneUnlockBadge(
              runeId: tier.unlockedRuneId!,
              isUnlocked: tier.isUnlocked,
              accentColor: accentColor,
              onTap: tier.isUnlocked
                  ? () => onRuneTapped?.call(tier.unlockedRuneId!)
                  : null,
            ),
          ],
        ],
      ),
    );
  }
}

class _RuneUnlockBadge extends StatelessWidget {
  const _RuneUnlockBadge({
    required this.runeId,
    required this.isUnlocked,
    required this.accentColor,
    this.onTap,
  });

  final String runeId;
  final bool isUnlocked;
  final Color accentColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    // Look up the rune title from the compendium
    final runes = runesForRole(null);
    final rune = runes.where((r) => r.id == runeId).firstOrNull;
    final runeTitle = rune?.title ?? runeId;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: isUnlocked
              ? accentColor.withAlpha(15)
              : Colors.white.withAlpha(6),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isUnlocked
                ? accentColor.withAlpha(60)
                : Colors.white.withAlpha(20),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isUnlocked
                  ? Icons.auto_awesome_rounded
                  : Icons.lock_outline_rounded,
              size: 14,
              color: isUnlocked
                  ? accentColor
                  : Colors.white.withAlpha(60),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                isUnlocked
                    ? l10n.skillTreeRuneUnlocked(runeTitle)
                    : l10n.skillTreeRuneLockedAt(runeTitle),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: isUnlocked
                      ? accentColor
                      : Colors.white.withAlpha(90),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (isUnlocked) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.chevron_right_rounded,
                size: 14,
                color: accentColor.withAlpha(150),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
