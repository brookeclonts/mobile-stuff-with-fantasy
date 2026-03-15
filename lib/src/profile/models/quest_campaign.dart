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
}
