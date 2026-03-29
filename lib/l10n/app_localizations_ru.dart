// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'StuffWithFantasy';

  @override
  String get bookSingular => 'book';

  @override
  String get bookPlural => 'books';

  @override
  String booksCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count books',
      one: '1 book',
    );
    return '$_temp0';
  }

  @override
  String get catalogSignUpPrompt =>
      'Create an account to save books to your reading list.';

  @override
  String get catalogSnackbarActionProfile => 'Profile';

  @override
  String get catalogTooltipLibrary => 'Library';

  @override
  String get catalogTooltipProfile => 'Profile';

  @override
  String get catalogFiltersUnavailable =>
      'Filters are unavailable until taxonomy loads successfully.';

  @override
  String get catalogRetry => 'Retry';

  @override
  String get catalogEmptyFiltered => 'No books match your filters';

  @override
  String get catalogEmptyNoBooks => 'No books yet';

  @override
  String get catalogClearFilters => 'Clear Filters';

  @override
  String get bookDetailSignUpPrompt =>
      'Create an account from your profile to save books to your reading list.';

  @override
  String bookDetailByAuthor(String author) {
    return 'by $author';
  }

  @override
  String get bookDetailSectionSubgenres => 'Subgenres';

  @override
  String get bookDetailSectionTropes => 'Tropes';

  @override
  String get bookDetailSectionRepresentation => 'Representation';

  @override
  String get bookDetailSectionAbout => 'About this book';

  @override
  String get bookDetailReadMore => 'Read more';

  @override
  String get bookDetailSectionSimilar => 'You might also like';

  @override
  String get bookDetailBadgeKu => 'KU';

  @override
  String get bookDetailUpdating => 'Updating...';

  @override
  String get bookDetailRemoveFromList => 'Remove from Reading List';

  @override
  String get bookDetailSaving => 'Saving...';

  @override
  String get bookDetailSaveToList => 'Save to Reading List';

  @override
  String get bookDetailOpening => 'Opening...';

  @override
  String get bookDetailReadInApp => 'Read in App';

  @override
  String get bookDetailGetBook => 'Get this Book';

  @override
  String get bookDetailAmazon => 'Amazon US';

  @override
  String get bookDetailAllRetailers => 'View all retailers';

  @override
  String get bookDetailAudiobook => 'Audiobook';

  @override
  String get filterSearchHint => 'Search by title or author...';

  @override
  String get filterChipKu => 'KU';

  @override
  String get filterChipAudiobook => 'Audiobook';

  @override
  String get filterClearAll => 'Clear all';

  @override
  String get filterSheetTitle => 'Filters';

  @override
  String get filterSheetReset => 'Reset';

  @override
  String get filterSheetSubgenres => 'Subgenres';

  @override
  String get filterSheetTropes => 'Tropes';

  @override
  String get filterSheetSpiceLevel => 'Spice Level';

  @override
  String get filterSheetAgeCategory => 'Age Category';

  @override
  String get filterSheetRepresentation => 'Representation';

  @override
  String get filterSheetLanguageLevel => 'Language Level';

  @override
  String filterSheetApplyWithCount(int count) {
    return 'Apply Filters ($count)';
  }

  @override
  String get filterSheetApply => 'Apply Filters';

  @override
  String get signUpSkip => 'Skip';

  @override
  String get rolePickerHeadline => 'I am a...';

  @override
  String get rolePickerSubtitle =>
      'Choose how you want to use StuffWithFantasy';

  @override
  String get rolePickerContinue => 'Continue';

  @override
  String get interestStepHeadline => 'What else brings you here?';

  @override
  String get interestStepSubtitle => 'Select any that apply — or skip ahead.';

  @override
  String get interestCardAuthorTitle => 'I\'m an Author';

  @override
  String get interestCardAuthorDescription =>
      'I want to get my books discovered by fantasy readers.';

  @override
  String get interestCardInfluencerTitle => 'I\'m an Influencer';

  @override
  String get interestCardInfluencerDescription =>
      'I create content and want to share fantasy books with my audience.';

  @override
  String get interestStepContinue => 'Continue';

  @override
  String get signUpFormHeadline => 'Create your account';

  @override
  String get signUpFormSubtitle => 'Just a few details and you\'re in';

  @override
  String get signUpFieldNameLabel => 'Display name';

  @override
  String get signUpFieldNameHint => 'How should we call you?';

  @override
  String get signUpValidatorEnterName => 'Enter your name';

  @override
  String get signUpFieldEmailLabel => 'Email';

  @override
  String get signUpFieldEmailHint => 'you@example.com';

  @override
  String get signUpValidatorEnterEmail => 'Enter your email';

  @override
  String get signUpValidatorInvalidEmail => 'Enter a valid email';

  @override
  String get signUpFieldPasswordLabel => 'Password';

  @override
  String get signUpFieldPasswordHint => 'At least 8 characters';

  @override
  String get signUpValidatorEnterPassword => 'Enter a password';

  @override
  String get signUpValidatorPasswordTooShort => 'Must be at least 8 characters';

  @override
  String get signUpButtonCreateAccount => 'Create Account';

  @override
  String welcomeStepHeadline(String name) {
    return 'Welcome, $name!';
  }

  @override
  String get welcomeStepSubtitle =>
      'Your next great fantasy adventure is waiting for you.';

  @override
  String get welcomeStepGetStarted => 'Get Started';

  @override
  String get profileUnknownRank => 'Unknown Rank';

  @override
  String get profileAppBarTitle => 'Guild Hall';

  @override
  String get profileSectionRunes => 'Runes';

  @override
  String get profileSectionRunesSubtitle =>
      'Seal quests to engrave ability runes.';

  @override
  String get profileSectionQuestLog => 'Quest Log';

  @override
  String get profileSectionQuestLogSubtitle =>
      'Unfurl scrolls to track and seal objectives.';

  @override
  String get profileSectionRelicVault => 'Relic Vault';

  @override
  String get profileSectionRelicVaultSubtitle =>
      'Seal scrolls to claim relics for your vault.';

  @override
  String get profileSectionCharacterSheet => 'Character Sheet';

  @override
  String get profileSnackbarRuneComingSoon =>
      'This rune will be configurable soon.';

  @override
  String get profileDeleteAccountTitle => 'Delete Account';

  @override
  String get profileDeleteAccountBody =>
      'This will permanently delete your account and all associated data. This cannot be undone.';

  @override
  String get profileDeleteCancel => 'Cancel';

  @override
  String get profileDeleteConfirm => 'Delete';

  @override
  String get profileSigningOut => 'Leaving the realm...';

  @override
  String get profileSignOut => 'Exit the Realm';

  @override
  String get profileDeletingAccount => 'Deleting account...';

  @override
  String get profileDeleteAccount => 'Delete Account';

  @override
  String get profileRetry => 'Retry';

  @override
  String get profileErrorHeadline => 'The quest board failed to load';

  @override
  String get profileTryAgain => 'Try again';

  @override
  String get guestGuildHallLabel => 'GUILD HALL';

  @override
  String get guestGuildHeadline => 'Begin your quest';

  @override
  String get guestGuildBody =>
      'Create an account to track your reading quests, unlock ability runes, and collect relics as you explore the realm.';

  @override
  String get guestGuildButtonCreateAccount => 'Create account to begin';

  @override
  String get runeStatusEngraved => 'ENGRAVED';

  @override
  String get runeStatusLocked => 'LOCKED';

  @override
  String get runeDetailLockedHint =>
      'Complete the linked quest to engrave this rune';

  @override
  String get runeDetailConfigure => 'Configure';

  @override
  String get arcShieldTitle => 'ARC Shield';

  @override
  String get arcShieldDescription =>
      'When active, authors and publishers can find you as an ARC reader.';

  @override
  String get arcShieldSectionAvailability => 'Availability';

  @override
  String get arcShieldToggleOpenLabel => 'Open to ARCs';

  @override
  String get arcShieldToggleClosedLabel => 'Not accepting ARCs';

  @override
  String get arcShieldToggleOpenSubtitle => 'Authors can reach out to you';

  @override
  String get arcShieldToggleClosedSubtitle =>
      'Your profile is hidden from ARC searches';

  @override
  String get genreAttunementTitle => 'Genre Attunement';

  @override
  String get genreAttunementDescription =>
      'Select the genres and tropes that call to you. The realm will learn what to surface.';

  @override
  String get genreAttunementSectionGenres => 'Genres';

  @override
  String get genreAttunementSectionTropes => 'Tropes';

  @override
  String genreAttunementCountAttuned(int count) {
    return '$count attuned';
  }

  @override
  String get genreEpicFantasy => 'Epic Fantasy';

  @override
  String get genreDarkFantasy => 'Dark Fantasy';

  @override
  String get genreUrbanFantasy => 'Urban Fantasy';

  @override
  String get genreRomantasy => 'Romantasy';

  @override
  String get genreCozyFantasy => 'Cozy Fantasy';

  @override
  String get genreGrimdark => 'Grimdark';

  @override
  String get genreLitRpg => 'LitRPG';

  @override
  String get genreSwordAndSorcery => 'Sword & Sorcery';

  @override
  String get genreMythicFantasy => 'Mythic Fantasy';

  @override
  String get genrePortalFantasy => 'Portal Fantasy';

  @override
  String get tropeFoundFamily => 'Found Family';

  @override
  String get tropeEnemiesToLovers => 'Enemies to Lovers';

  @override
  String get tropeChosenOne => 'Chosen One';

  @override
  String get tropeMagicSchools => 'Magic Schools';

  @override
  String get tropeMorallyGrey => 'Morally Grey';

  @override
  String get tropeSlowBurn => 'Slow Burn';

  @override
  String get tropePoliticalIntrigue => 'Political Intrigue';

  @override
  String get tropeQuestJourney => 'Quest Journey';

  @override
  String get tropeHiddenRoyalty => 'Hidden Royalty';

  @override
  String get tropeRevengeArc => 'Revenge Arc';

  @override
  String get eventWatchtowerTitle => 'Event Watchtower';

  @override
  String get eventWatchtowerDescription =>
      'Choose which signals reach you from the realm.';

  @override
  String get eventWatchtowerSectionSignals => 'Signals';

  @override
  String get notifNewEventsTitle => 'New Events';

  @override
  String get notifNewEventsDescription =>
      'When a Stuff Your Kindle event launches';

  @override
  String get notifBookDropsTitle => 'Book Drops';

  @override
  String get notifBookDropsDescription =>
      'When new books are added to the catalog';

  @override
  String get notifRecommendationsTitle => 'Recommendations';

  @override
  String get notifRecommendationsDescription =>
      'Personalized picks based on your attunement';

  @override
  String get rewardRevealBarrierLabel => 'Reward reveal';

  @override
  String get rewardRevealLegendRelicClaimed => 'LEGEND RELIC CLAIMED';

  @override
  String get rewardRevealRelicUnlocked => 'RELIC UNLOCKED';

  @override
  String get rewardRevealContinue => 'Continue questing';

  @override
  String get characterSheetHeaderLabel => 'CHARACTER SHEET';

  @override
  String get characterSheetStatName => 'Name';

  @override
  String get characterSheetStatRank => 'Rank';

  @override
  String get characterSheetStatQuests => 'Quests';

  @override
  String characterSheetStatQuestsValue(int completed, int total) {
    return '$completed / $total';
  }

  @override
  String get characterSheetStatRelics => 'Relics';

  @override
  String characterSheetStatRelicsValue(int collected, int total) {
    return '$collected / $total';
  }

  @override
  String get characterSheetStatSignal => 'Signal';

  @override
  String get realmMapCurrentQuest => 'CURRENT QUEST';

  @override
  String get questScrollSealed => 'Sealed';

  @override
  String get questScrollActive => 'ACTIVE';

  @override
  String get questScrollReward => 'REWARD';

  @override
  String get relicVaultLockedTitle => '???';

  @override
  String get relicVaultLegendRelic => 'Legend relic';

  @override
  String get relicVaultClaimed => 'Claimed';

  @override
  String get relicVaultSealed => 'Sealed';

  @override
  String get libraryAppBarTitle => 'Library';

  @override
  String get libraryTabMyBooks => 'My Books';

  @override
  String get libraryTabReadingList => 'Reading List';

  @override
  String get libraryMyBooksSignInTitle => 'Your bookshelf awaits';

  @override
  String get libraryMyBooksSignInMessage =>
      'Sign in to access books you\'ve purchased, claimed, or uploaded — ready to read right here.';

  @override
  String get libraryMyBooksEmptyTitle => 'No readable books yet';

  @override
  String get libraryMyBooksEmptyMessage =>
      'Books you buy, claim, or upload will show up here when they are ready to read.';

  @override
  String get libraryReadingListSignInTitle => 'Start your reading list';

  @override
  String get libraryReadingListSignInMessage =>
      'Sign in to save books from the catalog and build your personal reading list.';

  @override
  String get libraryReadingListEmptyTitle => 'Nothing saved yet';

  @override
  String get libraryReadingListEmptyMessage =>
      'Save books from the catalog to build your reading list.';

  @override
  String get libraryButtonSignIn => 'Sign In';

  @override
  String get libraryRetry => 'Retry';

  @override
  String readerProgressRead(String progress) {
    return '$progress read';
  }

  @override
  String get readerHintSwipeToTurn => 'Swipe to turn pages';

  @override
  String get readerHintOpeningBook => 'Opening book…';

  @override
  String get readerHintTapToHide => 'Tap the center to hide controls';

  @override
  String get readerTooltipBack => 'Back';

  @override
  String get readerTooltipChapters => 'Chapters';

  @override
  String get readerTooltipReadingSettings => 'Reading settings';

  @override
  String get readerTooltipPreviousPage => 'Previous page';

  @override
  String get readerButtonPrev => 'Prev';

  @override
  String get readerTooltipNextPage => 'Next page';

  @override
  String get readerButtonNext => 'Next';

  @override
  String get readerChaptersTitle => 'Chapters';

  @override
  String get readerSettingsTitle => 'Reading settings';

  @override
  String get readerSettingsTextSize => 'Text size';

  @override
  String get readerTooltipSmallerText => 'Smaller text';

  @override
  String readerFontSizeLabel(int size) {
    return '$size pt';
  }

  @override
  String get readerTooltipLargerText => 'Larger text';

  @override
  String get readerSettingsPageTheme => 'Page theme';

  @override
  String get readerAppearancePaper => 'Paper';

  @override
  String get readerAppearanceSepia => 'Sepia';

  @override
  String get readerAppearanceNight => 'Night';

  @override
  String get eventDetailLoadingBooks => 'Loading books...';

  @override
  String eventDetailBookCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count books in this event',
      one: '1 book in this event',
    );
    return '$_temp0';
  }

  @override
  String get eventDetailNoBooksYet => 'No books in this event yet.';

  @override
  String get creatorDetailNoBooksYet => 'No books to show yet.';

  @override
  String get creatorDetailFavoriteBookLabel => 'Favorite book: ';

  @override
  String get creatorDetailLovesLabel => 'Loves: ';

  @override
  String creatorDetailBooksBy(String name) {
    return 'Books by $name';
  }

  @override
  String creatorDetailRecommendedBy(String name) {
    return 'Recommended by $name';
  }

  @override
  String get socialLinkTiktok => 'TikTok';

  @override
  String get socialLinkInstagram => 'Instagram';

  @override
  String get socialLinkYoutube => 'YouTube';

  @override
  String get socialLinkThreads => 'Threads';

  @override
  String get socialLinkGoodreads => 'Goodreads';

  @override
  String get socialLinkStorygraph => 'StoryGraph';

  @override
  String get socialLinkBookbub => 'BookBub';

  @override
  String get socialLinkFacebook => 'Facebook';

  @override
  String get socialLinkWebsite => 'Website';

  @override
  String get userRoleReader => 'Reader';

  @override
  String get userRoleReaderDescription =>
      'Discover your next favorite fantasy book';

  @override
  String get creatorRoleAuthor => 'Author';

  @override
  String get creatorRoleInfluencer => 'Influencer';

  @override
  String get readAccessOwner => 'Your upload';

  @override
  String get readAccessPurchased => 'Purchased';

  @override
  String get readAccessNone => 'No access';

  @override
  String get eventStatusLastDay => 'Last day!';

  @override
  String get eventStatusHappeningNow => 'Happening now';

  @override
  String get eventStatusStartsToday => 'Starts today';

  @override
  String get eventStatusStartsTomorrow => 'Starts tomorrow';

  @override
  String eventStatusStartsInDays(int days) {
    return 'Starts in $days days';
  }

  @override
  String get spiceLevelNone => 'No Spice';

  @override
  String get spiceLevelMild => 'Mild Spice';

  @override
  String get spiceLevelMedium => 'Medium Spice';

  @override
  String get spiceLevelHot => 'Hot';

  @override
  String get spiceLevelScorching => 'Scorching';

  @override
  String get languageLevelClean => 'Clean';

  @override
  String get languageLevelMild => 'Mild Language';

  @override
  String get languageLevelModerate => 'Moderate Language';

  @override
  String get languageLevelStrong => 'Strong Language';

  @override
  String get homeHeadline => 'Stuff With Fantasy';

  @override
  String get homeTagline => 'Your fantasy reading companion.';

  @override
  String get homeSubtitle =>
      'Discover, track, and share the fantasy books you love.';

  @override
  String get homeChipMaterial3 => 'Material 3';

  @override
  String get homeChipStructuredStarter => 'Structured starter';

  @override
  String get homeChipWidgetTests => 'Widget tests';

  @override
  String get homeCardWhatIsReadyTitle => 'What is ready';

  @override
  String get homeCardWhatIsReadyItem1 =>
      'A branded app shell with light and dark themes.';

  @override
  String get homeCardWhatIsReadyItem2 =>
      'A stricter analyzer baseline using flutter_lints.';

  @override
  String get homeCardWhatIsReadyItem3 =>
      'A widget test to protect the starter experience.';

  @override
  String get homeCardWhereToGoNextTitle => 'Where to go next';

  @override
  String get homeCardWhereToGoNextItem1 =>
      'Add features under lib/src by domain instead of growing main.dart.';

  @override
  String get homeCardWhereToGoNextItem2 =>
      'Replace placeholder assets, launcher icons, and product copy.';

  @override
  String get homeCardWhereToGoNextItem3 =>
      'Run flutter analyze and flutter test as you add screens.';

  @override
  String get homeGetStarted => 'Get Started';

  @override
  String get homeBrowseBooks => 'Browse Books';

  @override
  String get monthJan => 'Jan';

  @override
  String get monthFeb => 'Feb';

  @override
  String get monthMar => 'Mar';

  @override
  String get monthApr => 'Apr';

  @override
  String get monthMay => 'May';

  @override
  String get monthJun => 'Jun';

  @override
  String get monthJul => 'Jul';

  @override
  String get monthAug => 'Aug';

  @override
  String get monthSep => 'Sep';

  @override
  String get monthOct => 'Oct';

  @override
  String get monthNov => 'Nov';

  @override
  String get monthDec => 'Dec';

  @override
  String get profileSectionLanguage => 'Language';

  @override
  String get languageSystemDefault => 'System default';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languagePortuguese => 'Português';

  @override
  String get languageGerman => 'Deutsch';

  @override
  String get languageRussian => 'Русский';

  @override
  String get languageBulgarian => 'Български';

  @override
  String get languageJapanese => '日本語';

  @override
  String get profileSectionReadingChronicle => 'Reading Chronicle';

  @override
  String get profileSectionReadingChronicleSubtitle =>
      'Your journey through the pages, mapped in ink.';

  @override
  String get profileSectionTomeCounter => 'Tome Counter';

  @override
  String get profileSectionTomeCounterSubtitle =>
      'Your accumulated reading feats.';

  @override
  String get profileSectionAchievementSigils => 'Achievement Sigils';

  @override
  String get profileSectionAchievementSigilsSubtitle =>
      'Milestones forged through dedication.';

  @override
  String chroniclePagesThisWeek(int count) {
    return '~$count pages this week';
  }

  @override
  String chronicleStreak(int count) {
    return '$count-day streak';
  }

  @override
  String get chronicleLess => 'Less';

  @override
  String get chronicleMore => 'More';

  @override
  String get tomeCounterBooks => 'Tomes Conquered';

  @override
  String get tomeCounterPages => 'Pages Turned';

  @override
  String get tomeCounterTime => 'Time in Realm';

  @override
  String tomeCounterHoursMinutes(int hours, int minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String tomeCounterMinutes(int minutes) {
    return '${minutes}m';
  }

  @override
  String get achievementLocked => 'SEALED';

  @override
  String get achievementUnlocked => 'EARNED';

  @override
  String get achievementFirstPageTitle => 'First Page';

  @override
  String get achievementFirstPageDesc => 'Open a book and begin reading.';

  @override
  String get achievementBookwormTitle => 'Bookworm Awakens';

  @override
  String get achievementBookwormDesc => 'Finish your first book.';

  @override
  String get achievementDailyRitualTitle => 'Daily Ritual';

  @override
  String get achievementDailyRitualDesc => 'Read for 3 days in a row.';

  @override
  String get achievementPageTurnerTitle => 'Page Turner';

  @override
  String get achievementPageTurnerDesc => 'Read approximately 100 pages.';

  @override
  String get achievementHourGlassTitle => 'Hour Glass';

  @override
  String get achievementHourGlassDesc => 'Spend 1 hour reading.';

  @override
  String get achievementChapterChampionTitle => 'Chapter Champion';

  @override
  String get achievementChapterChampionDesc => 'Finish 3 books.';

  @override
  String get achievementFlameKeeperTitle => 'Flame Keeper';

  @override
  String get achievementFlameKeeperDesc => 'Read for 7 days in a row.';

  @override
  String get achievementTomeScholarTitle => 'Tome Scholar';

  @override
  String get achievementTomeScholarDesc => 'Read approximately 1,000 pages.';

  @override
  String get achievementDevotedReaderTitle => 'Devoted Reader';

  @override
  String get achievementDevotedReaderDesc => 'Spend 10 hours reading.';

  @override
  String get achievementFiveRealmsTitle => 'Five Realms';

  @override
  String get achievementFiveRealmsDesc => 'Start reading 5 different books.';

  @override
  String get achievementGrandLibrarianTitle => 'Grand Librarian';

  @override
  String get achievementGrandLibrarianDesc => 'Finish 10 books.';

  @override
  String get achievementEternalFlameTitle => 'Eternal Flame';

  @override
  String get achievementEternalFlameDesc => 'Maintain a 30-day reading streak.';

  @override
  String get achievementMythicScribeTitle => 'Mythic Scribe';

  @override
  String get achievementMythicScribeDesc => 'Spend 100 hours reading.';

  @override
  String get achievementRealmWalkerTitle => 'Realm Walker';

  @override
  String get achievementRealmWalkerDesc => 'Start reading 10 different books.';

  @override
  String get oathAppBarTitle => 'Oath Stone';

  @override
  String get oathSectionTitle => 'Oath Stone';

  @override
  String get oathSectionSubtitle => 'Your sworn reading pledge';

  @override
  String get oathSwearCta => 'Swear an Oath';

  @override
  String get oathSwearSubtitle =>
      'Set a public reading goal and track your progress';

  @override
  String get oathSwearPageTitle => 'Inscribe Your Oath';

  @override
  String get oathFieldTitle => 'Your pledge';

  @override
  String get oathFieldTitleHint => 'I will read 24 books in 2026';

  @override
  String get oathFieldTarget => 'Target books';

  @override
  String get oathFieldYear => 'Year';

  @override
  String get oathFieldPublic => 'Public oath';

  @override
  String get oathFieldPublicSubtitle => 'Visible on the Lore Board';

  @override
  String get oathSwearButton => 'Swear This Oath';

  @override
  String get oathSwearing => 'Inscribing...';

  @override
  String oathProgressLabel(int current, int target) {
    return '$current of $target';
  }

  @override
  String get oathProgressComplete => 'Oath Fulfilled!';

  @override
  String get oathEntryLogged => 'Rune carved!';

  @override
  String get oathEntryRemoved => 'Entry removed';

  @override
  String get oathDeleteConfirmTitle => 'Break This Oath?';

  @override
  String get oathDeleteConfirmBody =>
      'This will permanently remove your oath and all logged entries.';

  @override
  String get oathDeleteCancel => 'Keep Oath';

  @override
  String get oathDeleteConfirm => 'Break Oath';

  @override
  String get oathDeleted => 'Oath broken';

  @override
  String get oathCompleteTitle => 'OATH FULFILLED';

  @override
  String get oathCompleteHeadline => 'Your Oath is Sealed';

  @override
  String get oathCompleteBody =>
      'You have honored your pledge. The runes are complete.';

  @override
  String get oathCompleteContinue => 'Continue';

  @override
  String get oathEmptyEntries => 'No books logged yet';

  @override
  String get oathLogBookAction => 'Log toward Oath';

  @override
  String oathLogBookConfirm(String title) {
    return 'Log \"$title\" toward your oath?';
  }

  @override
  String get oathLogBookButton => 'Log It';

  @override
  String get oathAlreadyLogged => 'Already logged toward your oath';

  @override
  String get oathEditButton => 'Edit Oath';

  @override
  String get oathUpdated => 'Oath updated';

  @override
  String get oathErrorCreate => 'Failed to create oath';

  @override
  String get oathErrorLoad => 'Failed to load oath';

  @override
  String get oathGuestHeadline => 'The Oath Stone Awaits';

  @override
  String get oathGuestBody =>
      'Create an account to swear a reading oath and track your progress.';

  @override
  String get seasonalCampaignLabel => 'Seasonal Campaign';

  @override
  String get seasonalCampaignExpired => 'Expedition ended';

  @override
  String get seasonalCampaignLastDay => 'Last day!';

  @override
  String seasonalCampaignCountdownDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days remaining',
      one: '1 day remaining',
    );
    return '$_temp0';
  }

  @override
  String seasonalCampaignCountdownMonths(int months) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: '$months months remaining',
      one: '1 month remaining',
    );
    return '$_temp0';
  }

  @override
  String seasonalCampaignCountdownMonthsDays(int months, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: '$months months',
      one: '1 month',
    );
    String _temp1 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days remaining',
      one: '1 day remaining',
    );
    return '$_temp0, $_temp1';
  }

  @override
  String get seasonalRelicSectionTitle => 'Seasonal Relics';

  @override
  String get profileSectionSeasonalQuests => 'Seasonal Quests';

  @override
  String get profileSectionSeasonalQuestsSubtitle =>
      'Time-limited expeditions with exclusive relics.';

  @override
  String get realmRankingsTitle => 'Realm Rankings';

  @override
  String get leaderboardMetricQuests => 'Quests';

  @override
  String get leaderboardMetricBooks => 'Books';

  @override
  String get leaderboardMetricRelics => 'Relics';

  @override
  String leaderboardTotalParticipants(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count adventurers ranked',
      one: '1 adventurer ranked',
    );
    return '$_temp0';
  }

  @override
  String get leaderboardYourPosition => 'YOUR POSITION';

  @override
  String leaderboardPositionOfTotal(int position, int total) {
    return '#$position of $total';
  }

  @override
  String get leaderboardErrorHeadline => 'The rankings failed to load';

  @override
  String get leaderboardOptInTitle => 'Realm Rankings';

  @override
  String get leaderboardOptInDescription =>
      'Compete with fellow adventurers by joining the realm leaderboard. Your ranking is based on quests sealed, books read, and relics collected.';

  @override
  String get leaderboardOptInPrivacy =>
      'Only your display name and rank are visible to others.';

  @override
  String get leaderboardOptInActive => 'Ranked in the realm';

  @override
  String get leaderboardOptInInactive => 'Not ranked';

  @override
  String get leaderboardOptInJoinButton => 'Join the Rankings';

  @override
  String get leaderboardOptInLeaveButton => 'Leave the Rankings';

  @override
  String get characterSheetStatRealmRank => 'Realm';

  @override
  String get characterSheetRealmRankJoin => 'Join Rankings';

  @override
  String get skillTreeSectionTitle => 'Skill Tree';

  @override
  String get skillTreeSectionSubtitle =>
      'Grow your genre mastery through reading.';

  @override
  String skillTreeXpProgress(int current, int next) {
    return '$current / $next XP';
  }

  @override
  String skillTreeXpLabel(int xp) {
    return '$xp XP';
  }

  @override
  String get skillTreeTiersLabel => 'Tiers';

  @override
  String get skillTreeTierUnlocked => 'UNLOCKED';

  @override
  String get skillTreeTierCurrent => 'IN PROGRESS';

  @override
  String get skillTreeTierLocked => 'LOCKED';

  @override
  String skillTreeRuneUnlocked(String runeTitle) {
    return 'Rune Unlocked: $runeTitle';
  }

  @override
  String skillTreeRuneLockedAt(String runeTitle) {
    return 'Unlocks: $runeTitle';
  }

  @override
  String get loreBoardTitle => 'Lore Board';

  @override
  String get loreBoardGlobalTab => 'Global';

  @override
  String get loreBoardFriendsTab => 'Friends';

  @override
  String get loreBoardEmpty =>
      'The board is bare... no tales have been posted yet.';

  @override
  String get loreBoardTooltip => 'Lore Board';

  @override
  String get guildHubTitle => 'Guild Hall';

  @override
  String get guildHubEmpty =>
      'You haven\'t joined any guilds yet. Found your own or discover existing ones.';

  @override
  String get guildCreateButton => 'Found a New Guild';

  @override
  String get guildDiscoverButton => 'Discover Guilds';

  @override
  String get guildDetailCompanions => 'Companions';

  @override
  String get guildDetailLedger => 'Party Ledger';

  @override
  String get guildDetailLedgerEmpty => 'No books in the ledger yet.';

  @override
  String get guildJoinButton => 'Join Guild';

  @override
  String get guildJoined => 'You have joined the guild!';

  @override
  String get guildLeaveButton => 'Leave Guild';

  @override
  String get guildLeft => 'You have left the guild.';

  @override
  String get guildDeleteConfirmTitle => 'Disband This Guild?';

  @override
  String get guildDeleteConfirmBody =>
      'This will permanently remove the guild and all its data. This cannot be undone.';

  @override
  String get guildDeleteCancel => 'Keep Guild';

  @override
  String get guildDeleteConfirm => 'Disband Guild';

  @override
  String get guildDeleted => 'Guild disbanded';

  @override
  String get guildCreated => 'Guild founded!';

  @override
  String get guildUpdated => 'Guild updated';

  @override
  String get guildCreatePageTitle => 'Found a Guild';

  @override
  String get guildFieldName => 'Guild Name';

  @override
  String get guildFieldNameHint => 'The Fellowship of Pages';

  @override
  String get guildFieldDescription => 'Description';

  @override
  String get guildFieldDescriptionHint => 'What is your guild about?';

  @override
  String get guildFieldPublic => 'Public guild';

  @override
  String get guildFieldPublicSubtitle =>
      'Visible on the Guild Board for anyone to join';

  @override
  String get guildCreateSubmit => 'Found This Guild';

  @override
  String get guildCreating => 'Founding...';

  @override
  String get guildDiscoverTitle => 'Guild Board';

  @override
  String get guildDiscoverEmpty => 'No guilds to discover yet.';

  @override
  String guildMemberCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count companions',
      one: '1 companion',
    );
    return '$_temp0';
  }

  @override
  String get guildRoleGuildmaster => 'Guildmaster';

  @override
  String get guildRoleCompanion => 'Companion';

  @override
  String get guildGuestHeadline => 'The Guild Hall Awaits';

  @override
  String get guildGuestBody =>
      'Create an account to found guilds, join reading parties, and build ledgers with fellow adventurers.';

  @override
  String get guildAddToLedger => 'Add to Ledger';

  @override
  String get guildBookAdded => 'Book added to the ledger!';

  @override
  String get guildBookRemoved => 'Book removed from the ledger.';

  @override
  String get guildAlreadyMember => 'You are already a member of this guild.';
}
