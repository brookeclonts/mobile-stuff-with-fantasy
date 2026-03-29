import 'package:flutter/material.dart';
import 'package:swf_app/src/profile/models/skill_tree.dart';

/// Returns a default skill tree with five genre branches and partial mock
/// progress for visual development.
SkillTree defaultSkillTree() {
  return SkillTree(
    totalXp: 430,
    branches: [
      // ── Epic Fantasy ──
      SkillBranch(
        id: 'branch-epic-fantasy',
        genreId: 'epic-fantasy',
        title: 'Epic Fantasy',
        icon: Icons.auto_stories,
        currentXp: 150,
        requiredXp: 300,
        tiers: const [
          SkillTier(
            id: 'epic-t1',
            level: 1,
            title: 'Apprentice Lorekeeper',
            description:
                'Begin your journey into the grand epics of the realm.',
            xpRequired: 100,
            isUnlocked: true,
          ),
          SkillTier(
            id: 'epic-t2',
            level: 2,
            title: 'Chronicle Guardian',
            description: 'Protect the ancient tomes and unlock the ARC Shield.',
            xpRequired: 300,
            isUnlocked: false,
            unlockedRuneId: 'reader-arc-shield',
          ),
          SkillTier(
            id: 'epic-t3',
            level: 3,
            title: 'Saga Weaver',
            description:
                'Master the epic arts and shape the stories of the realm.',
            xpRequired: 600,
            isUnlocked: false,
          ),
        ],
      ),

      // ── Romantasy ──
      SkillBranch(
        id: 'branch-romantasy',
        genreId: 'romantasy',
        title: 'Romantasy',
        icon: Icons.favorite,
        currentXp: 80,
        requiredXp: 100,
        tiers: const [
          SkillTier(
            id: 'romantasy-t1',
            level: 1,
            title: 'Heart Seeker',
            description:
                'Attune to the romantic threads woven through fantasy.',
            xpRequired: 100,
            isUnlocked: false,
            unlockedRuneId: 'reader-genre-attunement',
          ),
          SkillTier(
            id: 'romantasy-t2',
            level: 2,
            title: 'Bond Forger',
            description:
                'Deepen your connection to romantasy narratives.',
            xpRequired: 300,
            isUnlocked: false,
          ),
          SkillTier(
            id: 'romantasy-t3',
            level: 3,
            title: 'Flame Eternal',
            description:
                'Become a beacon for the most passionate tales in the realm.',
            xpRequired: 600,
            isUnlocked: false,
          ),
        ],
      ),

      // ── Dark Fantasy ──
      SkillBranch(
        id: 'branch-dark-fantasy',
        genreId: 'dark-fantasy',
        title: 'Dark Fantasy',
        icon: Icons.dark_mode,
        currentXp: 200,
        requiredXp: 300,
        tiers: const [
          SkillTier(
            id: 'dark-t1',
            level: 1,
            title: 'Shadow Initiate',
            description: 'Step into the darker corners of the fantasy realm.',
            xpRequired: 100,
            isUnlocked: true,
          ),
          SkillTier(
            id: 'dark-t2',
            level: 2,
            title: 'Dusk Watcher',
            description:
                'Keep vigil over the realm and unlock the Event Watchtower.',
            xpRequired: 300,
            isUnlocked: false,
            unlockedRuneId: 'reader-event-watchtower',
          ),
          SkillTier(
            id: 'dark-t3',
            level: 3,
            title: 'Abyssal Scholar',
            description:
                'Plumb the deepest lore of grimdark and eldritch tales.',
            xpRequired: 600,
            isUnlocked: false,
          ),
        ],
      ),

      // ── Urban Fantasy ──
      SkillBranch(
        id: 'branch-urban-fantasy',
        genreId: 'urban-fantasy',
        title: 'Urban Fantasy',
        icon: Icons.location_city,
        currentXp: 0,
        requiredXp: 100,
        tiers: const [
          SkillTier(
            id: 'urban-t1',
            level: 1,
            title: 'Street Mage',
            description:
                'Discover magic hidden in the modern world.',
            xpRequired: 100,
            isUnlocked: false,
          ),
          SkillTier(
            id: 'urban-t2',
            level: 2,
            title: 'Neon Enchanter',
            description:
                'Navigate the intersection of magic and city life.',
            xpRequired: 300,
            isUnlocked: false,
          ),
          SkillTier(
            id: 'urban-t3',
            level: 3,
            title: 'Arcane Architect',
            description:
                'Shape the magical infrastructure of urban realms.',
            xpRequired: 600,
            isUnlocked: false,
          ),
        ],
      ),

      // ── Mythic Fantasy ──
      SkillBranch(
        id: 'branch-mythic-fantasy',
        genreId: 'mythic-fantasy',
        title: 'Mythic Fantasy',
        icon: Icons.castle,
        currentXp: 0,
        requiredXp: 100,
        tiers: const [
          SkillTier(
            id: 'mythic-t1',
            level: 1,
            title: 'Myth Listener',
            description:
                'Open your ears to the legends of gods and heroes.',
            xpRequired: 100,
            isUnlocked: false,
          ),
          SkillTier(
            id: 'mythic-t2',
            level: 2,
            title: 'Pantheon Acolyte',
            description:
                'Study the divine stories woven into fantasy worlds.',
            xpRequired: 300,
            isUnlocked: false,
          ),
          SkillTier(
            id: 'mythic-t3',
            level: 3,
            title: 'Legend Incarnate',
            description:
                'Embody the mythic tales and become a living legend.',
            xpRequired: 600,
            isUnlocked: false,
          ),
        ],
      ),
    ],
  );
}
