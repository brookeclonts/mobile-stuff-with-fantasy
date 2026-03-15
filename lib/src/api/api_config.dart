/// API environment configuration.
///
/// The base URL determines which backend the app talks to.
/// In production this should come from a build-time env variable
/// or a remote config service.
abstract final class ApiConfig {
  /// Override this at startup or via `--dart-define=API_BASE_URL=...`
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://stuffwithfantasy.com',
  );
}
