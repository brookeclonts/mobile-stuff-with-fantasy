import 'package:swf_app/src/api/api_client.dart';
import 'package:swf_app/src/api/api_result.dart';
import 'package:swf_app/src/profile/models/leaderboard.dart';

/// Repository for fetching leaderboard data and managing opt-in state.
class LeaderboardRepository {
  LeaderboardRepository({required ApiClient apiClient}) : _api = apiClient;

  final ApiClient _api;

  /// Fetch a page of leaderboard rankings for the given [metric].
  Future<ApiResult<LeaderboardPage>> fetchLeaderboard({
    LeaderboardMetric metric = LeaderboardMetric.questsSealed,
    int page = 1,
    int limit = 50,
  }) {
    return _api.get<LeaderboardPage>(
      '/api/leaderboard',
      fromJson: LeaderboardPage.fromJson,
      queryParams: {
        'metric': metric.name,
        'page': page.toString(),
        'limit': limit.toString(),
      },
    );
  }

  /// Opt the current user in to the leaderboard.
  Future<ApiResult<bool>> optIn() {
    return _api.post<bool>(
      '/api/profile/leaderboard/opt-in',
      fromJson: (json) {
        if (json is Map<String, dynamic>) {
          return json['leaderboardOptIn'] as bool? ?? true;
        }
        return true;
      },
    );
  }

  /// Opt the current user out of the leaderboard.
  Future<ApiResult<bool>> optOut() {
    return _api.delete<bool>(
      '/api/profile/leaderboard/opt-in',
      fromJson: (json) {
        if (json is Map<String, dynamic>) {
          return json['leaderboardOptIn'] as bool? ?? false;
        }
        return false;
      },
    );
  }
}
