import 'package:flutter/material.dart';
import 'package:swf_app/src/profile/models/ability_rune.dart';

/// Returns the ability runes available for a given role.
List<AbilityRune> runesForRole(String? role) {
  return switch (role) {
    'author' => _authorRunes,
    'influencer' => _influencerRunes,
    _ => _readerRunes,
  };
}

// ---------------------------------------------------------------------------
// Reader runes
// ---------------------------------------------------------------------------

const _readerRunes = <AbilityRune>[
  AbilityRune(
    id: 'reader-arc-shield',
    title: 'ARC Shield',
    description:
        'Mark yourself as open to Advanced Reader Copies. Authors and publishers can find you when they need early readers.',
    icon: Icons.shield_rounded,
    unlocksAfterScrollId: 'reader-taste',
  ),
  AbilityRune(
    id: 'reader-genre-attunement',
    title: 'Genre Attunement',
    description:
        'Set the genres and tropes that pull you in. The realm learns what to surface for you.',
    icon: Icons.auto_awesome_rounded,
    unlocksAfterScrollId: 'reader-taste',
  ),
  AbilityRune(
    id: 'reader-event-watchtower',
    title: 'Event Watchtower',
    description:
        'Receive push notifications when events, drops, and new campaigns launch in the realm.',
    icon: Icons.notifications_active_rounded,
    unlocksAfterScrollId: 'reader-hunt',
  ),
];

// ---------------------------------------------------------------------------
// Author runes
// ---------------------------------------------------------------------------

const _authorRunes = <AbilityRune>[
  AbilityRune(
    id: 'author-subscriber-ledger',
    title: 'Subscriber Ledger',
    description:
        'Start a subscriber list so readers can follow your work. Track your active follower count.',
    icon: Icons.people_rounded,
    unlocksAfterScrollId: 'author-enrollment',
  ),
  AbilityRune(
    id: 'author-manuscript-hall',
    title: 'Manuscript Hall',
    description:
        'Add your book to the realm catalog. Set up the listing readers will discover.',
    icon: Icons.menu_book_rounded,
    unlocksAfterScrollId: 'author-offering',
  ),
  AbilityRune(
    id: 'author-festival-booth',
    title: 'Festival Booth',
    description:
        'Publish your book for sale. Set pricing, link storefronts, and go live in the marketplace.',
    icon: Icons.storefront_rounded,
    unlocksAfterScrollId: 'author-signal',
  ),
];

// ---------------------------------------------------------------------------
// Influencer runes
// ---------------------------------------------------------------------------

const _influencerRunes = <AbilityRune>[
  AbilityRune(
    id: 'influencer-crystal-lens',
    title: 'Crystal Lens',
    description:
        'Define your creator profile — your niche, your platform, your audience promise.',
    icon: Icons.camera_rounded,
    unlocksAfterScrollId: 'influencer-lens',
  ),
  AbilityRune(
    id: 'influencer-feature-forge',
    title: 'Feature Forge',
    description:
        'Build and manage your feature templates — carousels, roundups, review formats.',
    icon: Icons.dashboard_customize_rounded,
    unlocksAfterScrollId: 'influencer-asset',
  ),
  AbilityRune(
    id: 'influencer-signal-horn',
    title: 'Signal Horn',
    description:
        'Broadcast features to your channels. Schedule and track your content drops.',
    icon: Icons.campaign_rounded,
    unlocksAfterScrollId: 'influencer-broadcast',
  ),
];
