import 'package:swf_app/src/api/api_client.dart';
import 'package:swf_app/src/api/api_config.dart';
import 'package:swf_app/src/auth/data/auth_repository.dart';
import 'package:swf_app/src/auth/data/session_store.dart';
import 'package:swf_app/src/catalog/data/book_repository.dart';
import 'package:swf_app/src/creators/data/creator_repository.dart';
import 'package:swf_app/src/events/data/event_repository.dart';
import 'package:swf_app/src/guild/data/guild_repository.dart';
import 'package:swf_app/src/locale_provider.dart';
import 'package:swf_app/src/lore_board/data/lore_board_repository.dart';
import 'package:swf_app/src/oath/data/oath_repository.dart';
import 'package:swf_app/src/profile/data/leaderboard_repository.dart';
import 'package:swf_app/src/profile/data/preferences_provider.dart';
import 'package:swf_app/src/profile/data/profile_repository.dart';
import 'package:swf_app/src/profile/data/reading_stats_repository.dart';
import 'package:swf_app/src/profile/data/recommendation_repository.dart';
import 'package:swf_app/src/profile/data/review_repository.dart';
import 'package:swf_app/src/reader/data/local_book_repository.dart';
import 'package:swf_app/src/reader/data/reader_access_repository.dart';
import 'package:swf_app/src/reader/data/reader_repository.dart';
import 'package:swf_app/src/reader/data/reading_list_repository.dart';

/// Simple service locator for shared singletons.
///
/// Call [ServiceLocator.init] once at app startup. Access instances via
/// the static getters. This avoids pulling in a DI package while keeping
/// a single source of truth for object lifetimes.
///
/// When the app grows, swap this for `get_it`, `riverpod`, or similar.
abstract final class ServiceLocator {
  static late final ApiClient _apiClient;
  static late final BookRepository _bookRepository;
  static late final SessionStore _sessionStore;
  static late final AuthRepository _authRepository;
  static late final CreatorRepository _creatorRepository;
  static late final EventRepository _eventRepository;
  static late final ProfileRepository _profileRepository;
  static late final ReaderAccessRepository _readerAccessRepository;
  static late final ReaderRepository _readerRepository;
  static late final ReadingListRepository _readingListRepository;
  static late final LocaleProvider _localeProvider;
  static late final ReadingStatsRepository _readingStatsRepository;
  static late final ReviewRepository _reviewRepository;
  static late final OathRepository _oathRepository;
  static late final RecommendationRepository _recommendationRepository;
  static late final ProfilePreferencesProvider _preferencesProvider;
  static late final LeaderboardRepository _leaderboardRepository;
  static late final LoreBoardRepository _loreBoardRepository;
  static late final GuildRepository _guildRepository;
  static late final LocalBookRepository _localBookRepository;

  static ApiClient get apiClient => _apiClient;
  static BookRepository get bookRepository => _bookRepository;
  static CreatorRepository get creatorRepository => _creatorRepository;
  static EventRepository get eventRepository => _eventRepository;
  static SessionStore get sessionStore => _sessionStore;
  static AuthRepository get authRepository => _authRepository;
  static ProfileRepository get profileRepository => _profileRepository;
  static ReaderAccessRepository get readerAccessRepository =>
      _readerAccessRepository;
  static ReaderRepository get readerRepository => _readerRepository;
  static ReadingListRepository get readingListRepository =>
      _readingListRepository;
  static LocaleProvider get localeProvider => _localeProvider;
  static ReadingStatsRepository get readingStatsRepository =>
      _readingStatsRepository;
  static ReviewRepository get reviewRepository => _reviewRepository;
  static OathRepository get oathRepository => _oathRepository;
  static RecommendationRepository get recommendationRepository =>
      _recommendationRepository;
  static ProfilePreferencesProvider get preferencesProvider =>
      _preferencesProvider;
  static LeaderboardRepository get leaderboardRepository =>
      _leaderboardRepository;
  static LoreBoardRepository get loreBoardRepository =>
      _loreBoardRepository;
  static GuildRepository get guildRepository => _guildRepository;
  static LocalBookRepository get localBookRepository => _localBookRepository;

  /// Initialize all shared services. Call from `main()` before `runApp`.
  static void init({String? baseUrl}) {
    final resolvedBaseUrl = baseUrl ?? ApiConfig.baseUrl;
    _apiClient = ApiClient(baseUrl: resolvedBaseUrl);
    _bookRepository = BookRepository(apiClient: _apiClient);
    _creatorRepository = CreatorRepository(apiClient: _apiClient);
    _eventRepository = EventRepository(apiClient: _apiClient);
    _sessionStore = SessionStore();
    _authRepository = AuthRepository(
      baseUrl: resolvedBaseUrl,
      apiClient: _apiClient,
      sessionStore: _sessionStore,
    );
    _profileRepository = ProfileRepository(apiClient: _apiClient);
    _readerAccessRepository = ReaderAccessRepository(apiClient: _apiClient);
    _readerRepository = ReaderRepository();
    _readingListRepository = ReadingListRepository(apiClient: _apiClient);
    _localeProvider = LocaleProvider();
    _readingStatsRepository = ReadingStatsRepository();
    _reviewRepository = ReviewRepository(apiClient: _apiClient);
    _oathRepository = OathRepository(apiClient: _apiClient);
    _recommendationRepository =
        RecommendationRepository(apiClient: _apiClient);
    _preferencesProvider = ProfilePreferencesProvider();
    _leaderboardRepository = LeaderboardRepository(apiClient: _apiClient);
    _loreBoardRepository = LoreBoardRepository(apiClient: _apiClient);
    _guildRepository = GuildRepository(apiClient: _apiClient);
    _localBookRepository = LocalBookRepository();
  }

  /// Tear down. Useful in tests.
  static void dispose() {
    _apiClient.dispose();
    _authRepository.dispose();
  }
}
