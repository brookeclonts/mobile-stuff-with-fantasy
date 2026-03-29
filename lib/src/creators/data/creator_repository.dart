import 'package:swf_app/src/api/api_client.dart';
import 'package:swf_app/src/api/api_result.dart';
import 'package:swf_app/src/creators/models/creator.dart';

class CreatorRepository {
  CreatorRepository({required ApiClient apiClient}) : _api = apiClient;

  final ApiClient _api;

  /// Hardcoded featured creator slugs, in display order.
  /// Replace with a server-driven list when sponsorship/featuring is built.
  static const _featuredSlugs = <String>[
    // TODO: add real slugs here once you pick the featured creators
  ];

  /// Fetch the featured creators for the stories-style row.
  ///
  /// Pulls the full influencer list and filters to the hardcoded featured set,
  /// preserving display order.
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
        if (_featuredSlugs.isEmpty) {
          // No curated list yet — show all creators.
          return Success(all);
        }
        final bySlug = {for (final c in all) c.slug: c};
        final featured = _featuredSlugs
            .map((slug) => bySlug[slug])
            .whereType<Creator>()
            .toList();
        return Success(featured);
      },
      failure: (message, statusCode) => Failure(message, statusCode: statusCode),
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
