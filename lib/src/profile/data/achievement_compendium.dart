import 'package:flutter/material.dart';
import 'package:swf_app/l10n/app_localizations.dart';
import 'package:swf_app/src/profile/models/achievement.dart';

/// Returns the full list of achievements with localized text.
List<Achievement> achievements(AppLocalizations l10n) => [
      // ── Bronze ──
      Achievement(
        id: 'first_page',
        title: l10n.achievementFirstPageTitle,
        description: l10n.achievementFirstPageDesc,
        icon: Icons.auto_stories_rounded,
        tier: AchievementTier.bronze,
        isUnlocked: (s) => s.totalSessionCount >= 1,
      ),
      Achievement(
        id: 'bookworm_awakens',
        title: l10n.achievementBookwormTitle,
        description: l10n.achievementBookwormDesc,
        icon: Icons.menu_book_rounded,
        tier: AchievementTier.bronze,
        isUnlocked: (s) => s.totalBooksCompleted >= 1,
      ),
      Achievement(
        id: 'daily_ritual',
        title: l10n.achievementDailyRitualTitle,
        description: l10n.achievementDailyRitualDesc,
        icon: Icons.local_fire_department_rounded,
        tier: AchievementTier.bronze,
        isUnlocked: (s) => s.longestStreakDays >= 3,
      ),
      Achievement(
        id: 'page_turner',
        title: l10n.achievementPageTurnerTitle,
        description: l10n.achievementPageTurnerDesc,
        icon: Icons.import_contacts_rounded,
        tier: AchievementTier.bronze,
        isUnlocked: (s) => s.estimatedPages >= 100,
      ),
      Achievement(
        id: 'hour_glass',
        title: l10n.achievementHourGlassTitle,
        description: l10n.achievementHourGlassDesc,
        icon: Icons.hourglass_bottom_rounded,
        tier: AchievementTier.bronze,
        isUnlocked: (s) => s.totalReadingSeconds >= 3600,
      ),

      // ── Silver ──
      Achievement(
        id: 'chapter_champion',
        title: l10n.achievementChapterChampionTitle,
        description: l10n.achievementChapterChampionDesc,
        icon: Icons.emoji_events_rounded,
        tier: AchievementTier.silver,
        isUnlocked: (s) => s.totalBooksCompleted >= 3,
      ),
      Achievement(
        id: 'flame_keeper',
        title: l10n.achievementFlameKeeperTitle,
        description: l10n.achievementFlameKeeperDesc,
        icon: Icons.whatshot_rounded,
        tier: AchievementTier.silver,
        isUnlocked: (s) => s.longestStreakDays >= 7,
      ),
      Achievement(
        id: 'tome_scholar',
        title: l10n.achievementTomeScholarTitle,
        description: l10n.achievementTomeScholarDesc,
        icon: Icons.school_rounded,
        tier: AchievementTier.silver,
        isUnlocked: (s) => s.estimatedPages >= 1000,
      ),
      Achievement(
        id: 'devoted_reader',
        title: l10n.achievementDevotedReaderTitle,
        description: l10n.achievementDevotedReaderDesc,
        icon: Icons.schedule_rounded,
        tier: AchievementTier.silver,
        isUnlocked: (s) => s.totalReadingSeconds >= 36000,
      ),
      Achievement(
        id: 'five_realms',
        title: l10n.achievementFiveRealmsTitle,
        description: l10n.achievementFiveRealmsDesc,
        icon: Icons.explore_rounded,
        tier: AchievementTier.silver,
        isUnlocked: (s) => s.bookProgress.length >= 5,
      ),

      // ── Gold ──
      Achievement(
        id: 'grand_librarian',
        title: l10n.achievementGrandLibrarianTitle,
        description: l10n.achievementGrandLibrarianDesc,
        icon: Icons.account_balance_rounded,
        tier: AchievementTier.gold,
        isUnlocked: (s) => s.totalBooksCompleted >= 10,
      ),
      Achievement(
        id: 'eternal_flame',
        title: l10n.achievementEternalFlameTitle,
        description: l10n.achievementEternalFlameDesc,
        icon: Icons.brightness_7_rounded,
        tier: AchievementTier.gold,
        isUnlocked: (s) => s.longestStreakDays >= 30,
      ),
      Achievement(
        id: 'mythic_scribe',
        title: l10n.achievementMythicScribeTitle,
        description: l10n.achievementMythicScribeDesc,
        icon: Icons.history_edu_rounded,
        tier: AchievementTier.gold,
        isUnlocked: (s) => s.totalReadingSeconds >= 360000,
      ),
      Achievement(
        id: 'realm_walker',
        title: l10n.achievementRealmWalkerTitle,
        description: l10n.achievementRealmWalkerDesc,
        icon: Icons.public_rounded,
        tier: AchievementTier.gold,
        isUnlocked: (s) => s.bookProgress.length >= 10,
      ),
    ];
