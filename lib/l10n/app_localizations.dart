import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bg.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bg'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('ja'),
    Locale('pt'),
    Locale('ru'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'StuffWithFantasy'**
  String get appTitle;

  /// No description provided for @bookSingular.
  ///
  /// In en, this message translates to:
  /// **'book'**
  String get bookSingular;

  /// No description provided for @bookPlural.
  ///
  /// In en, this message translates to:
  /// **'books'**
  String get bookPlural;

  /// No description provided for @booksCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 book} other{{count} books}}'**
  String booksCount(int count);

  /// No description provided for @catalogSignUpPrompt.
  ///
  /// In en, this message translates to:
  /// **'Create an account to save books to your reading list.'**
  String get catalogSignUpPrompt;

  /// No description provided for @catalogSnackbarActionProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get catalogSnackbarActionProfile;

  /// No description provided for @catalogTooltipLibrary.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get catalogTooltipLibrary;

  /// No description provided for @catalogTooltipProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get catalogTooltipProfile;

  /// No description provided for @catalogFiltersUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Filters are unavailable until taxonomy loads successfully.'**
  String get catalogFiltersUnavailable;

  /// No description provided for @catalogRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get catalogRetry;

  /// No description provided for @catalogEmptyFiltered.
  ///
  /// In en, this message translates to:
  /// **'No books match your filters'**
  String get catalogEmptyFiltered;

  /// No description provided for @catalogEmptyNoBooks.
  ///
  /// In en, this message translates to:
  /// **'No books yet'**
  String get catalogEmptyNoBooks;

  /// No description provided for @catalogClearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear Filters'**
  String get catalogClearFilters;

  /// No description provided for @bookDetailSignUpPrompt.
  ///
  /// In en, this message translates to:
  /// **'Create an account from your profile to save books to your reading list.'**
  String get bookDetailSignUpPrompt;

  /// No description provided for @bookDetailByAuthor.
  ///
  /// In en, this message translates to:
  /// **'by {author}'**
  String bookDetailByAuthor(String author);

  /// No description provided for @bookDetailSectionSubgenres.
  ///
  /// In en, this message translates to:
  /// **'Subgenres'**
  String get bookDetailSectionSubgenres;

  /// No description provided for @bookDetailSectionTropes.
  ///
  /// In en, this message translates to:
  /// **'Tropes'**
  String get bookDetailSectionTropes;

  /// No description provided for @bookDetailSectionRepresentation.
  ///
  /// In en, this message translates to:
  /// **'Representation'**
  String get bookDetailSectionRepresentation;

  /// No description provided for @bookDetailSectionAbout.
  ///
  /// In en, this message translates to:
  /// **'About this book'**
  String get bookDetailSectionAbout;

  /// No description provided for @bookDetailReadMore.
  ///
  /// In en, this message translates to:
  /// **'Read more'**
  String get bookDetailReadMore;

  /// No description provided for @bookDetailSectionSimilar.
  ///
  /// In en, this message translates to:
  /// **'You might also like'**
  String get bookDetailSectionSimilar;

  /// No description provided for @bookDetailBadgeKu.
  ///
  /// In en, this message translates to:
  /// **'KU'**
  String get bookDetailBadgeKu;

  /// No description provided for @bookDetailUpdating.
  ///
  /// In en, this message translates to:
  /// **'Updating...'**
  String get bookDetailUpdating;

  /// No description provided for @bookDetailRemoveFromList.
  ///
  /// In en, this message translates to:
  /// **'Remove from Reading List'**
  String get bookDetailRemoveFromList;

  /// No description provided for @bookDetailSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get bookDetailSaving;

  /// No description provided for @bookDetailSaveToList.
  ///
  /// In en, this message translates to:
  /// **'Save to Reading List'**
  String get bookDetailSaveToList;

  /// No description provided for @bookDetailOpening.
  ///
  /// In en, this message translates to:
  /// **'Opening...'**
  String get bookDetailOpening;

  /// No description provided for @bookDetailReadInApp.
  ///
  /// In en, this message translates to:
  /// **'Read in App'**
  String get bookDetailReadInApp;

  /// No description provided for @bookDetailGetBook.
  ///
  /// In en, this message translates to:
  /// **'Get this Book'**
  String get bookDetailGetBook;

  /// No description provided for @bookDetailAmazon.
  ///
  /// In en, this message translates to:
  /// **'Amazon US'**
  String get bookDetailAmazon;

  /// No description provided for @bookDetailAllRetailers.
  ///
  /// In en, this message translates to:
  /// **'View all retailers'**
  String get bookDetailAllRetailers;

  /// No description provided for @bookDetailAudiobook.
  ///
  /// In en, this message translates to:
  /// **'Audiobook'**
  String get bookDetailAudiobook;

  /// No description provided for @filterSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by title or author...'**
  String get filterSearchHint;

  /// No description provided for @filterChipKu.
  ///
  /// In en, this message translates to:
  /// **'KU'**
  String get filterChipKu;

  /// No description provided for @filterChipAudiobook.
  ///
  /// In en, this message translates to:
  /// **'Audiobook'**
  String get filterChipAudiobook;

  /// No description provided for @filterClearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get filterClearAll;

  /// No description provided for @filterSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filterSheetTitle;

  /// No description provided for @filterSheetReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get filterSheetReset;

  /// No description provided for @filterSheetSubgenres.
  ///
  /// In en, this message translates to:
  /// **'Subgenres'**
  String get filterSheetSubgenres;

  /// No description provided for @filterSheetTropes.
  ///
  /// In en, this message translates to:
  /// **'Tropes'**
  String get filterSheetTropes;

  /// No description provided for @filterSheetSpiceLevel.
  ///
  /// In en, this message translates to:
  /// **'Spice Level'**
  String get filterSheetSpiceLevel;

  /// No description provided for @filterSheetAgeCategory.
  ///
  /// In en, this message translates to:
  /// **'Age Category'**
  String get filterSheetAgeCategory;

  /// No description provided for @filterSheetRepresentation.
  ///
  /// In en, this message translates to:
  /// **'Representation'**
  String get filterSheetRepresentation;

  /// No description provided for @filterSheetLanguageLevel.
  ///
  /// In en, this message translates to:
  /// **'Language Level'**
  String get filterSheetLanguageLevel;

  /// No description provided for @filterSheetApplyWithCount.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters ({count})'**
  String filterSheetApplyWithCount(int count);

  /// No description provided for @filterSheetApply.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get filterSheetApply;

  /// No description provided for @signUpSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get signUpSkip;

  /// No description provided for @rolePickerHeadline.
  ///
  /// In en, this message translates to:
  /// **'I am a...'**
  String get rolePickerHeadline;

  /// No description provided for @rolePickerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose how you want to use StuffWithFantasy'**
  String get rolePickerSubtitle;

  /// No description provided for @rolePickerContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get rolePickerContinue;

  /// No description provided for @interestStepHeadline.
  ///
  /// In en, this message translates to:
  /// **'What else brings you here?'**
  String get interestStepHeadline;

  /// No description provided for @interestStepSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select any that apply — or skip ahead.'**
  String get interestStepSubtitle;

  /// No description provided for @interestCardAuthorTitle.
  ///
  /// In en, this message translates to:
  /// **'I\'m an Author'**
  String get interestCardAuthorTitle;

  /// No description provided for @interestCardAuthorDescription.
  ///
  /// In en, this message translates to:
  /// **'I want to get my books discovered by fantasy readers.'**
  String get interestCardAuthorDescription;

  /// No description provided for @interestCardInfluencerTitle.
  ///
  /// In en, this message translates to:
  /// **'I\'m an Influencer'**
  String get interestCardInfluencerTitle;

  /// No description provided for @interestCardInfluencerDescription.
  ///
  /// In en, this message translates to:
  /// **'I create content and want to share fantasy books with my audience.'**
  String get interestCardInfluencerDescription;

  /// No description provided for @interestStepContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get interestStepContinue;

  /// No description provided for @signUpFormHeadline.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get signUpFormHeadline;

  /// No description provided for @signUpFormSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Just a few details and you\'re in'**
  String get signUpFormSubtitle;

  /// No description provided for @signUpFieldNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Display name'**
  String get signUpFieldNameLabel;

  /// No description provided for @signUpFieldNameHint.
  ///
  /// In en, this message translates to:
  /// **'How should we call you?'**
  String get signUpFieldNameHint;

  /// No description provided for @signUpValidatorEnterName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get signUpValidatorEnterName;

  /// No description provided for @signUpFieldEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get signUpFieldEmailLabel;

  /// No description provided for @signUpFieldEmailHint.
  ///
  /// In en, this message translates to:
  /// **'you@example.com'**
  String get signUpFieldEmailHint;

  /// No description provided for @signUpValidatorEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get signUpValidatorEnterEmail;

  /// No description provided for @signUpValidatorInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get signUpValidatorInvalidEmail;

  /// No description provided for @signUpFieldPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get signUpFieldPasswordLabel;

  /// No description provided for @signUpFieldPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters'**
  String get signUpFieldPasswordHint;

  /// No description provided for @signUpValidatorEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter a password'**
  String get signUpValidatorEnterPassword;

  /// No description provided for @signUpValidatorPasswordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Must be at least 8 characters'**
  String get signUpValidatorPasswordTooShort;

  /// No description provided for @signUpButtonCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get signUpButtonCreateAccount;

  /// No description provided for @welcomeStepHeadline.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {name}!'**
  String welcomeStepHeadline(String name);

  /// No description provided for @welcomeStepSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your next great fantasy adventure is waiting for you.'**
  String get welcomeStepSubtitle;

  /// No description provided for @welcomeStepGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get welcomeStepGetStarted;

  /// No description provided for @profileUnknownRank.
  ///
  /// In en, this message translates to:
  /// **'Unknown Rank'**
  String get profileUnknownRank;

  /// No description provided for @profileAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Guild Hall'**
  String get profileAppBarTitle;

  /// No description provided for @profileSectionRunes.
  ///
  /// In en, this message translates to:
  /// **'Runes'**
  String get profileSectionRunes;

  /// No description provided for @profileSectionRunesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Seal quests to engrave ability runes.'**
  String get profileSectionRunesSubtitle;

  /// No description provided for @profileSectionQuestLog.
  ///
  /// In en, this message translates to:
  /// **'Quest Log'**
  String get profileSectionQuestLog;

  /// No description provided for @profileSectionQuestLogSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Unfurl scrolls to track and seal objectives.'**
  String get profileSectionQuestLogSubtitle;

  /// No description provided for @profileSectionRelicVault.
  ///
  /// In en, this message translates to:
  /// **'Relic Vault'**
  String get profileSectionRelicVault;

  /// No description provided for @profileSectionRelicVaultSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Seal scrolls to claim relics for your vault.'**
  String get profileSectionRelicVaultSubtitle;

  /// No description provided for @profileSectionCharacterSheet.
  ///
  /// In en, this message translates to:
  /// **'Character Sheet'**
  String get profileSectionCharacterSheet;

  /// No description provided for @profileSnackbarRuneComingSoon.
  ///
  /// In en, this message translates to:
  /// **'This rune will be configurable soon.'**
  String get profileSnackbarRuneComingSoon;

  /// No description provided for @profileDeleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get profileDeleteAccountTitle;

  /// No description provided for @profileDeleteAccountBody.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete your account and all associated data. This cannot be undone.'**
  String get profileDeleteAccountBody;

  /// No description provided for @profileDeleteCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get profileDeleteCancel;

  /// No description provided for @profileDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get profileDeleteConfirm;

  /// No description provided for @profileSigningOut.
  ///
  /// In en, this message translates to:
  /// **'Leaving the realm...'**
  String get profileSigningOut;

  /// No description provided for @profileSignOut.
  ///
  /// In en, this message translates to:
  /// **'Exit the Realm'**
  String get profileSignOut;

  /// No description provided for @profileDeletingAccount.
  ///
  /// In en, this message translates to:
  /// **'Deleting account...'**
  String get profileDeletingAccount;

  /// No description provided for @profileDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get profileDeleteAccount;

  /// No description provided for @profileRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get profileRetry;

  /// No description provided for @profileErrorHeadline.
  ///
  /// In en, this message translates to:
  /// **'The quest board failed to load'**
  String get profileErrorHeadline;

  /// No description provided for @profileTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get profileTryAgain;

  /// No description provided for @guestGuildHallLabel.
  ///
  /// In en, this message translates to:
  /// **'GUILD HALL'**
  String get guestGuildHallLabel;

  /// No description provided for @guestGuildHeadline.
  ///
  /// In en, this message translates to:
  /// **'Begin your quest'**
  String get guestGuildHeadline;

  /// No description provided for @guestGuildBody.
  ///
  /// In en, this message translates to:
  /// **'Create an account to track your reading quests, unlock ability runes, and collect relics as you explore the realm.'**
  String get guestGuildBody;

  /// No description provided for @guestGuildButtonCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account to begin'**
  String get guestGuildButtonCreateAccount;

  /// No description provided for @runeStatusEngraved.
  ///
  /// In en, this message translates to:
  /// **'ENGRAVED'**
  String get runeStatusEngraved;

  /// No description provided for @runeStatusLocked.
  ///
  /// In en, this message translates to:
  /// **'LOCKED'**
  String get runeStatusLocked;

  /// No description provided for @runeDetailLockedHint.
  ///
  /// In en, this message translates to:
  /// **'Complete the linked quest to engrave this rune'**
  String get runeDetailLockedHint;

  /// No description provided for @runeDetailConfigure.
  ///
  /// In en, this message translates to:
  /// **'Configure'**
  String get runeDetailConfigure;

  /// No description provided for @arcShieldTitle.
  ///
  /// In en, this message translates to:
  /// **'ARC Shield'**
  String get arcShieldTitle;

  /// No description provided for @arcShieldDescription.
  ///
  /// In en, this message translates to:
  /// **'When active, authors and publishers can find you as an ARC reader.'**
  String get arcShieldDescription;

  /// No description provided for @arcShieldSectionAvailability.
  ///
  /// In en, this message translates to:
  /// **'Availability'**
  String get arcShieldSectionAvailability;

  /// No description provided for @arcShieldToggleOpenLabel.
  ///
  /// In en, this message translates to:
  /// **'Open to ARCs'**
  String get arcShieldToggleOpenLabel;

  /// No description provided for @arcShieldToggleClosedLabel.
  ///
  /// In en, this message translates to:
  /// **'Not accepting ARCs'**
  String get arcShieldToggleClosedLabel;

  /// No description provided for @arcShieldToggleOpenSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Authors can reach out to you'**
  String get arcShieldToggleOpenSubtitle;

  /// No description provided for @arcShieldToggleClosedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your profile is hidden from ARC searches'**
  String get arcShieldToggleClosedSubtitle;

  /// No description provided for @genreAttunementTitle.
  ///
  /// In en, this message translates to:
  /// **'Genre Attunement'**
  String get genreAttunementTitle;

  /// No description provided for @genreAttunementDescription.
  ///
  /// In en, this message translates to:
  /// **'Select the genres and tropes that call to you. The realm will learn what to surface.'**
  String get genreAttunementDescription;

  /// No description provided for @genreAttunementSectionGenres.
  ///
  /// In en, this message translates to:
  /// **'Genres'**
  String get genreAttunementSectionGenres;

  /// No description provided for @genreAttunementSectionTropes.
  ///
  /// In en, this message translates to:
  /// **'Tropes'**
  String get genreAttunementSectionTropes;

  /// No description provided for @genreAttunementCountAttuned.
  ///
  /// In en, this message translates to:
  /// **'{count} attuned'**
  String genreAttunementCountAttuned(int count);

  /// No description provided for @genreEpicFantasy.
  ///
  /// In en, this message translates to:
  /// **'Epic Fantasy'**
  String get genreEpicFantasy;

  /// No description provided for @genreDarkFantasy.
  ///
  /// In en, this message translates to:
  /// **'Dark Fantasy'**
  String get genreDarkFantasy;

  /// No description provided for @genreUrbanFantasy.
  ///
  /// In en, this message translates to:
  /// **'Urban Fantasy'**
  String get genreUrbanFantasy;

  /// No description provided for @genreRomantasy.
  ///
  /// In en, this message translates to:
  /// **'Romantasy'**
  String get genreRomantasy;

  /// No description provided for @genreCozyFantasy.
  ///
  /// In en, this message translates to:
  /// **'Cozy Fantasy'**
  String get genreCozyFantasy;

  /// No description provided for @genreGrimdark.
  ///
  /// In en, this message translates to:
  /// **'Grimdark'**
  String get genreGrimdark;

  /// No description provided for @genreLitRpg.
  ///
  /// In en, this message translates to:
  /// **'LitRPG'**
  String get genreLitRpg;

  /// No description provided for @genreSwordAndSorcery.
  ///
  /// In en, this message translates to:
  /// **'Sword & Sorcery'**
  String get genreSwordAndSorcery;

  /// No description provided for @genreMythicFantasy.
  ///
  /// In en, this message translates to:
  /// **'Mythic Fantasy'**
  String get genreMythicFantasy;

  /// No description provided for @genrePortalFantasy.
  ///
  /// In en, this message translates to:
  /// **'Portal Fantasy'**
  String get genrePortalFantasy;

  /// No description provided for @tropeFoundFamily.
  ///
  /// In en, this message translates to:
  /// **'Found Family'**
  String get tropeFoundFamily;

  /// No description provided for @tropeEnemiesToLovers.
  ///
  /// In en, this message translates to:
  /// **'Enemies to Lovers'**
  String get tropeEnemiesToLovers;

  /// No description provided for @tropeChosenOne.
  ///
  /// In en, this message translates to:
  /// **'Chosen One'**
  String get tropeChosenOne;

  /// No description provided for @tropeMagicSchools.
  ///
  /// In en, this message translates to:
  /// **'Magic Schools'**
  String get tropeMagicSchools;

  /// No description provided for @tropeMorallyGrey.
  ///
  /// In en, this message translates to:
  /// **'Morally Grey'**
  String get tropeMorallyGrey;

  /// No description provided for @tropeSlowBurn.
  ///
  /// In en, this message translates to:
  /// **'Slow Burn'**
  String get tropeSlowBurn;

  /// No description provided for @tropePoliticalIntrigue.
  ///
  /// In en, this message translates to:
  /// **'Political Intrigue'**
  String get tropePoliticalIntrigue;

  /// No description provided for @tropeQuestJourney.
  ///
  /// In en, this message translates to:
  /// **'Quest Journey'**
  String get tropeQuestJourney;

  /// No description provided for @tropeHiddenRoyalty.
  ///
  /// In en, this message translates to:
  /// **'Hidden Royalty'**
  String get tropeHiddenRoyalty;

  /// No description provided for @tropeRevengeArc.
  ///
  /// In en, this message translates to:
  /// **'Revenge Arc'**
  String get tropeRevengeArc;

  /// No description provided for @eventWatchtowerTitle.
  ///
  /// In en, this message translates to:
  /// **'Event Watchtower'**
  String get eventWatchtowerTitle;

  /// No description provided for @eventWatchtowerDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose which signals reach you from the realm.'**
  String get eventWatchtowerDescription;

  /// No description provided for @eventWatchtowerSectionSignals.
  ///
  /// In en, this message translates to:
  /// **'Signals'**
  String get eventWatchtowerSectionSignals;

  /// No description provided for @notifNewEventsTitle.
  ///
  /// In en, this message translates to:
  /// **'New Events'**
  String get notifNewEventsTitle;

  /// No description provided for @notifNewEventsDescription.
  ///
  /// In en, this message translates to:
  /// **'When a Stuff Your Kindle event launches'**
  String get notifNewEventsDescription;

  /// No description provided for @notifBookDropsTitle.
  ///
  /// In en, this message translates to:
  /// **'Book Drops'**
  String get notifBookDropsTitle;

  /// No description provided for @notifBookDropsDescription.
  ///
  /// In en, this message translates to:
  /// **'When new books are added to the catalog'**
  String get notifBookDropsDescription;

  /// No description provided for @notifRecommendationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Recommendations'**
  String get notifRecommendationsTitle;

  /// No description provided for @notifRecommendationsDescription.
  ///
  /// In en, this message translates to:
  /// **'Personalized picks based on your attunement'**
  String get notifRecommendationsDescription;

  /// No description provided for @rewardRevealBarrierLabel.
  ///
  /// In en, this message translates to:
  /// **'Reward reveal'**
  String get rewardRevealBarrierLabel;

  /// No description provided for @rewardRevealLegendRelicClaimed.
  ///
  /// In en, this message translates to:
  /// **'LEGEND RELIC CLAIMED'**
  String get rewardRevealLegendRelicClaimed;

  /// No description provided for @rewardRevealRelicUnlocked.
  ///
  /// In en, this message translates to:
  /// **'RELIC UNLOCKED'**
  String get rewardRevealRelicUnlocked;

  /// No description provided for @rewardRevealContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue questing'**
  String get rewardRevealContinue;

  /// No description provided for @characterSheetHeaderLabel.
  ///
  /// In en, this message translates to:
  /// **'CHARACTER SHEET'**
  String get characterSheetHeaderLabel;

  /// No description provided for @characterSheetStatName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get characterSheetStatName;

  /// No description provided for @characterSheetStatRank.
  ///
  /// In en, this message translates to:
  /// **'Rank'**
  String get characterSheetStatRank;

  /// No description provided for @characterSheetStatQuests.
  ///
  /// In en, this message translates to:
  /// **'Quests'**
  String get characterSheetStatQuests;

  /// No description provided for @characterSheetStatQuestsValue.
  ///
  /// In en, this message translates to:
  /// **'{completed} / {total}'**
  String characterSheetStatQuestsValue(int completed, int total);

  /// No description provided for @characterSheetStatRelics.
  ///
  /// In en, this message translates to:
  /// **'Relics'**
  String get characterSheetStatRelics;

  /// No description provided for @characterSheetStatRelicsValue.
  ///
  /// In en, this message translates to:
  /// **'{collected} / {total}'**
  String characterSheetStatRelicsValue(int collected, int total);

  /// No description provided for @characterSheetStatSignal.
  ///
  /// In en, this message translates to:
  /// **'Signal'**
  String get characterSheetStatSignal;

  /// No description provided for @realmMapCurrentQuest.
  ///
  /// In en, this message translates to:
  /// **'CURRENT QUEST'**
  String get realmMapCurrentQuest;

  /// No description provided for @questScrollSealed.
  ///
  /// In en, this message translates to:
  /// **'Sealed'**
  String get questScrollSealed;

  /// No description provided for @questScrollActive.
  ///
  /// In en, this message translates to:
  /// **'ACTIVE'**
  String get questScrollActive;

  /// No description provided for @questScrollReward.
  ///
  /// In en, this message translates to:
  /// **'REWARD'**
  String get questScrollReward;

  /// No description provided for @relicVaultLockedTitle.
  ///
  /// In en, this message translates to:
  /// **'???'**
  String get relicVaultLockedTitle;

  /// No description provided for @relicVaultLegendRelic.
  ///
  /// In en, this message translates to:
  /// **'Legend relic'**
  String get relicVaultLegendRelic;

  /// No description provided for @relicVaultClaimed.
  ///
  /// In en, this message translates to:
  /// **'Claimed'**
  String get relicVaultClaimed;

  /// No description provided for @relicVaultSealed.
  ///
  /// In en, this message translates to:
  /// **'Sealed'**
  String get relicVaultSealed;

  /// No description provided for @libraryAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get libraryAppBarTitle;

  /// No description provided for @libraryTabMyBooks.
  ///
  /// In en, this message translates to:
  /// **'My Books'**
  String get libraryTabMyBooks;

  /// No description provided for @libraryTabReadingList.
  ///
  /// In en, this message translates to:
  /// **'Reading List'**
  String get libraryTabReadingList;

  /// No description provided for @libraryMyBooksSignInTitle.
  ///
  /// In en, this message translates to:
  /// **'Your bookshelf awaits'**
  String get libraryMyBooksSignInTitle;

  /// No description provided for @libraryMyBooksSignInMessage.
  ///
  /// In en, this message translates to:
  /// **'Sign in to access books you\'ve purchased, claimed, or uploaded — ready to read right here.'**
  String get libraryMyBooksSignInMessage;

  /// No description provided for @libraryMyBooksEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No readable books yet'**
  String get libraryMyBooksEmptyTitle;

  /// No description provided for @libraryMyBooksEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Books you buy, claim, or upload will show up here when they are ready to read.'**
  String get libraryMyBooksEmptyMessage;

  /// No description provided for @libraryReadingListSignInTitle.
  ///
  /// In en, this message translates to:
  /// **'Start your reading list'**
  String get libraryReadingListSignInTitle;

  /// No description provided for @libraryReadingListSignInMessage.
  ///
  /// In en, this message translates to:
  /// **'Sign in to save books from the catalog and build your personal reading list.'**
  String get libraryReadingListSignInMessage;

  /// No description provided for @libraryReadingListEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing saved yet'**
  String get libraryReadingListEmptyTitle;

  /// No description provided for @libraryReadingListEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Save books from the catalog to build your reading list.'**
  String get libraryReadingListEmptyMessage;

  /// No description provided for @libraryButtonSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get libraryButtonSignIn;

  /// No description provided for @libraryRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get libraryRetry;

  /// No description provided for @readerProgressRead.
  ///
  /// In en, this message translates to:
  /// **'{progress} read'**
  String readerProgressRead(String progress);

  /// No description provided for @readerHintSwipeToTurn.
  ///
  /// In en, this message translates to:
  /// **'Swipe to turn pages'**
  String get readerHintSwipeToTurn;

  /// No description provided for @readerHintOpeningBook.
  ///
  /// In en, this message translates to:
  /// **'Opening book…'**
  String get readerHintOpeningBook;

  /// No description provided for @readerHintTapToHide.
  ///
  /// In en, this message translates to:
  /// **'Tap the center to hide controls'**
  String get readerHintTapToHide;

  /// No description provided for @readerTooltipBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get readerTooltipBack;

  /// No description provided for @readerTooltipChapters.
  ///
  /// In en, this message translates to:
  /// **'Chapters'**
  String get readerTooltipChapters;

  /// No description provided for @readerTooltipReadingSettings.
  ///
  /// In en, this message translates to:
  /// **'Reading settings'**
  String get readerTooltipReadingSettings;

  /// No description provided for @readerTooltipPreviousPage.
  ///
  /// In en, this message translates to:
  /// **'Previous page'**
  String get readerTooltipPreviousPage;

  /// No description provided for @readerButtonPrev.
  ///
  /// In en, this message translates to:
  /// **'Prev'**
  String get readerButtonPrev;

  /// No description provided for @readerTooltipNextPage.
  ///
  /// In en, this message translates to:
  /// **'Next page'**
  String get readerTooltipNextPage;

  /// No description provided for @readerButtonNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get readerButtonNext;

  /// No description provided for @readerChaptersTitle.
  ///
  /// In en, this message translates to:
  /// **'Chapters'**
  String get readerChaptersTitle;

  /// No description provided for @readerSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Reading settings'**
  String get readerSettingsTitle;

  /// No description provided for @readerSettingsTextSize.
  ///
  /// In en, this message translates to:
  /// **'Text size'**
  String get readerSettingsTextSize;

  /// No description provided for @readerTooltipSmallerText.
  ///
  /// In en, this message translates to:
  /// **'Smaller text'**
  String get readerTooltipSmallerText;

  /// No description provided for @readerFontSizeLabel.
  ///
  /// In en, this message translates to:
  /// **'{size} pt'**
  String readerFontSizeLabel(int size);

  /// No description provided for @readerTooltipLargerText.
  ///
  /// In en, this message translates to:
  /// **'Larger text'**
  String get readerTooltipLargerText;

  /// No description provided for @readerSettingsPageTheme.
  ///
  /// In en, this message translates to:
  /// **'Page theme'**
  String get readerSettingsPageTheme;

  /// No description provided for @readerAppearancePaper.
  ///
  /// In en, this message translates to:
  /// **'Paper'**
  String get readerAppearancePaper;

  /// No description provided for @readerAppearanceSepia.
  ///
  /// In en, this message translates to:
  /// **'Sepia'**
  String get readerAppearanceSepia;

  /// No description provided for @readerAppearanceNight.
  ///
  /// In en, this message translates to:
  /// **'Night'**
  String get readerAppearanceNight;

  /// No description provided for @eventDetailLoadingBooks.
  ///
  /// In en, this message translates to:
  /// **'Loading books...'**
  String get eventDetailLoadingBooks;

  /// No description provided for @eventDetailBookCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 book in this event} other{{count} books in this event}}'**
  String eventDetailBookCount(int count);

  /// No description provided for @eventDetailNoBooksYet.
  ///
  /// In en, this message translates to:
  /// **'No books in this event yet.'**
  String get eventDetailNoBooksYet;

  /// No description provided for @creatorDetailNoBooksYet.
  ///
  /// In en, this message translates to:
  /// **'No books to show yet.'**
  String get creatorDetailNoBooksYet;

  /// No description provided for @creatorDetailFavoriteBookLabel.
  ///
  /// In en, this message translates to:
  /// **'Favorite book: '**
  String get creatorDetailFavoriteBookLabel;

  /// No description provided for @creatorDetailLovesLabel.
  ///
  /// In en, this message translates to:
  /// **'Loves: '**
  String get creatorDetailLovesLabel;

  /// No description provided for @creatorDetailBooksBy.
  ///
  /// In en, this message translates to:
  /// **'Books by {name}'**
  String creatorDetailBooksBy(String name);

  /// No description provided for @creatorDetailRecommendedBy.
  ///
  /// In en, this message translates to:
  /// **'Recommended by {name}'**
  String creatorDetailRecommendedBy(String name);

  /// No description provided for @socialLinkTiktok.
  ///
  /// In en, this message translates to:
  /// **'TikTok'**
  String get socialLinkTiktok;

  /// No description provided for @socialLinkInstagram.
  ///
  /// In en, this message translates to:
  /// **'Instagram'**
  String get socialLinkInstagram;

  /// No description provided for @socialLinkYoutube.
  ///
  /// In en, this message translates to:
  /// **'YouTube'**
  String get socialLinkYoutube;

  /// No description provided for @socialLinkThreads.
  ///
  /// In en, this message translates to:
  /// **'Threads'**
  String get socialLinkThreads;

  /// No description provided for @socialLinkGoodreads.
  ///
  /// In en, this message translates to:
  /// **'Goodreads'**
  String get socialLinkGoodreads;

  /// No description provided for @socialLinkStorygraph.
  ///
  /// In en, this message translates to:
  /// **'StoryGraph'**
  String get socialLinkStorygraph;

  /// No description provided for @socialLinkBookbub.
  ///
  /// In en, this message translates to:
  /// **'BookBub'**
  String get socialLinkBookbub;

  /// No description provided for @socialLinkFacebook.
  ///
  /// In en, this message translates to:
  /// **'Facebook'**
  String get socialLinkFacebook;

  /// No description provided for @socialLinkWebsite.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get socialLinkWebsite;

  /// No description provided for @userRoleReader.
  ///
  /// In en, this message translates to:
  /// **'Reader'**
  String get userRoleReader;

  /// No description provided for @userRoleReaderDescription.
  ///
  /// In en, this message translates to:
  /// **'Discover your next favorite fantasy book'**
  String get userRoleReaderDescription;

  /// No description provided for @creatorRoleAuthor.
  ///
  /// In en, this message translates to:
  /// **'Author'**
  String get creatorRoleAuthor;

  /// No description provided for @creatorRoleInfluencer.
  ///
  /// In en, this message translates to:
  /// **'Influencer'**
  String get creatorRoleInfluencer;

  /// No description provided for @readAccessOwner.
  ///
  /// In en, this message translates to:
  /// **'Your upload'**
  String get readAccessOwner;

  /// No description provided for @readAccessPurchased.
  ///
  /// In en, this message translates to:
  /// **'Purchased'**
  String get readAccessPurchased;

  /// No description provided for @readAccessNone.
  ///
  /// In en, this message translates to:
  /// **'No access'**
  String get readAccessNone;

  /// No description provided for @eventStatusLastDay.
  ///
  /// In en, this message translates to:
  /// **'Last day!'**
  String get eventStatusLastDay;

  /// No description provided for @eventStatusHappeningNow.
  ///
  /// In en, this message translates to:
  /// **'Happening now'**
  String get eventStatusHappeningNow;

  /// No description provided for @eventStatusStartsToday.
  ///
  /// In en, this message translates to:
  /// **'Starts today'**
  String get eventStatusStartsToday;

  /// No description provided for @eventStatusStartsTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Starts tomorrow'**
  String get eventStatusStartsTomorrow;

  /// No description provided for @eventStatusStartsInDays.
  ///
  /// In en, this message translates to:
  /// **'Starts in {days} days'**
  String eventStatusStartsInDays(int days);

  /// No description provided for @spiceLevelNone.
  ///
  /// In en, this message translates to:
  /// **'No Spice'**
  String get spiceLevelNone;

  /// No description provided for @spiceLevelMild.
  ///
  /// In en, this message translates to:
  /// **'Mild Spice'**
  String get spiceLevelMild;

  /// No description provided for @spiceLevelMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium Spice'**
  String get spiceLevelMedium;

  /// No description provided for @spiceLevelHot.
  ///
  /// In en, this message translates to:
  /// **'Hot'**
  String get spiceLevelHot;

  /// No description provided for @spiceLevelScorching.
  ///
  /// In en, this message translates to:
  /// **'Scorching'**
  String get spiceLevelScorching;

  /// No description provided for @languageLevelClean.
  ///
  /// In en, this message translates to:
  /// **'Clean'**
  String get languageLevelClean;

  /// No description provided for @languageLevelMild.
  ///
  /// In en, this message translates to:
  /// **'Mild Language'**
  String get languageLevelMild;

  /// No description provided for @languageLevelModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate Language'**
  String get languageLevelModerate;

  /// No description provided for @languageLevelStrong.
  ///
  /// In en, this message translates to:
  /// **'Strong Language'**
  String get languageLevelStrong;

  /// No description provided for @homeHeadline.
  ///
  /// In en, this message translates to:
  /// **'Stuff With Fantasy'**
  String get homeHeadline;

  /// No description provided for @homeTagline.
  ///
  /// In en, this message translates to:
  /// **'Your fantasy reading companion.'**
  String get homeTagline;

  /// No description provided for @homeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Discover, track, and share the fantasy books you love.'**
  String get homeSubtitle;

  /// No description provided for @homeChipMaterial3.
  ///
  /// In en, this message translates to:
  /// **'Material 3'**
  String get homeChipMaterial3;

  /// No description provided for @homeChipStructuredStarter.
  ///
  /// In en, this message translates to:
  /// **'Structured starter'**
  String get homeChipStructuredStarter;

  /// No description provided for @homeChipWidgetTests.
  ///
  /// In en, this message translates to:
  /// **'Widget tests'**
  String get homeChipWidgetTests;

  /// No description provided for @homeCardWhatIsReadyTitle.
  ///
  /// In en, this message translates to:
  /// **'What is ready'**
  String get homeCardWhatIsReadyTitle;

  /// No description provided for @homeCardWhatIsReadyItem1.
  ///
  /// In en, this message translates to:
  /// **'A branded app shell with light and dark themes.'**
  String get homeCardWhatIsReadyItem1;

  /// No description provided for @homeCardWhatIsReadyItem2.
  ///
  /// In en, this message translates to:
  /// **'A stricter analyzer baseline using flutter_lints.'**
  String get homeCardWhatIsReadyItem2;

  /// No description provided for @homeCardWhatIsReadyItem3.
  ///
  /// In en, this message translates to:
  /// **'A widget test to protect the starter experience.'**
  String get homeCardWhatIsReadyItem3;

  /// No description provided for @homeCardWhereToGoNextTitle.
  ///
  /// In en, this message translates to:
  /// **'Where to go next'**
  String get homeCardWhereToGoNextTitle;

  /// No description provided for @homeCardWhereToGoNextItem1.
  ///
  /// In en, this message translates to:
  /// **'Add features under lib/src by domain instead of growing main.dart.'**
  String get homeCardWhereToGoNextItem1;

  /// No description provided for @homeCardWhereToGoNextItem2.
  ///
  /// In en, this message translates to:
  /// **'Replace placeholder assets, launcher icons, and product copy.'**
  String get homeCardWhereToGoNextItem2;

  /// No description provided for @homeCardWhereToGoNextItem3.
  ///
  /// In en, this message translates to:
  /// **'Run flutter analyze and flutter test as you add screens.'**
  String get homeCardWhereToGoNextItem3;

  /// No description provided for @homeGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get homeGetStarted;

  /// No description provided for @homeBrowseBooks.
  ///
  /// In en, this message translates to:
  /// **'Browse Books'**
  String get homeBrowseBooks;

  /// No description provided for @monthJan.
  ///
  /// In en, this message translates to:
  /// **'Jan'**
  String get monthJan;

  /// No description provided for @monthFeb.
  ///
  /// In en, this message translates to:
  /// **'Feb'**
  String get monthFeb;

  /// No description provided for @monthMar.
  ///
  /// In en, this message translates to:
  /// **'Mar'**
  String get monthMar;

  /// No description provided for @monthApr.
  ///
  /// In en, this message translates to:
  /// **'Apr'**
  String get monthApr;

  /// No description provided for @monthMay.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get monthMay;

  /// No description provided for @monthJun.
  ///
  /// In en, this message translates to:
  /// **'Jun'**
  String get monthJun;

  /// No description provided for @monthJul.
  ///
  /// In en, this message translates to:
  /// **'Jul'**
  String get monthJul;

  /// No description provided for @monthAug.
  ///
  /// In en, this message translates to:
  /// **'Aug'**
  String get monthAug;

  /// No description provided for @monthSep.
  ///
  /// In en, this message translates to:
  /// **'Sep'**
  String get monthSep;

  /// No description provided for @monthOct.
  ///
  /// In en, this message translates to:
  /// **'Oct'**
  String get monthOct;

  /// No description provided for @monthNov.
  ///
  /// In en, this message translates to:
  /// **'Nov'**
  String get monthNov;

  /// No description provided for @monthDec.
  ///
  /// In en, this message translates to:
  /// **'Dec'**
  String get monthDec;

  /// No description provided for @profileSectionLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get profileSectionLanguage;

  /// No description provided for @languageSystemDefault.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get languageSystemDefault;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageSpanish.
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get languageSpanish;

  /// No description provided for @languagePortuguese.
  ///
  /// In en, this message translates to:
  /// **'Português'**
  String get languagePortuguese;

  /// No description provided for @languageGerman.
  ///
  /// In en, this message translates to:
  /// **'Deutsch'**
  String get languageGerman;

  /// No description provided for @languageRussian.
  ///
  /// In en, this message translates to:
  /// **'Русский'**
  String get languageRussian;

  /// No description provided for @languageBulgarian.
  ///
  /// In en, this message translates to:
  /// **'Български'**
  String get languageBulgarian;

  /// No description provided for @languageJapanese.
  ///
  /// In en, this message translates to:
  /// **'日本語'**
  String get languageJapanese;

  /// No description provided for @profileSectionReadingChronicle.
  ///
  /// In en, this message translates to:
  /// **'Reading Chronicle'**
  String get profileSectionReadingChronicle;

  /// No description provided for @profileSectionReadingChronicleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your journey through the pages, mapped in ink.'**
  String get profileSectionReadingChronicleSubtitle;

  /// No description provided for @profileSectionTomeCounter.
  ///
  /// In en, this message translates to:
  /// **'Tome Counter'**
  String get profileSectionTomeCounter;

  /// No description provided for @profileSectionTomeCounterSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your accumulated reading feats.'**
  String get profileSectionTomeCounterSubtitle;

  /// No description provided for @profileSectionAchievementSigils.
  ///
  /// In en, this message translates to:
  /// **'Achievement Sigils'**
  String get profileSectionAchievementSigils;

  /// No description provided for @profileSectionAchievementSigilsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Milestones forged through dedication.'**
  String get profileSectionAchievementSigilsSubtitle;

  /// No description provided for @chroniclePagesThisWeek.
  ///
  /// In en, this message translates to:
  /// **'~{count} pages this week'**
  String chroniclePagesThisWeek(int count);

  /// No description provided for @chronicleStreak.
  ///
  /// In en, this message translates to:
  /// **'{count}-day streak'**
  String chronicleStreak(int count);

  /// No description provided for @chronicleLess.
  ///
  /// In en, this message translates to:
  /// **'Less'**
  String get chronicleLess;

  /// No description provided for @chronicleMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get chronicleMore;

  /// No description provided for @tomeCounterBooks.
  ///
  /// In en, this message translates to:
  /// **'Tomes Conquered'**
  String get tomeCounterBooks;

  /// No description provided for @tomeCounterPages.
  ///
  /// In en, this message translates to:
  /// **'Pages Turned'**
  String get tomeCounterPages;

  /// No description provided for @tomeCounterTime.
  ///
  /// In en, this message translates to:
  /// **'Time in Realm'**
  String get tomeCounterTime;

  /// No description provided for @tomeCounterHoursMinutes.
  ///
  /// In en, this message translates to:
  /// **'{hours}h {minutes}m'**
  String tomeCounterHoursMinutes(int hours, int minutes);

  /// No description provided for @tomeCounterMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes}m'**
  String tomeCounterMinutes(int minutes);

  /// No description provided for @achievementLocked.
  ///
  /// In en, this message translates to:
  /// **'SEALED'**
  String get achievementLocked;

  /// No description provided for @achievementUnlocked.
  ///
  /// In en, this message translates to:
  /// **'EARNED'**
  String get achievementUnlocked;

  /// No description provided for @achievementFirstPageTitle.
  ///
  /// In en, this message translates to:
  /// **'First Page'**
  String get achievementFirstPageTitle;

  /// No description provided for @achievementFirstPageDesc.
  ///
  /// In en, this message translates to:
  /// **'Open a book and begin reading.'**
  String get achievementFirstPageDesc;

  /// No description provided for @achievementBookwormTitle.
  ///
  /// In en, this message translates to:
  /// **'Bookworm Awakens'**
  String get achievementBookwormTitle;

  /// No description provided for @achievementBookwormDesc.
  ///
  /// In en, this message translates to:
  /// **'Finish your first book.'**
  String get achievementBookwormDesc;

  /// No description provided for @achievementDailyRitualTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Ritual'**
  String get achievementDailyRitualTitle;

  /// No description provided for @achievementDailyRitualDesc.
  ///
  /// In en, this message translates to:
  /// **'Read for 3 days in a row.'**
  String get achievementDailyRitualDesc;

  /// No description provided for @achievementPageTurnerTitle.
  ///
  /// In en, this message translates to:
  /// **'Page Turner'**
  String get achievementPageTurnerTitle;

  /// No description provided for @achievementPageTurnerDesc.
  ///
  /// In en, this message translates to:
  /// **'Read approximately 100 pages.'**
  String get achievementPageTurnerDesc;

  /// No description provided for @achievementHourGlassTitle.
  ///
  /// In en, this message translates to:
  /// **'Hour Glass'**
  String get achievementHourGlassTitle;

  /// No description provided for @achievementHourGlassDesc.
  ///
  /// In en, this message translates to:
  /// **'Spend 1 hour reading.'**
  String get achievementHourGlassDesc;

  /// No description provided for @achievementChapterChampionTitle.
  ///
  /// In en, this message translates to:
  /// **'Chapter Champion'**
  String get achievementChapterChampionTitle;

  /// No description provided for @achievementChapterChampionDesc.
  ///
  /// In en, this message translates to:
  /// **'Finish 3 books.'**
  String get achievementChapterChampionDesc;

  /// No description provided for @achievementFlameKeeperTitle.
  ///
  /// In en, this message translates to:
  /// **'Flame Keeper'**
  String get achievementFlameKeeperTitle;

  /// No description provided for @achievementFlameKeeperDesc.
  ///
  /// In en, this message translates to:
  /// **'Read for 7 days in a row.'**
  String get achievementFlameKeeperDesc;

  /// No description provided for @achievementTomeScholarTitle.
  ///
  /// In en, this message translates to:
  /// **'Tome Scholar'**
  String get achievementTomeScholarTitle;

  /// No description provided for @achievementTomeScholarDesc.
  ///
  /// In en, this message translates to:
  /// **'Read approximately 1,000 pages.'**
  String get achievementTomeScholarDesc;

  /// No description provided for @achievementDevotedReaderTitle.
  ///
  /// In en, this message translates to:
  /// **'Devoted Reader'**
  String get achievementDevotedReaderTitle;

  /// No description provided for @achievementDevotedReaderDesc.
  ///
  /// In en, this message translates to:
  /// **'Spend 10 hours reading.'**
  String get achievementDevotedReaderDesc;

  /// No description provided for @achievementFiveRealmsTitle.
  ///
  /// In en, this message translates to:
  /// **'Five Realms'**
  String get achievementFiveRealmsTitle;

  /// No description provided for @achievementFiveRealmsDesc.
  ///
  /// In en, this message translates to:
  /// **'Start reading 5 different books.'**
  String get achievementFiveRealmsDesc;

  /// No description provided for @achievementGrandLibrarianTitle.
  ///
  /// In en, this message translates to:
  /// **'Grand Librarian'**
  String get achievementGrandLibrarianTitle;

  /// No description provided for @achievementGrandLibrarianDesc.
  ///
  /// In en, this message translates to:
  /// **'Finish 10 books.'**
  String get achievementGrandLibrarianDesc;

  /// No description provided for @achievementEternalFlameTitle.
  ///
  /// In en, this message translates to:
  /// **'Eternal Flame'**
  String get achievementEternalFlameTitle;

  /// No description provided for @achievementEternalFlameDesc.
  ///
  /// In en, this message translates to:
  /// **'Maintain a 30-day reading streak.'**
  String get achievementEternalFlameDesc;

  /// No description provided for @achievementMythicScribeTitle.
  ///
  /// In en, this message translates to:
  /// **'Mythic Scribe'**
  String get achievementMythicScribeTitle;

  /// No description provided for @achievementMythicScribeDesc.
  ///
  /// In en, this message translates to:
  /// **'Spend 100 hours reading.'**
  String get achievementMythicScribeDesc;

  /// No description provided for @achievementRealmWalkerTitle.
  ///
  /// In en, this message translates to:
  /// **'Realm Walker'**
  String get achievementRealmWalkerTitle;

  /// No description provided for @achievementRealmWalkerDesc.
  ///
  /// In en, this message translates to:
  /// **'Start reading 10 different books.'**
  String get achievementRealmWalkerDesc;

  /// No description provided for @oathAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Oath Stone'**
  String get oathAppBarTitle;

  /// No description provided for @oathSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Oath Stone'**
  String get oathSectionTitle;

  /// No description provided for @oathSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your sworn reading pledge'**
  String get oathSectionSubtitle;

  /// No description provided for @oathSwearCta.
  ///
  /// In en, this message translates to:
  /// **'Swear an Oath'**
  String get oathSwearCta;

  /// No description provided for @oathSwearSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set a public reading goal and track your progress'**
  String get oathSwearSubtitle;

  /// No description provided for @oathSwearPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Inscribe Your Oath'**
  String get oathSwearPageTitle;

  /// No description provided for @oathFieldTitle.
  ///
  /// In en, this message translates to:
  /// **'Your pledge'**
  String get oathFieldTitle;

  /// No description provided for @oathFieldTitleHint.
  ///
  /// In en, this message translates to:
  /// **'I will read 24 books in 2026'**
  String get oathFieldTitleHint;

  /// No description provided for @oathFieldTarget.
  ///
  /// In en, this message translates to:
  /// **'Target books'**
  String get oathFieldTarget;

  /// No description provided for @oathFieldYear.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get oathFieldYear;

  /// No description provided for @oathFieldPublic.
  ///
  /// In en, this message translates to:
  /// **'Public oath'**
  String get oathFieldPublic;

  /// No description provided for @oathFieldPublicSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Visible on the Lore Board'**
  String get oathFieldPublicSubtitle;

  /// No description provided for @oathSwearButton.
  ///
  /// In en, this message translates to:
  /// **'Swear This Oath'**
  String get oathSwearButton;

  /// No description provided for @oathSwearing.
  ///
  /// In en, this message translates to:
  /// **'Inscribing...'**
  String get oathSwearing;

  /// No description provided for @oathProgressLabel.
  ///
  /// In en, this message translates to:
  /// **'{current} of {target}'**
  String oathProgressLabel(int current, int target);

  /// No description provided for @oathProgressComplete.
  ///
  /// In en, this message translates to:
  /// **'Oath Fulfilled!'**
  String get oathProgressComplete;

  /// No description provided for @oathEntryLogged.
  ///
  /// In en, this message translates to:
  /// **'Rune carved!'**
  String get oathEntryLogged;

  /// No description provided for @oathEntryRemoved.
  ///
  /// In en, this message translates to:
  /// **'Entry removed'**
  String get oathEntryRemoved;

  /// No description provided for @oathDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Break This Oath?'**
  String get oathDeleteConfirmTitle;

  /// No description provided for @oathDeleteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This will permanently remove your oath and all logged entries.'**
  String get oathDeleteConfirmBody;

  /// No description provided for @oathDeleteCancel.
  ///
  /// In en, this message translates to:
  /// **'Keep Oath'**
  String get oathDeleteCancel;

  /// No description provided for @oathDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Break Oath'**
  String get oathDeleteConfirm;

  /// No description provided for @oathDeleted.
  ///
  /// In en, this message translates to:
  /// **'Oath broken'**
  String get oathDeleted;

  /// No description provided for @oathCompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'OATH FULFILLED'**
  String get oathCompleteTitle;

  /// No description provided for @oathCompleteHeadline.
  ///
  /// In en, this message translates to:
  /// **'Your Oath is Sealed'**
  String get oathCompleteHeadline;

  /// No description provided for @oathCompleteBody.
  ///
  /// In en, this message translates to:
  /// **'You have honored your pledge. The runes are complete.'**
  String get oathCompleteBody;

  /// No description provided for @oathCompleteContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get oathCompleteContinue;

  /// No description provided for @oathEmptyEntries.
  ///
  /// In en, this message translates to:
  /// **'No books logged yet'**
  String get oathEmptyEntries;

  /// No description provided for @oathLogBookAction.
  ///
  /// In en, this message translates to:
  /// **'Log toward Oath'**
  String get oathLogBookAction;

  /// No description provided for @oathLogBookConfirm.
  ///
  /// In en, this message translates to:
  /// **'Log \"{title}\" toward your oath?'**
  String oathLogBookConfirm(String title);

  /// No description provided for @oathLogBookButton.
  ///
  /// In en, this message translates to:
  /// **'Log It'**
  String get oathLogBookButton;

  /// No description provided for @oathAlreadyLogged.
  ///
  /// In en, this message translates to:
  /// **'Already logged toward your oath'**
  String get oathAlreadyLogged;

  /// No description provided for @oathEditButton.
  ///
  /// In en, this message translates to:
  /// **'Edit Oath'**
  String get oathEditButton;

  /// No description provided for @oathUpdated.
  ///
  /// In en, this message translates to:
  /// **'Oath updated'**
  String get oathUpdated;

  /// No description provided for @oathErrorCreate.
  ///
  /// In en, this message translates to:
  /// **'Failed to create oath'**
  String get oathErrorCreate;

  /// No description provided for @oathErrorLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load oath'**
  String get oathErrorLoad;

  /// No description provided for @oathGuestHeadline.
  ///
  /// In en, this message translates to:
  /// **'The Oath Stone Awaits'**
  String get oathGuestHeadline;

  /// No description provided for @oathGuestBody.
  ///
  /// In en, this message translates to:
  /// **'Create an account to swear a reading oath and track your progress.'**
  String get oathGuestBody;

  /// No description provided for @seasonalCampaignLabel.
  ///
  /// In en, this message translates to:
  /// **'Seasonal Campaign'**
  String get seasonalCampaignLabel;

  /// No description provided for @seasonalCampaignExpired.
  ///
  /// In en, this message translates to:
  /// **'Expedition ended'**
  String get seasonalCampaignExpired;

  /// No description provided for @seasonalCampaignLastDay.
  ///
  /// In en, this message translates to:
  /// **'Last day!'**
  String get seasonalCampaignLastDay;

  /// No description provided for @seasonalCampaignCountdownDays.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =1{1 day remaining} other{{days} days remaining}}'**
  String seasonalCampaignCountdownDays(int days);

  /// No description provided for @seasonalCampaignCountdownMonths.
  ///
  /// In en, this message translates to:
  /// **'{months, plural, =1{1 month remaining} other{{months} months remaining}}'**
  String seasonalCampaignCountdownMonths(int months);

  /// No description provided for @seasonalCampaignCountdownMonthsDays.
  ///
  /// In en, this message translates to:
  /// **'{months, plural, =1{1 month} other{{months} months}}, {days, plural, =1{1 day remaining} other{{days} days remaining}}'**
  String seasonalCampaignCountdownMonthsDays(int months, int days);

  /// No description provided for @seasonalRelicSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Seasonal Relics'**
  String get seasonalRelicSectionTitle;

  /// No description provided for @profileSectionSeasonalQuests.
  ///
  /// In en, this message translates to:
  /// **'Seasonal Quests'**
  String get profileSectionSeasonalQuests;

  /// No description provided for @profileSectionSeasonalQuestsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Time-limited expeditions with exclusive relics.'**
  String get profileSectionSeasonalQuestsSubtitle;

  /// No description provided for @realmRankingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Realm Rankings'**
  String get realmRankingsTitle;

  /// No description provided for @leaderboardMetricQuests.
  ///
  /// In en, this message translates to:
  /// **'Quests'**
  String get leaderboardMetricQuests;

  /// No description provided for @leaderboardMetricBooks.
  ///
  /// In en, this message translates to:
  /// **'Books'**
  String get leaderboardMetricBooks;

  /// No description provided for @leaderboardMetricRelics.
  ///
  /// In en, this message translates to:
  /// **'Relics'**
  String get leaderboardMetricRelics;

  /// No description provided for @leaderboardTotalParticipants.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 adventurer ranked} other{{count} adventurers ranked}}'**
  String leaderboardTotalParticipants(int count);

  /// No description provided for @leaderboardYourPosition.
  ///
  /// In en, this message translates to:
  /// **'YOUR POSITION'**
  String get leaderboardYourPosition;

  /// No description provided for @leaderboardPositionOfTotal.
  ///
  /// In en, this message translates to:
  /// **'#{position} of {total}'**
  String leaderboardPositionOfTotal(int position, int total);

  /// No description provided for @leaderboardErrorHeadline.
  ///
  /// In en, this message translates to:
  /// **'The rankings failed to load'**
  String get leaderboardErrorHeadline;

  /// No description provided for @leaderboardOptInTitle.
  ///
  /// In en, this message translates to:
  /// **'Realm Rankings'**
  String get leaderboardOptInTitle;

  /// No description provided for @leaderboardOptInDescription.
  ///
  /// In en, this message translates to:
  /// **'Compete with fellow adventurers by joining the realm leaderboard. Your ranking is based on quests sealed, books read, and relics collected.'**
  String get leaderboardOptInDescription;

  /// No description provided for @leaderboardOptInPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Only your display name and rank are visible to others.'**
  String get leaderboardOptInPrivacy;

  /// No description provided for @leaderboardOptInActive.
  ///
  /// In en, this message translates to:
  /// **'Ranked in the realm'**
  String get leaderboardOptInActive;

  /// No description provided for @leaderboardOptInInactive.
  ///
  /// In en, this message translates to:
  /// **'Not ranked'**
  String get leaderboardOptInInactive;

  /// No description provided for @leaderboardOptInJoinButton.
  ///
  /// In en, this message translates to:
  /// **'Join the Rankings'**
  String get leaderboardOptInJoinButton;

  /// No description provided for @leaderboardOptInLeaveButton.
  ///
  /// In en, this message translates to:
  /// **'Leave the Rankings'**
  String get leaderboardOptInLeaveButton;

  /// No description provided for @characterSheetStatRealmRank.
  ///
  /// In en, this message translates to:
  /// **'Realm'**
  String get characterSheetStatRealmRank;

  /// No description provided for @characterSheetRealmRankJoin.
  ///
  /// In en, this message translates to:
  /// **'Join Rankings'**
  String get characterSheetRealmRankJoin;

  /// No description provided for @skillTreeSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Skill Tree'**
  String get skillTreeSectionTitle;

  /// No description provided for @skillTreeSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Grow your genre mastery through reading.'**
  String get skillTreeSectionSubtitle;

  /// No description provided for @skillTreeXpProgress.
  ///
  /// In en, this message translates to:
  /// **'{current} / {next} XP'**
  String skillTreeXpProgress(int current, int next);

  /// No description provided for @skillTreeXpLabel.
  ///
  /// In en, this message translates to:
  /// **'{xp} XP'**
  String skillTreeXpLabel(int xp);

  /// No description provided for @skillTreeTiersLabel.
  ///
  /// In en, this message translates to:
  /// **'Tiers'**
  String get skillTreeTiersLabel;

  /// No description provided for @skillTreeTierUnlocked.
  ///
  /// In en, this message translates to:
  /// **'UNLOCKED'**
  String get skillTreeTierUnlocked;

  /// No description provided for @skillTreeTierCurrent.
  ///
  /// In en, this message translates to:
  /// **'IN PROGRESS'**
  String get skillTreeTierCurrent;

  /// No description provided for @skillTreeTierLocked.
  ///
  /// In en, this message translates to:
  /// **'LOCKED'**
  String get skillTreeTierLocked;

  /// No description provided for @skillTreeRuneUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Rune Unlocked: {runeTitle}'**
  String skillTreeRuneUnlocked(String runeTitle);

  /// No description provided for @skillTreeRuneLockedAt.
  ///
  /// In en, this message translates to:
  /// **'Unlocks: {runeTitle}'**
  String skillTreeRuneLockedAt(String runeTitle);

  /// No description provided for @loreBoardTitle.
  ///
  /// In en, this message translates to:
  /// **'Lore Board'**
  String get loreBoardTitle;

  /// No description provided for @loreBoardGlobalTab.
  ///
  /// In en, this message translates to:
  /// **'Global'**
  String get loreBoardGlobalTab;

  /// No description provided for @loreBoardFriendsTab.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get loreBoardFriendsTab;

  /// No description provided for @loreBoardEmpty.
  ///
  /// In en, this message translates to:
  /// **'The board is bare... no tales have been posted yet.'**
  String get loreBoardEmpty;

  /// No description provided for @loreBoardTooltip.
  ///
  /// In en, this message translates to:
  /// **'Lore Board'**
  String get loreBoardTooltip;

  /// No description provided for @guildHubTitle.
  ///
  /// In en, this message translates to:
  /// **'Guild Hall'**
  String get guildHubTitle;

  /// No description provided for @guildHubEmpty.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t joined any guilds yet. Found your own or discover existing ones.'**
  String get guildHubEmpty;

  /// No description provided for @guildCreateButton.
  ///
  /// In en, this message translates to:
  /// **'Found a New Guild'**
  String get guildCreateButton;

  /// No description provided for @guildDiscoverButton.
  ///
  /// In en, this message translates to:
  /// **'Discover Guilds'**
  String get guildDiscoverButton;

  /// No description provided for @guildDetailCompanions.
  ///
  /// In en, this message translates to:
  /// **'Companions'**
  String get guildDetailCompanions;

  /// No description provided for @guildDetailLedger.
  ///
  /// In en, this message translates to:
  /// **'Party Ledger'**
  String get guildDetailLedger;

  /// No description provided for @guildDetailLedgerEmpty.
  ///
  /// In en, this message translates to:
  /// **'No books in the ledger yet.'**
  String get guildDetailLedgerEmpty;

  /// No description provided for @guildJoinButton.
  ///
  /// In en, this message translates to:
  /// **'Join Guild'**
  String get guildJoinButton;

  /// No description provided for @guildJoined.
  ///
  /// In en, this message translates to:
  /// **'You have joined the guild!'**
  String get guildJoined;

  /// No description provided for @guildLeaveButton.
  ///
  /// In en, this message translates to:
  /// **'Leave Guild'**
  String get guildLeaveButton;

  /// No description provided for @guildLeft.
  ///
  /// In en, this message translates to:
  /// **'You have left the guild.'**
  String get guildLeft;

  /// No description provided for @guildDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Disband This Guild?'**
  String get guildDeleteConfirmTitle;

  /// No description provided for @guildDeleteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This will permanently remove the guild and all its data. This cannot be undone.'**
  String get guildDeleteConfirmBody;

  /// No description provided for @guildDeleteCancel.
  ///
  /// In en, this message translates to:
  /// **'Keep Guild'**
  String get guildDeleteCancel;

  /// No description provided for @guildDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Disband Guild'**
  String get guildDeleteConfirm;

  /// No description provided for @guildDeleted.
  ///
  /// In en, this message translates to:
  /// **'Guild disbanded'**
  String get guildDeleted;

  /// No description provided for @guildCreated.
  ///
  /// In en, this message translates to:
  /// **'Guild founded!'**
  String get guildCreated;

  /// No description provided for @guildUpdated.
  ///
  /// In en, this message translates to:
  /// **'Guild updated'**
  String get guildUpdated;

  /// No description provided for @guildCreatePageTitle.
  ///
  /// In en, this message translates to:
  /// **'Found a Guild'**
  String get guildCreatePageTitle;

  /// No description provided for @guildFieldName.
  ///
  /// In en, this message translates to:
  /// **'Guild Name'**
  String get guildFieldName;

  /// No description provided for @guildFieldNameHint.
  ///
  /// In en, this message translates to:
  /// **'The Fellowship of Pages'**
  String get guildFieldNameHint;

  /// No description provided for @guildFieldDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get guildFieldDescription;

  /// No description provided for @guildFieldDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'What is your guild about?'**
  String get guildFieldDescriptionHint;

  /// No description provided for @guildFieldPublic.
  ///
  /// In en, this message translates to:
  /// **'Public guild'**
  String get guildFieldPublic;

  /// No description provided for @guildFieldPublicSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Visible on the Guild Board for anyone to join'**
  String get guildFieldPublicSubtitle;

  /// No description provided for @guildCreateSubmit.
  ///
  /// In en, this message translates to:
  /// **'Found This Guild'**
  String get guildCreateSubmit;

  /// No description provided for @guildCreating.
  ///
  /// In en, this message translates to:
  /// **'Founding...'**
  String get guildCreating;

  /// No description provided for @guildDiscoverTitle.
  ///
  /// In en, this message translates to:
  /// **'Guild Board'**
  String get guildDiscoverTitle;

  /// No description provided for @guildDiscoverEmpty.
  ///
  /// In en, this message translates to:
  /// **'No guilds to discover yet.'**
  String get guildDiscoverEmpty;

  /// No description provided for @guildMemberCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 companion} other{{count} companions}}'**
  String guildMemberCountLabel(int count);

  /// No description provided for @guildRoleGuildmaster.
  ///
  /// In en, this message translates to:
  /// **'Guildmaster'**
  String get guildRoleGuildmaster;

  /// No description provided for @guildRoleCompanion.
  ///
  /// In en, this message translates to:
  /// **'Companion'**
  String get guildRoleCompanion;

  /// No description provided for @guildGuestHeadline.
  ///
  /// In en, this message translates to:
  /// **'The Guild Hall Awaits'**
  String get guildGuestHeadline;

  /// No description provided for @guildGuestBody.
  ///
  /// In en, this message translates to:
  /// **'Create an account to found guilds, join reading parties, and build ledgers with fellow adventurers.'**
  String get guildGuestBody;

  /// No description provided for @guildAddToLedger.
  ///
  /// In en, this message translates to:
  /// **'Add to Ledger'**
  String get guildAddToLedger;

  /// No description provided for @guildBookAdded.
  ///
  /// In en, this message translates to:
  /// **'Book added to the ledger!'**
  String get guildBookAdded;

  /// No description provided for @guildBookRemoved.
  ///
  /// In en, this message translates to:
  /// **'Book removed from the ledger.'**
  String get guildBookRemoved;

  /// No description provided for @guildAlreadyMember.
  ///
  /// In en, this message translates to:
  /// **'You are already a member of this guild.'**
  String get guildAlreadyMember;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'bg',
    'de',
    'en',
    'es',
    'ja',
    'pt',
    'ru',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bg':
      return AppLocalizationsBg();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'ja':
      return AppLocalizationsJa();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
