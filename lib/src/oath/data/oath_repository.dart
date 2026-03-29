import 'package:swf_app/src/api/api_client.dart';
import 'package:swf_app/src/api/api_result.dart';
import 'package:swf_app/src/oath/models/book_oath.dart';

class OathRepository {
  OathRepository({required ApiClient apiClient}) : _api = apiClient;

  final ApiClient _api;

  BookOath? _cachedOath;
  bool _hasLoaded = false;

  BookOath? get cachedOath => _cachedOath;
  bool get hasLoaded => _hasLoaded;

  Future<ApiResult<BookOath?>> fetchMyOath({
    bool forceRefresh = false,
  }) async {
    if (_hasLoaded && !forceRefresh) {
      return Success(_cachedOath);
    }

    // Use nullable fromJson — the API returns { data: null } when no oath
    // exists, which means fromJson receives the envelope object. We detect
    // this and return null instead of a garbage-parsed BookOath.
    final result = await _api.get<BookOath?>(
      '/api/oaths',
      fromJson: (json) {
        final map = json as Map<String, Object?>;
        // If the envelope itself was passed (data was null), detect it.
        if (map.containsKey('success') && !map.containsKey('title')) {
          return null;
        }
        return BookOath.fromJson(json);
      },
    );

    if (result is Failure<BookOath?> && result.statusCode == 401) {
      clear();
      _hasLoaded = true;
      return const Success(null);
    }

    return result.when(
      success: (oath) {
        _cachedOath = oath;
        _hasLoaded = true;
        return Success<BookOath?>(oath);
      },
      failure: (message, statusCode) =>
          Failure(message, statusCode: statusCode),
    );
  }

  Future<ApiResult<BookOath>> createOath({
    required String title,
    required int targetCount,
    required int year,
    bool isPublic = true,
  }) async {
    final result = await _api.post<BookOath>(
      '/api/oaths',
      fromJson: BookOath.fromJson,
      body: {
        'title': title,
        'targetCount': targetCount,
        'year': year,
        'isPublic': isPublic,
      },
    );

    return result.when(
      success: (oath) {
        _cachedOath = oath;
        _hasLoaded = true;
        return Success(oath);
      },
      failure: (message, statusCode) =>
          Failure(message, statusCode: statusCode),
    );
  }

  Future<ApiResult<BookOath>> updateOath(
    String oathId, {
    String? title,
    int? targetCount,
    bool? isPublic,
  }) async {
    final body = <String, Object>{
      'title': ?title,
      'targetCount': ?targetCount,
      'isPublic': ?isPublic,
    };

    final result = await _api.put<BookOath>(
      '/api/oaths/$oathId',
      fromJson: BookOath.fromJson,
      body: body,
    );

    return result.when(
      success: (oath) {
        _cachedOath = oath;
        return Success(oath);
      },
      failure: (message, statusCode) =>
          Failure(message, statusCode: statusCode),
    );
  }

  Future<ApiResult<void>> deleteOath(String oathId) async {
    final result = await _api.delete<BookOath>(
      '/api/oaths/$oathId',
      fromJson: BookOath.fromJson,
    );

    return result.when(
      success: (_) {
        clear();
        _hasLoaded = true;
        return const Success(null);
      },
      failure: (message, statusCode) =>
          Failure(message, statusCode: statusCode),
    );
  }

  Future<ApiResult<BookOath>> logEntry(
    String oathId, {
    required String bookId,
    required String bookTitle,
  }) async {
    final result = await _api.post<BookOath>(
      '/api/oaths/$oathId/entries',
      fromJson: BookOath.fromJson,
      body: {
        'bookId': bookId,
        'bookTitle': bookTitle,
      },
    );

    return result.when(
      success: (oath) {
        _cachedOath = oath;
        return Success(oath);
      },
      failure: (message, statusCode) =>
          Failure(message, statusCode: statusCode),
    );
  }

  Future<ApiResult<BookOath>> removeEntry(
    String oathId, {
    required String entryId,
  }) async {
    final result = await _api.delete<BookOath>(
      '/api/oaths/$oathId/entries/$entryId',
      fromJson: BookOath.fromJson,
    );

    return result.when(
      success: (oath) {
        _cachedOath = oath;
        return Success(oath);
      },
      failure: (message, statusCode) =>
          Failure(message, statusCode: statusCode),
    );
  }

  void clear() {
    _cachedOath = null;
    _hasLoaded = false;
  }
}
