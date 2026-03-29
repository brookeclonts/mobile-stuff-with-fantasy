import 'package:flutter/material.dart';

class QuestCampaign {
  const QuestCampaign({
    required this.role,
    required this.title,
    required this.headline,
    required this.flavorText,
    required this.progressLabel,
    required this.rankTitles,
    required this.heroGradient,
    required this.accentColor,
    required this.scrollColor,
    required this.borderColor,
    required this.scrolls,
    this.referenceLabel,
    this.referenceUrl,
    this.finalReward,
    this.seasonId,
    this.startDate,
    this.endDate,
  });

  final String role;
  final String title;
  final String headline;
  final String flavorText;
  final String progressLabel;
  final List<String> rankTitles;
  final List<Color> heroGradient;
  final Color accentColor;
  final Color scrollColor;
  final Color borderColor;
  final List<QuestScroll> scrolls;
  final String? referenceLabel;
  final String? referenceUrl;
  final QuestReward? finalReward;

  /// Null means permanent campaign; non-null means seasonal.
  final String? seasonId;
  final DateTime? startDate;
  final DateTime? endDate;

  /// Whether this campaign is time-limited (seasonal).
  bool get isSeasonal => seasonId != null;

  /// Whether this seasonal campaign is currently active.
  bool get isActive {
    if (!isSeasonal) return true;
    final now = DateTime.now();
    final start = startDate;
    final end = endDate;
    if (start != null && now.isBefore(start)) return false;
    if (end != null && now.isAfter(end)) return false;
    return true;
  }

  /// Whether this seasonal campaign has expired.
  bool get isExpired {
    if (!isSeasonal) return false;
    final end = endDate;
    if (end == null) return false;
    return DateTime.now().isAfter(end);
  }

  factory QuestCampaign.fromJson(Object json) {
    final map = json as Map<String, dynamic>;
    final scrollsList = (map['scrolls'] as List?)
            ?.map((s) => QuestScroll.fromJson(s as Map<String, dynamic>))
            .toList() ??
        const <QuestScroll>[];
    final gradientList = (map['heroGradient'] as List?)
            ?.map((c) => Color(c as int))
            .toList() ??
        const <Color>[];

    return QuestCampaign(
      role: map['role'] as String? ?? '',
      title: map['title'] as String? ?? '',
      headline: map['headline'] as String? ?? '',
      flavorText: map['flavorText'] as String? ?? '',
      progressLabel: map['progressLabel'] as String? ?? '',
      rankTitles: (map['rankTitles'] as List?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      heroGradient: gradientList,
      accentColor: Color(map['accentColor'] as int? ?? 0xFF82B1A1),
      scrollColor: Color(map['scrollColor'] as int? ?? 0xFFF3F1EC),
      borderColor: Color(map['borderColor'] as int? ?? 0xFF82B1A1),
      scrolls: scrollsList,
      referenceLabel: map['referenceLabel'] as String?,
      referenceUrl: map['referenceUrl'] as String?,
      finalReward: map['finalReward'] != null
          ? QuestReward.fromJson(map['finalReward'] as Map<String, dynamic>)
          : null,
      seasonId: map['seasonId'] as String?,
      startDate: map['startDate'] != null
          ? DateTime.tryParse(map['startDate'] as String)
          : null,
      endDate: map['endDate'] != null
          ? DateTime.tryParse(map['endDate'] as String)
          : null,
    );
  }
}

class QuestScroll {
  const QuestScroll({
    required this.id,
    required this.chapterLabel,
    required this.title,
    required this.summary,
    required this.reward,
    required this.objectives,
  });

  final String id;
  final String chapterLabel;
  final String title;
  final String summary;
  final QuestReward reward;
  final List<QuestObjective> objectives;

  factory QuestScroll.fromJson(Map<String, dynamic> map) {
    return QuestScroll(
      id: map['id'] as String? ?? '',
      chapterLabel: map['chapterLabel'] as String? ?? '',
      title: map['title'] as String? ?? '',
      summary: map['summary'] as String? ?? '',
      reward: QuestReward.fromJson(
        map['reward'] as Map<String, dynamic>? ?? const <String, dynamic>{},
      ),
      objectives: (map['objectives'] as List?)
              ?.map(
                (o) => QuestObjective.fromJson(o as Map<String, dynamic>),
              )
              .toList() ??
          const <QuestObjective>[],
    );
  }
}

class QuestObjective {
  const QuestObjective({
    required this.id,
    required this.title,
    required this.description,
  });

  final String id;
  final String title;
  final String description;

  factory QuestObjective.fromJson(Map<String, dynamic> map) {
    return QuestObjective(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
    );
  }
}

class QuestReward {
  const QuestReward({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
  });

  final String id;
  final String title;
  final String description;
  final IconData icon;

  factory QuestReward.fromJson(Map<String, dynamic> map) {
    return QuestReward(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      icon: IconData(
        map['iconCodePoint'] as int? ?? Icons.help_outline_rounded.codePoint,
        fontFamily: 'MaterialIcons',
      ),
    );
  }
}
