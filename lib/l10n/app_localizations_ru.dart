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
  String get bookSingular => 'книга';

  @override
  String get bookPlural => 'книги';

  @override
  String booksCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count книг',
      many: '$count книг',
      few: '$count книги',
      one: '1 книга',
    );
    return '$_temp0';
  }

  @override
  String get catalogSignUpPrompt =>
      'Создайте аккаунт, чтобы сохранять книги в список чтения.';

  @override
  String get catalogSnackbarActionProfile => 'Профиль';

  @override
  String get catalogTooltipLibrary => 'Библиотека';

  @override
  String get catalogTooltipProfile => 'Профиль';

  @override
  String get catalogFiltersUnavailable =>
      'Фильтры недоступны, пока таксономия не загрузится.';

  @override
  String get catalogRetry => 'Повторить';

  @override
  String get catalogEmptyFiltered => 'Нет книг, соответствующих вашим фильтрам';

  @override
  String get catalogEmptyNoBooks => 'Книг пока нет';

  @override
  String get catalogClearFilters => 'Сбросить фильтры';

  @override
  String get bookDetailSignUpPrompt =>
      'Создайте аккаунт в профиле, чтобы сохранять книги в список чтения.';

  @override
  String bookDetailByAuthor(String author) {
    return 'автор: $author';
  }

  @override
  String get bookDetailSectionSubgenres => 'Поджанры';

  @override
  String get bookDetailSectionTropes => 'Тропы';

  @override
  String get bookDetailSectionRepresentation => 'Репрезентация';

  @override
  String get bookDetailSectionAbout => 'Об этой книге';

  @override
  String get bookDetailReadMore => 'Читать далее';

  @override
  String get bookDetailSectionSimilar => 'Вам также может понравиться';

  @override
  String get bookDetailBadgeKu => 'KU';

  @override
  String get bookDetailUpdating => 'Обновление...';

  @override
  String get bookDetailRemoveFromList => 'Удалить из списка чтения';

  @override
  String get bookDetailSaving => 'Сохранение...';

  @override
  String get bookDetailSaveToList => 'Сохранить в список чтения';

  @override
  String get bookDetailOpening => 'Открытие...';

  @override
  String get bookDetailReadInApp => 'Читать в приложении';

  @override
  String get bookDetailGetBook => 'Получить книгу';

  @override
  String get bookDetailAmazon => 'Amazon US';

  @override
  String get bookDetailAllRetailers => 'Все магазины';

  @override
  String get bookDetailAudiobook => 'Аудиокнига';

  @override
  String get filterSearchHint => 'Поиск по названию или автору...';

  @override
  String get filterChipKu => 'KU';

  @override
  String get filterChipAudiobook => 'Аудиокнига';

  @override
  String get filterClearAll => 'Сбросить все';

  @override
  String get filterSheetTitle => 'Фильтры';

  @override
  String get filterSheetReset => 'Сбросить';

  @override
  String get filterSheetSubgenres => 'Поджанры';

  @override
  String get filterSheetTropes => 'Тропы';

  @override
  String get filterSheetSpiceLevel => 'Уровень пикантности';

  @override
  String get filterSheetAgeCategory => 'Возрастная категория';

  @override
  String get filterSheetRepresentation => 'Репрезентация';

  @override
  String get filterSheetLanguageLevel => 'Уровень лексики';

  @override
  String filterSheetApplyWithCount(int count) {
    return 'Применить фильтры ($count)';
  }

  @override
  String get filterSheetApply => 'Применить фильтры';

  @override
  String get signUpSkip => 'Пропустить';

  @override
  String get rolePickerHeadline => 'Я...';

  @override
  String get rolePickerSubtitle =>
      'Выберите, как вы хотите использовать StuffWithFantasy';

  @override
  String get rolePickerContinue => 'Продолжить';

  @override
  String get interestStepHeadline => 'Что ещё привело вас сюда?';

  @override
  String get interestStepSubtitle =>
      'Выберите подходящие варианты — или пропустите.';

  @override
  String get interestCardAuthorTitle => 'Я автор';

  @override
  String get interestCardAuthorDescription =>
      'Я хочу, чтобы читатели фэнтези находили мои книги.';

  @override
  String get interestCardInfluencerTitle => 'Я инфлюенсер';

  @override
  String get interestCardInfluencerDescription =>
      'Я создаю контент и хочу делиться книгами фэнтези со своей аудиторией.';

  @override
  String get interestStepContinue => 'Продолжить';

  @override
  String get signUpFormHeadline => 'Создайте аккаунт';

  @override
  String get signUpFormSubtitle => 'Пара деталей — и вы в деле';

  @override
  String get signUpFieldNameLabel => 'Отображаемое имя';

  @override
  String get signUpFieldNameHint => 'Как нам вас называть?';

  @override
  String get signUpValidatorEnterName => 'Введите ваше имя';

  @override
  String get signUpFieldEmailLabel => 'Email';

  @override
  String get signUpFieldEmailHint => 'you@example.com';

  @override
  String get signUpValidatorEnterEmail => 'Введите ваш email';

  @override
  String get signUpValidatorInvalidEmail => 'Введите корректный email';

  @override
  String get signUpFieldPasswordLabel => 'Пароль';

  @override
  String get signUpFieldPasswordHint => 'Минимум 8 символов';

  @override
  String get signUpValidatorEnterPassword => 'Введите пароль';

  @override
  String get signUpValidatorPasswordTooShort => 'Минимум 8 символов';

  @override
  String get signUpButtonCreateAccount => 'Создать аккаунт';

  @override
  String welcomeStepHeadline(String name) {
    return 'Добро пожаловать, $name!';
  }

  @override
  String get welcomeStepSubtitle =>
      'Ваше следующее великое фэнтези-приключение ждёт вас.';

  @override
  String get welcomeStepGetStarted => 'Начать';

  @override
  String get profileUnknownRank => 'Неизвестный ранг';

  @override
  String get profileAppBarTitle => 'Гильдейский зал';

  @override
  String get profileSectionRunes => 'Руны';

  @override
  String get profileSectionRunesSubtitle =>
      'Завершайте квесты, чтобы выгравировать руны способностей.';

  @override
  String get profileSectionQuestLog => 'Журнал квестов';

  @override
  String get profileSectionQuestLogSubtitle =>
      'Разворачивайте свитки, чтобы отслеживать и выполнять задания.';

  @override
  String get profileSectionRelicVault => 'Хранилище реликвий';

  @override
  String get profileSectionRelicVaultSubtitle =>
      'Завершайте свитки, чтобы получить реликвии в хранилище.';

  @override
  String get profileSectionCharacterSheet => 'Лист персонажа';

  @override
  String get profileSnackbarRuneComingSoon =>
      'Настройка этой руны скоро будет доступна.';

  @override
  String get profileDeleteAccountTitle => 'Удалить аккаунт';

  @override
  String get profileDeleteAccountBody =>
      'Это навсегда удалит ваш аккаунт и все связанные данные. Это действие нельзя отменить.';

  @override
  String get profileDeleteCancel => 'Отмена';

  @override
  String get profileDeleteConfirm => 'Удалить';

  @override
  String get profileSigningOut => 'Покидаем мир...';

  @override
  String get profileSignOut => 'Покинуть мир';

  @override
  String get profileDeletingAccount => 'Удаление аккаунта...';

  @override
  String get profileDeleteAccount => 'Удалить аккаунт';

  @override
  String get profileRetry => 'Повторить';

  @override
  String get profileErrorHeadline => 'Не удалось загрузить доску заданий';

  @override
  String get profileTryAgain => 'Попробовать снова';

  @override
  String get guestGuildHallLabel => 'ГИЛЬДЕЙСКИЙ ЗАЛ';

  @override
  String get guestGuildHeadline => 'Начните ваш квест';

  @override
  String get guestGuildBody =>
      'Создайте аккаунт, чтобы отслеживать квесты чтения, открывать руны способностей и собирать реликвии, исследуя мир.';

  @override
  String get guestGuildButtonCreateAccount => 'Создать аккаунт';

  @override
  String get runeStatusEngraved => 'ВЫГРАВИРОВАНА';

  @override
  String get runeStatusLocked => 'ЗАБЛОКИРОВАНА';

  @override
  String get runeDetailLockedHint =>
      'Завершите связанный квест, чтобы выгравировать эту руну';

  @override
  String get runeDetailConfigure => 'Настроить';

  @override
  String get arcShieldTitle => 'Щит ARC';

  @override
  String get arcShieldDescription =>
      'Когда активен, авторы и издатели могут найти вас как ARC-читателя.';

  @override
  String get arcShieldSectionAvailability => 'Доступность';

  @override
  String get arcShieldToggleOpenLabel => 'Открыт для ARC';

  @override
  String get arcShieldToggleClosedLabel => 'Не принимаю ARC';

  @override
  String get arcShieldToggleOpenSubtitle => 'Авторы могут связаться с вами';

  @override
  String get arcShieldToggleClosedSubtitle => 'Ваш профиль скрыт от поиска ARC';

  @override
  String get genreAttunementTitle => 'Настройка жанров';

  @override
  String get genreAttunementDescription =>
      'Выберите жанры и тропы, которые вам близки. Мир подстроится под ваши предпочтения.';

  @override
  String get genreAttunementSectionGenres => 'Жанры';

  @override
  String get genreAttunementSectionTropes => 'Тропы';

  @override
  String genreAttunementCountAttuned(int count) {
    return '$count настроено';
  }

  @override
  String get genreEpicFantasy => 'Эпическое фэнтези';

  @override
  String get genreDarkFantasy => 'Тёмное фэнтези';

  @override
  String get genreUrbanFantasy => 'Городское фэнтези';

  @override
  String get genreRomantasy => 'Романтическое фэнтези';

  @override
  String get genreCozyFantasy => 'Уютное фэнтези';

  @override
  String get genreGrimdark => 'Гримдарк';

  @override
  String get genreLitRpg => 'LitRPG';

  @override
  String get genreSwordAndSorcery => 'Меч и магия';

  @override
  String get genreMythicFantasy => 'Мифическое фэнтези';

  @override
  String get genrePortalFantasy => 'Попаданцы';

  @override
  String get tropeFoundFamily => 'Обретённая семья';

  @override
  String get tropeEnemiesToLovers => 'От врагов к влюблённым';

  @override
  String get tropeChosenOne => 'Избранный';

  @override
  String get tropeMagicSchools => 'Магические школы';

  @override
  String get tropeMorallyGrey => 'Морально неоднозначный';

  @override
  String get tropeSlowBurn => 'Медленное развитие';

  @override
  String get tropePoliticalIntrigue => 'Политические интриги';

  @override
  String get tropeQuestJourney => 'Путешествие-квест';

  @override
  String get tropeHiddenRoyalty => 'Скрытое происхождение';

  @override
  String get tropeRevengeArc => 'Арка мести';

  @override
  String get eventWatchtowerTitle => 'Сторожевая башня';

  @override
  String get eventWatchtowerDescription =>
      'Выберите, какие сигналы из мира будут доходить до вас.';

  @override
  String get eventWatchtowerSectionSignals => 'Сигналы';

  @override
  String get notifNewEventsTitle => 'Новые события';

  @override
  String get notifNewEventsDescription =>
      'Когда запускается событие Stuff Your Kindle';

  @override
  String get notifBookDropsTitle => 'Новинки';

  @override
  String get notifBookDropsDescription =>
      'Когда в каталог добавляются новые книги';

  @override
  String get notifRecommendationsTitle => 'Рекомендации';

  @override
  String get notifRecommendationsDescription =>
      'Персональные подборки на основе ваших предпочтений';

  @override
  String get rewardRevealBarrierLabel => 'Награда';

  @override
  String get rewardRevealLegendRelicClaimed => 'ЛЕГЕНДАРНАЯ РЕЛИКВИЯ ПОЛУЧЕНА';

  @override
  String get rewardRevealRelicUnlocked => 'РЕЛИКВИЯ ОТКРЫТА';

  @override
  String get rewardRevealContinue => 'Продолжить путешествие';

  @override
  String get characterSheetHeaderLabel => 'ЛИСТ ПЕРСОНАЖА';

  @override
  String get characterSheetStatName => 'Имя';

  @override
  String get characterSheetStatRank => 'Ранг';

  @override
  String get characterSheetStatQuests => 'Квесты';

  @override
  String characterSheetStatQuestsValue(int completed, int total) {
    return '$completed / $total';
  }

  @override
  String get characterSheetStatRelics => 'Реликвии';

  @override
  String characterSheetStatRelicsValue(int collected, int total) {
    return '$collected / $total';
  }

  @override
  String get characterSheetStatSignal => 'Сигнал';

  @override
  String get realmMapCurrentQuest => 'ТЕКУЩИЙ КВЕСТ';

  @override
  String get questScrollSealed => 'Завершён';

  @override
  String get questScrollActive => 'АКТИВЕН';

  @override
  String get questScrollReward => 'НАГРАДА';

  @override
  String get relicVaultLockedTitle => '???';

  @override
  String get relicVaultLegendRelic => 'Легендарная реликвия';

  @override
  String get relicVaultClaimed => 'Получена';

  @override
  String get relicVaultSealed => 'Запечатана';

  @override
  String get libraryAppBarTitle => 'Библиотека';

  @override
  String get libraryTabMyBooks => 'Мои книги';

  @override
  String get libraryTabReadingList => 'Список чтения';

  @override
  String get libraryMyBooksSignInTitle => 'Ваша книжная полка ждёт';

  @override
  String get libraryMyBooksSignInMessage =>
      'Войдите, чтобы получить доступ к купленным, полученным или загруженным книгам — готовым к чтению прямо здесь.';

  @override
  String get libraryMyBooksEmptyTitle => 'Книг для чтения пока нет';

  @override
  String get libraryMyBooksEmptyMessage =>
      'Книги, которые вы купите, получите или загрузите, появятся здесь, когда будут готовы к чтению.';

  @override
  String get libraryReadingListSignInTitle => 'Начните список чтения';

  @override
  String get libraryReadingListSignInMessage =>
      'Войдите, чтобы сохранять книги из каталога и создавать свой список чтения.';

  @override
  String get libraryReadingListEmptyTitle => 'Пока ничего не сохранено';

  @override
  String get libraryReadingListEmptyMessage =>
      'Сохраняйте книги из каталога, чтобы создать свой список чтения.';

  @override
  String get libraryButtonSignIn => 'Войти';

  @override
  String get libraryRetry => 'Повторить';

  @override
  String readerProgressRead(String progress) {
    return '$progress прочитано';
  }

  @override
  String get readerHintSwipeToTurn => 'Проведите, чтобы перевернуть страницу';

  @override
  String get readerHintOpeningBook => 'Открытие книги…';

  @override
  String get readerHintTapToHide =>
      'Нажмите в центр, чтобы скрыть элементы управления';

  @override
  String get readerTooltipBack => 'Назад';

  @override
  String get readerTooltipChapters => 'Главы';

  @override
  String get readerTooltipReadingSettings => 'Настройки чтения';

  @override
  String get readerTooltipPreviousPage => 'Предыдущая страница';

  @override
  String get readerButtonPrev => 'Назад';

  @override
  String get readerTooltipNextPage => 'Следующая страница';

  @override
  String get readerButtonNext => 'Далее';

  @override
  String get readerChaptersTitle => 'Главы';

  @override
  String get readerSettingsTitle => 'Настройки чтения';

  @override
  String get readerSettingsTextSize => 'Размер текста';

  @override
  String get readerTooltipSmallerText => 'Уменьшить текст';

  @override
  String readerFontSizeLabel(int size) {
    return '$size пт';
  }

  @override
  String get readerTooltipLargerText => 'Увеличить текст';

  @override
  String get readerSettingsPageTheme => 'Тема страницы';

  @override
  String get readerAppearancePaper => 'Бумага';

  @override
  String get readerAppearanceSepia => 'Сепия';

  @override
  String get readerAppearanceNight => 'Ночь';

  @override
  String get eventDetailLoadingBooks => 'Загрузка книг...';

  @override
  String eventDetailBookCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count книг в этом событии',
      many: '$count книг в этом событии',
      few: '$count книги в этом событии',
      one: '1 книга в этом событии',
    );
    return '$_temp0';
  }

  @override
  String get eventDetailNoBooksYet => 'В этом событии пока нет книг.';

  @override
  String get creatorDetailNoBooksYet => 'Книг пока нет.';

  @override
  String get creatorDetailFavoriteBookLabel => 'Любимая книга: ';

  @override
  String get creatorDetailLovesLabel => 'Увлечения: ';

  @override
  String creatorDetailBooksBy(String name) {
    return 'Книги автора $name';
  }

  @override
  String creatorDetailRecommendedBy(String name) {
    return 'Рекомендовано: $name';
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
  String get socialLinkWebsite => 'Веб-сайт';

  @override
  String get userRoleReader => 'Читатель';

  @override
  String get userRoleReaderDescription =>
      'Откройте для себя следующую любимую фэнтези-книгу';

  @override
  String get creatorRoleAuthor => 'Автор';

  @override
  String get creatorRoleInfluencer => 'Инфлюенсер';

  @override
  String get readAccessOwner => 'Ваша загрузка';

  @override
  String get readAccessPurchased => 'Куплено';

  @override
  String get readAccessNone => 'Нет доступа';

  @override
  String get eventStatusLastDay => 'Последний день!';

  @override
  String get eventStatusHappeningNow => 'Идёт сейчас';

  @override
  String get eventStatusStartsToday => 'Начинается сегодня';

  @override
  String get eventStatusStartsTomorrow => 'Начинается завтра';

  @override
  String eventStatusStartsInDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Начинается через $days дней',
      many: 'Начинается через $days дней',
      few: 'Начинается через $days дня',
      one: 'Начинается через 1 день',
    );
    return '$_temp0';
  }

  @override
  String get spiceLevelNone => 'Без пикантности';

  @override
  String get spiceLevelMild => 'Слегка пикантно';

  @override
  String get spiceLevelMedium => 'Умеренно пикантно';

  @override
  String get spiceLevelHot => 'Горячо';

  @override
  String get spiceLevelScorching => 'Обжигающе';

  @override
  String get languageLevelClean => 'Без ненормативной лексики';

  @override
  String get languageLevelMild => 'Мягкая лексика';

  @override
  String get languageLevelModerate => 'Умеренная лексика';

  @override
  String get languageLevelStrong => 'Грубая лексика';

  @override
  String get homeHeadline => 'Stuff With Fantasy';

  @override
  String get homeTagline => 'Ваш компаньон в мире фэнтези.';

  @override
  String get homeSubtitle =>
      'Открывайте, отслеживайте и делитесь любимыми книгами фэнтези.';

  @override
  String get homeChipMaterial3 => 'Material 3';

  @override
  String get homeChipStructuredStarter => 'Структурированный шаблон';

  @override
  String get homeChipWidgetTests => 'Тесты виджетов';

  @override
  String get homeCardWhatIsReadyTitle => 'Что уже готово';

  @override
  String get homeCardWhatIsReadyItem1 =>
      'Брендированная оболочка приложения со светлой и тёмной темами.';

  @override
  String get homeCardWhatIsReadyItem2 =>
      'Строгая базовая конфигурация анализатора на основе flutter_lints.';

  @override
  String get homeCardWhatIsReadyItem3 =>
      'Тест виджетов для проверки начального опыта.';

  @override
  String get homeCardWhereToGoNextTitle => 'Что делать дальше';

  @override
  String get homeCardWhereToGoNextItem1 =>
      'Добавляйте функции в lib/src по доменам, а не расширяйте main.dart.';

  @override
  String get homeCardWhereToGoNextItem2 =>
      'Замените заглушки ассетов, иконок и текстов.';

  @override
  String get homeCardWhereToGoNextItem3 =>
      'Запускайте flutter analyze и flutter test по мере добавления экранов.';

  @override
  String get homeGetStarted => 'Начать';

  @override
  String get homeBrowseBooks => 'Каталог книг';

  @override
  String get monthJan => 'Янв';

  @override
  String get monthFeb => 'Фев';

  @override
  String get monthMar => 'Мар';

  @override
  String get monthApr => 'Апр';

  @override
  String get monthMay => 'Май';

  @override
  String get monthJun => 'Июн';

  @override
  String get monthJul => 'Июл';

  @override
  String get monthAug => 'Авг';

  @override
  String get monthSep => 'Сен';

  @override
  String get monthOct => 'Окт';

  @override
  String get monthNov => 'Ноя';

  @override
  String get monthDec => 'Дек';

  @override
  String get profileSectionLanguage => 'Язык';

  @override
  String get languageSystemDefault => 'По умолчанию (системный)';

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
  String get profileSectionReadingChronicle => 'Хроника чтения';

  @override
  String get profileSectionReadingChronicleSubtitle =>
      'Ваш путь сквозь страницы, запечатлённый чернилами.';

  @override
  String get profileSectionTomeCounter => 'Счётчик томов';

  @override
  String get profileSectionTomeCounterSubtitle =>
      'Ваши накопленные читательские достижения.';

  @override
  String get profileSectionAchievementSigils => 'Печати достижений';

  @override
  String get profileSectionAchievementSigilsSubtitle =>
      'Вехи, выкованные упорством.';

  @override
  String chroniclePagesThisWeek(int count) {
    return '~$count страниц за неделю';
  }

  @override
  String chronicleStreak(int count) {
    return '$count-дневная серия';
  }

  @override
  String get chronicleLess => 'Меньше';

  @override
  String get chronicleMore => 'Больше';

  @override
  String get tomeCounterBooks => 'Покорённые тома';

  @override
  String get tomeCounterPages => 'Перевёрнутые страницы';

  @override
  String get tomeCounterTime => 'Время в мире';

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
  String get achievementUnlocked => 'ПОЛУЧЕНО';

  @override
  String get achievementFirstPageTitle => 'Первая страница';

  @override
  String get achievementFirstPageDesc => 'Откройте книгу и начните читать.';

  @override
  String get achievementBookwormTitle => 'Пробуждение книжного червя';

  @override
  String get achievementBookwormDesc => 'Закончите свою первую книгу.';

  @override
  String get achievementDailyRitualTitle => 'Ежедневный ритуал';

  @override
  String get achievementDailyRitualDesc => 'Читайте 3 дня подряд.';

  @override
  String get achievementPageTurnerTitle => 'Любитель страниц';

  @override
  String get achievementPageTurnerDesc => 'Прочитайте около 100 страниц.';

  @override
  String get achievementHourGlassTitle => 'Песочные часы';

  @override
  String get achievementHourGlassDesc => 'Проведите 1 час за чтением.';

  @override
  String get achievementChapterChampionTitle => 'Чемпион глав';

  @override
  String get achievementChapterChampionDesc => 'Закончите 3 книги.';

  @override
  String get achievementFlameKeeperTitle => 'Хранитель пламени';

  @override
  String get achievementFlameKeeperDesc => 'Читайте 7 дней подряд.';

  @override
  String get achievementTomeScholarTitle => 'Учёный томов';

  @override
  String get achievementTomeScholarDesc => 'Прочитайте около 1 000 страниц.';

  @override
  String get achievementDevotedReaderTitle => 'Преданный читатель';

  @override
  String get achievementDevotedReaderDesc => 'Проведите 10 часов за чтением.';

  @override
  String get achievementFiveRealmsTitle => 'Пять миров';

  @override
  String get achievementFiveRealmsDesc => 'Начните читать 5 разных книг.';

  @override
  String get achievementGrandLibrarianTitle => 'Великий библиотекарь';

  @override
  String get achievementGrandLibrarianDesc => 'Закончите 10 книг.';

  @override
  String get achievementEternalFlameTitle => 'Вечное пламя';

  @override
  String get achievementEternalFlameDesc =>
      'Поддерживайте 30-дневную серию чтения.';

  @override
  String get achievementMythicScribeTitle => 'Мифический писец';

  @override
  String get achievementMythicScribeDesc => 'Проведите 100 часов за чтением.';

  @override
  String get achievementRealmWalkerTitle => 'Странник миров';

  @override
  String get achievementRealmWalkerDesc => 'Начните читать 10 разных книг.';

  @override
  String get oathAppBarTitle => 'Камень клятв';

  @override
  String get oathSectionTitle => 'Камень клятв';

  @override
  String get oathSectionSubtitle => 'Ваш торжественный читательский обет';

  @override
  String get oathSwearCta => 'Принести клятву';

  @override
  String get oathSwearSubtitle =>
      'Поставьте публичную цель чтения и отслеживайте прогресс';

  @override
  String get oathSwearPageTitle => 'Начертайте клятву';

  @override
  String get oathFieldTitle => 'Ваш обет';

  @override
  String get oathFieldTitleHint => 'Я прочитаю 24 книги в 2026 году';

  @override
  String get oathFieldTarget => 'Целевое количество книг';

  @override
  String get oathFieldYear => 'Год';

  @override
  String get oathFieldPublic => 'Публичная клятва';

  @override
  String get oathFieldPublicSubtitle => 'Видна на Доске знаний';

  @override
  String get oathSwearButton => 'Принести эту клятву';

  @override
  String get oathSwearing => 'Начертание...';

  @override
  String oathProgressLabel(int current, int target) {
    return '$current из $target';
  }

  @override
  String get oathProgressComplete => 'Клятва исполнена!';

  @override
  String get oathEntryLogged => 'Руна выгравирована!';

  @override
  String get oathEntryRemoved => 'Запись удалена';

  @override
  String get oathDeleteConfirmTitle => 'Нарушить клятву?';

  @override
  String get oathDeleteConfirmBody =>
      'Это навсегда удалит вашу клятву и все записанные данные.';

  @override
  String get oathDeleteCancel => 'Сохранить клятву';

  @override
  String get oathDeleteConfirm => 'Нарушить клятву';

  @override
  String get oathDeleted => 'Клятва нарушена';

  @override
  String get oathCompleteTitle => 'КЛЯТВА ИСПОЛНЕНА';

  @override
  String get oathCompleteHeadline => 'Ваша клятва запечатана';

  @override
  String get oathCompleteBody => 'Вы сдержали обет. Руны завершены.';

  @override
  String get oathCompleteContinue => 'Продолжить';

  @override
  String get oathEmptyEntries => 'Книги ещё не записаны';

  @override
  String get oathLogBookAction => 'Записать в клятву';

  @override
  String oathLogBookConfirm(String title) {
    return 'Записать «$title» в вашу клятву?';
  }

  @override
  String get oathLogBookButton => 'Записать';

  @override
  String get oathAlreadyLogged => 'Уже записано в клятву';

  @override
  String get oathEditButton => 'Изменить клятву';

  @override
  String get oathUpdated => 'Клятва обновлена';

  @override
  String get oathErrorCreate => 'Не удалось создать клятву';

  @override
  String get oathErrorLoad => 'Не удалось загрузить клятву';

  @override
  String get oathGuestHeadline => 'Камень клятв ждёт';

  @override
  String get oathGuestBody =>
      'Создайте аккаунт, чтобы принести читательскую клятву и отслеживать прогресс.';

  @override
  String get seasonalCampaignLabel => 'Сезонная кампания';

  @override
  String get seasonalCampaignExpired => 'Экспедиция завершена';

  @override
  String get seasonalCampaignLastDay => 'Последний день!';

  @override
  String seasonalCampaignCountdownDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Осталось $days дней',
      many: 'Осталось $days дней',
      few: 'Осталось $days дня',
      one: 'Остался 1 день',
    );
    return '$_temp0';
  }

  @override
  String seasonalCampaignCountdownMonths(int months) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: 'Осталось $months месяцев',
      many: 'Осталось $months месяцев',
      few: 'Осталось $months месяца',
      one: 'Остался 1 месяц',
    );
    return '$_temp0';
  }

  @override
  String seasonalCampaignCountdownMonthsDays(int months, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: '$months месяцев',
      many: '$months месяцев',
      few: '$months месяца',
      one: '1 месяц',
    );
    String _temp1 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'осталось $days дней',
      many: 'осталось $days дней',
      few: 'осталось $days дня',
      one: 'остался 1 день',
    );
    return '$_temp0, $_temp1';
  }

  @override
  String get seasonalRelicSectionTitle => 'Сезонные реликвии';

  @override
  String get profileSectionSeasonalQuests => 'Сезонные квесты';

  @override
  String get profileSectionSeasonalQuestsSubtitle =>
      'Ограниченные по времени экспедиции с эксклюзивными реликвиями.';

  @override
  String get realmRankingsTitle => 'Рейтинг мира';

  @override
  String get leaderboardMetricQuests => 'Квесты';

  @override
  String get leaderboardMetricBooks => 'Книги';

  @override
  String get leaderboardMetricRelics => 'Реликвии';

  @override
  String leaderboardTotalParticipants(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count искателей приключений в рейтинге',
      many: '$count искателей приключений в рейтинге',
      few: '$count искателя приключений в рейтинге',
      one: '1 искатель приключений в рейтинге',
    );
    return '$_temp0';
  }

  @override
  String get leaderboardYourPosition => 'ВАША ПОЗИЦИЯ';

  @override
  String leaderboardPositionOfTotal(int position, int total) {
    return '#$position из $total';
  }

  @override
  String get leaderboardErrorHeadline => 'Не удалось загрузить рейтинг';

  @override
  String get leaderboardOptInTitle => 'Рейтинг мира';

  @override
  String get leaderboardOptInDescription =>
      'Соревнуйтесь с другими искателями приключений, присоединившись к рейтингу мира. Ваш рейтинг основан на завершённых квестах, прочитанных книгах и собранных реликвиях.';

  @override
  String get leaderboardOptInPrivacy => 'Другим видны только ваше имя и ранг.';

  @override
  String get leaderboardOptInActive => 'Участвует в рейтинге';

  @override
  String get leaderboardOptInInactive => 'Не в рейтинге';

  @override
  String get leaderboardOptInJoinButton => 'Присоединиться к рейтингу';

  @override
  String get leaderboardOptInLeaveButton => 'Покинуть рейтинг';

  @override
  String get characterSheetStatRealmRank => 'Мир';

  @override
  String get characterSheetRealmRankJoin => 'Вступить в рейтинг';

  @override
  String get skillTreeSectionTitle => 'Древо навыков';

  @override
  String get skillTreeSectionSubtitle =>
      'Развивайте мастерство жанров через чтение.';

  @override
  String skillTreeXpProgress(int current, int next) {
    return '$current / $next XP';
  }

  @override
  String skillTreeXpLabel(int xp) {
    return '$xp XP';
  }

  @override
  String get skillTreeTiersLabel => 'Уровни';

  @override
  String get skillTreeTierUnlocked => 'ОТКРЫТ';

  @override
  String get skillTreeTierCurrent => 'В ПРОЦЕССЕ';

  @override
  String get skillTreeTierLocked => 'ЗАБЛОКИРОВАН';

  @override
  String skillTreeRuneUnlocked(String runeTitle) {
    return 'Руна открыта: $runeTitle';
  }

  @override
  String skillTreeRuneLockedAt(String runeTitle) {
    return 'Откроется: $runeTitle';
  }

  @override
  String get loreBoardTitle => 'Доска знаний';

  @override
  String get loreBoardGlobalTab => 'Глобально';

  @override
  String get loreBoardFriendsTab => 'Друзья';

  @override
  String get loreBoardEmpty =>
      'Доска пуста... ещё ни одной истории не опубликовано.';

  @override
  String get loreBoardTooltip => 'Доска знаний';

  @override
  String get guildHubTitle => 'Гильдейский зал';

  @override
  String get guildHubEmpty =>
      'Вы ещё не вступили ни в одну гильдию. Основайте свою или найдите существующие.';

  @override
  String get guildCreateButton => 'Основать гильдию';

  @override
  String get guildDiscoverButton => 'Найти гильдии';

  @override
  String get guildDetailCompanions => 'Соратники';

  @override
  String get guildDetailLedger => 'Книга гильдии';

  @override
  String get guildDetailLedgerEmpty => 'В книге гильдии пока нет записей.';

  @override
  String get guildJoinButton => 'Вступить в гильдию';

  @override
  String get guildJoined => 'Вы вступили в гильдию!';

  @override
  String get guildLeaveButton => 'Покинуть гильдию';

  @override
  String get guildLeft => 'Вы покинули гильдию.';

  @override
  String get guildDeleteConfirmTitle => 'Распустить гильдию?';

  @override
  String get guildDeleteConfirmBody =>
      'Это навсегда удалит гильдию и все её данные. Это действие нельзя отменить.';

  @override
  String get guildDeleteCancel => 'Сохранить гильдию';

  @override
  String get guildDeleteConfirm => 'Распустить гильдию';

  @override
  String get guildDeleted => 'Гильдия распущена';

  @override
  String get guildCreated => 'Гильдия основана!';

  @override
  String get guildUpdated => 'Гильдия обновлена';

  @override
  String get guildCreatePageTitle => 'Основать гильдию';

  @override
  String get guildFieldName => 'Название гильдии';

  @override
  String get guildFieldNameHint => 'Братство страниц';

  @override
  String get guildFieldDescription => 'Описание';

  @override
  String get guildFieldDescriptionHint => 'Чем занимается ваша гильдия?';

  @override
  String get guildFieldPublic => 'Публичная гильдия';

  @override
  String get guildFieldPublicSubtitle =>
      'Видна на Доске гильдий — любой может вступить';

  @override
  String get guildCreateSubmit => 'Основать гильдию';

  @override
  String get guildCreating => 'Основание...';

  @override
  String get guildDiscoverTitle => 'Доска гильдий';

  @override
  String get guildDiscoverEmpty => 'Гильдий пока нет.';

  @override
  String guildMemberCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count соратников',
      many: '$count соратников',
      few: '$count соратника',
      one: '1 соратник',
    );
    return '$_temp0';
  }

  @override
  String get guildRoleGuildmaster => 'Глава гильдии';

  @override
  String get guildRoleCompanion => 'Соратник';

  @override
  String get guildGuestHeadline => 'Гильдейский зал ждёт';

  @override
  String get guildGuestBody =>
      'Создайте аккаунт, чтобы основывать гильдии, вступать в читательские отряды и вести книги вместе с другими искателями приключений.';

  @override
  String get guildAddToLedger => 'Добавить в книгу гильдии';

  @override
  String get guildBookAdded => 'Книга добавлена в книгу гильдии!';

  @override
  String get guildBookRemoved => 'Книга удалена из книги гильдии.';

  @override
  String get guildAlreadyMember => 'Вы уже состоите в этой гильдии.';
}
