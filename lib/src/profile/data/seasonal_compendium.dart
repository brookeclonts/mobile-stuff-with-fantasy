import 'package:flutter/material.dart';
import 'package:swf_app/src/profile/models/quest_campaign.dart';
import 'package:swf_app/src/theme/swf_colors.dart';

/// Returns mock seasonal campaigns for development.
///
/// Falls back to this data when the API is unavailable.
List<QuestCampaign> mockSeasonalCampaigns() => <QuestCampaign>[
      _summerReadingExpedition,
    ];

const QuestCampaign _summerReadingExpedition = QuestCampaign(
  role: 'reader',
  seasonId: 'summer-2026',
  startDate: null, // Parsed at runtime below
  endDate: null, // Parsed at runtime below
  title: 'Summer Reading Expedition',
  headline:
      'Chart a blazing trail through the summer stacks before the season fades.',
  flavorText:
      'The long days call for bold reads. Venture beyond your usual shelves, '
      'chase new authors, and fill your pack with summer discoveries before '
      'the autumn winds blow in.',
  progressLabel: 'Expedition progress',
  rankTitles: <String>[
    'Trailhead Scout',
    'Sun-Path Seeker',
    'Summit Reader',
  ],
  heroGradient: <Color>[
    Color(0xFF5C3D1E), // warm earth brown
    Color(0xFFBC8D60), // SwfColors.secondaryAccent / gold
    Color(0xFFF3BD75), // SwfColors.orange / warm amber
  ],
  accentColor: SwfColors.orange,
  scrollColor: Color(0xFFFDF6EC),
  borderColor: SwfColors.secondaryAccent,
  finalReward: QuestReward(
    id: 'summer-2026-grand-reward',
    title: 'Sunfire Compass',
    description:
        'A legendary relic granted to those who complete every summer expedition objective.',
    icon: Icons.wb_sunny_rounded,
  ),
  scrolls: <QuestScroll>[
    QuestScroll(
      id: 'summer-explore',
      chapterLabel: 'Leg I',
      title: 'Blaze a New Trail',
      summary:
          'Push past your comfort zone and discover authors or subgenres you have never tried.',
      reward: QuestReward(
        id: 'summer-explore-reward',
        title: 'Wayfinder Torch',
        description:
            'A light for those who dare to read beyond the familiar paths.',
        icon: Icons.local_fire_department_rounded,
      ),
      objectives: <QuestObjective>[
        QuestObjective(
          id: 'summer-explore-new-subgenre',
          title: 'Venture into an unfamiliar subgenre',
          description:
              'Open a book from a subgenre you have never explored before.',
        ),
        QuestObjective(
          id: 'summer-explore-new-author',
          title: 'Discover a new author',
          description:
              'Find and inspect a book by an author not already on your shelf.',
        ),
        QuestObjective(
          id: 'summer-explore-recommend',
          title: 'Follow a recommendation trail',
          description:
              'Tap a "You might also like" pick and explore where it leads.',
        ),
      ],
    ),
    QuestScroll(
      id: 'summer-endurance',
      chapterLabel: 'Leg II',
      title: 'Endurance March',
      summary:
          'Build reading momentum and prove your stamina before the expedition ends.',
      reward: QuestReward(
        id: 'summer-endurance-reward',
        title: 'Amber Trail Badge',
        description:
            'Proof that you kept moving through the longest chapters of summer.',
        icon: Icons.shield_rounded,
      ),
      objectives: <QuestObjective>[
        QuestObjective(
          id: 'summer-endurance-streak',
          title: 'Read three days in a row',
          description:
              'Open a book and read for any amount on three consecutive days.',
        ),
        QuestObjective(
          id: 'summer-endurance-save',
          title: 'Stock the expedition pack',
          description:
              'Save at least two books to your reading list for the road ahead.',
        ),
        QuestObjective(
          id: 'summer-endurance-finish',
          title: 'Finish a summer read',
          description:
              'Complete any book before the expedition timer runs out.',
        ),
      ],
    ),
  ],
);

/// Runtime-aware version that sets proper DateTime values.
QuestCampaign get summerReadingExpedition {
  return QuestCampaign(
    role: _summerReadingExpedition.role,
    seasonId: _summerReadingExpedition.seasonId,
    startDate: DateTime(2026, 6, 1),
    endDate: DateTime(2026, 9, 1),
    title: _summerReadingExpedition.title,
    headline: _summerReadingExpedition.headline,
    flavorText: _summerReadingExpedition.flavorText,
    progressLabel: _summerReadingExpedition.progressLabel,
    rankTitles: _summerReadingExpedition.rankTitles,
    heroGradient: _summerReadingExpedition.heroGradient,
    accentColor: _summerReadingExpedition.accentColor,
    scrollColor: _summerReadingExpedition.scrollColor,
    borderColor: _summerReadingExpedition.borderColor,
    scrolls: _summerReadingExpedition.scrolls,
    finalReward: _summerReadingExpedition.finalReward,
  );
}
