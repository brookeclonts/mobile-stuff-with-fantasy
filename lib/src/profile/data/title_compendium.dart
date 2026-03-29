import 'package:flutter/material.dart';
import 'package:swf_app/src/profile/models/earned_title.dart';

// ---------------------------------------------------------------------------
// Title registry
// ---------------------------------------------------------------------------

/// All titles available in the system, grouped by category.
const List<EarnedTitle> allTitles = [
  // ── Genre-Based ──
  EarnedTitle(
    id: 'keeper-cozy',
    label: 'Keeper of Cozy Fantasy',
    category: 'genre',
    description: 'You seek warmth, found family, and gentle magic.',
    icon: Icons.local_fire_department_rounded,
    unlockHint: 'Select cozy fantasy as a genre preference',
  ),
  EarnedTitle(
    id: 'grimdark-wanderer',
    label: 'Grimdark Wanderer',
    category: 'genre',
    description: 'You walk the dark paths where heroes fall.',
    icon: Icons.thunderstorm_rounded,
    unlockHint: 'Select grimdark as a genre preference',
  ),
  EarnedTitle(
    id: 'romantasy-devotee',
    label: 'Romantasy Devotee',
    category: 'genre',
    description: 'Love and sorcery intertwine in every tale you chase.',
    icon: Icons.favorite_rounded,
    unlockHint: 'Select romantasy as a genre preference',
  ),
  EarnedTitle(
    id: 'urban-shadow',
    label: 'Urban Shadow Walker',
    category: 'genre',
    description: 'Magic hides in city streets and neon-lit alleys.',
    icon: Icons.location_city_rounded,
    unlockHint: 'Select urban fantasy as a genre preference',
  ),
  EarnedTitle(
    id: 'epic-sentinel',
    label: 'Epic Realm Sentinel',
    category: 'genre',
    description: 'Vast worlds and sprawling sagas are your domain.',
    icon: Icons.castle_rounded,
    unlockHint: 'Select epic fantasy as a genre preference',
  ),
  EarnedTitle(
    id: 'litrpg-player',
    label: 'LitRPG Player One',
    category: 'genre',
    description: 'Levels, loot, and game-like worlds call to you.',
    icon: Icons.sports_esports_rounded,
    unlockHint: 'Select LitRPG as a genre preference',
  ),

  // ── Quest-Based ──
  EarnedTitle(
    id: 'scroll-seeker',
    label: 'Scroll Seeker',
    category: 'quest',
    description: 'You have mapped your taste and know what you hunt.',
    icon: Icons.explore_rounded,
    unlockHint: 'Complete Chapter I — Map Your Taste',
  ),
  EarnedTitle(
    id: 'stack-hunter',
    label: 'Stack Hunter',
    category: 'quest',
    description: 'The hidden stacks reveal their secrets to you.',
    icon: Icons.travel_explore_rounded,
    unlockHint: 'Complete Chapter II — Hunt the Hidden Stacks',
  ),
  EarnedTitle(
    id: 'hoard-master',
    label: 'Hoard Master',
    category: 'quest',
    description: 'Your reading pile is a curated treasury, not a chaotic heap.',
    icon: Icons.inventory_2_rounded,
    unlockHint: 'Complete Chapter III — Build the Hoard',
  ),
  EarnedTitle(
    id: 'dragon-sage',
    label: 'Dragon Sage',
    category: 'quest',
    description: 'All quests sealed, all relics claimed. The realm bows.',
    icon: Icons.menu_book_rounded,
    unlockHint: 'Complete all quest scrolls and claim the grand relic',
  ),

  // ── Special ──
  EarnedTitle(
    id: 'rune-bearer',
    label: 'Rune Bearer',
    category: 'special',
    description: 'You have attuned your first rune and shaped your path.',
    icon: Icons.hexagon_rounded,
    unlockHint: 'Configure at least one rune ability',
  ),
  EarnedTitle(
    id: 'leaderboard-contender',
    label: 'Leaderboard Contender',
    category: 'special',
    description: 'You have entered the rankings and stand among peers.',
    icon: Icons.emoji_events_rounded,
    unlockHint: 'Opt into the leaderboard',
  ),
];

// ---------------------------------------------------------------------------
// Genre → title mapping
// ---------------------------------------------------------------------------

/// Maps lowercase genre preference strings to title IDs.
const Map<String, String> _genreToTitle = {
  'cozy fantasy': 'keeper-cozy',
  'cozy': 'keeper-cozy',
  'grimdark': 'grimdark-wanderer',
  'romantasy': 'romantasy-devotee',
  'romantic fantasy': 'romantasy-devotee',
  'urban fantasy': 'urban-shadow',
  'urban': 'urban-shadow',
  'epic fantasy': 'epic-sentinel',
  'epic': 'epic-sentinel',
  'litrpg': 'litrpg-player',
  'lit rpg': 'litrpg-player',
  'gamelit': 'litrpg-player',
};

// ---------------------------------------------------------------------------
// Quest scroll → title mapping
// ---------------------------------------------------------------------------

/// Maps quest scroll IDs to the title they unlock.
const Map<String, String> _scrollToTitle = {
  'reader-taste': 'scroll-seeker',
  'reader-hunt': 'stack-hunter',
  'reader-hoard': 'hoard-master',
};

// ---------------------------------------------------------------------------
// Evaluator
// ---------------------------------------------------------------------------

/// Determines which titles are unlocked given the user's current state.
///
/// [completedObjectiveIds] — IDs of completed quest objectives.
/// [revealedRewardIds] — IDs of revealed rewards (including grand reward).
/// [selectedGenres] — genre strings from the Genre Attunement rune config.
/// [hasConfiguredRune] — whether the user has configured at least one rune.
/// [leaderboardOptIn] — whether the user has opted into the leaderboard.
/// [scrollObjectives] — map of scroll ID → list of objective IDs for that scroll.
List<EarnedTitle> evaluateUnlockedTitles({
  required Set<String> completedObjectiveIds,
  required Set<String> revealedRewardIds,
  required Set<String> selectedGenres,
  required bool hasConfiguredRune,
  required bool leaderboardOptIn,
  required Map<String, List<String>> scrollObjectives,
}) {
  final unlockedIds = <String>{};

  // Genre-based titles
  for (final genre in selectedGenres) {
    final titleId = _genreToTitle[genre.toLowerCase()];
    if (titleId != null) unlockedIds.add(titleId);
  }

  // Quest-based titles — unlocked when all objectives in a scroll are complete
  for (final entry in _scrollToTitle.entries) {
    final objectives = scrollObjectives[entry.key];
    if (objectives != null &&
        objectives.every(completedObjectiveIds.contains)) {
      unlockedIds.add(entry.value);
    }
  }

  // Dragon Sage — all scrolls complete + grand reward revealed
  if (revealedRewardIds.contains('reader-grand-reward')) {
    unlockedIds.add('dragon-sage');
  }

  // Special titles
  if (hasConfiguredRune) unlockedIds.add('rune-bearer');
  if (leaderboardOptIn) unlockedIds.add('leaderboard-contender');

  return allTitles.where((t) => unlockedIds.contains(t.id)).toList();
}

/// Finds a title by its ID, or returns `null`.
EarnedTitle? titleById(String? id) {
  if (id == null) return null;
  for (final title in allTitles) {
    if (title.id == id) return title;
  }
  return null;
}
