// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'StuffWithFantasy';

  @override
  String get bookSingular => 'Buch';

  @override
  String get bookPlural => 'Bücher';

  @override
  String booksCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Bücher',
      one: '1 Buch',
    );
    return '$_temp0';
  }

  @override
  String get catalogSignUpPrompt =>
      'Erstelle ein Konto, um Bücher auf deiner Leseliste zu speichern.';

  @override
  String get catalogSnackbarActionProfile => 'Profil';

  @override
  String get catalogTooltipLibrary => 'Bibliothek';

  @override
  String get catalogTooltipProfile => 'Profil';

  @override
  String get catalogFiltersUnavailable =>
      'Filter sind nicht verfügbar, bis die Taxonomie erfolgreich geladen wurde.';

  @override
  String get catalogRetry => 'Erneut versuchen';

  @override
  String get catalogEmptyFiltered => 'Keine Bücher entsprechen deinen Filtern';

  @override
  String get catalogEmptyNoBooks => 'Noch keine Bücher';

  @override
  String get catalogClearFilters => 'Filter zurücksetzen';

  @override
  String get bookDetailSignUpPrompt =>
      'Erstelle ein Konto über dein Profil, um Bücher auf deiner Leseliste zu speichern.';

  @override
  String bookDetailByAuthor(String author) {
    return 'von $author';
  }

  @override
  String get bookDetailSectionSubgenres => 'Subgenres';

  @override
  String get bookDetailSectionTropes => 'Tropen';

  @override
  String get bookDetailSectionRepresentation => 'Repräsentation';

  @override
  String get bookDetailSectionAbout => 'Über dieses Buch';

  @override
  String get bookDetailReadMore => 'Mehr lesen';

  @override
  String get bookDetailSectionSimilar => 'Das könnte dir auch gefallen';

  @override
  String get bookDetailBadgeKu => 'KU';

  @override
  String get bookDetailUpdating => 'Wird aktualisiert...';

  @override
  String get bookDetailRemoveFromList => 'Von der Leseliste entfernen';

  @override
  String get bookDetailSaving => 'Wird gespeichert...';

  @override
  String get bookDetailSaveToList => 'Auf die Leseliste setzen';

  @override
  String get bookDetailOpening => 'Wird geöffnet...';

  @override
  String get bookDetailReadInApp => 'In der App lesen';

  @override
  String get bookDetailGetBook => 'Buch kaufen';

  @override
  String get bookDetailAmazon => 'Amazon DE';

  @override
  String get bookDetailAllRetailers => 'Alle Händler anzeigen';

  @override
  String get bookDetailAudiobook => 'Hörbuch';

  @override
  String get filterSearchHint => 'Nach Titel oder Autor suchen...';

  @override
  String get filterChipKu => 'KU';

  @override
  String get filterChipAudiobook => 'Hörbuch';

  @override
  String get filterClearAll => 'Alle zurücksetzen';

  @override
  String get filterSheetTitle => 'Filter';

  @override
  String get filterSheetReset => 'Zurücksetzen';

  @override
  String get filterSheetSubgenres => 'Subgenres';

  @override
  String get filterSheetTropes => 'Tropen';

  @override
  String get filterSheetSpiceLevel => 'Schärfegrad';

  @override
  String get filterSheetAgeCategory => 'Alterskategorie';

  @override
  String get filterSheetRepresentation => 'Repräsentation';

  @override
  String get filterSheetLanguageLevel => 'Sprachniveau';

  @override
  String filterSheetApplyWithCount(int count) {
    return 'Filter anwenden ($count)';
  }

  @override
  String get filterSheetApply => 'Filter anwenden';

  @override
  String get signUpSkip => 'Überspringen';

  @override
  String get rolePickerHeadline => 'Ich bin ein/e...';

  @override
  String get rolePickerSubtitle =>
      'Wähle, wie du StuffWithFantasy nutzen möchtest';

  @override
  String get rolePickerContinue => 'Weiter';

  @override
  String get interestStepHeadline => 'Was führt dich noch hierher?';

  @override
  String get interestStepSubtitle =>
      'Wähle aus, was zutrifft — oder überspringe diesen Schritt.';

  @override
  String get interestCardAuthorTitle => 'Ich bin Autor/in';

  @override
  String get interestCardAuthorDescription =>
      'Ich möchte, dass Fantasy-Leser meine Bücher entdecken.';

  @override
  String get interestCardInfluencerTitle => 'Ich bin Influencer/in';

  @override
  String get interestCardInfluencerDescription =>
      'Ich erstelle Inhalte und möchte Fantasy-Bücher mit meinem Publikum teilen.';

  @override
  String get interestStepContinue => 'Weiter';

  @override
  String get signUpFormHeadline => 'Erstelle dein Konto';

  @override
  String get signUpFormSubtitle => 'Nur ein paar Angaben und du bist dabei';

  @override
  String get signUpFieldNameLabel => 'Anzeigename';

  @override
  String get signUpFieldNameHint => 'Wie sollen wir dich nennen?';

  @override
  String get signUpValidatorEnterName => 'Gib deinen Namen ein';

  @override
  String get signUpFieldEmailLabel => 'E-Mail';

  @override
  String get signUpFieldEmailHint => 'du@beispiel.de';

  @override
  String get signUpValidatorEnterEmail => 'Gib deine E-Mail-Adresse ein';

  @override
  String get signUpValidatorInvalidEmail =>
      'Gib eine gültige E-Mail-Adresse ein';

  @override
  String get signUpFieldPasswordLabel => 'Passwort';

  @override
  String get signUpFieldPasswordHint => 'Mindestens 8 Zeichen';

  @override
  String get signUpValidatorEnterPassword => 'Gib ein Passwort ein';

  @override
  String get signUpValidatorPasswordTooShort =>
      'Muss mindestens 8 Zeichen lang sein';

  @override
  String get signUpButtonCreateAccount => 'Konto erstellen';

  @override
  String welcomeStepHeadline(String name) {
    return 'Willkommen, $name!';
  }

  @override
  String get welcomeStepSubtitle =>
      'Dein nächstes großes Fantasy-Abenteuer wartet auf dich.';

  @override
  String get welcomeStepGetStarted => 'Los geht\'s';

  @override
  String get profileUnknownRank => 'Unbekannter Rang';

  @override
  String get profileAppBarTitle => 'Gildenhalle';

  @override
  String get profileSectionRunes => 'Runen';

  @override
  String get profileSectionRunesSubtitle =>
      'Schließe Quests ab, um Fähigkeitsrunen einzugravieren.';

  @override
  String get profileSectionQuestLog => 'Questlog';

  @override
  String get profileSectionQuestLogSubtitle =>
      'Entrolle Schriftrollen, um Ziele zu verfolgen und zu besiegeln.';

  @override
  String get profileSectionRelicVault => 'Reliktgewölbe';

  @override
  String get profileSectionRelicVaultSubtitle =>
      'Besiegle Schriftrollen, um Relikte für dein Gewölbe zu erhalten.';

  @override
  String get profileSectionCharacterSheet => 'Charakterbogen';

  @override
  String get profileSnackbarRuneComingSoon =>
      'Diese Rune wird bald konfigurierbar sein.';

  @override
  String get profileDeleteAccountTitle => 'Konto löschen';

  @override
  String get profileDeleteAccountBody =>
      'Dadurch wird dein Konto und alle zugehörigen Daten dauerhaft gelöscht. Dies kann nicht rückgängig gemacht werden.';

  @override
  String get profileDeleteCancel => 'Abbrechen';

  @override
  String get profileDeleteConfirm => 'Löschen';

  @override
  String get profileSigningOut => 'Verlasse das Reich...';

  @override
  String get profileSignOut => 'Das Reich verlassen';

  @override
  String get profileDeletingAccount => 'Konto wird gelöscht...';

  @override
  String get profileDeleteAccount => 'Konto löschen';

  @override
  String get profileRetry => 'Erneut versuchen';

  @override
  String get profileErrorHeadline =>
      'Das Questbrett konnte nicht geladen werden';

  @override
  String get profileTryAgain => 'Erneut versuchen';

  @override
  String get guestGuildHallLabel => 'GILDENHALLE';

  @override
  String get guestGuildHeadline => 'Beginne deine Quest';

  @override
  String get guestGuildBody =>
      'Erstelle ein Konto, um deine Lesequests zu verfolgen, Fähigkeitsrunen freizuschalten und Relikte zu sammeln, während du das Reich erkundest.';

  @override
  String get guestGuildButtonCreateAccount => 'Konto erstellen und loslegen';

  @override
  String get runeStatusEngraved => 'EINGRAVIERT';

  @override
  String get runeStatusLocked => 'GESPERRT';

  @override
  String get runeDetailLockedHint =>
      'Schließe die verknüpfte Quest ab, um diese Rune einzugravieren';

  @override
  String get runeDetailConfigure => 'Konfigurieren';

  @override
  String get arcShieldTitle => 'ARC-Schild';

  @override
  String get arcShieldDescription =>
      'Wenn aktiv, können Autoren und Verlage dich als ARC-Leser finden.';

  @override
  String get arcShieldSectionAvailability => 'Verfügbarkeit';

  @override
  String get arcShieldToggleOpenLabel => 'Offen für ARCs';

  @override
  String get arcShieldToggleClosedLabel => 'Keine ARCs annehmen';

  @override
  String get arcShieldToggleOpenSubtitle => 'Autoren können dich kontaktieren';

  @override
  String get arcShieldToggleClosedSubtitle =>
      'Dein Profil ist bei ARC-Suchen verborgen';

  @override
  String get genreAttunementTitle => 'Genre-Einstimmung';

  @override
  String get genreAttunementDescription =>
      'Wähle die Genres und Tropen, die dich ansprechen. Das Reich lernt, was es dir zeigen soll.';

  @override
  String get genreAttunementSectionGenres => 'Genres';

  @override
  String get genreAttunementSectionTropes => 'Tropen';

  @override
  String genreAttunementCountAttuned(int count) {
    return '$count eingestimmt';
  }

  @override
  String get genreEpicFantasy => 'Epische Fantasy';

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
  String get genreSwordAndSorcery => 'Schwert & Magie';

  @override
  String get genreMythicFantasy => 'Mythische Fantasy';

  @override
  String get genrePortalFantasy => 'Portal-Fantasy';

  @override
  String get tropeFoundFamily => 'Wahlfamilie';

  @override
  String get tropeEnemiesToLovers => 'Vom Feind zum Geliebten';

  @override
  String get tropeChosenOne => 'Der Auserwählte';

  @override
  String get tropeMagicSchools => 'Magieschulen';

  @override
  String get tropeMorallyGrey => 'Moralisch grau';

  @override
  String get tropeSlowBurn => 'Slow Burn';

  @override
  String get tropePoliticalIntrigue => 'Politische Intrigen';

  @override
  String get tropeQuestJourney => 'Quest-Reise';

  @override
  String get tropeHiddenRoyalty => 'Verborgene Königlichkeit';

  @override
  String get tropeRevengeArc => 'Rachegeschichte';

  @override
  String get eventWatchtowerTitle => 'Ereigniswachturm';

  @override
  String get eventWatchtowerDescription =>
      'Wähle, welche Signale dich aus dem Reich erreichen.';

  @override
  String get eventWatchtowerSectionSignals => 'Signale';

  @override
  String get notifNewEventsTitle => 'Neue Ereignisse';

  @override
  String get notifNewEventsDescription =>
      'Wenn ein Stuff Your Kindle-Event startet';

  @override
  String get notifBookDropsTitle => 'Neue Bücher';

  @override
  String get notifBookDropsDescription =>
      'Wenn neue Bücher zum Katalog hinzugefügt werden';

  @override
  String get notifRecommendationsTitle => 'Empfehlungen';

  @override
  String get notifRecommendationsDescription =>
      'Personalisierte Vorschläge basierend auf deiner Einstimmung';

  @override
  String get rewardRevealBarrierLabel => 'Belohnungsenthüllung';

  @override
  String get rewardRevealLegendRelicClaimed => 'LEGENDÄRES RELIKT ERHALTEN';

  @override
  String get rewardRevealRelicUnlocked => 'RELIKT FREIGESCHALTET';

  @override
  String get rewardRevealContinue => 'Weiter auf der Quest';

  @override
  String get characterSheetHeaderLabel => 'CHARAKTERBOGEN';

  @override
  String get characterSheetStatName => 'Name';

  @override
  String get characterSheetStatRank => 'Rang';

  @override
  String get characterSheetStatQuests => 'Quests';

  @override
  String characterSheetStatQuestsValue(int completed, int total) {
    return '$completed / $total';
  }

  @override
  String get characterSheetStatRelics => 'Relikte';

  @override
  String characterSheetStatRelicsValue(int collected, int total) {
    return '$collected / $total';
  }

  @override
  String get characterSheetStatSignal => 'Signal';

  @override
  String get realmMapCurrentQuest => 'AKTUELLE QUEST';

  @override
  String get questScrollSealed => 'Besiegelt';

  @override
  String get questScrollActive => 'AKTIV';

  @override
  String get questScrollReward => 'BELOHNUNG';

  @override
  String get relicVaultLockedTitle => '???';

  @override
  String get relicVaultLegendRelic => 'Legendäres Relikt';

  @override
  String get relicVaultClaimed => 'Erhalten';

  @override
  String get relicVaultSealed => 'Besiegelt';

  @override
  String get libraryAppBarTitle => 'Bibliothek';

  @override
  String get libraryTabMyBooks => 'Meine Bücher';

  @override
  String get libraryTabReadingList => 'Leseliste';

  @override
  String get libraryMyBooksSignInTitle => 'Dein Bücherregal wartet';

  @override
  String get libraryMyBooksSignInMessage =>
      'Melde dich an, um auf Bücher zuzugreifen, die du gekauft, beansprucht oder hochgeladen hast — bereit zum Lesen direkt hier.';

  @override
  String get libraryMyBooksEmptyTitle => 'Noch keine lesbaren Bücher';

  @override
  String get libraryMyBooksEmptyMessage =>
      'Bücher, die du kaufst, beanspruchst oder hochlädst, erscheinen hier, wenn sie lesebereit sind.';

  @override
  String get libraryReadingListSignInTitle => 'Starte deine Leseliste';

  @override
  String get libraryReadingListSignInMessage =>
      'Melde dich an, um Bücher aus dem Katalog zu speichern und deine persönliche Leseliste aufzubauen.';

  @override
  String get libraryReadingListEmptyTitle => 'Noch nichts gespeichert';

  @override
  String get libraryReadingListEmptyMessage =>
      'Speichere Bücher aus dem Katalog, um deine Leseliste aufzubauen.';

  @override
  String get libraryButtonSignIn => 'Anmelden';

  @override
  String get libraryRetry => 'Erneut versuchen';

  @override
  String readerProgressRead(String progress) {
    return '$progress gelesen';
  }

  @override
  String get readerHintSwipeToTurn => 'Wische, um Seiten umzublättern';

  @override
  String get readerHintOpeningBook => 'Buch wird geöffnet…';

  @override
  String get readerHintTapToHide =>
      'Tippe in die Mitte, um die Steuerung auszublenden';

  @override
  String get readerTooltipBack => 'Zurück';

  @override
  String get readerTooltipChapters => 'Kapitel';

  @override
  String get readerTooltipReadingSettings => 'Leseeinstellungen';

  @override
  String get readerTooltipPreviousPage => 'Vorherige Seite';

  @override
  String get readerButtonPrev => 'Zurück';

  @override
  String get readerTooltipNextPage => 'Nächste Seite';

  @override
  String get readerButtonNext => 'Weiter';

  @override
  String get readerChaptersTitle => 'Kapitel';

  @override
  String get readerSettingsTitle => 'Leseeinstellungen';

  @override
  String get readerSettingsTextSize => 'Textgröße';

  @override
  String get readerTooltipSmallerText => 'Kleinerer Text';

  @override
  String readerFontSizeLabel(int size) {
    return '$size pt';
  }

  @override
  String get readerTooltipLargerText => 'Größerer Text';

  @override
  String get readerSettingsPageTheme => 'Seitendesign';

  @override
  String get readerAppearancePaper => 'Papier';

  @override
  String get readerAppearanceSepia => 'Sepia';

  @override
  String get readerAppearanceNight => 'Nacht';

  @override
  String get eventDetailLoadingBooks => 'Bücher werden geladen...';

  @override
  String eventDetailBookCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Bücher in diesem Event',
      one: '1 Buch in diesem Event',
    );
    return '$_temp0';
  }

  @override
  String get eventDetailNoBooksYet => 'Noch keine Bücher in diesem Event.';

  @override
  String get creatorDetailNoBooksYet => 'Noch keine Bücher vorhanden.';

  @override
  String get creatorDetailFavoriteBookLabel => 'Lieblingsbuch: ';

  @override
  String get creatorDetailLovesLabel => 'Liebt: ';

  @override
  String creatorDetailBooksBy(String name) {
    return 'Bücher von $name';
  }

  @override
  String creatorDetailRecommendedBy(String name) {
    return 'Empfohlen von $name';
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
  String get socialLinkWebsite => 'Webseite';

  @override
  String get userRoleReader => 'Leser/in';

  @override
  String get userRoleReaderDescription =>
      'Entdecke dein nächstes Fantasy-Lieblingsbuch';

  @override
  String get creatorRoleAuthor => 'Autor/in';

  @override
  String get creatorRoleInfluencer => 'Influencer/in';

  @override
  String get readAccessOwner => 'Dein Upload';

  @override
  String get readAccessPurchased => 'Gekauft';

  @override
  String get readAccessNone => 'Kein Zugriff';

  @override
  String get eventStatusLastDay => 'Letzter Tag!';

  @override
  String get eventStatusHappeningNow => 'Läuft gerade';

  @override
  String get eventStatusStartsToday => 'Startet heute';

  @override
  String get eventStatusStartsTomorrow => 'Startet morgen';

  @override
  String eventStatusStartsInDays(int days) {
    return 'Startet in $days Tagen';
  }

  @override
  String get spiceLevelNone => 'Keine Schärfe';

  @override
  String get spiceLevelMild => 'Leichte Schärfe';

  @override
  String get spiceLevelMedium => 'Mittlere Schärfe';

  @override
  String get spiceLevelHot => 'Scharf';

  @override
  String get spiceLevelScorching => 'Sehr scharf';

  @override
  String get languageLevelClean => 'Ohne Kraftausdrücke';

  @override
  String get languageLevelMild => 'Leichte Sprache';

  @override
  String get languageLevelModerate => 'Mäßige Sprache';

  @override
  String get languageLevelStrong => 'Derbe Sprache';

  @override
  String get homeHeadline => 'Stuff With Fantasy';

  @override
  String get homeTagline => 'Dein Fantasy-Lesebegleiter.';

  @override
  String get homeSubtitle =>
      'Entdecke, verfolge und teile die Fantasy-Bücher, die du liebst.';

  @override
  String get homeChipMaterial3 => 'Material 3';

  @override
  String get homeChipStructuredStarter => 'Strukturierter Starter';

  @override
  String get homeChipWidgetTests => 'Widget-Tests';

  @override
  String get homeCardWhatIsReadyTitle => 'Was bereits fertig ist';

  @override
  String get homeCardWhatIsReadyItem1 =>
      'Eine gebrandete App-Hülle mit hellem und dunklem Design.';

  @override
  String get homeCardWhatIsReadyItem2 =>
      'Eine strengere Analyzer-Basis mit flutter_lints.';

  @override
  String get homeCardWhatIsReadyItem3 =>
      'Ein Widget-Test zum Schutz der Starter-Erfahrung.';

  @override
  String get homeCardWhereToGoNextTitle => 'Nächste Schritte';

  @override
  String get homeCardWhereToGoNextItem1 =>
      'Füge Features unter lib/src nach Domäne hinzu, statt main.dart wachsen zu lassen.';

  @override
  String get homeCardWhereToGoNextItem2 =>
      'Ersetze Platzhalter-Assets, Launcher-Icons und Produkttexte.';

  @override
  String get homeCardWhereToGoNextItem3 =>
      'Führe flutter analyze und flutter test aus, wenn du Screens hinzufügst.';

  @override
  String get homeGetStarted => 'Los geht\'s';

  @override
  String get homeBrowseBooks => 'Bücher durchstöbern';

  @override
  String get monthJan => 'Jan';

  @override
  String get monthFeb => 'Feb';

  @override
  String get monthMar => 'Mär';

  @override
  String get monthApr => 'Apr';

  @override
  String get monthMay => 'Mai';

  @override
  String get monthJun => 'Jun';

  @override
  String get monthJul => 'Jul';

  @override
  String get monthAug => 'Aug';

  @override
  String get monthSep => 'Sep';

  @override
  String get monthOct => 'Okt';

  @override
  String get monthNov => 'Nov';

  @override
  String get monthDec => 'Dez';

  @override
  String get profileSectionLanguage => 'Sprache';

  @override
  String get languageSystemDefault => 'Systemstandard';

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
  String get profileSectionReadingChronicle => 'Lesechronik';

  @override
  String get profileSectionReadingChronicleSubtitle =>
      'Deine Reise durch die Seiten, festgehalten in Tinte.';

  @override
  String get profileSectionTomeCounter => 'Folianten-Zähler';

  @override
  String get profileSectionTomeCounterSubtitle =>
      'Deine gesammelten Leseleistungen.';

  @override
  String get profileSectionAchievementSigils => 'Errungenschafts-Siegel';

  @override
  String get profileSectionAchievementSigilsSubtitle =>
      'Meilensteine, geschmiedet durch Hingabe.';

  @override
  String chroniclePagesThisWeek(int count) {
    return '~$count Seiten diese Woche';
  }

  @override
  String chronicleStreak(int count) {
    return '$count-Tage-Serie';
  }

  @override
  String get chronicleLess => 'Weniger';

  @override
  String get chronicleMore => 'Mehr';

  @override
  String get tomeCounterBooks => 'Bezwungene Folianten';

  @override
  String get tomeCounterPages => 'Umgeblätterte Seiten';

  @override
  String get tomeCounterTime => 'Zeit im Reich';

  @override
  String tomeCounterHoursMinutes(int hours, int minutes) {
    return '$hours Std. $minutes Min.';
  }

  @override
  String tomeCounterMinutes(int minutes) {
    return '$minutes Min.';
  }

  @override
  String get achievementLocked => 'VERSIEGELT';

  @override
  String get achievementUnlocked => 'ERRUNGEN';

  @override
  String get achievementFirstPageTitle => 'Erste Seite';

  @override
  String get achievementFirstPageDesc => 'Öffne ein Buch und beginne zu lesen.';

  @override
  String get achievementBookwormTitle => 'Bücherwurm erwacht';

  @override
  String get achievementBookwormDesc => 'Beende dein erstes Buch.';

  @override
  String get achievementDailyRitualTitle => 'Tägliches Ritual';

  @override
  String get achievementDailyRitualDesc => 'Lies 3 Tage hintereinander.';

  @override
  String get achievementPageTurnerTitle => 'Seitenumblätterer';

  @override
  String get achievementPageTurnerDesc => 'Lies ungefähr 100 Seiten.';

  @override
  String get achievementHourGlassTitle => 'Sanduhr';

  @override
  String get achievementHourGlassDesc => 'Verbringe 1 Stunde mit Lesen.';

  @override
  String get achievementChapterChampionTitle => 'Kapitelmeister';

  @override
  String get achievementChapterChampionDesc => 'Beende 3 Bücher.';

  @override
  String get achievementFlameKeeperTitle => 'Flammenhüter';

  @override
  String get achievementFlameKeeperDesc => 'Lies 7 Tage hintereinander.';

  @override
  String get achievementTomeScholarTitle => 'Folianten-Gelehrter';

  @override
  String get achievementTomeScholarDesc => 'Lies ungefähr 1.000 Seiten.';

  @override
  String get achievementDevotedReaderTitle => 'Hingebungsvoller Leser';

  @override
  String get achievementDevotedReaderDesc => 'Verbringe 10 Stunden mit Lesen.';

  @override
  String get achievementFiveRealmsTitle => 'Fünf Reiche';

  @override
  String get achievementFiveRealmsDesc =>
      'Beginne 5 verschiedene Bücher zu lesen.';

  @override
  String get achievementGrandLibrarianTitle => 'Großbibliothekar';

  @override
  String get achievementGrandLibrarianDesc => 'Beende 10 Bücher.';

  @override
  String get achievementEternalFlameTitle => 'Ewige Flamme';

  @override
  String get achievementEternalFlameDesc =>
      'Halte eine 30-Tage-Leseserie aufrecht.';

  @override
  String get achievementMythicScribeTitle => 'Mythischer Schreiber';

  @override
  String get achievementMythicScribeDesc => 'Verbringe 100 Stunden mit Lesen.';

  @override
  String get achievementRealmWalkerTitle => 'Reichswanderer';

  @override
  String get achievementRealmWalkerDesc =>
      'Beginne 10 verschiedene Bücher zu lesen.';

  @override
  String get oathAppBarTitle => 'Eidstein';

  @override
  String get oathSectionTitle => 'Eidstein';

  @override
  String get oathSectionSubtitle => 'Dein geschworenes Lesegelöbnis';

  @override
  String get oathSwearCta => 'Einen Eid schwören';

  @override
  String get oathSwearSubtitle =>
      'Setze dir ein öffentliches Leseziel und verfolge deinen Fortschritt';

  @override
  String get oathSwearPageTitle => 'Deinen Eid einritzen';

  @override
  String get oathFieldTitle => 'Dein Gelöbnis';

  @override
  String get oathFieldTitleHint => 'Ich werde 2026 24 Bücher lesen';

  @override
  String get oathFieldTarget => 'Zielbücher';

  @override
  String get oathFieldYear => 'Jahr';

  @override
  String get oathFieldPublic => 'Öffentlicher Eid';

  @override
  String get oathFieldPublicSubtitle => 'Sichtbar auf der Lore-Tafel';

  @override
  String get oathSwearButton => 'Diesen Eid schwören';

  @override
  String get oathSwearing => 'Wird eingeritzt...';

  @override
  String oathProgressLabel(int current, int target) {
    return '$current von $target';
  }

  @override
  String get oathProgressComplete => 'Eid erfüllt!';

  @override
  String get oathEntryLogged => 'Rune eingeritzt!';

  @override
  String get oathEntryRemoved => 'Eintrag entfernt';

  @override
  String get oathDeleteConfirmTitle => 'Diesen Eid brechen?';

  @override
  String get oathDeleteConfirmBody =>
      'Dadurch werden dein Eid und alle protokollierten Einträge dauerhaft gelöscht.';

  @override
  String get oathDeleteCancel => 'Eid behalten';

  @override
  String get oathDeleteConfirm => 'Eid brechen';

  @override
  String get oathDeleted => 'Eid gebrochen';

  @override
  String get oathCompleteTitle => 'EID ERFÜLLT';

  @override
  String get oathCompleteHeadline => 'Dein Eid ist besiegelt';

  @override
  String get oathCompleteBody =>
      'Du hast dein Gelöbnis eingehalten. Die Runen sind vollständig.';

  @override
  String get oathCompleteContinue => 'Weiter';

  @override
  String get oathEmptyEntries => 'Noch keine Bücher eingetragen';

  @override
  String get oathLogBookAction => 'Für den Eid eintragen';

  @override
  String oathLogBookConfirm(String title) {
    return '„$title“ für deinen Eid eintragen?';
  }

  @override
  String get oathLogBookButton => 'Eintragen';

  @override
  String get oathAlreadyLogged => 'Bereits für deinen Eid eingetragen';

  @override
  String get oathEditButton => 'Eid bearbeiten';

  @override
  String get oathUpdated => 'Eid aktualisiert';

  @override
  String get oathErrorCreate => 'Eid konnte nicht erstellt werden';

  @override
  String get oathErrorLoad => 'Eid konnte nicht geladen werden';

  @override
  String get oathGuestHeadline => 'Der Eidstein wartet';

  @override
  String get oathGuestBody =>
      'Erstelle ein Konto, um einen Leseeid zu schwören und deinen Fortschritt zu verfolgen.';

  @override
  String get seasonalCampaignLabel => 'Saisonale Kampagne';

  @override
  String get seasonalCampaignExpired => 'Expedition beendet';

  @override
  String get seasonalCampaignLastDay => 'Letzter Tag!';

  @override
  String seasonalCampaignCountdownDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days Tage verbleibend',
      one: '1 Tag verbleibend',
    );
    return '$_temp0';
  }

  @override
  String seasonalCampaignCountdownMonths(int months) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: '$months Monate verbleibend',
      one: '1 Monat verbleibend',
    );
    return '$_temp0';
  }

  @override
  String seasonalCampaignCountdownMonthsDays(int months, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: '$months Monate',
      one: '1 Monat',
    );
    String _temp1 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days Tage verbleibend',
      one: '1 Tag verbleibend',
    );
    return '$_temp0, $_temp1';
  }

  @override
  String get seasonalRelicSectionTitle => 'Saisonale Relikte';

  @override
  String get profileSectionSeasonalQuests => 'Saisonale Quests';

  @override
  String get profileSectionSeasonalQuestsSubtitle =>
      'Zeitlich begrenzte Expeditionen mit exklusiven Relikten.';

  @override
  String get realmRankingsTitle => 'Reichsrangliste';

  @override
  String get leaderboardMetricQuests => 'Quests';

  @override
  String get leaderboardMetricBooks => 'Bücher';

  @override
  String get leaderboardMetricRelics => 'Relikte';

  @override
  String leaderboardTotalParticipants(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Abenteurer platziert',
      one: '1 Abenteurer platziert',
    );
    return '$_temp0';
  }

  @override
  String get leaderboardYourPosition => 'DEINE POSITION';

  @override
  String leaderboardPositionOfTotal(int position, int total) {
    return '#$position von $total';
  }

  @override
  String get leaderboardErrorHeadline =>
      'Die Rangliste konnte nicht geladen werden';

  @override
  String get leaderboardOptInTitle => 'Reichsrangliste';

  @override
  String get leaderboardOptInDescription =>
      'Tritt gegen andere Abenteurer an, indem du der Reichsrangliste beitrittst. Deine Platzierung basiert auf abgeschlossenen Quests, gelesenen Büchern und gesammelten Relikten.';

  @override
  String get leaderboardOptInPrivacy =>
      'Nur dein Anzeigename und Rang sind für andere sichtbar.';

  @override
  String get leaderboardOptInActive => 'Im Reich platziert';

  @override
  String get leaderboardOptInInactive => 'Nicht platziert';

  @override
  String get leaderboardOptInJoinButton => 'Der Rangliste beitreten';

  @override
  String get leaderboardOptInLeaveButton => 'Rangliste verlassen';

  @override
  String get characterSheetStatRealmRank => 'Reich';

  @override
  String get characterSheetRealmRankJoin => 'Rangliste beitreten';

  @override
  String get skillTreeSectionTitle => 'Fähigkeitenbaum';

  @override
  String get skillTreeSectionSubtitle =>
      'Steigere deine Genre-Meisterschaft durch Lesen.';

  @override
  String skillTreeXpProgress(int current, int next) {
    return '$current / $next XP';
  }

  @override
  String skillTreeXpLabel(int xp) {
    return '$xp XP';
  }

  @override
  String get skillTreeTiersLabel => 'Stufen';

  @override
  String get skillTreeTierUnlocked => 'FREIGESCHALTET';

  @override
  String get skillTreeTierCurrent => 'IN BEARBEITUNG';

  @override
  String get skillTreeTierLocked => 'GESPERRT';

  @override
  String skillTreeRuneUnlocked(String runeTitle) {
    return 'Rune freigeschaltet: $runeTitle';
  }

  @override
  String skillTreeRuneLockedAt(String runeTitle) {
    return 'Schaltet frei: $runeTitle';
  }

  @override
  String get loreBoardTitle => 'Lore-Tafel';

  @override
  String get loreBoardGlobalTab => 'Global';

  @override
  String get loreBoardFriendsTab => 'Freunde';

  @override
  String get loreBoardEmpty =>
      'Die Tafel ist leer... noch wurden keine Geschichten geteilt.';

  @override
  String get loreBoardTooltip => 'Lore-Tafel';

  @override
  String get guildHubTitle => 'Gildenhalle';

  @override
  String get guildHubEmpty =>
      'Du bist noch keiner Gilde beigetreten. Gründe deine eigene oder entdecke bestehende.';

  @override
  String get guildCreateButton => 'Neue Gilde gründen';

  @override
  String get guildDiscoverButton => 'Gilden entdecken';

  @override
  String get guildDetailCompanions => 'Gefährten';

  @override
  String get guildDetailLedger => 'Gruppenbuch';

  @override
  String get guildDetailLedgerEmpty => 'Noch keine Bücher im Gruppenbuch.';

  @override
  String get guildJoinButton => 'Gilde beitreten';

  @override
  String get guildJoined => 'Du bist der Gilde beigetreten!';

  @override
  String get guildLeaveButton => 'Gilde verlassen';

  @override
  String get guildLeft => 'Du hast die Gilde verlassen.';

  @override
  String get guildDeleteConfirmTitle => 'Diese Gilde auflösen?';

  @override
  String get guildDeleteConfirmBody =>
      'Dadurch werden die Gilde und alle zugehörigen Daten dauerhaft gelöscht. Dies kann nicht rückgängig gemacht werden.';

  @override
  String get guildDeleteCancel => 'Gilde behalten';

  @override
  String get guildDeleteConfirm => 'Gilde auflösen';

  @override
  String get guildDeleted => 'Gilde aufgelöst';

  @override
  String get guildCreated => 'Gilde gegründet!';

  @override
  String get guildUpdated => 'Gilde aktualisiert';

  @override
  String get guildCreatePageTitle => 'Eine Gilde gründen';

  @override
  String get guildFieldName => 'Gildenname';

  @override
  String get guildFieldNameHint => 'Die Gemeinschaft der Seiten';

  @override
  String get guildFieldDescription => 'Beschreibung';

  @override
  String get guildFieldDescriptionHint => 'Worum geht es in deiner Gilde?';

  @override
  String get guildFieldPublic => 'Öffentliche Gilde';

  @override
  String get guildFieldPublicSubtitle =>
      'Auf der Gildentafel sichtbar, damit jeder beitreten kann';

  @override
  String get guildCreateSubmit => 'Diese Gilde gründen';

  @override
  String get guildCreating => 'Wird gegründet...';

  @override
  String get guildDiscoverTitle => 'Gildentafel';

  @override
  String get guildDiscoverEmpty => 'Noch keine Gilden zu entdecken.';

  @override
  String guildMemberCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Gefährten',
      one: '1 Gefährte',
    );
    return '$_temp0';
  }

  @override
  String get guildRoleGuildmaster => 'Gildenmeister';

  @override
  String get guildRoleCompanion => 'Gefährte';

  @override
  String get guildGuestHeadline => 'Die Gildenhalle wartet';

  @override
  String get guildGuestBody =>
      'Erstelle ein Konto, um Gilden zu gründen, Lesegruppen beizutreten und gemeinsam mit anderen Abenteurern Bücherlisten zu führen.';

  @override
  String get guildAddToLedger => 'Zum Gruppenbuch hinzufügen';

  @override
  String get guildBookAdded => 'Buch zum Gruppenbuch hinzugefügt!';

  @override
  String get guildBookRemoved => 'Buch aus dem Gruppenbuch entfernt.';

  @override
  String get guildAlreadyMember => 'Du bist bereits Mitglied dieser Gilde.';
}
