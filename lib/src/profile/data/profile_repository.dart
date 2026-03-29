import 'package:swf_app/src/api/api_client.dart';
import 'package:swf_app/src/api/api_result.dart';
import 'package:swf_app/src/profile/models/gamification_state.dart';
import 'package:swf_app/src/profile/models/quest_campaign.dart';

class ProfileRepository {
  ProfileRepository({required ApiClient apiClient}) : _api = apiClient;

  final ApiClient _api;

  GamificationState? _cached;
  GamificationState? get cached => _cached;

  Future<ApiResult<GamificationState>> fetchGamificationState() async {
    final result = await _api.get<GamificationState>(
      '/api/profile/gamification',
      fromJson: GamificationState.fromJson,
    );
    result.when(
      success: (state) => _cached = state,
      failure: (_, _) {},
    );
    return result;
  }

  Future<ApiResult<Map<String, dynamic>>> toggleObjective(
    String objectiveId,
  ) {
    return _api.post<Map<String, dynamic>>(
      '/api/profile/gamification/objectives/$objectiveId/toggle',
      fromJson: (json) => json as Map<String, dynamic>,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> revealReward(String rewardId) {
    return _api.post<Map<String, dynamic>>(
      '/api/profile/gamification/rewards/$rewardId/reveal',
      fromJson: (json) => json as Map<String, dynamic>,
    );
  }

  /// Fetch user preferences from the server.
  Future<ApiResult<Map<String, dynamic>>> fetchPreferences() {
    return _api.get<Map<String, dynamic>>(
      '/api/user/preferences',
      fromJson: (json) => json as Map<String, dynamic>,
    );
  }

  /// Patch user preferences on the server (fire-and-forget friendly).
  Future<ApiResult<Map<String, dynamic>>> updatePreferences(
    Map<String, dynamic> fields,
  ) {
    return _api.patch<Map<String, dynamic>>(
      '/api/user/preferences',
      body: fields,
      fromJson: (json) => json as Map<String, dynamic>,
    );
  }

  /// Fetch currently active seasonal campaigns from the API.
  Future<ApiResult<List<QuestCampaign>>> fetchActiveCampaigns() {
    return _api.get<List<QuestCampaign>>(
      '/api/campaigns/active',
      fromJson: (json) {
        final list = json as List;
        return list
            .map((item) => QuestCampaign.fromJson(item as Map<String, dynamic>))
            .toList();
      },
    );
  }
}
