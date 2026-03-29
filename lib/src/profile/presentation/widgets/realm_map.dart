import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:swf_app/l10n/app_localizations.dart';
import 'package:swf_app/src/profile/models/quest_campaign.dart';
import 'package:swf_app/src/theme/swf_colors.dart';

/// The hero map showing the user's rank progression as a journey path.
///
/// Parchment-textured card with rank waypoints connected by a path line.
/// Shows current position, completed ranks, and the next quest objective.
class RealmMap extends StatelessWidget {
  const RealmMap({
    super.key,
    required this.campaign,
    required this.currentRankIndex,
    required this.rankTitle,
    required this.userName,
    required this.completedObjectives,
    required this.totalObjectives,
    this.activeScrollTitle,
    this.activeScrollObjectivesDone = 0,
    this.activeScrollObjectivesTotal = 0,
  });

  final QuestCampaign campaign;
  final int currentRankIndex;
  final String rankTitle;
  final String userName;
  final int completedObjectives;
  final int totalObjectives;
  final String? activeScrollTitle;
  final int activeScrollObjectivesDone;
  final int activeScrollObjectivesTotal;

  static const _parchment = Color(0xFFF4F0E8);
  static const _parchmentDark = Color(0xFFE8E0D4);
  static const _inkDark = Color(0xFF2A1F1A);
  static const _inkFaded = Color(0xFF8A7D70);

  @override
  Widget build(BuildContext context) {
    final ranks = campaign.rankTitles;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      decoration: BoxDecoration(
        color: _parchment,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: SwfColors.secondaryAccent.withAlpha(90),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(70),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          _MapHeader(
            title: campaign.title,
            completedObjectives: completedObjectives,
            totalObjectives: totalObjectives,
          ),
          _UserBanner(
            userName: userName,
            rankTitle: rankTitle,
            accentColor: campaign.accentColor,
            roleIcon: _roleIcon(campaign.role),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
            child: _RankPath(
              ranks: ranks,
              currentRankIndex: currentRankIndex,
              accentColor: campaign.accentColor,
            ),
          ),
          if (activeScrollTitle != null)
            _QuestCallout(
              scrollTitle: activeScrollTitle!,
              objectivesDone: activeScrollObjectivesDone,
              objectivesTotal: activeScrollObjectivesTotal,
              accentColor: campaign.accentColor,
            ),
          const SizedBox(height: 18),
        ],
      ),
    );
  }
}

class _MapHeader extends StatelessWidget {
  const _MapHeader({
    required this.title,
    required this.completedObjectives,
    required this.totalObjectives,
  });

