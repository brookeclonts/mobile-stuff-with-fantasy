import 'package:swf_app/src/api/api_client.dart';
import 'package:swf_app/src/api/api_result.dart';
import 'package:swf_app/src/profile/models/recommendation_pairing.dart';

class RecommendationRepository {
  RecommendationRepository({required ApiClient apiClient}) : _api = apiClient;

  final ApiClient _api;
  List<RecommendationPairing> _cached = [];
  bool _hasLoaded = false;

  List<RecommendationPairing> get pairings => List.unmodifiable(_cached);
  bool get hasLoaded => _hasLoaded;

  Future<ApiResult<List<RecommendationPairing>>> fetchMyPairings({
    bool forceRefresh = false,
  }) async {
    if (_hasLoaded && !forceRefresh) {
      return Success(_cached);
    }

    final result = await _api.get<List<RecommendationPairing>>(
      '/api/user/recommendations',
      fromJson: (json) => (json as List)
          .whereType<Map<String, Object?>>()
          .map(RecommendationPairing.fromJson)
          .toList(),
    );

    if (result is Failure<List<RecommendationPairing>> &&
        result.statusCode == 401) {
      clear();
      _hasLoaded = true;
      return const Success(<RecommendationPairing>[]);
    }

    return result.when(
      success: (pairings) {
        _cached = pairings;
        _hasLoaded = true;
        return Success(pairings);
      },
      failure: (message, statusCode) =>
          Failure(message, statusCode: statusCode),
    );
  }

  Future<ApiResult<RecommendationPairing>> createPairing({
    required String sourceBookId,
    required String targetBookId,
    required String reason,
  }) async {
    final result = await _api.post<RecommendationPairing>(
      '/api/recommendations',
      fromJson: RecommendationPairing.fromJson,
      body: {
        'sourceBookId': sourceBookId,
        'targetBookId': targetBookId,
        'reason': reason,
      },
    );

    return result.when(
      success: (pairing) {
        _cached.insert(0, pairing);
        return Success(pairing);
      },
      failure: (message, statusCode) =>
          Failure(message, statusCode: statusCode),
    );
  }

  Future<ApiResult<void>> deletePairing(String id) async {
    final result = await _api.delete<Map<String, Object?>>(
      '/api/recommendations/$id',
      fromJson: (json) => json as Map<String, Object?>,
    );

    return result.when(
      success: (_) {
        _cached.removeWhere((p) => p.id == id);
        return const Success(null);
      },
      failure: (message, statusCode) =>
          Failure(message, statusCode: statusCode),
    );
  }

  void clear() {
    _cached = [];
    _hasLoaded = false;
  }
}
