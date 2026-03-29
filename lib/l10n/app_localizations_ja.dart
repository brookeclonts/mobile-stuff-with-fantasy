// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'StuffWithFantasy';

  @override
  String get bookSingular => '本';

  @override
  String get bookPlural => '本';

  @override
  String booksCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count冊',
    );
    return '$_temp0';
  }

  @override
  String get catalogSignUpPrompt => 'アカウントを作成して、読書リストに本を保存しましょう。';

  @override
  String get catalogSnackbarActionProfile => 'プロフィール';

  @override
  String get catalogTooltipLibrary => 'ライブラリ';

  @override
  String get catalogTooltipProfile => 'プロフィール';

  @override
  String get catalogFiltersUnavailable => 'タクソノミーの読み込みが完了するまでフィルターは利用できません。';

  @override
  String get catalogRetry => '再試行';

  @override
  String get catalogEmptyFiltered => 'フィルター条件に一致する本がありません';

  @override
  String get catalogEmptyNoBooks => 'まだ本がありません';

  @override
  String get catalogClearFilters => 'フィルターをクリア';

  @override
  String get bookDetailSignUpPrompt => 'プロフィールからアカウントを作成して、読書リストに本を保存しましょう。';

  @override
  String bookDetailByAuthor(String author) {
    return '$author 著';
  }

  @override
  String get bookDetailSectionSubgenres => 'サブジャンル';

  @override
  String get bookDetailSectionTropes => 'トロープ';

  @override
  String get bookDetailSectionRepresentation => 'レプリゼンテーション';

  @override
  String get bookDetailSectionAbout => 'この本について';

  @override
  String get bookDetailReadMore => '続きを読む';

  @override
  String get bookDetailSectionSimilar => 'こちらもおすすめ';

  @override
  String get bookDetailBadgeKu => 'KU';

  @override
  String get bookDetailUpdating => '更新中...';

  @override
  String get bookDetailRemoveFromList => '読書リストから削除';

  @override
  String get bookDetailSaving => '保存中...';

  @override
  String get bookDetailSaveToList => '読書リストに保存';

  @override
  String get bookDetailOpening => '開いています...';

  @override
  String get bookDetailReadInApp => 'アプリで読む';

  @override
  String get bookDetailGetBook => 'この本を入手';

  @override
  String get bookDetailAmazon => 'Amazon US';

  @override
  String get bookDetailAllRetailers => 'すべての販売店を表示';

  @override
  String get bookDetailAudiobook => 'オーディオブック';

  @override
  String get filterSearchHint => 'タイトルまたは著者で検索...';

  @override
  String get filterChipKu => 'KU';

  @override
  String get filterChipAudiobook => 'オーディオブック';

  @override
  String get filterClearAll => 'すべてクリア';

  @override
  String get filterSheetTitle => 'フィルター';

  @override
  String get filterSheetReset => 'リセット';

  @override
  String get filterSheetSubgenres => 'サブジャンル';

  @override
  String get filterSheetTropes => 'トロープ';

  @override
  String get filterSheetSpiceLevel => 'スパイスレベル';

  @override
  String get filterSheetAgeCategory => '年齢カテゴリー';

  @override
  String get filterSheetRepresentation => 'レプリゼンテーション';

  @override
  String get filterSheetLanguageLevel => '言語レベル';

  @override
  String filterSheetApplyWithCount(int count) {
    return 'フィルターを適用（$count）';
  }

  @override
  String get filterSheetApply => 'フィルターを適用';

  @override
  String get signUpSkip => 'スキップ';

  @override
  String get rolePickerHeadline => '私は...';

  @override
  String get rolePickerSubtitle => 'StuffWithFantasyの使い方を選んでください';

  @override
  String get rolePickerContinue => '続ける';

  @override
  String get interestStepHeadline => '他に何がきっかけで来ましたか？';

  @override
  String get interestStepSubtitle => '該当するものを選択するか、スキップしてください。';

  @override
  String get interestCardAuthorTitle => '著者です';

  @override
  String get interestCardAuthorDescription => 'ファンタジー読者に自分の本を見つけてもらいたいです。';

  @override
  String get interestCardInfluencerTitle => 'インフルエンサーです';

  @override
  String get interestCardInfluencerDescription =>
      'コンテンツを作成し、ファンタジー本を視聴者と共有したいです。';

  @override
  String get interestStepContinue => '続ける';

  @override
  String get signUpFormHeadline => 'アカウントを作成';

  @override
  String get signUpFormSubtitle => '少しの情報で登録完了です';

  @override
  String get signUpFieldNameLabel => '表示名';

  @override
  String get signUpFieldNameHint => 'なんとお呼びしますか？';

  @override
  String get signUpValidatorEnterName => '名前を入力してください';

  @override
  String get signUpFieldEmailLabel => 'メールアドレス';

  @override
  String get signUpFieldEmailHint => 'you@example.com';

  @override
  String get signUpValidatorEnterEmail => 'メールアドレスを入力してください';

  @override
  String get signUpValidatorInvalidEmail => '有効なメールアドレスを入力してください';

  @override
  String get signUpFieldPasswordLabel => 'パスワード';

  @override
  String get signUpFieldPasswordHint => '8文字以上';

  @override
  String get signUpValidatorEnterPassword => 'パスワードを入力してください';

  @override
  String get signUpValidatorPasswordTooShort => '8文字以上で入力してください';

  @override
  String get signUpButtonCreateAccount => 'アカウントを作成';

  @override
  String welcomeStepHeadline(String name) {
    return 'ようこそ、$nameさん！';
  }

  @override
  String get welcomeStepSubtitle => '次の素晴らしいファンタジーの冒険があなたを待っています。';

  @override
  String get welcomeStepGetStarted => 'はじめる';

  @override
  String get profileUnknownRank => '不明なランク';

  @override
  String get profileAppBarTitle => 'ギルドホール';

  @override
  String get profileSectionRunes => 'ルーン';

  @override
  String get profileSectionRunesSubtitle => 'クエストを封印してアビリティルーンを刻みましょう。';

  @override
  String get profileSectionQuestLog => 'クエストログ';

  @override
  String get profileSectionQuestLogSubtitle => '巻物を開いて目標を追跡し、封印しましょう。';

  @override
  String get profileSectionRelicVault => 'レリック保管庫';

  @override
  String get profileSectionRelicVaultSubtitle => '巻物を封印して保管庫のレリックを獲得しましょう。';

  @override
  String get profileSectionCharacterSheet => 'キャラクターシート';

  @override
  String get profileSnackbarRuneComingSoon => 'このルーンは近日中に設定可能になります。';

  @override
  String get profileDeleteAccountTitle => 'アカウントを削除';

  @override
  String get profileDeleteAccountBody =>
      'アカウントと関連するすべてのデータが完全に削除されます。この操作は取り消せません。';

  @override
  String get profileDeleteCancel => 'キャンセル';

  @override
  String get profileDeleteConfirm => '削除';

  @override
  String get profileSigningOut => '世界から退出中...';

  @override
  String get profileSignOut => '世界から退出';

  @override
  String get profileDeletingAccount => 'アカウントを削除中...';

  @override
  String get profileDeleteAccount => 'アカウントを削除';

  @override
  String get profileRetry => '再試行';

  @override
  String get profileErrorHeadline => 'クエストボードの読み込みに失敗しました';

  @override
  String get profileTryAgain => 'もう一度試す';

  @override
  String get guestGuildHallLabel => 'ギルドホール';

  @override
  String get guestGuildHeadline => '冒険を始めよう';

  @override
  String get guestGuildBody =>
      'アカウントを作成して、読書クエストの追跡、アビリティルーンの解放、レリックの収集をしながら世界を探索しましょう。';

  @override
  String get guestGuildButtonCreateAccount => 'アカウントを作成して始める';

  @override
  String get runeStatusEngraved => '刻印済み';

  @override
  String get runeStatusLocked => '封印中';

  @override
  String get runeDetailLockedHint => '関連クエストを完了してこのルーンを刻印しましょう';

  @override
  String get runeDetailConfigure => '設定';

  @override
  String get arcShieldTitle => 'ARCシールド';

  @override
  String get arcShieldDescription => '有効にすると、著者や出版社がARCリーダーとしてあなたを見つけられます。';

  @override
  String get arcShieldSectionAvailability => '受付状況';

  @override
  String get arcShieldToggleOpenLabel => 'ARC受付中';

  @override
  String get arcShieldToggleClosedLabel => 'ARC受付停止中';

  @override
  String get arcShieldToggleOpenSubtitle => '著者からの連絡を受け付けます';

  @override
  String get arcShieldToggleClosedSubtitle => 'ARC検索からプロフィールが非表示になります';

  @override
  String get genreAttunementTitle => 'ジャンル適性';

  @override
  String get genreAttunementDescription =>
      '惹かれるジャンルやトロープを選択してください。世界があなたに合ったものを提示します。';

  @override
  String get genreAttunementSectionGenres => 'ジャンル';

  @override
  String get genreAttunementSectionTropes => 'トロープ';

  @override
  String genreAttunementCountAttuned(int count) {
    return '$count件適性済み';
  }

  @override
  String get genreEpicFantasy => 'エピックファンタジー';

  @override
  String get genreDarkFantasy => 'ダークファンタジー';

  @override
  String get genreUrbanFantasy => 'アーバンファンタジー';

  @override
  String get genreRomantasy => 'ロマンタジー';

  @override
  String get genreCozyFantasy => 'コージーファンタジー';

  @override
  String get genreGrimdark => 'グリムダーク';

  @override
  String get genreLitRpg => 'LitRPG';

  @override
  String get genreSwordAndSorcery => 'ソード＆ソーサリー';

  @override
  String get genreMythicFantasy => '神話ファンタジー';

  @override
  String get genrePortalFantasy => '異世界ファンタジー';

  @override
  String get tropeFoundFamily => '疑似家族';

  @override
  String get tropeEnemiesToLovers => '敵から恋人へ';

  @override
  String get tropeChosenOne => '選ばれし者';

  @override
  String get tropeMagicSchools => '魔法学校';

  @override
  String get tropeMorallyGrey => 'モラルグレー';

  @override
  String get tropeSlowBurn => 'スローバーン';

  @override
  String get tropePoliticalIntrigue => '政治的陰謀';

  @override
  String get tropeQuestJourney => '冒険の旅';

  @override
  String get tropeHiddenRoyalty => '隠された王族';

  @override
  String get tropeRevengeArc => '復讐劇';

  @override
  String get eventWatchtowerTitle => 'イベント物見塔';

  @override
  String get eventWatchtowerDescription => '世界からどの通知を受け取るか選択してください。';

  @override
  String get eventWatchtowerSectionSignals => '通知シグナル';

  @override
  String get notifNewEventsTitle => '新着イベント';

  @override
  String get notifNewEventsDescription => 'Stuff Your Kindleイベントの開始時';

  @override
  String get notifBookDropsTitle => '新着ブック';

  @override
  String get notifBookDropsDescription => 'カタログに新しい本が追加された時';

  @override
  String get notifRecommendationsTitle => 'おすすめ';

  @override
  String get notifRecommendationsDescription => '適性に基づくパーソナライズされたおすすめ';

  @override
  String get rewardRevealBarrierLabel => '報酬公開';

  @override
  String get rewardRevealLegendRelicClaimed => '伝説のレリック獲得';

  @override
  String get rewardRevealRelicUnlocked => 'レリック解放';

  @override
  String get rewardRevealContinue => '冒険を続ける';

  @override
  String get characterSheetHeaderLabel => 'キャラクターシート';

  @override
  String get characterSheetStatName => '名前';

  @override
  String get characterSheetStatRank => 'ランク';

  @override
  String get characterSheetStatQuests => 'クエスト';

  @override
  String characterSheetStatQuestsValue(int completed, int total) {
    return '$completed / $total';
  }

  @override
  String get characterSheetStatRelics => 'レリック';

  @override
  String characterSheetStatRelicsValue(int collected, int total) {
    return '$collected / $total';
  }

  @override
  String get characterSheetStatSignal => 'シグナル';

  @override
  String get realmMapCurrentQuest => '現在のクエスト';

  @override
  String get questScrollSealed => '封印済み';

  @override
  String get questScrollActive => '進行中';

  @override
  String get questScrollReward => '報酬';

  @override
  String get relicVaultLockedTitle => '???';

  @override
  String get relicVaultLegendRelic => '伝説のレリック';

  @override
  String get relicVaultClaimed => '獲得済み';

  @override
  String get relicVaultSealed => '封印済み';

  @override
  String get libraryAppBarTitle => 'ライブラリ';

  @override
  String get libraryTabMyBooks => 'マイブック';

  @override
  String get libraryTabReadingList => '読書リスト';

  @override
  String get libraryMyBooksSignInTitle => 'あなたの本棚が待っています';

  @override
  String get libraryMyBooksSignInMessage =>
      'サインインして、購入・獲得・アップロードした本にアクセスしましょう。すぐに読めます。';

  @override
  String get libraryMyBooksEmptyTitle => '読める本がまだありません';

  @override
  String get libraryMyBooksEmptyMessage =>
      '購入・獲得・アップロードした本は、読める状態になるとここに表示されます。';

  @override
  String get libraryReadingListSignInTitle => '読書リストを始めよう';

  @override
  String get libraryReadingListSignInMessage =>
      'サインインしてカタログから本を保存し、自分だけの読書リストを作りましょう。';

  @override
  String get libraryReadingListEmptyTitle => 'まだ保存した本がありません';

  @override
  String get libraryReadingListEmptyMessage => 'カタログから本を保存して読書リストを作りましょう。';

  @override
  String get libraryButtonSignIn => 'サインイン';

  @override
  String get libraryRetry => '再試行';

  @override
  String readerProgressRead(String progress) {
    return '$progress 読了';
  }

  @override
  String get readerHintSwipeToTurn => 'スワイプでページをめくります';

  @override
  String get readerHintOpeningBook => '本を開いています…';

  @override
  String get readerHintTapToHide => '中央をタップして操作パネルを非表示';

  @override
  String get readerTooltipBack => '戻る';

  @override
  String get readerTooltipChapters => '章';

  @override
  String get readerTooltipReadingSettings => '読書設定';

  @override
  String get readerTooltipPreviousPage => '前のページ';

  @override
  String get readerButtonPrev => '前へ';

  @override
  String get readerTooltipNextPage => '次のページ';

  @override
  String get readerButtonNext => '次へ';

  @override
  String get readerChaptersTitle => '章';

  @override
  String get readerSettingsTitle => '読書設定';

  @override
  String get readerSettingsTextSize => '文字サイズ';

  @override
  String get readerTooltipSmallerText => '文字を小さく';

  @override
  String readerFontSizeLabel(int size) {
    return '$size pt';
  }

  @override
  String get readerTooltipLargerText => '文字を大きく';

  @override
  String get readerSettingsPageTheme => 'ページテーマ';

  @override
  String get readerAppearancePaper => 'ペーパー';

  @override
  String get readerAppearanceSepia => 'セピア';

  @override
  String get readerAppearanceNight => 'ナイト';

  @override
  String get eventDetailLoadingBooks => '本を読み込み中...';

  @override
  String eventDetailBookCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'このイベントには$count冊の本があります',
    );
    return '$_temp0';
  }

  @override
  String get eventDetailNoBooksYet => 'このイベントにはまだ本がありません。';

  @override
  String get creatorDetailNoBooksYet => '表示できる本がまだありません。';

  @override
  String get creatorDetailFavoriteBookLabel => 'お気に入りの本：';

  @override
  String get creatorDetailLovesLabel => '好きなもの：';

  @override
  String creatorDetailBooksBy(String name) {
    return '$nameの本';
  }

  @override
  String creatorDetailRecommendedBy(String name) {
    return '$nameのおすすめ';
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
  String get socialLinkWebsite => 'ウェブサイト';

  @override
  String get userRoleReader => '読者';

  @override
  String get userRoleReaderDescription => '次のお気に入りのファンタジー本を見つけよう';

  @override
  String get creatorRoleAuthor => '著者';

  @override
  String get creatorRoleInfluencer => 'インフルエンサー';

  @override
  String get readAccessOwner => 'あなたのアップロード';

  @override
  String get readAccessPurchased => '購入済み';

  @override
  String get readAccessNone => 'アクセス権なし';

  @override
  String get eventStatusLastDay => '最終日！';

  @override
  String get eventStatusHappeningNow => '開催中';

  @override
  String get eventStatusStartsToday => '本日開始';

  @override
  String get eventStatusStartsTomorrow => '明日開始';

  @override
  String eventStatusStartsInDays(int days) {
    return 'あと$days日で開始';
  }

  @override
  String get spiceLevelNone => 'スパイスなし';

  @override
  String get spiceLevelMild => 'マイルド';

  @override
  String get spiceLevelMedium => 'ミディアム';

  @override
  String get spiceLevelHot => 'ホット';

  @override
  String get spiceLevelScorching => '激辛';

  @override
  String get languageLevelClean => 'クリーン';

  @override
  String get languageLevelMild => 'マイルドな表現';

  @override
  String get languageLevelModerate => 'やや強い表現';

  @override
  String get languageLevelStrong => '強い表現';

  @override
  String get homeHeadline => 'Stuff With Fantasy';

  @override
  String get homeTagline => 'あなたのファンタジー読書パートナー。';

  @override
  String get homeSubtitle => '好きなファンタジー本を発見し、記録し、共有しよう。';

  @override
  String get homeChipMaterial3 => 'Material 3';

  @override
  String get homeChipStructuredStarter => '構造化スターター';

  @override
  String get homeChipWidgetTests => 'ウィジェットテスト';

  @override
  String get homeCardWhatIsReadyTitle => '準備できているもの';

  @override
  String get homeCardWhatIsReadyItem1 => 'ライト・ダークテーマ対応のブランドアプリシェル。';

  @override
  String get homeCardWhatIsReadyItem2 => 'flutter_lintsを使ったより厳格な解析ベースライン。';

  @override
  String get homeCardWhatIsReadyItem3 => 'スターター体験を保護するウィジェットテスト。';

  @override
  String get homeCardWhereToGoNextTitle => '次のステップ';

  @override
  String get homeCardWhereToGoNextItem1 =>
      'main.dartを拡大するのではなく、lib/src配下にドメインごとに機能を追加。';

  @override
  String get homeCardWhereToGoNextItem2 =>
      'プレースホルダーアセット、ランチャーアイコン、プロダクトコピーを差し替え。';

  @override
  String get homeCardWhereToGoNextItem3 =>
      '画面を追加するたびにflutter analyzeとflutter testを実行。';

  @override
  String get homeGetStarted => 'はじめる';

  @override
  String get homeBrowseBooks => '本を探す';

  @override
  String get monthJan => '1月';

  @override
  String get monthFeb => '2月';

  @override
  String get monthMar => '3月';

  @override
  String get monthApr => '4月';

  @override
  String get monthMay => '5月';

  @override
  String get monthJun => '6月';

  @override
  String get monthJul => '7月';

  @override
  String get monthAug => '8月';

  @override
  String get monthSep => '9月';

  @override
  String get monthOct => '10月';

  @override
  String get monthNov => '11月';

  @override
  String get monthDec => '12月';

  @override
  String get profileSectionLanguage => '言語';

  @override
  String get languageSystemDefault => 'システムのデフォルト';

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
  String get profileSectionReadingChronicle => '読書クロニクル';

  @override
  String get profileSectionReadingChronicleSubtitle => 'ページを巡るあなたの旅路を記録。';

  @override
  String get profileSectionTomeCounter => 'トームカウンター';

  @override
  String get profileSectionTomeCounterSubtitle => '積み重ねた読書の功績。';

  @override
  String get profileSectionAchievementSigils => '実績シギル';

  @override
  String get profileSectionAchievementSigilsSubtitle => '献身によって鍛えられたマイルストーン。';

  @override
  String chroniclePagesThisWeek(int count) {
    return '今週 約$countページ';
  }

  @override
  String chronicleStreak(int count) {
    return '$count日連続';
  }

  @override
  String get chronicleLess => '少ない';

  @override
  String get chronicleMore => '多い';

  @override
  String get tomeCounterBooks => '征服したトーム';

  @override
  String get tomeCounterPages => 'めくったページ';

  @override
  String get tomeCounterTime => '世界での滞在時間';

  @override
  String tomeCounterHoursMinutes(int hours, int minutes) {
    return '$hours時間$minutes分';
  }

  @override
  String tomeCounterMinutes(int minutes) {
    return '$minutes分';
  }

  @override
  String get achievementLocked => '封印中';

  @override
  String get achievementUnlocked => '獲得済み';

  @override
  String get achievementFirstPageTitle => '最初の一ページ';

  @override
  String get achievementFirstPageDesc => '本を開いて読み始めましょう。';

  @override
  String get achievementBookwormTitle => '本の虫の目覚め';

  @override
  String get achievementBookwormDesc => '最初の本を読了しましょう。';

  @override
  String get achievementDailyRitualTitle => '日課の読書';

  @override
  String get achievementDailyRitualDesc => '3日連続で読書しましょう。';

  @override
  String get achievementPageTurnerTitle => 'ページターナー';

  @override
  String get achievementPageTurnerDesc => '約100ページ読みましょう。';

  @override
  String get achievementHourGlassTitle => '砂時計';

  @override
  String get achievementHourGlassDesc => '1時間読書しましょう。';

  @override
  String get achievementChapterChampionTitle => '章の覇者';

  @override
  String get achievementChapterChampionDesc => '3冊の本を読了しましょう。';

  @override
  String get achievementFlameKeeperTitle => '炎の守護者';

  @override
  String get achievementFlameKeeperDesc => '7日連続で読書しましょう。';

  @override
  String get achievementTomeScholarTitle => 'トームの学者';

  @override
  String get achievementTomeScholarDesc => '約1,000ページ読みましょう。';

  @override
  String get achievementDevotedReaderTitle => '献身的な読者';

  @override
  String get achievementDevotedReaderDesc => '10時間読書しましょう。';

  @override
  String get achievementFiveRealmsTitle => '五つの世界';

  @override
  String get achievementFiveRealmsDesc => '5冊の異なる本を読み始めましょう。';

  @override
  String get achievementGrandLibrarianTitle => '大図書館長';

  @override
  String get achievementGrandLibrarianDesc => '10冊の本を読了しましょう。';

  @override
  String get achievementEternalFlameTitle => '永遠の炎';

  @override
  String get achievementEternalFlameDesc => '30日間の読書連続記録を維持しましょう。';

  @override
  String get achievementMythicScribeTitle => '神話の書記';

  @override
  String get achievementMythicScribeDesc => '100時間読書しましょう。';

  @override
  String get achievementRealmWalkerTitle => '世界渡り';

  @override
  String get achievementRealmWalkerDesc => '10冊の異なる本を読み始めましょう。';

  @override
  String get oathAppBarTitle => '誓いの石';

  @override
  String get oathSectionTitle => '誓いの石';

  @override
  String get oathSectionSubtitle => 'あなたが誓った読書の約束';

  @override
  String get oathSwearCta => '誓いを立てる';

  @override
  String get oathSwearSubtitle => '公開読書目標を設定して進捗を追跡しましょう';

  @override
  String get oathSwearPageTitle => '誓いを刻む';

  @override
  String get oathFieldTitle => 'あなたの誓い';

  @override
  String get oathFieldTitleHint => '2026年に24冊読みます';

  @override
  String get oathFieldTarget => '目標冊数';

  @override
  String get oathFieldYear => '年';

  @override
  String get oathFieldPublic => '公開の誓い';

  @override
  String get oathFieldPublicSubtitle => 'ロアボードに表示されます';

  @override
  String get oathSwearButton => 'この誓いを立てる';

  @override
  String get oathSwearing => '刻印中...';

  @override
  String oathProgressLabel(int current, int target) {
    return '$current / $target';
  }

  @override
  String get oathProgressComplete => '誓い達成！';

  @override
  String get oathEntryLogged => 'ルーン刻印完了！';

  @override
  String get oathEntryRemoved => 'エントリーを削除しました';

  @override
  String get oathDeleteConfirmTitle => 'この誓いを破りますか？';

  @override
  String get oathDeleteConfirmBody => '誓いとすべてのログエントリーが完全に削除されます。';

  @override
  String get oathDeleteCancel => '誓いを維持';

  @override
  String get oathDeleteConfirm => '誓いを破る';

  @override
  String get oathDeleted => '誓いが破られました';

  @override
  String get oathCompleteTitle => '誓い達成';

  @override
  String get oathCompleteHeadline => '誓いが封印されました';

  @override
  String get oathCompleteBody => 'あなたは約束を果たしました。ルーンは完成しました。';

  @override
  String get oathCompleteContinue => '続ける';

  @override
  String get oathEmptyEntries => 'まだ記録した本がありません';

  @override
  String get oathLogBookAction => '誓いに記録';

  @override
  String oathLogBookConfirm(String title) {
    return '「$title」を誓いに記録しますか？';
  }

  @override
  String get oathLogBookButton => '記録する';

  @override
  String get oathAlreadyLogged => 'すでに誓いに記録済みです';

  @override
  String get oathEditButton => '誓いを編集';

  @override
  String get oathUpdated => '誓いを更新しました';

  @override
  String get oathErrorCreate => '誓いの作成に失敗しました';

  @override
  String get oathErrorLoad => '誓いの読み込みに失敗しました';

  @override
  String get oathGuestHeadline => '誓いの石が待っています';

  @override
  String get oathGuestBody => 'アカウントを作成して読書の誓いを立て、進捗を追跡しましょう。';

  @override
  String get seasonalCampaignLabel => 'シーズンキャンペーン';

  @override
  String get seasonalCampaignExpired => '遠征終了';

  @override
  String get seasonalCampaignLastDay => '最終日！';

  @override
  String seasonalCampaignCountdownDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '残り$days日',
    );
    return '$_temp0';
  }

  @override
  String seasonalCampaignCountdownMonths(int months) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: '残り$monthsヶ月',
    );
    return '$_temp0';
  }

  @override
  String seasonalCampaignCountdownMonthsDays(int months, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: '$monthsヶ月',
    );
    String _temp1 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'と$days日残り',
    );
    return '$_temp0$_temp1';
  }

  @override
  String get seasonalRelicSectionTitle => 'シーズンレリック';

  @override
  String get profileSectionSeasonalQuests => 'シーズンクエスト';

  @override
  String get profileSectionSeasonalQuestsSubtitle => '限定レリック付きの期間限定遠征。';

  @override
  String get realmRankingsTitle => '世界ランキング';

  @override
  String get leaderboardMetricQuests => 'クエスト';

  @override
  String get leaderboardMetricBooks => 'ブック';

  @override
  String get leaderboardMetricRelics => 'レリック';

  @override
  String leaderboardTotalParticipants(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count人の冒険者がランクイン',
    );
    return '$_temp0';
  }

  @override
  String get leaderboardYourPosition => 'あなたの順位';

  @override
  String leaderboardPositionOfTotal(int position, int total) {
    return '#$position / $total';
  }

  @override
  String get leaderboardErrorHeadline => 'ランキングの読み込みに失敗しました';

  @override
  String get leaderboardOptInTitle => '世界ランキング';

  @override
  String get leaderboardOptInDescription =>
      '世界のリーダーボードに参加して、他の冒険者と競い合いましょう。ランキングは封印したクエスト、読んだ本、収集したレリックに基づきます。';

  @override
  String get leaderboardOptInPrivacy => '表示名とランクのみが他のプレイヤーに公開されます。';

  @override
  String get leaderboardOptInActive => '世界にランクイン中';

  @override
  String get leaderboardOptInInactive => 'ランク外';

  @override
  String get leaderboardOptInJoinButton => 'ランキングに参加';

  @override
  String get leaderboardOptInLeaveButton => 'ランキングから脱退';

  @override
  String get characterSheetStatRealmRank => '世界';

  @override
  String get characterSheetRealmRankJoin => 'ランキングに参加';

  @override
  String get skillTreeSectionTitle => 'スキルツリー';

  @override
  String get skillTreeSectionSubtitle => '読書を通じてジャンルの熟練度を高めよう。';

  @override
  String skillTreeXpProgress(int current, int next) {
    return '$current / $next XP';
  }

  @override
  String skillTreeXpLabel(int xp) {
    return '$xp XP';
  }

  @override
  String get skillTreeTiersLabel => 'ティア';

  @override
  String get skillTreeTierUnlocked => '解放済み';

  @override
  String get skillTreeTierCurrent => '進行中';

  @override
  String get skillTreeTierLocked => '封印中';

  @override
  String skillTreeRuneUnlocked(String runeTitle) {
    return 'ルーン解放：$runeTitle';
  }

  @override
  String skillTreeRuneLockedAt(String runeTitle) {
    return '解放条件：$runeTitle';
  }

  @override
  String get loreBoardTitle => 'ロアボード';

  @override
  String get loreBoardGlobalTab => 'グローバル';

  @override
  String get loreBoardFriendsTab => 'フレンド';

  @override
  String get loreBoardEmpty => 'ボードはまだ空です...まだ物語が投稿されていません。';

  @override
  String get loreBoardTooltip => 'ロアボード';

  @override
  String get guildHubTitle => 'ギルドホール';

  @override
  String get guildHubEmpty => 'まだギルドに参加していません。自分でギルドを設立するか、既存のギルドを探しましょう。';

  @override
  String get guildCreateButton => '新しいギルドを設立';

  @override
  String get guildDiscoverButton => 'ギルドを探す';

  @override
  String get guildDetailCompanions => '仲間';

  @override
  String get guildDetailLedger => 'パーティー台帳';

  @override
  String get guildDetailLedgerEmpty => '台帳にはまだ本がありません。';

  @override
  String get guildJoinButton => 'ギルドに参加';

  @override
  String get guildJoined => 'ギルドに参加しました！';

  @override
  String get guildLeaveButton => 'ギルドを脱退';

  @override
  String get guildLeft => 'ギルドを脱退しました。';

  @override
  String get guildDeleteConfirmTitle => 'このギルドを解散しますか？';

  @override
  String get guildDeleteConfirmBody => 'ギルドとすべてのデータが完全に削除されます。この操作は取り消せません。';

  @override
  String get guildDeleteCancel => 'ギルドを維持';

  @override
  String get guildDeleteConfirm => 'ギルドを解散';

  @override
  String get guildDeleted => 'ギルドが解散されました';

  @override
  String get guildCreated => 'ギルド設立！';

  @override
  String get guildUpdated => 'ギルドを更新しました';

  @override
  String get guildCreatePageTitle => 'ギルドを設立';

  @override
  String get guildFieldName => 'ギルド名';

  @override
  String get guildFieldNameHint => 'ページの仲間たち';

  @override
  String get guildFieldDescription => '説明';

  @override
  String get guildFieldDescriptionHint => 'あなたのギルドについて教えてください';

  @override
  String get guildFieldPublic => '公開ギルド';

  @override
  String get guildFieldPublicSubtitle => 'ギルドボードに表示され、誰でも参加可能';

  @override
  String get guildCreateSubmit => 'このギルドを設立';

  @override
  String get guildCreating => '設立中...';

  @override
  String get guildDiscoverTitle => 'ギルドボード';

  @override
  String get guildDiscoverEmpty => 'まだ見つかるギルドがありません。';

  @override
  String guildMemberCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count人の仲間',
    );
    return '$_temp0';
  }

  @override
  String get guildRoleGuildmaster => 'ギルドマスター';

  @override
  String get guildRoleCompanion => '仲間';

  @override
  String get guildGuestHeadline => 'ギルドホールが待っています';

  @override
  String get guildGuestBody =>
      'アカウントを作成して、ギルドの設立、読書パーティーへの参加、仲間との台帳づくりを始めましょう。';

  @override
  String get guildAddToLedger => '台帳に追加';

  @override
  String get guildBookAdded => '本を台帳に追加しました！';

  @override
  String get guildBookRemoved => '本を台帳から削除しました。';

  @override
  String get guildAlreadyMember => 'すでにこのギルドのメンバーです。';
}