  final String title;
  final int completedObjectives;
  final int totalObjectives;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 14),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: SwfColors.secondaryAccent.withAlpha(50),
          ),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.map_rounded,
            size: 16,
            color: SwfColors.secondaryAccent,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title.toUpperCase(),
              style: theme.textTheme.labelLarge?.copyWith(
                color: SwfColors.secondaryAccent,
                letterSpacing: 1.8,
                fontSize: 11,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: SwfColors.secondaryAccent.withAlpha(20),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: SwfColors.secondaryAccent.withAlpha(50),
              ),
            ),
            child: Text(
              '$completedObjectives / $totalObjectives',
              style: theme.textTheme.labelSmall?.copyWith(
                color: SwfColors.secondaryAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RankPath extends StatelessWidget {
  const _RankPath({
    required this.ranks,
    required this.currentRankIndex,
    required this.accentColor,
  });

  final List<String> ranks;
  final int currentRankIndex;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Path with nodes
        SizedBox(
          height: 56,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Connecting lines (behind nodes)
              Row(
                children: [
                  for (int i = 0; i < ranks.length; i++) ...[
                    if (i > 0)
                      Expanded(
                        child: _PathSegment(
                          isCompleted: i <= currentRankIndex,
                          accentColor: accentColor,
                        ),
                      ),
                    const SizedBox(width: 44),
                  ],
                ],
              ),
              // Nodes (in front)
              Row(
                children: [
                  for (int i = 0; i < ranks.length; i++) ...[
                    if (i > 0) const Expanded(child: SizedBox()),
                    _RankNode(
                      isCompleted: i < currentRankIndex,
                      isCurrent: i == currentRankIndex,
                      accentColor: accentColor,
                      index: i,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Labels row
        Row(
          children: [
            for (int i = 0; i < ranks.length; i++) ...[
              if (i > 0) const Expanded(child: SizedBox()),
              SizedBox(
                width: 72,
                child: Column(
                  children: [
                    if (i == currentRankIndex) ...[
                      Transform.translate(
                        offset: const Offset(0, -2),
                        child: Icon(
                          Icons.arrow_drop_up_rounded,
                          size: 20,
                          color: accentColor,
                        ),
                      ),
                    ],
                    Text(
                      ranks[i],
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: i <= currentRankIndex
                            ? RealmMap._inkDark
                            : RealmMap._inkFaded,
                        fontWeight: i == currentRankIndex
                            ? FontWeight.w700
                            : FontWeight.w500,
                        fontSize: 10,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _PathSegment extends StatelessWidget {
  const _PathSegment({
    required this.isCompleted,
    required this.accentColor,
  });

  final bool isCompleted;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    if (isCompleted) {
      return Container(
        height: 3,
        decoration: BoxDecoration(
          color: accentColor,
          borderRadius: BorderRadius.circular(2),
        ),
      );
    }

    return CustomPaint(
      size: const Size(double.infinity, 3),
      painter: _DashedLinePainter(
        color: accentColor.withAlpha(70),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  _DashedLinePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    const dashWidth = 6.0;
    const dashGap = 4.0;
    double x = 0;
    final y = size.height / 2;

    while (x < size.width) {
      canvas.drawLine(
        Offset(x, y),
        Offset(math.min(x + dashWidth, size.width), y),
        paint,
      );
      x += dashWidth + dashGap;
    }
  }

  @override
  bool shouldRepaint(_DashedLinePainter oldDelegate) =>
      color != oldDelegate.color;
}

class _RankNode extends StatelessWidget {
  const _RankNode({
    required this.isCompleted,
    required this.isCurrent,
    required this.accentColor,
    required this.index,
  });

  final bool isCompleted;
  final bool isCurrent;
  final Color accentColor;
  final int index;

  @override
  Widget build(BuildContext context) {
    const size = 44.0;

    if (isCompleted) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: accentColor,
          border: Border.all(
            color: SwfColors.secondaryAccent.withAlpha(120),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: accentColor.withAlpha(50),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(
          Icons.check_rounded,
          size: 20,
          color: Colors.white,
        ),
      );
    }

    if (isCurrent) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: accentColor.withAlpha(25),
          border: Border.all(color: accentColor, width: 2.5),
          boxShadow: [
            BoxShadow(
              color: accentColor.withAlpha(60),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Center(
          child: Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accentColor,
            ),
          ),
        ),
      );
    }

    // Future node
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: RealmMap._parchmentDark,
        border: Border.all(
          color: accentColor.withAlpha(40),
          width: 1.5,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.lock_outline_rounded,
          size: 16,
          color: accentColor.withAlpha(60),
        ),
      ),
    );
  }
}

IconData _roleIcon(String role) {
  return switch (role) {
    'author' => Icons.edit_note_rounded,
    'influencer' => Icons.campaign_rounded,
    _ => Icons.auto_stories_rounded,
  };
}

class _UserBanner extends StatelessWidget {
  const _UserBanner({
    required this.userName,
    required this.rankTitle,
    required this.accentColor,
    required this.roleIcon,
  });

  final String userName;
  final String rankTitle;
  final Color accentColor;
  final IconData roleIcon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final initials = userName
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part.substring(0, 1))
        .join()
        .toUpperCase();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
      child: Row(
        children: [
          // Guild emblem
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accentColor.withAlpha(20),
              border: Border.all(
                color: accentColor.withAlpha(80),
                width: 1.5,
              ),
            ),
            child: Center(
              child: Text(
                initials.isEmpty ? '?' : initials,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: accentColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: RealmMap._inkDark,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(roleIcon, size: 14, color: accentColor),
                    const SizedBox(width: 6),
                    Text(
                      rankTitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: accentColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestCallout extends StatelessWidget {
  const _QuestCallout({
    required this.scrollTitle,
    required this.objectivesDone,
    required this.objectivesTotal,
    required this.accentColor,
  });

  final String scrollTitle;
  final int objectivesDone;
  final int objectivesTotal;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: accentColor.withAlpha(15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accentColor.withAlpha(40)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accentColor.withAlpha(25),
              border: Border.all(color: accentColor.withAlpha(60)),
            ),
            child: Icon(
              Icons.auto_stories_rounded,
              size: 16,
              color: accentColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.realmMapCurrentQuest,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: accentColor,
                    letterSpacing: 1.2,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  scrollTitle,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: RealmMap._inkDark,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: accentColor.withAlpha(20),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '$objectivesDone / $objectivesTotal',
              style: theme.textTheme.labelSmall?.copyWith(
                color: accentColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
