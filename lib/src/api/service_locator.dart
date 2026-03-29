import 'package:swf_app/src/api/api_client.dart';
import 'package:swf_app/src/api/api_config.dart';
import 'package:swf_app/src/auth/data/auth_repository.dart';
import 'package:swf_app/src/auth/data/session_store.dart';
import 'package:swf_app/src/catalog/data/book_repository.dart';
import 'package:swf_app/src/creators/data/creator_repository.dart';
import 'package:swf_app/src/events/data/event_repository.dart';
import 'package:swf_app/src/profile/data/profile_repository.dart';
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
  static late final ReaderRepository _readerRepository;
  static late final ReadingListRepository _readingListRepository;

  static ApiClient get apiClient => _apiClient;
  static BookRepository get bookRepository => _bookRepository;
  static CreatorRepository get creatorRepository => _creatorRepository;
  static EventRepository get eventRepository => _eventRepository;
  static SessionStore get sessionStore => _sessionStore;
  static AuthRepository get authRepository => _authRepository;
  static ProfileRepository get profileRepository => _profileRepository;
  static ReaderRepository get readerRepository => _readerRepository;
  static ReadingListRepository get readingListRepository =>
      _readingListRepository;

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
    _readerRepository = ReaderRepository();
    _readingListRepository = ReadingListRepository(apiClient: _apiClient);
  }

  /// Tear down. Useful in tests.
  static void dispose() {
    _apiClient.dispose();
    _authRepository.dispose();
  }
}
