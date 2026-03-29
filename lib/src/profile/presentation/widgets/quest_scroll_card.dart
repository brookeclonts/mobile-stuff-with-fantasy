import 'package:flutter/material.dart';
import 'package:swf_app/l10n/app_localizations.dart';
import 'package:swf_app/src/profile/models/quest_campaign.dart';
import 'package:swf_app/src/theme/swf_colors.dart';

/// The state of a quest scroll in the journal.
enum ScrollState { sealed, active, locked }

/// A quest scroll card that visually changes based on its state:
/// - **Sealed**: completed, rolled up with a wax seal
/// - **Active**: unfurled, showing objectives and reward
/// - **Locked**: future quest, greyed out with chain icon
class QuestScrollCard extends StatelessWidget {
  const QuestScrollCard({
    super.key,
    required this.scroll,
    required this.scrollState,
    required this.accentColor,
    required this.borderColor,
    required this.parchmentColor,
    required this.completedObjectiveIds,
    required this.onToggleObjective,
    required this.isExpanded,
    required this.onToggleExpand,
  });

  final QuestScroll scroll;
  final ScrollState scrollState;
  final Color accentColor;
  final Color borderColor;
  final Color parchmentColor;
  final Set<String> completedObjectiveIds;
  final ValueChanged<QuestObjective> onToggleObjective;
  final bool isExpanded;
  final VoidCallback onToggleExpand;

  static const _inkDark = Color(0xFF2A1F1A);

  @override
  Widget build(BuildContext context) {
    return switch (scrollState) {
      ScrollState.sealed => _SealedScroll(
          scroll: scroll,
          accentColor: accentColor,
          borderColor: borderColor,
          isExpanded: isExpanded,
          onToggleExpand: onToggleExpand,
          completedObjectiveIds: completedObjectiveIds,
        ),
      ScrollState.active => _ActiveScroll(
          scroll: scroll,
          accentColor: accentColor,
          borderColor: borderColor,
          parchmentColor: parchmentColor,
          completedObjectiveIds: completedObjectiveIds,
          onToggleObjective: onToggleObjective,
        ),
      ScrollState.locked => _LockedScroll(
          scroll: scroll,
          accentColor: accentColor,
          onToggleExpand: onToggleExpand,
          isExpanded: isExpanded,
          completedObjectiveIds: completedObjectiveIds,
          onToggleObjective: onToggleObjective,
        ),
    };
  }
}

// ---------------------------------------------------------------------------
// SEALED scroll — completed, rolled up tight
// ---------------------------------------------------------------------------
class _SealedScroll extends StatelessWidget {
  const _SealedScroll({
    required this.scroll,
    required this.accentColor,
    required this.borderColor,
    required this.isExpanded,
    required this.onToggleExpand,
    required this.completedObjectiveIds,
  });

