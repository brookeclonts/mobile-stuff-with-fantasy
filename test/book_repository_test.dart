import 'package:flutter_test/flutter_test.dart';
import 'package:swf_app/src/api/api_client.dart';
import 'package:swf_app/src/api/api_result.dart';
import 'package:swf_app/src/catalog/data/book_repository.dart';

void main() {
  test('getBooks includes kindleUnlimited in the request body', () async {
    final apiClient = RecordingApiClient();
    final repository = BookRepository(apiClient: apiClient);

    await repository.getBooks(kindleUnlimited: true);

    expect(apiClient.lastPath, '/api/filter/books/all');
    expect(
      apiClient.lastBody,
      containsPair('kindleUnlimited', true),
    );
  });
}

class RecordingApiClient extends ApiClient {
  RecordingApiClient() : super(baseUrl: 'http://localhost');

  String? lastPath;
  Object? lastBody;

  @override
  Future<ApiResult<T>> post<T>(
    String path, {
    required T Function(Object json) fromJson,
    Object? body,
    Map<String, String>? headers,
  }) async {
    lastPath = path;
    lastBody = body;

    return Success(
      fromJson(<String, Object?>{
        'books': const <Object?>[],
        'total': 0,
        'page': 1,
        'limit': 18,
        'totalPages': 1,
        'hasNext': false,
        'hasPrev': false,
      }),
    );
  }

  @override
  Future<ApiResult<T>> get<T>(
    String path, {
    required T Function(Object json) fromJson,
    Map<String, String>? queryParams,
    Map<String, String>? headers,
  }) async {
    throw UnimplementedError();
  }
}
