import 'package:swf_app/src/api/api_client.dart';
import 'package:swf_app/src/api/api_result.dart';
import 'package:swf_app/src/api/paginated.dart';
import 'package:swf_app/src/lore_board/models/lore_entry.dart';

class LoreBoardRepository {
  LoreBoardRepository({required ApiClient apiClient}) : _api = apiClient;

  final ApiClient _api;

  Future<ApiResult<Paginated<LoreEntry>>> fetchGlobalFeed({
    int page = 1,
    int limit = 20,
  }) async {
    return _fetchFeed(
      '/api/lore-board',
      page: page,
      limit: limit,
    );
  }

  Future<ApiResult<Paginated<LoreEntry>>> fetchFriendsFeed({
    int page = 1,
    int limit = 20,
  }) async {
    return _fetchFeed(
      '/api/lore-board/friends',
      page: page,
      limit: limit,
    );
  }

  Future<ApiResult<Paginated<LoreEntry>>> fetchGuildActivity(
    String guildId, {
    int page = 1,
    int limit = 20,
  }) async {
    return _fetchFeed(
      '/api/lore-board/guild/$guildId',
      page: page,
      limit: limit,
    );
  }

  Future<ApiResult<Paginated<LoreEntry>>> _fetchFeed(
    String path, {
    required int page,
    required int limit,
  }) async {
    final result = await _api.get<Paginated<LoreEntry>>(
      path,
      queryParams: {
        'page': '$page',
        'limit': '$limit',
      },
      fromJson: (json) {
        final map = json as Map<String, Object?>;
        final rawPage = (map['page'] as num?)?.toInt() ?? 1;
        final totalPages = (map['totalPages'] as num?)?.toInt() ?? 1;
        return Paginated.fromJson(
          {
            ...map,
            'hasNext': rawPage < totalPages,
            'hasPrev': rawPage > 1,
            'limit': limit,
          },
          itemsKey: 'entries',
          fromJsonItem: LoreEntry.fromJson,
        );
      },
    );

    return result;
  }
}
