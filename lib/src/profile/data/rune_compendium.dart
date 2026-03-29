import 'package:flutter/material.dart';
import 'package:swf_app/src/profile/models/ability_rune.dart';

/// Returns the ability runes available for a given role.
List<AbilityRune> runesForRole(String? role) => _readerRunes;

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
    unlocksAtTierId: 'epic-t2',
  ),
  AbilityRune(
    id: 'reader-genre-attunement',
    title: 'Genre Attunement',
    description:
        'Set the genres and tropes that pull you in. The realm learns what to surface for you.',
    icon: Icons.auto_awesome_rounded,
    unlocksAfterScrollId: 'reader-taste',
    unlocksAtTierId: 'romantasy-t1',
  ),
  AbilityRune(
    id: 'reader-event-watchtower',
    title: 'Event Watchtower',
    description:
        'Receive push notifications when events, drops, and new campaigns launch in the realm.',
    icon: Icons.notifications_active_rounded,
    unlocksAfterScrollId: 'reader-hunt',
    unlocksAtTierId: 'dark-t2',
  ),
];

