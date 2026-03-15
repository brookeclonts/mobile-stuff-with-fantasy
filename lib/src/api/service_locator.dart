import 'package:swf_app/src/api/api_client.dart';
import 'package:swf_app/src/api/api_config.dart';
import 'package:swf_app/src/catalog/data/book_repository.dart';

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

  static ApiClient get apiClient => _apiClient;
  static BookRepository get bookRepository => _bookRepository;

  /// Initialize all shared services. Call from `main()` before `runApp`.
  static void init({String? baseUrl}) {
    _apiClient = ApiClient(baseUrl: baseUrl ?? ApiConfig.baseUrl);
    _bookRepository = BookRepository(apiClient: _apiClient);
  }

  /// Tear down. Useful in tests.
  static void dispose() {
    _apiClient.dispose();
  }
}
