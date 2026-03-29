import 'package:swf_app/src/api/api_client.dart';
import 'package:swf_app/src/api/api_result.dart';
import 'package:swf_app/src/profile/models/review.dart';

class ReviewRepository {
  ReviewRepository({required ApiClient apiClient}) : _api = apiClient;

  final ApiClient _api;
  List<Review> _cached = [];
  bool _hasLoaded = false;

  List<Review> get reviews => List.unmodifiable(_cached);
  bool get hasLoaded => _hasLoaded;

  Future<ApiResult<List<Review>>> fetchMyReviews({
    bool forceRefresh = false,
  }) async {
    if (_hasLoaded && !forceRefresh) {
      return Success(_cached);
    }

    final result = await _api.get<List<Review>>(
      '/api/user/reviews',
      fromJson: (json) => (json as List)
          .whereType<Map<String, Object?>>()
          .map(Review.fromJson)
          .toList(),
    );

    if (result is Failure<List<Review>> && result.statusCode == 401) {
      clear();
      _hasLoaded = true;
      return const Success(<Review>[]);
    }

    return result.when(
      success: (reviews) {
        _cached = reviews;
        _hasLoaded = true;
        return Success(reviews);
      },
      failure: (message, statusCode) =>
          Failure(message, statusCode: statusCode),
    );
  }

  Future<ApiResult<Review>> createReview({
    required String bookId,
    required int rating,
    required String title,
    required String body,
  }) async {
    final result = await _api.post<Review>(
      '/api/books/$bookId/reviews',
      fromJson: Review.fromJson,
      body: {'rating': rating, 'title': title, 'body': body},
    );

    return result.when(
      success: (review) {
        _cached.insert(0, review);
        return Success(review);
      },
      failure: (message, statusCode) =>
          Failure(message, statusCode: statusCode),
    );
  }

  Future<ApiResult<Review>> updateReview({
    required String reviewId,
    required int rating,
    required String title,
    required String body,
  }) async {
    final result = await _api.put<Review>(
      '/api/reviews/$reviewId',
      fromJson: Review.fromJson,
      body: {'rating': rating, 'title': title, 'body': body},
    );

    return result.when(
      success: (updated) {
        final index = _cached.indexWhere((r) => r.id == reviewId);
        if (index != -1) {
          _cached[index] = updated;
        }
        return Success(updated);
      },
      failure: (message, statusCode) =>
          Failure(message, statusCode: statusCode),
    );
  }

  Future<ApiResult<void>> deleteReview(String reviewId) async {
    final result = await _api.delete<Map<String, Object?>>(
      '/api/reviews/$reviewId',
      fromJson: (json) => json as Map<String, Object?>,
    );

    return result.when(
      success: (_) {
        _cached.removeWhere((r) => r.id == reviewId);
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
