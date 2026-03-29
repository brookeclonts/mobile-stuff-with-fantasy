import 'package:swf_app/src/api/api_client.dart';
import 'package:swf_app/src/api/api_result.dart';
import 'package:swf_app/src/creators/models/creator.dart';

class CreatorRepository {
  CreatorRepository({required ApiClient apiClient}) : _api = apiClient;

  final ApiClient _api;

  /// Hardcoded featured creator IDs, in display order.
  /// Replace with a server-driven list when sponsorship/featuring is built.
  static const _featuredIds = <String>[
    '684476864653ceacdf87bb38', // Jeremy Sparks
    '6842ed2bb7f6ab6c06c847a3', // Andrea
    '68018c1e7a31625ae2083631', // Madeline Burget
    '67fe0661f40e6ff07af89ce2', // Brooke Clonts
  ];

  /// Fetch the featured creators for the stories-style row.
  ///
  /// Pulls the full influencer list and filters to the hardcoded featured set,
  /// preserving display order. When the featured list has entries, only those
  /// creators are shown; remaining creators follow in their original order.
  Future<ApiResult<List<Creator>>> getFeaturedCreators() async {
    final result = await _api.get<List<Creator>>(
      '/api/influencers',
      fromJson: (json) {
        if (json is! List) return const [];
        return json
            .whereType<Map<String, Object?>>()
            .map((e) => Creator.fromListJson(e))
            .toList();
      },
    );

    return result.when(
      success: (all) {
        if (_featuredIds.isEmpty) return Success(all);

        final byId = {for (final c in all) c.id: c};
        // Pinned creators first, in declared order.
        final pinned = _featuredIds
            .map((id) => byId[id])
            .whereType<Creator>()
            .toList();
        // Everyone else after.
        final rest = all.where((c) => !_featuredIds.contains(c.id)).toList();
        return Success([...pinned, ...rest]);
      },
      failure: (message, statusCode) =>
          Failure(message, statusCode: statusCode),
    );
  }

  /// Fetch a single creator's full profile.
  Future<ApiResult<Creator>> getCreator(String identifier) {
    return _api.get<Creator>(
      '/api/influencer/$identifier',
      fromJson: (json) =>
          Creator.fromDetailJson(json as Map<String, Object?>),
    );
  }
}
