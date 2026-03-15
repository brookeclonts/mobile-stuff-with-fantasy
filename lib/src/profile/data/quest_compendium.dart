import 'package:flutter/material.dart';
import 'package:swf_app/src/profile/models/quest_campaign.dart';
import 'package:swf_app/src/theme/swf_colors.dart';

QuestCampaign campaignForRole(String? role) {
  return switch (role) {
    'author' => _authorCampaign,
    'influencer' => _influencerCampaign,
    _ => _readerCampaign,
  };
}

List<QuestCampaign> get guestCampaignPreview => const <QuestCampaign>[
  _readerCampaign,
  _influencerCampaign,
  _authorCampaign,
];

const QuestCampaign _authorCampaign = QuestCampaign(
  role: 'author',
  title: 'Author Field Journal',
  headline: 'Forge the event path and lead readers to your free book.',
  flavorText:
      'This path is adapted from the Stuff With Fantasy Author Help scroll: join the event, prepare the book offer, and raise the signal at the right moment.',
  progressLabel: 'Campaign readiness',
  rankTitles: <String>[
    'Novice Scribe',
    'Festival Herald',
    'Lorebinder',
    'Realm Architect',
  ],
  heroGradient: <Color>[SwfColors.color2, SwfColors.color3, SwfColors.color4],
  accentColor: SwfColors.color6,
  scrollColor: SwfColors.color8,
  borderColor: SwfColors.color6,
  referenceLabel: 'Open Author Help Scroll',
  referenceUrl: 'https://stuffwithfantasy.com/authorhelp',
  finalReward: QuestReward(
    id: 'author-grand-reward',
    title: 'Stuff Your Kindle Champion Crest',
    description:
        'Awarded for completing the full launch ritual from enrollment to post-event promotion.',
    icon: Icons.workspace_premium_rounded,
  ),
  scrolls: <QuestScroll>[
    QuestScroll(
      id: 'author-enrollment',
      chapterLabel: 'Chapter I',
      title: 'The Enrollment Scroll',
      summary:
          'Learn the event structure, submit the right book, and confirm the storefronts you can actually use.',
      reward: QuestReward(
        id: 'author-enrollment-reward',
        title: 'Festival Seal',
        description:
            'Proof that your book is properly enrolled and ready to enter the event.',
        icon: Icons.shield_rounded,
      ),
      objectives: <QuestObjective>[
        QuestObjective(
          id: 'author-enrollment-what-is-it',
          title: 'Study the event charter',
          description:
              'Know what the Stuff With Fantasy event is and how the hosts frame it for readers.',
        ),
        QuestObjective(
          id: 'author-enrollment-join',
          title: 'Join the event',
          description:
              'Complete the submission steps so your title is actually part of the campaign.',
        ),
        QuestObjective(
          id: 'author-enrollment-platforms',
          title: 'Confirm eligible platforms',
          description:
              'Only send readers to supported storefronts and skip dead-end routes.',
        ),
      ],
    ),
    QuestScroll(
      id: 'author-offering',
      chapterLabel: 'Chapter II',
      title: 'The Freebook Rite',
      summary:
          'Prepare the actual offer readers will find: free pricing, clean destination, and a link that works everywhere.',
      reward: QuestReward(
        id: 'author-offering-reward',
        title: 'Portal Sigil',
        description:
            'Unlocked once your free-book destination is clean, universal, and ready for traffic.',
        icon: Icons.auto_awesome_rounded,
      ),
      objectives: <QuestObjective>[
        QuestObjective(
          id: 'author-offering-free',
          title: 'Set the book to free',
          description:
              'Use the storefront tools the hosts recommend so your promotion matches the event promise.',
        ),
        QuestObjective(
          id: 'author-offering-clean-link',
          title: 'Use a clean link',
          description:
              'Send readers straight to the book instead of piling on tracking junk or maze links.',
        ),
        QuestObjective(
          id: 'author-offering-ubl',
          title: 'Forge a universal book link',
          description:
              'Create the single link that can route readers to the right store for them.',
        ),
      ],
    ),
    QuestScroll(
      id: 'author-signal',
      chapterLabel: 'Chapter III',
      title: 'The Signal Summoning',
      summary:
          'Package the campaign, start promoting at the right moment, and keep the momentum alive after the first rush.',
      reward: QuestReward(
        id: 'author-signal-reward',
        title: 'Golden Banner',
        description:
            'A reward for coordinating the event visuals and carrying the promo energy beyond launch day.',
        icon: Icons.campaign_rounded,
      ),
      objectives: <QuestObjective>[
        QuestObjective(
          id: 'author-signal-assets',
          title: 'Forge the marketing materials',
          description:
              'Prepare graphics, copy, and promo assets before the event traffic hits.',
        ),
        QuestObjective(
          id: 'author-signal-window',
          title: 'Promote in the host window',
          description:
              'Start shouting when the hosts say it is time so the campaign lands together.',
        ),
        QuestObjective(
          id: 'author-signal-beyond',
          title: 'Keep the marketing alive',
          description:
              'Use the event as the start of the push, not the end of it.',
        ),
      ],
    ),
  ],
);

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