  final QuestScroll scroll;
  final Color accentColor;
  final Color borderColor;
  final bool isExpanded;
  final VoidCallback onToggleExpand;
  final Set<String> completedObjectiveIds;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFFF4F0E8),
        border: Border.all(color: accentColor.withAlpha(100), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: accentColor.withAlpha(25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onToggleExpand,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                child: Row(
                  children: [
                    // Wax seal icon
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: accentColor,
                        boxShadow: [
                          BoxShadow(
                            color: accentColor.withAlpha(50),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.verified_rounded,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            scroll.chapterLabel.toUpperCase(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: accentColor,
                              letterSpacing: 1.5,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            scroll.title,
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: QuestScrollCard._inkDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: accentColor.withAlpha(18),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: accentColor.withAlpha(60)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_rounded,
                            size: 12,
                            color: accentColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            l10n.questScrollSealed,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: accentColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    AnimatedRotation(
                      duration: const Duration(milliseconds: 200),
                      turns: isExpanded ? 0.5 : 0,
                      child: Icon(
                        Icons.expand_more_rounded,
                        size: 20,
                        color: QuestScrollCard._inkDark.withAlpha(120),
                      ),
                    ),
                  ],
                ),
              ),
              // Expanded: show completed objectives
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 250),
                crossFadeState: isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                firstChild: const SizedBox(width: double.infinity),
                secondChild: _SealedExpandedContent(
                  scroll: scroll,
                  accentColor: accentColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SealedExpandedContent extends StatelessWidget {
  const _SealedExpandedContent({
    required this.scroll,
    required this.accentColor,
  });

  final QuestScroll scroll;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 1,
            color: SwfColors.secondaryAccent.withAlpha(30),
          ),
          const SizedBox(height: 12),
          ...scroll.objectives.map(
            (obj) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Icon(Icons.check_circle, size: 16, color: accentColor),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      obj.title,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: QuestScrollCard._inkDark.withAlpha(150),
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Reward
          Row(
            children: [
              Icon(scroll.reward.icon, size: 16, color: accentColor),
              const SizedBox(width: 8),
              Text(
                scroll.reward.title,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: accentColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// ACTIVE scroll — unfurled, showing full objectives
// ---------------------------------------------------------------------------
class _ActiveScroll extends StatelessWidget {
  const _ActiveScroll({
    required this.scroll,
    required this.accentColor,
    required this.borderColor,
    required this.parchmentColor,
    required this.completedObjectiveIds,
    required this.onToggleObjective,
  });

  final QuestScroll scroll;
  final Color accentColor;
  final Color borderColor;
  final Color parchmentColor;
  final Set<String> completedObjectiveIds;
  final ValueChanged<QuestObjective> onToggleObjective;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final doneCount = scroll.objectives
        .where((obj) => completedObjectiveIds.contains(obj.id))
        .length;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: parchmentColor,
        border: Border.all(color: borderColor.withAlpha(120), width: 2),
        boxShadow: [
          BoxShadow(
            color: accentColor.withAlpha(30),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header bar
          Container(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
            decoration: BoxDecoration(
              color: SwfColors.brandDark.withAlpha(220),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: accentColor.withAlpha(45),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    scroll.chapterLabel.toUpperCase(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: accentColor.withAlpha(30),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    l10n.questScrollActive,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: accentColor,
                      letterSpacing: 1,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  '$doneCount / ${scroll.objectives.length}',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: Colors.white.withAlpha(200),
                  ),
                ),
              ],
            ),
          ),

          // Body
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  scroll.title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: QuestScrollCard._inkDark,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  scroll.summary,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: QuestScrollCard._inkDark.withAlpha(160),
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 16),

                // Reward preview
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(140),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: SwfColors.secondaryAccent.withAlpha(50),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: accentColor.withAlpha(20),
                        ),
                        child: Icon(
                          scroll.reward.icon,
                          size: 18,
                          color: accentColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.questScrollReward,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: SwfColors.secondaryAccent,
                                letterSpacing: 1.2,
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              scroll.reward.title,
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: QuestScrollCard._inkDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Objectives
                ...scroll.objectives.map(
                  (objective) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _ObjectiveTile(
                      objective: objective,
                      accentColor: accentColor,
                      isComplete: completedObjectiveIds.contains(objective.id),
                      onTap: () => onToggleObjective(objective),
                    ),
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

// ---------------------------------------------------------------------------
// LOCKED scroll — future quest, greyed out
// ---------------------------------------------------------------------------
class _LockedScroll extends StatelessWidget {
  const _LockedScroll({
    required this.scroll,
    required this.accentColor,
    required this.onToggleExpand,
    required this.isExpanded,
    required this.completedObjectiveIds,
    required this.onToggleObjective,
  });

  final QuestScroll scroll;
  final Color accentColor;
  final VoidCallback onToggleExpand;
  final bool isExpanded;
  final Set<String> completedObjectiveIds;
  final ValueChanged<QuestObjective> onToggleObjective;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFFE8E4DE),
        border: Border.all(
          color: SwfColors.lightGray.withAlpha(60),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onToggleExpand,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: SwfColors.lightGray.withAlpha(30),
                        border: Border.all(
                          color: SwfColors.lightGray.withAlpha(60),
                        ),
                      ),
                      child: Icon(
                        Icons.lock_outline_rounded,
                        size: 16,
                        color: SwfColors.lightGray,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            scroll.chapterLabel.toUpperCase(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: SwfColors.lightGray,
                              letterSpacing: 1.5,
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            scroll.title,
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: SwfColors.lightGray,
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
                        size: 20,
                        color: SwfColors.lightGray.withAlpha(120),
                      ),
                    ),
                  ],
                ),
              ),
              // Expandable content — still interactable
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 250),
                crossFadeState: isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                firstChild: const SizedBox(width: double.infinity),
                secondChild: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 1,
                        color: SwfColors.lightGray.withAlpha(30),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        scroll.summary,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: QuestScrollCard._inkDark.withAlpha(120),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...scroll.objectives.map(
                        (objective) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _ObjectiveTile(
                            objective: objective,
                            accentColor: accentColor,
                            isComplete: completedObjectiveIds.contains(
                              objective.id,
                            ),
                            onTap: () => onToggleObjective(objective),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared objective tile — ink-style journal entry
// ---------------------------------------------------------------------------
class _ObjectiveTile extends StatelessWidget {
  const _ObjectiveTile({
    required this.objective,
    required this.accentColor,
    required this.isComplete,
    required this.onTap,
  });

  final QuestObjective objective;
  final Color accentColor;
  final bool isComplete;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: Key('quest-toggle-${objective.id}'),
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isComplete
                ? accentColor.withAlpha(15)
                : Colors.white.withAlpha(100),
            border: Border.all(
              color: isComplete
                  ? accentColor.withAlpha(60)
                  : SwfColors.secondaryAccent.withAlpha(30),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ink-style checkmark
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isComplete ? accentColor : Colors.transparent,
                  border: Border.all(
                    color: isComplete
                        ? accentColor
                        : QuestScrollCard._inkDark.withAlpha(60),
                    width: 1.5,
                  ),
                ),
                child: isComplete
                    ? const Icon(
                        Icons.check_rounded,
                        size: 14,
                        color: Colors.white,
                      )
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      objective.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: QuestScrollCard._inkDark,
                        decoration:
                            isComplete ? TextDecoration.lineThrough : null,
                        decorationColor:
                            QuestScrollCard._inkDark.withAlpha(100),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      objective.description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: QuestScrollCard._inkDark.withAlpha(130),
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
