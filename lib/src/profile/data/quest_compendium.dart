import 'package:flutter/material.dart';
import 'package:swf_app/src/profile/models/quest_campaign.dart';
import 'package:swf_app/src/theme/swf_colors.dart';

QuestCampaign campaignForRole(String? role) => _readerCampaign;

const QuestCampaign _readerCampaign = QuestCampaign(
  role: 'reader',
  title: 'Reader Field Journal',
  headline:
      'Build your fantasy trail, hunt your next obsession, and level up your shelf.',
  flavorText:
      'Readers move through the realm by learning their taste, tracking their favorite formats, and building an intentional fantasy hoard.',
  progressLabel: 'Realm exploration',
  rankTitles: <String>[
    'Shelf Scout',
    'Rune Reader',
    'Archive Ranger',
    'Realm Sage',
  ],
  heroGradient: <Color>[SwfColors.color7, SwfColors.blue, SwfColors.color3],
  accentColor: SwfColors.blue,
  scrollColor: Color(0xFFF3F1EC),
  borderColor: SwfColors.blue,
  finalReward: QuestReward(
    id: 'reader-grand-reward',
    title: 'Dragon Shelf Relic',
    description:
        'Granted when your reading path is fully mapped and your hunt instincts are tuned.',
    icon: Icons.menu_book_rounded,
  ),
  scrolls: <QuestScroll>[
    QuestScroll(
      id: 'reader-taste',
      chapterLabel: 'Chapter I',
      title: 'Map Your Taste',
      summary:
          'Decide what actually pulls you through a fantasy story before the endless stack swallows you whole.',
      reward: QuestReward(
        id: 'reader-taste-reward',
        title: 'Compass Rune',
        description:
            'A guide stone for subgenres, spice levels, and the tropes that never miss.',
        icon: Icons.explore_rounded,
      ),
      objectives: <QuestObjective>[
        QuestObjective(
          id: 'reader-taste-subgenre',
          title: 'Name your favorite subgenre trails',
          description:
              'Know whether you are hunting epic worlds, urban shadows, romantasy sparks, or all of the above.',
        ),
        QuestObjective(
          id: 'reader-taste-tropes',
          title: 'Choose the tropes that hook you',
          description:
              'Found family, enemies to lovers, magical schools, cursed crowns. Pick your bait.',
        ),
        QuestObjective(
          id: 'reader-taste-format',
          title: 'Set your format priorities',
          description:
              'Decide whether audiobook, Kindle Unlimited, or fast free reads matter most this season.',
        ),
      ],
    ),
    QuestScroll(
      id: 'reader-hunt',
      chapterLabel: 'Chapter II',
      title: 'Hunt the Hidden Stacks',
      summary:
          'Use the catalog like a tracking board instead of doom-scrolling every cover in the kingdom.',
      reward: QuestReward(
        id: 'reader-hunt-reward',
        title: 'Tracker Lantern',
        description:
            'A hunter’s light for filtering faster and spotting the books that actually match.',
        icon: Icons.travel_explore_rounded,
      ),
      objectives: <QuestObjective>[
        QuestObjective(
          id: 'reader-hunt-search',
          title: 'Search with intention',
          description:
              'Use title or author search like a clue trail instead of an accidental swipe.',
        ),
        QuestObjective(
          id: 'reader-hunt-filter',
          title: 'Stack filters with purpose',
          description:
              'Mix tropes, spice, age category, and representation until the list feels sharp.',
        ),
        QuestObjective(
          id: 'reader-hunt-detail',
          title: 'Inspect a book in detail',
          description:
              'Open the book page and read enough to know whether it belongs on your quest path.',
        ),
      ],
    ),
    QuestScroll(
      id: 'reader-hoard',
      chapterLabel: 'Chapter III',
      title: 'Build the Hoard',
      summary:
          'Turn a lucky find into a lasting reading streak with a shelf strategy that stays alive after the event rush.',
      reward: QuestReward(
        id: 'reader-hoard-reward',
        title: 'TBR Vault Key',
        description:
            'The key to a reading pile that feels curated instead of chaotic.',
        icon: Icons.inventory_2_rounded,
      ),
      objectives: <QuestObjective>[
        QuestObjective(
          id: 'reader-hoard-refresh',
          title: 'Refresh the board regularly',
          description:
              'Come back for new drops instead of assuming the first stack was the whole map.',
        ),
        QuestObjective(
          id: 'reader-hoard-balance',
          title: 'Balance comfort reads with wild cards',
          description:
              'Keep one sure thing and one surprising pick in every haul.',
        ),
        QuestObjective(
          id: 'reader-hoard-finish',
          title: 'Choose the next book now',
          description:
              'Leave profile with one clear next read instead of twenty maybes.',
        ),
      ],
    ),
  ],
);