const QuestCampaign _influencerCampaign = QuestCampaign(
  role: 'influencer',
  title: 'Influencer Field Journal',
  headline: 'Turn your signal into a fantasy beacon readers actually follow.',
  flavorText:
      'Influencer quests focus on curation, clean promo paths, and making each event feature feel shareable instead of generic.',
  progressLabel: 'Signal strength',
  rankTitles: <String>[
    'Signal Scout',
    'Hype Weaver',
    'Realm Broadcaster',
    'Legend Maker',
  ],
  heroGradient: <Color>[SwfColors.color2, SwfColors.violet, SwfColors.color6],
  accentColor: SwfColors.violet,
  scrollColor: Color(0xFFF7F0EC),
  borderColor: SwfColors.violet,
  finalReward: QuestReward(
    id: 'influencer-grand-reward',
    title: 'Beacon Crown',
    description:
        'For building a fantasy signal readers trust and creators want to join.',
    icon: Icons.visibility_rounded,
  ),
  scrolls: <QuestScroll>[
    QuestScroll(
      id: 'influencer-lens',
      chapterLabel: 'Chapter I',
      title: 'Claim Your Lens',
      summary:
          'The strongest creators are clear about what kind of fantasy guide they are.',
      reward: QuestReward(
        id: 'influencer-lens-reward',
        title: 'Crystal Lens',
        description:
            'A marker that your taste, lane, and audience promise are all in focus.',
        icon: Icons.tune_rounded,
      ),
      objectives: <QuestObjective>[
        QuestObjective(
          id: 'influencer-lens-lane',
          title: 'Define your fantasy lane',
          description:
              'Know whether you lead readers through spicy romantasy, cozy quests, dark fantasy, or indie gems.',
        ),
        QuestObjective(
          id: 'influencer-lens-angle',
          title: 'Choose your feature angle',
          description:
              'Roundup, reel, carousel, newsletter, listicle. Pick the format that is truly yours.',
        ),
        QuestObjective(
          id: 'influencer-lens-link',
          title: 'Keep the call-to-action clean',
          description:
              'Make it easy for readers to click without sending them through clutter.',
        ),
      ],
    ),
    QuestScroll(
      id: 'influencer-asset',
      chapterLabel: 'Chapter II',
      title: 'Forge the Feature Stack',
      summary:
          'Build the visual and editorial package before you hit publish so the content feels crafted.',
      reward: QuestReward(
        id: 'influencer-asset-reward',
        title: 'Carousel Forge',
        description:
            'Unlocked when your promo assets, captions, and visual identity are ready to ship.',
        icon: Icons.photo_library_rounded,
      ),
      objectives: <QuestObjective>[
        QuestObjective(
          id: 'influencer-asset-graphics',
          title: 'Design the promo graphics',
          description:
              'Create a visual set that looks intentional enough to stop the scroll.',
        ),
        QuestObjective(
          id: 'influencer-asset-copy',
          title: 'Write the feature copy',
          description:
              'Draft captions and hooks that make the books feel like discoveries, not ads.',
        ),
        QuestObjective(
          id: 'influencer-asset-queue',
          title: 'Queue the release order',
          description:
              'Know what hits first, what follows, and what gets reposted if it lands.',
        ),
      ],
    ),
    QuestScroll(
      id: 'influencer-broadcast',
      chapterLabel: 'Chapter III',
      title: 'Raise the Realm Signal',
      summary:
          'Launch the feature, amplify the event, and keep your audience engaged beyond a single post.',
      reward: QuestReward(
        id: 'influencer-broadcast-reward',
        title: 'Signal Horn',
        description:
            'A relic for creators who know how to launch, amplify, and sustain momentum.',
        icon: Icons.record_voice_over_rounded,
      ),
      objectives: <QuestObjective>[
        QuestObjective(
          id: 'influencer-broadcast-launch',
          title: 'Launch in the right window',
          description:
              'Coordinate your feature timing so it lands with the event surge instead of missing it.',
        ),
        QuestObjective(
          id: 'influencer-broadcast-amplify',
          title: 'Amplify across channels',
          description:
              'Repackage the same story for the platforms where your audience already listens.',
        ),
        QuestObjective(
          id: 'influencer-broadcast-extend',
          title: 'Extend the life of the feature',
          description:
              'Turn one good post into follow-up recommendations, roundup threads, or callback content.',
        ),
      ],
    ),
  ],
);
