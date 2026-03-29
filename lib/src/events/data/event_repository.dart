import 'package:swf_app/src/api/api_client.dart';
import 'package:swf_app/src/api/api_result.dart';
import 'package:swf_app/src/api/paginated.dart';
import 'package:swf_app/src/catalog/models/book.dart';
import 'package:swf_app/src/events/models/event.dart';

class EventRepository {
  EventRepository({required ApiClient apiClient}) : _api = apiClient;

  final ApiClient _api;

  /// Fetch the next/current event. Returns null (as Success) if none found.
  Future<ApiResult<Event?>> fetchNextEvent() async {
    final result = await _api.get<Event?>(
      '/api/events/next',
      fromJson: (json) {
        if (json is Map<String, Object?>) return Event.fromJson(json);
        return null;
      },
    );

    return result.when(
      success: (event) {
        if (event != null && event.shouldShowBanner) {
          return Success(event);
        }
        return const Success(null);
      },
      // 404 means no upcoming event — that's fine, not an error.
      failure: (message, statusCode) {
        if (statusCode == 404) return const Success(null);
        return Failure(message, statusCode: statusCode);
      },
    );
  }

  /// Fetch books for an event (paginated).
  Future<ApiResult<Paginated<Book>>> fetchEventBooks(
    String eventId, {
    int page = 1,
    int limit = 48,
  }) {
    return _api.post<Paginated<Book>>(
      '/api/filter/books/event/$eventId',
      body: {'page': page, 'limit': limit},
      fromJson: (json) => Paginated.fromJson(
        json as Map<String, Object?>,
        itemsKey: 'books',
        fromJsonItem: (b) => Book.fromJson(b),
      ),
    );
  }
}
