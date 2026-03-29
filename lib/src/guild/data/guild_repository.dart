import 'package:swf_app/src/api/api_client.dart';
import 'package:swf_app/src/api/api_result.dart';
import 'package:swf_app/src/api/paginated.dart';
import 'package:swf_app/src/guild/models/guild.dart';

class GuildRepository {
  GuildRepository({required ApiClient apiClient}) : _api = apiClient;

  final ApiClient _api;

  List<Guild>? _myGuilds;

  List<Guild>? get cachedGuilds => _myGuilds;

  Future<ApiResult<List<Guild>>> fetchMyGuilds({
    bool forceRefresh = false,
  }) async {
    if (_myGuilds != null && !forceRefresh) {
      return Success(_myGuilds!);
    }

    final result = await _api.get<List<Guild>>(
      '/api/guilds',
      fromJson: (json) {
        if (json is List) {
          return json
              .whereType<Map<String, Object?>>()
              .map((e) => Guild.fromJson(e))
              .toList();
        }
        return const <Guild>[];
      },
    );

    return result.when(
      success: (guilds) {
        _myGuilds = guilds;
        return Success(guilds);
      },
      failure: (message, statusCode) =>
          Failure(message, statusCode: statusCode),
    );
  }

  Future<ApiResult<Guild>> fetchGuildDetail(String guildId) async {
    final result = await _api.get<Guild>(
      '/api/guilds/$guildId',
      fromJson: Guild.fromJson,
    );

    return result;
  }

  Future<ApiResult<Guild>> createGuild({
    required String name,
    String? description,
    bool isPublic = true,
  }) async {
    final result = await _api.post<Guild>(
      '/api/guilds',
      fromJson: Guild.fromJson,
      body: {
        'name': name,
        'description': ?description,
        'isPublic': isPublic,
      },
    );

    return result.when(
      success: (guild) {
        _myGuilds = [...?_myGuilds, guild];
        return Success(guild);
      },
      failure: (message, statusCode) =>
          Failure(message, statusCode: statusCode),
    );
  }

  Future<ApiResult<Guild>> updateGuild(
    String guildId, {
    String? name,
    String? description,
    bool? isPublic,
  }) async {
    final body = <String, Object>{
      'name': ?name,
      'description': ?description,
      'isPublic': ?isPublic,
    };

    final result = await _api.put<Guild>(
      '/api/guilds/$guildId',
      fromJson: Guild.fromJson,
      body: body,
    );

    return result.when(
      success: (guild) {
        _myGuilds = _myGuilds
            ?.map((g) => g.id == guildId ? guild : g)
            .toList();
        return Success(guild);
      },
      failure: (message, statusCode) =>
          Failure(message, statusCode: statusCode),
    );
  }

  Future<ApiResult<void>> deleteGuild(String guildId) async {
    final result = await _api.delete<Guild>(
      '/api/guilds/$guildId',
      fromJson: Guild.fromJson,
    );

    return result.when(
      success: (_) {
        _myGuilds = _myGuilds?.where((g) => g.id != guildId).toList();
        return const Success(null);
      },
      failure: (message, statusCode) =>
          Failure(message, statusCode: statusCode),
    );
  }

  Future<ApiResult<Guild>> joinGuild(String guildId) async {
    final result = await _api.post<Guild>(
      '/api/guilds/$guildId/join',
      fromJson: Guild.fromJson,
    );

    return result.when(
      success: (guild) {
        _myGuilds = [...?_myGuilds, guild];
        return Success(guild);
      },
      failure: (message, statusCode) =>
          Failure(message, statusCode: statusCode),
    );
  }

  Future<ApiResult<void>> leaveGuild(String guildId) async {
    final result = await _api.post<Guild>(
      '/api/guilds/$guildId/leave',
      fromJson: Guild.fromJson,
    );

    return result.when(
      success: (_) {
        _myGuilds = _myGuilds?.where((g) => g.id != guildId).toList();
        return const Success(null);
      },
      failure: (message, statusCode) =>
          Failure(message, statusCode: statusCode),
    );
  }

  Future<ApiResult<Guild>> addToLedger(
    String guildId, {
    required String bookId,
  }) async {
    final result = await _api.post<Guild>(
      '/api/guilds/$guildId/ledger',
      fromJson: Guild.fromJson,
      body: {'bookId': bookId},
    );

    return result.when(
      success: (guild) {
        _myGuilds = _myGuilds
            ?.map((g) => g.id == guildId ? guild : g)
            .toList();
        return Success(guild);
      },
      failure: (message, statusCode) =>
          Failure(message, statusCode: statusCode),
    );
  }

  Future<ApiResult<Guild>> removeFromLedger(
    String guildId, {
    required String bookId,
  }) async {
    final result = await _api.delete<Guild>(
      '/api/guilds/$guildId/ledger/$bookId',
      fromJson: Guild.fromJson,
    );

    return result.when(
      success: (guild) {
        _myGuilds = _myGuilds
            ?.map((g) => g.id == guildId ? guild : g)
            .toList();
        return Success(guild);
      },
      failure: (message, statusCode) =>
          Failure(message, statusCode: statusCode),
    );
  }

  Future<ApiResult<Paginated<Guild>>> discoverGuilds({int page = 1}) async {
    final result = await _api.get<Paginated<Guild>>(
      '/api/guilds/discover',
      fromJson: (json) {
        final map = json as Map<String, Object?>;
        return Paginated.fromJson<Guild>(
          map,
          itemsKey: 'guilds',
          fromJsonItem: (item) => Guild.fromJson(item),
        );
      },
      queryParams: {'page': page.toString()},
    );

    return result;
  }

  void clear() {
    _myGuilds = null;
  }
}
