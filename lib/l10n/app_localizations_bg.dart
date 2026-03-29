// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bulgarian (`bg`).
class AppLocalizationsBg extends AppLocalizations {
  AppLocalizationsBg([String locale = 'bg']) : super(locale);

  @override
  String get appTitle => 'StuffWithFantasy';

  @override
  String get bookSingular => 'книга';

  @override
  String get bookPlural => 'книги';

  @override
  String booksCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count книги',
      one: '1 книга',
    );
    return '$_temp0';
  }

  @override
  String get catalogSignUpPrompt =>
      'Създайте акаунт, за да запазвате книги в списъка си за четене.';

  @override
  String get catalogSnackbarActionProfile => 'Профил';

  @override
  String get catalogTooltipLibrary => 'Библиотека';

  @override
  String get catalogTooltipProfile => 'Профил';

  @override
  String get catalogFiltersUnavailable =>
      'Филтрите не са налични, докато таксономията не се зареди успешно.';

  @override
  String get catalogRetry => 'Опитай отново';

  @override
  String get catalogEmptyFiltered => 'Няма книги, отговарящи на филтрите ви';

  @override
  String get catalogEmptyNoBooks => 'Все още няма книги';

  @override
  String get catalogClearFilters => 'Изчисти филтрите';

  @override
  String get bookDetailSignUpPrompt =>
      'Създайте акаунт от профила си, за да запазвате книги в списъка си за четене.';

  @override
  String bookDetailByAuthor(String author) {
    return 'от $author';
  }

  @override
  String get bookDetailSectionSubgenres => 'Поджанрове';

  @override
  String get bookDetailSectionTropes => 'Тропи';

  @override
  String get bookDetailSectionRepresentation => 'Представителство';

  @override
  String get bookDetailSectionAbout => 'За тази книга';

  @override
  String get bookDetailReadMore => 'Прочети повече';

  @override
  String get bookDetailSectionSimilar => 'Може също да ви хареса';

  @override
  String get bookDetailBadgeKu => 'KU';

  @override
  String get bookDetailUpdating => 'Обновяване...';

  @override
  String get bookDetailRemoveFromList => 'Премахни от списъка за четене';

  @override
  String get bookDetailSaving => 'Запазване...';

  @override
  String get bookDetailSaveToList => 'Запази в списъка за четене';

  @override
  String get bookDetailOpening => 'Отваряне...';

  @override
  String get bookDetailReadInApp => 'Чети в приложението';

  @override
  String get bookDetailGetBook => 'Вземи тази книга';

  @override
  String get bookDetailAmazon => 'Amazon US';

  @override
  String get bookDetailAllRetailers => 'Виж всички търговци';

  @override
  String get bookDetailAudiobook => 'Аудиокнига';

  @override
  String get filterSearchHint => 'Търси по заглавие или автор...';

  @override
  String get filterChipKu => 'KU';

  @override
  String get filterChipAudiobook => 'Аудиокнига';

  @override
  String get filterClearAll => 'Изчисти всички';

  @override
  String get filterSheetTitle => 'Филтри';

  @override
  String get filterSheetReset => 'Нулиране';

  @override
  String get filterSheetSubgenres => 'Поджанрове';

  @override
  String get filterSheetTropes => 'Тропи';

  @override
  String get filterSheetSpiceLevel => 'Ниво на пикантност';

  @override
  String get filterSheetAgeCategory => 'Възрастова категория';

  @override
  String get filterSheetRepresentation => 'Представителство';

  @override
  String get filterSheetLanguageLevel => 'Ниво на езика';

  @override
  String filterSheetApplyWithCount(int count) {
    return 'Приложи филтри ($count)';
  }

  @override
  String get filterSheetApply => 'Приложи филтри';

  @override
  String get signUpSkip => 'Пропусни';

  @override
  String get rolePickerHeadline => 'Аз съм...';

  @override
  String get rolePickerSubtitle =>
      'Изберете как искате да използвате StuffWithFantasy';

  @override
  String get rolePickerContinue => 'Продължи';

  @override
  String get interestStepHeadline => 'Какво друго ви води тук?';

  @override
  String get interestStepSubtitle =>
      'Изберете каквото е приложимо — или пропуснете.';

  @override
  String get interestCardAuthorTitle => 'Аз съм автор';

  @override
  String get interestCardAuthorDescription =>
      'Искам книгите ми да бъдат открити от читатели на фентъзи.';

  @override
  String get interestCardInfluencerTitle => 'Аз съм инфлуенсър';

  @override
  String get interestCardInfluencerDescription =>
      'Създавам съдържание и искам да споделям фентъзи книги с аудиторията си.';

  @override
  String get interestStepContinue => 'Продължи';

  @override
  String get signUpFormHeadline => 'Създайте своя акаунт';

  @override
  String get signUpFormSubtitle => 'Само няколко детайла и сте вътре';

  @override
  String get signUpFieldNameLabel => 'Име за показване';

  @override
  String get signUpFieldNameHint => 'Как да ви наричаме?';

  @override
  String get signUpValidatorEnterName => 'Въведете името си';

  @override
  String get signUpFieldEmailLabel => 'Имейл';

  @override
  String get signUpFieldEmailHint => 'вие@example.com';

  @override
  String get signUpValidatorEnterEmail => 'Въведете имейла си';

  @override
  String get signUpValidatorInvalidEmail => 'Въведете валиден имейл';

  @override
  String get signUpFieldPasswordLabel => 'Парола';

  @override
  String get signUpFieldPasswordHint => 'Поне 8 символа';

  @override
  String get signUpValidatorEnterPassword => 'Въведете парола';

  @override
  String get signUpValidatorPasswordTooShort => 'Трябва да е поне 8 символа';

  @override
  String get signUpButtonCreateAccount => 'Създай акаунт';

  @override
  String welcomeStepHeadline(String name) {
    return 'Добре дошли, $name!';
  }

  @override
  String get welcomeStepSubtitle =>
      'Следващото ви велико фентъзи приключение ви очаква.';

  @override
  String get welcomeStepGetStarted => 'Да започваме';

  @override
  String get profileUnknownRank => 'Неизвестен ранг';

  @override
  String get profileAppBarTitle => 'Гилдийски зал';

  @override
  String get profileSectionRunes => 'Руни';

  @override
  String get profileSectionRunesSubtitle =>
      'Завършвайте куестове, за да гравирате руни за умения.';

  @override
  String get profileSectionQuestLog => 'Дневник на куестовете';

  @override
  String get profileSectionQuestLogSubtitle =>
      'Разгънете свитъци, за да следите и завършвате цели.';

  @override
  String get profileSectionRelicVault => 'Хранилище на реликви';

  @override
  String get profileSectionRelicVaultSubtitle =>
      'Завършвайте свитъци, за да спечелите реликви за хранилището си.';

  @override
  String get profileSectionCharacterSheet => 'Лист на героя';

  @override
  String get profileSnackbarRuneComingSoon =>
      'Тази руна скоро ще може да се настройва.';

  @override
  String get profileDeleteAccountTitle => 'Изтриване на акаунт';

  @override
  String get profileDeleteAccountBody =>
      'Това ще изтрие завинаги акаунта ви и всички свързани данни. Действието е необратимо.';

  @override
  String get profileDeleteCancel => 'Отказ';

  @override
  String get profileDeleteConfirm => 'Изтрий';

  @override
  String get profileSigningOut => 'Напускане на кралството...';

  @override
  String get profileSignOut => 'Напусни кралството';

  @override
  String get profileDeletingAccount => 'Изтриване на акаунт...';

  @override
  String get profileDeleteAccount => 'Изтрий акаунта';

  @override
  String get profileRetry => 'Опитай отново';

  @override
  String get profileErrorHeadline => 'Таблото с куестове не успя да се зареди';

  @override
  String get profileTryAgain => 'Опитай отново';

  @override
  String get guestGuildHallLabel => 'ГИЛДИЙСКИ ЗАЛ';

  @override
  String get guestGuildHeadline => 'Започни своя куест';

  @override
  String get guestGuildBody =>
      'Създайте акаунт, за да следите куестовете си за четене, да отключвате руни за умения и да събирате реликви, докато изследвате кралството.';

  @override
  String get guestGuildButtonCreateAccount => 'Създай акаунт, за да започнеш';

  @override
  String get runeStatusEngraved => 'ГРАВИРАНА';

  @override
  String get runeStatusLocked => 'ЗАКЛЮЧЕНА';

  @override
  String get runeDetailLockedHint =>
      'Завършете свързания куест, за да гравирате тази руна';

  @override
  String get runeDetailConfigure => 'Настрой';

  @override
  String get arcShieldTitle => 'ARC щит';

  @override
  String get arcShieldDescription =>
      'Когато е активен, авторите и издателите могат да ви намерят като ARC читател.';

  @override
  String get arcShieldSectionAvailability => 'Наличност';

  @override
  String get arcShieldToggleOpenLabel => 'Отворен за ARC';

  @override
  String get arcShieldToggleClosedLabel => 'Не приема ARC';

  @override
  String get arcShieldToggleOpenSubtitle =>
      'Авторите могат да се свържат с вас';

  @override
  String get arcShieldToggleClosedSubtitle =>
      'Профилът ви е скрит от ARC търсенията';

  @override
  String get genreAttunementTitle => 'Жанрова настройка';

  @override
  String get genreAttunementDescription =>
      'Изберете жанровете и тропите, които ви привличат. Кралството ще научи какво да ви показва.';

  @override
  String get genreAttunementSectionGenres => 'Жанрове';

  @override
  String get genreAttunementSectionTropes => 'Тропи';

  @override
  String genreAttunementCountAttuned(int count) {
    return '$count настроени';
  }

  @override
  String get genreEpicFantasy => 'Епично фентъзи';

  @override
  String get genreDarkFantasy => 'Тъмно фентъзи';

  @override
  String get genreUrbanFantasy => 'Градско фентъзи';

  @override
  String get genreRomantasy => 'Романтази';

  @override
  String get genreCozyFantasy => 'Уютно фентъзи';

  @override
  String get genreGrimdark => 'Grimdark';

  @override
  String get genreLitRpg => 'LitRPG';

  @override
  String get genreSwordAndSorcery => 'Меч и магия';

  @override
  String get genreMythicFantasy => 'Митично фентъзи';

  @override
  String get genrePortalFantasy => 'Портално фентъзи';

  @override
  String get tropeFoundFamily => 'Намерено семейство';

  @override
  String get tropeEnemiesToLovers => 'От врагове до любовници';

  @override
  String get tropeChosenOne => 'Избраният';

  @override
  String get tropeMagicSchools => 'Магически училища';

  @override
  String get tropeMorallyGrey => 'Морално сиви';

  @override
  String get tropeSlowBurn => 'Бавно разгаряне';

  @override
  String get tropePoliticalIntrigue => 'Политически интриги';

  @override
  String get tropeQuestJourney => 'Куест пътешествие';

  @override
  String get tropeHiddenRoyalty => 'Скрита кралска кръв';

  @override
  String get tropeRevengeArc => 'Арка на отмъщението';

  @override
  String get eventWatchtowerTitle => 'Наблюдателна кула';

  @override
  String get eventWatchtowerDescription =>
      'Изберете кои сигнали да достигат до вас от кралството.';

  @override
  String get eventWatchtowerSectionSignals => 'Сигнали';

  @override
  String get notifNewEventsTitle => 'Нови събития';

  @override
  String get notifNewEventsDescription =>
      'Когато се стартира събитие Stuff Your Kindle';

  @override
  String get notifBookDropsTitle => 'Нови книги';

  @override
  String get notifBookDropsDescription =>
      'Когато нови книги бъдат добавени в каталога';

  @override
  String get notifRecommendationsTitle => 'Препоръки';

  @override
  String get notifRecommendationsDescription =>
      'Персонализирани предложения според вашата настройка';

  @override
  String get rewardRevealBarrierLabel => 'Разкриване на награда';

  @override
  String get rewardRevealLegendRelicClaimed => 'ЛЕГЕНДАРНА РЕЛИКВА ПОЛУЧЕНА';

  @override
  String get rewardRevealRelicUnlocked => 'РЕЛИКВА ОТКЛЮЧЕНА';

  @override
  String get rewardRevealContinue => 'Продължи приключенията';

  @override
  String get characterSheetHeaderLabel => 'ЛИСТ НА ГЕРОЯ';

  @override
  String get characterSheetStatName => 'Име';

  @override
  String get characterSheetStatRank => 'Ранг';

  @override
  String get characterSheetStatQuests => 'Куестове';

  @override
  String characterSheetStatQuestsValue(int completed, int total) {
    return '$completed / $total';
  }

  @override
  String get characterSheetStatRelics => 'Реликви';

  @override
  String characterSheetStatRelicsValue(int collected, int total) {
    return '$collected / $total';
  }

  @override
  String get characterSheetStatSignal => 'Сигнал';

  @override
  String get realmMapCurrentQuest => 'ТЕКУЩ КУЕСТ';

  @override
  String get questScrollSealed => 'Завършен';

  @override
  String get questScrollActive => 'АКТИВЕН';

  @override
  String get questScrollReward => 'НАГРАДА';

  @override
  String get relicVaultLockedTitle => '???';

  @override
  String get relicVaultLegendRelic => 'Легендарна реликва';

  @override
  String get relicVaultClaimed => 'Получена';

  @override
  String get relicVaultSealed => 'Запечатана';

  @override
  String get libraryAppBarTitle => 'Библиотека';

  @override
  String get libraryTabMyBooks => 'Моите книги';

  @override
  String get libraryTabReadingList => 'Списък за четене';

  @override
  String get libraryMyBooksSignInTitle => 'Рафтът ви очаква';

  @override
  String get libraryMyBooksSignInMessage =>
      'Влезте, за да получите достъп до книги, които сте закупили, заявили или качили — готови за четене тук.';

  @override
  String get libraryMyBooksEmptyTitle => 'Все още няма книги за четене';

  @override
  String get libraryMyBooksEmptyMessage =>
      'Книги, които купувате, заявявате или качвате, ще се появят тук, когато са готови за четене.';

  @override
  String get libraryReadingListSignInTitle => 'Започнете списъка си за четене';

  @override
  String get libraryReadingListSignInMessage =>
      'Влезте, за да запазвате книги от каталога и да съставяте личния си списък за четене.';

  @override
  String get libraryReadingListEmptyTitle => 'Все още няма запазени';

  @override
  String get libraryReadingListEmptyMessage =>
      'Запазвайте книги от каталога, за да съставите списъка си за четене.';

  @override
  String get libraryButtonSignIn => 'Вход';

  @override
  String get libraryRetry => 'Опитай отново';

  @override
  String readerProgressRead(String progress) {
    return '$progress прочетено';
  }

  @override
  String get readerHintSwipeToTurn => 'Плъзнете, за да обърнете страниците';

  @override
  String get readerHintOpeningBook => 'Отваряне на книгата…';

  @override
  String get readerHintTapToHide =>
      'Докоснете центъра, за да скриете контролите';

  @override
  String get readerTooltipBack => 'Назад';

  @override
  String get readerTooltipChapters => 'Глави';

  @override
  String get readerTooltipReadingSettings => 'Настройки за четене';

  @override
  String get readerTooltipPreviousPage => 'Предишна страница';

  @override
  String get readerButtonPrev => 'Пред.';

  @override
  String get readerTooltipNextPage => 'Следваща страница';

  @override
  String get readerButtonNext => 'Сл.';

  @override
  String get readerChaptersTitle => 'Глави';

  @override
  String get readerSettingsTitle => 'Настройки за четене';

  @override
  String get readerSettingsTextSize => 'Размер на текста';

  @override
  String get readerTooltipSmallerText => 'По-малък текст';

  @override
  String readerFontSizeLabel(int size) {
    return '$size pt';
  }

  @override
  String get readerTooltipLargerText => 'По-голям текст';

  @override
  String get readerSettingsPageTheme => 'Тема на страницата';

  @override
  String get readerAppearancePaper => 'Хартия';

  @override
  String get readerAppearanceSepia => 'Сепия';

  @override
  String get readerAppearanceNight => 'Нощ';

  @override
  String get eventDetailLoadingBooks => 'Зареждане на книги...';

  @override
  String eventDetailBookCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count книги в това събитие',
      one: '1 книга в това събитие',
    );
    return '$_temp0';
  }

  @override
  String get eventDetailNoBooksYet => 'Все още няма книги в това събитие.';

  @override
  String get creatorDetailNoBooksYet => 'Все още няма книги за показване.';

  @override
  String get creatorDetailFavoriteBookLabel => 'Любима книга: ';

  @override
  String get creatorDetailLovesLabel => 'Обича: ';

  @override
  String creatorDetailBooksBy(String name) {
    return 'Книги от $name';
  }

  @override
  String creatorDetailRecommendedBy(String name) {
    return 'Препоръчано от $name';
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
  String get socialLinkWebsite => 'Уебсайт';

  @override
  String get userRoleReader => 'Читател';

  @override
  String get userRoleReaderDescription =>
      'Открийте следващата си любима фентъзи книга';

  @override
  String get creatorRoleAuthor => 'Автор';

  @override
  String get creatorRoleInfluencer => 'Инфлуенсър';

  @override
  String get readAccessOwner => 'Ваше качване';

  @override
  String get readAccessPurchased => 'Закупена';

  @override
  String get readAccessNone => 'Няма достъп';

  @override
  String get eventStatusLastDay => 'Последен ден!';

  @override
  String get eventStatusHappeningNow => 'Протича сега';

  @override
  String get eventStatusStartsToday => 'Започва днес';

  @override
  String get eventStatusStartsTomorrow => 'Започва утре';

  @override
  String eventStatusStartsInDays(int days) {
    return 'Започва след $days дни';
  }

  @override
  String get spiceLevelNone => 'Без пикантност';

  @override
  String get spiceLevelMild => 'Леко пикантно';

  @override
  String get spiceLevelMedium => 'Средно пикантно';

  @override
  String get spiceLevelHot => 'Горещо';

  @override
  String get spiceLevelScorching => 'Изгарящо';

  @override
  String get languageLevelClean => 'Чист';

  @override
  String get languageLevelMild => 'Лек език';

  @override
  String get languageLevelModerate => 'Умерен език';

  @override
  String get languageLevelStrong => 'Силен език';

  @override
  String get homeHeadline => 'Stuff With Fantasy';

  @override
  String get homeTagline => 'Вашият спътник за фентъзи четене.';

  @override
  String get homeSubtitle =>
      'Откривайте, следете и споделяйте фентъзи книгите, които обичате.';

  @override
  String get homeChipMaterial3 => 'Material 3';

  @override
  String get homeChipStructuredStarter => 'Структуриран стартер';

  @override
  String get homeChipWidgetTests => 'Уиджет тестове';

  @override
  String get homeCardWhatIsReadyTitle => 'Какво е готово';

  @override
  String get homeCardWhatIsReadyItem1 =>
      'Брандирана обвивка на приложението със светла и тъмна тема.';

  @override
  String get homeCardWhatIsReadyItem2 =>
      'По-строга базова линия за анализ чрез flutter_lints.';

  @override
  String get homeCardWhatIsReadyItem3 =>
      'Уиджет тест за защита на стартовото изживяване.';

  @override
  String get homeCardWhereToGoNextTitle => 'Накъде след това';

  @override
  String get homeCardWhereToGoNextItem1 =>
      'Добавяйте функционалности под lib/src по домейн, вместо да разширявате main.dart.';

  @override
  String get homeCardWhereToGoNextItem2 =>
      'Заменете примерните ресурси, икони за стартиране и текстове за продукта.';

  @override
  String get homeCardWhereToGoNextItem3 =>
      'Стартирайте flutter analyze и flutter test, докато добавяте екрани.';

  @override
  String get homeGetStarted => 'Да започваме';

  @override
  String get homeBrowseBooks => 'Разгледай книгите';

  @override
  String get monthJan => 'яну';

  @override
  String get monthFeb => 'фев';

  @override
  String get monthMar => 'мар';

  @override
  String get monthApr => 'апр';

  @override
  String get monthMay => 'май';

  @override
  String get monthJun => 'юни';

  @override
  String get monthJul => 'юли';

  @override
  String get monthAug => 'авг';

  @override
  String get monthSep => 'сеп';

  @override
  String get monthOct => 'окт';

  @override
  String get monthNov => 'ное';

  @override
  String get monthDec => 'дек';

  @override
  String get profileSectionLanguage => 'Език';

  @override
  String get languageSystemDefault => 'Системен по подразбиране';

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
  String get profileSectionReadingChronicle => 'Хроника на четенето';

  @override
  String get profileSectionReadingChronicleSubtitle =>
      'Вашето пътешествие през страниците, отбелязано с мастило.';

  @override
  String get profileSectionTomeCounter => 'Брояч на томове';

  @override
  String get profileSectionTomeCounterSubtitle =>
      'Вашите натрупани четивни подвизи.';

  @override
  String get profileSectionAchievementSigils => 'Печати на постиженията';

  @override
  String get profileSectionAchievementSigilsSubtitle =>
      'Крайъгълни камъни, изковани чрез отдаденост.';

  @override
  String chroniclePagesThisWeek(int count) {
    return '~$count страници тази седмица';
  }

  @override
  String chronicleStreak(int count) {
    return '$count-дневна поредица';
  }

  @override
  String get chronicleLess => 'По-малко';

  @override
  String get chronicleMore => 'Повече';

  @override
  String get tomeCounterBooks => 'Покорени томове';

  @override
  String get tomeCounterPages => 'Обърнати страници';

  @override
  String get tomeCounterTime => 'Време в кралството';

  @override
  String tomeCounterHoursMinutes(int hours, int minutes) {
    return '$hoursч $minutesм';
  }

  @override
  String tomeCounterMinutes(int minutes) {
    return '$minutesм';
  }

  @override
  String get achievementLocked => 'ЗАПЕЧАТАНО';

  @override
  String get achievementUnlocked => 'СПЕЧЕЛЕНО';

  @override
  String get achievementFirstPageTitle => 'Първа страница';

  @override
  String get achievementFirstPageDesc =>
      'Отворете книга и започнете да четете.';

  @override
  String get achievementBookwormTitle => 'Пробуждане на книжния червей';

  @override
  String get achievementBookwormDesc => 'Завършете първата си книга.';

  @override
  String get achievementDailyRitualTitle => 'Ежедневен ритуал';

  @override
  String get achievementDailyRitualDesc => 'Четете 3 дни поред.';

  @override
  String get achievementPageTurnerTitle => 'Обръщач на страници';

  @override
  String get achievementPageTurnerDesc =>
      'Прочетете приблизително 100 страници.';

  @override
  String get achievementHourGlassTitle => 'Пясъчен часовник';

  @override
  String get achievementHourGlassDesc => 'Прекарайте 1 час в четене.';

  @override
  String get achievementChapterChampionTitle => 'Шампион на главите';

  @override
  String get achievementChapterChampionDesc => 'Завършете 3 книги.';

  @override
  String get achievementFlameKeeperTitle => 'Пазител на пламъка';

  @override
  String get achievementFlameKeeperDesc => 'Четете 7 дни поред.';

  @override
  String get achievementTomeScholarTitle => 'Учен на томовете';

  @override
  String get achievementTomeScholarDesc =>
      'Прочетете приблизително 1000 страници.';

  @override
  String get achievementDevotedReaderTitle => 'Отдаден читател';

  @override
  String get achievementDevotedReaderDesc => 'Прекарайте 10 часа в четене.';

  @override
  String get achievementFiveRealmsTitle => 'Пет кралства';

  @override
  String get achievementFiveRealmsDesc =>
      'Започнете да четете 5 различни книги.';

  @override
  String get achievementGrandLibrarianTitle => 'Велик библиотекар';

  @override
  String get achievementGrandLibrarianDesc => 'Завършете 10 книги.';

  @override
  String get achievementEternalFlameTitle => 'Вечен пламък';

  @override
  String get achievementEternalFlameDesc =>
      'Поддържайте 30-дневна поредица на четене.';

  @override
  String get achievementMythicScribeTitle => 'Митичен писар';

  @override
  String get achievementMythicScribeDesc => 'Прекарайте 100 часа в четене.';

  @override
  String get achievementRealmWalkerTitle => 'Странник на кралствата';

  @override
  String get achievementRealmWalkerDesc =>
      'Започнете да четете 10 различни книги.';

  @override
  String get oathAppBarTitle => 'Камък на клетвата';

  @override
  String get oathSectionTitle => 'Камък на клетвата';

  @override
  String get oathSectionSubtitle => 'Вашата заклета цел за четене';

  @override
  String get oathSwearCta => 'Положи клетва';

  @override
  String get oathSwearSubtitle =>
      'Поставете публична цел за четене и следете напредъка си';

  @override
  String get oathSwearPageTitle => 'Впишете вашата клетва';

  @override
  String get oathFieldTitle => 'Вашата клетва';

  @override
  String get oathFieldTitleHint => 'Ще прочета 24 книги през 2026';

  @override
  String get oathFieldTarget => 'Целеви книги';

  @override
  String get oathFieldYear => 'Година';

  @override
  String get oathFieldPublic => 'Публична клетва';

  @override
  String get oathFieldPublicSubtitle => 'Видима в Таблото на преданията';

  @override
  String get oathSwearButton => 'Положи тази клетва';

  @override
  String get oathSwearing => 'Вписване...';

  @override
  String oathProgressLabel(int current, int target) {
    return '$current от $target';
  }

  @override
  String get oathProgressComplete => 'Клетвата е изпълнена!';

  @override
  String get oathEntryLogged => 'Руна гравирана!';

  @override
  String get oathEntryRemoved => 'Записът е премахнат';

  @override
  String get oathDeleteConfirmTitle => 'Нарушаване на клетвата?';

  @override
  String get oathDeleteConfirmBody =>
      'Това ще премахне завинаги вашата клетва и всички записани позиции.';

  @override
  String get oathDeleteCancel => 'Запази клетвата';

  @override
  String get oathDeleteConfirm => 'Наруши клетвата';

  @override
  String get oathDeleted => 'Клетвата е нарушена';

  @override
  String get oathCompleteTitle => 'КЛЕТВАТА Е ИЗПЪЛНЕНА';

  @override
  String get oathCompleteHeadline => 'Вашата клетва е запечатана';

  @override
  String get oathCompleteBody =>
      'Вие изпълнихте обещанието си. Руните са завършени.';

  @override
  String get oathCompleteContinue => 'Продължи';

  @override
  String get oathEmptyEntries => 'Все още няма записани книги';

  @override
  String get oathLogBookAction => 'Запиши към клетвата';

  @override
  String oathLogBookConfirm(String title) {
    return 'Да запиша ли \"$title\" към вашата клетва?';
  }

  @override
  String get oathLogBookButton => 'Запиши';

  @override
  String get oathAlreadyLogged => 'Вече е записана към вашата клетва';

  @override
  String get oathEditButton => 'Редактирай клетвата';

  @override
  String get oathUpdated => 'Клетвата е обновена';

  @override
  String get oathErrorCreate => 'Неуспешно създаване на клетва';

  @override
  String get oathErrorLoad => 'Неуспешно зареждане на клетва';

  @override
  String get oathGuestHeadline => 'Камъкът на клетвата очаква';

  @override
  String get oathGuestBody =>
      'Създайте акаунт, за да положите клетва за четене и да следите напредъка си.';

  @override
  String get seasonalCampaignLabel => 'Сезонна кампания';

  @override
  String get seasonalCampaignExpired => 'Експедицията приключи';

  @override
  String get seasonalCampaignLastDay => 'Последен ден!';

  @override
  String seasonalCampaignCountdownDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Остават $days дни',
      one: 'Остава 1 ден',
    );
    return '$_temp0';
  }

  @override
  String seasonalCampaignCountdownMonths(int months) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: 'Остават $months месеца',
      one: 'Остава 1 месец',
    );
    return '$_temp0';
  }

  @override
  String seasonalCampaignCountdownMonthsDays(int months, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: '$months месеца',
      one: '1 месец',
    );
    String _temp1 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'остават $days дни',
      one: 'остава 1 ден',
    );
    return '$_temp0, $_temp1';
  }

  @override
  String get seasonalRelicSectionTitle => 'Сезонни реликви';

  @override
  String get profileSectionSeasonalQuests => 'Сезонни куестове';

  @override
  String get profileSectionSeasonalQuestsSubtitle =>
      'Ограничени във времето експедиции с ексклузивни реликви.';

  @override
  String get realmRankingsTitle => 'Класации на кралството';

  @override
  String get leaderboardMetricQuests => 'Куестове';

  @override
  String get leaderboardMetricBooks => 'Книги';

  @override
  String get leaderboardMetricRelics => 'Реликви';

  @override
  String leaderboardTotalParticipants(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count приключенци в класацията',
      one: '1 приключенец в класацията',
    );
    return '$_temp0';
  }

  @override
  String get leaderboardYourPosition => 'ВАШАТА ПОЗИЦИЯ';

  @override
  String leaderboardPositionOfTotal(int position, int total) {
    return '#$position от $total';
  }

  @override
  String get leaderboardErrorHeadline => 'Класациите не успяха да се заредят';

  @override
  String get leaderboardOptInTitle => 'Класации на кралството';

  @override
  String get leaderboardOptInDescription =>
      'Състезавайте се с други приключенци, като се присъедините към класацията на кралството. Класирането ви се основава на завършени куестове, прочетени книги и събрани реликви.';

  @override
  String get leaderboardOptInPrivacy =>
      'Само вашето име за показване и ранг са видими за другите.';

  @override
  String get leaderboardOptInActive => 'Класиран в кралството';

  @override
  String get leaderboardOptInInactive => 'Некласиран';

  @override
  String get leaderboardOptInJoinButton => 'Присъедини се към класацията';

  @override
  String get leaderboardOptInLeaveButton => 'Напусни класацията';

  @override
  String get characterSheetStatRealmRank => 'Кралство';

  @override
  String get characterSheetRealmRankJoin => 'Към класацията';

  @override
  String get skillTreeSectionTitle => 'Дърво на уменията';

  @override
  String get skillTreeSectionSubtitle =>
      'Развивайте жанровото си майсторство чрез четене.';

  @override
  String skillTreeXpProgress(int current, int next) {
    return '$current / $next XP';
  }

  @override
  String skillTreeXpLabel(int xp) {
    return '$xp XP';
  }

  @override
  String get skillTreeTiersLabel => 'Нива';

  @override
  String get skillTreeTierUnlocked => 'ОТКЛЮЧЕНО';

  @override
  String get skillTreeTierCurrent => 'В ПРОГРЕС';

  @override
  String get skillTreeTierLocked => 'ЗАКЛЮЧЕНО';

  @override
  String skillTreeRuneUnlocked(String runeTitle) {
    return 'Руна отключена: $runeTitle';
  }

  @override
  String skillTreeRuneLockedAt(String runeTitle) {
    return 'Отключва: $runeTitle';
  }

  @override
  String get loreBoardTitle => 'Табло на преданията';

  @override
  String get loreBoardGlobalTab => 'Глобално';

  @override
  String get loreBoardFriendsTab => 'Приятели';

  @override
  String get loreBoardEmpty =>
      'Таблото е празно... все още няма публикувани истории.';

  @override
  String get loreBoardTooltip => 'Табло на преданията';

  @override
  String get guildHubTitle => 'Гилдийски зал';

  @override
  String get guildHubEmpty =>
      'Все още не сте се присъединили към гилдия. Основете своя или открийте съществуващи.';

  @override
  String get guildCreateButton => 'Основи нова гилдия';

  @override
  String get guildDiscoverButton => 'Открий гилдии';

  @override
  String get guildDetailCompanions => 'Спътници';

  @override
  String get guildDetailLedger => 'Дневник на групата';

  @override
  String get guildDetailLedgerEmpty => 'Все още няма книги в дневника.';

  @override
  String get guildJoinButton => 'Присъедини се към гилдията';

  @override
  String get guildJoined => 'Присъединихте се към гилдията!';

  @override
  String get guildLeaveButton => 'Напусни гилдията';

  @override
  String get guildLeft => 'Напуснахте гилдията.';

  @override
  String get guildDeleteConfirmTitle => 'Разпускане на гилдията?';

  @override
  String get guildDeleteConfirmBody =>
      'Това ще премахне завинаги гилдията и всичките й данни. Действието е необратимо.';

  @override
  String get guildDeleteCancel => 'Запази гилдията';

  @override
  String get guildDeleteConfirm => 'Разпусни гилдията';

  @override
  String get guildDeleted => 'Гилдията е разпусната';

  @override
  String get guildCreated => 'Гилдията е основана!';

  @override
  String get guildUpdated => 'Гилдията е обновена';

  @override
  String get guildCreatePageTitle => 'Основи гилдия';

  @override
  String get guildFieldName => 'Име на гилдията';

  @override
  String get guildFieldNameHint => 'Братството на страниците';

  @override
  String get guildFieldDescription => 'Описание';

  @override
  String get guildFieldDescriptionHint => 'За какво е вашата гилдия?';

  @override
  String get guildFieldPublic => 'Публична гилдия';

  @override
  String get guildFieldPublicSubtitle =>
      'Видима в Гилдийското табло за присъединяване от всеки';

  @override
  String get guildCreateSubmit => 'Основи тази гилдия';

  @override
  String get guildCreating => 'Основаване...';

  @override
  String get guildDiscoverTitle => 'Гилдийско табло';

  @override
  String get guildDiscoverEmpty => 'Все още няма гилдии за откриване.';

  @override
  String guildMemberCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count спътници',
      one: '1 спътник',
    );
    return '$_temp0';
  }

  @override
  String get guildRoleGuildmaster => 'Гилдмайстор';

  @override
  String get guildRoleCompanion => 'Спътник';

  @override
  String get guildGuestHeadline => 'Гилдийският зал очаква';

  @override
  String get guildGuestBody =>
      'Създайте акаунт, за да основавате гилдии, да се присъединявате към групи за четене и да водите дневници с други приключенци.';

  @override
  String get guildAddToLedger => 'Добави в дневника';

  @override
  String get guildBookAdded => 'Книгата е добавена в дневника!';

  @override
  String get guildBookRemoved => 'Книгата е премахната от дневника.';

  @override
  String get guildAlreadyMember => 'Вече сте член на тази гилдия.';
}
