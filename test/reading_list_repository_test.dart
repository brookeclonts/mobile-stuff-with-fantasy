import 'package:flutter_test/flutter_test.dart';
import 'package:swf_app/src/api/api_client.dart';
import 'package:swf_app/src/api/api_result.dart';
import 'package:swf_app/src/catalog/models/book.dart';
import 'package:swf_app/src/reader/data/reading_list_repository.dart';

void main() {
  test('fetchReadingList caches saved ids and books', () async {
    final apiClient = RecordingApiClient()
      ..nextGetJson = {
        'books': [_bookJson('book-1')],
        'ids': ['book-1'],
      };
    final repository = ReadingListRepository(apiClient: apiClient);

    final result = await repository.fetchReadingList(forceRefresh: true);

    expect(apiClient.lastGetPath, '/api/user/reading-list');
    expect(result.isSuccess, isTrue);
    expect(result.data.single.id, 'book-1');
    expect(repository.contains('book-1'), isTrue);
    expect(repository.savedIds, {'book-1'});
  });

  test('save and remove keep the local cache in sync', () async {
    final apiClient = RecordingApiClient()
      ..nextPostJson = {'bookId': 'book-1', 'saved': true}
      ..nextDeleteJson = {'bookId': 'book-1', 'saved': false};
    final repository = ReadingListRepository(apiClient: apiClient);
    final book = Book.fromDetailJson(_bookJson('book-1'));

    final saveResult = await repository.save(book);
    expect(apiClient.lastPostPath, '/api/books/book-1/reading-list');
    expect(saveResult.isSuccess, isTrue);
    expect(repository.contains('book-1'), isTrue);
    expect(repository.books.single.id, 'book-1');

    final removeResult = await repository.remove('book-1');
    expect(apiClient.lastDeletePath, '/api/books/book-1/reading-list');
    expect(removeResult.isSuccess, isTrue);
    expect(repository.contains('book-1'), isFalse);
    expect(repository.books, isEmpty);
  });
}

Map<String, Object?> _bookJson(String id) => {
  '_id': id,
  'title': 'A Fate Bound in Ash',
  'author_name': 'Seth Example',
  'description': 'A fantasy test book.',
  'image_url': '',
  'purchase_link': '',
  'alternate_purchase_link': '',
  'audiobook_link': '',
  'amazonASIN': '',
  'subgenres': const <Object?>[],
  'tropes': const <Object?>[],
  'spiceLevel': const {'name': 'No Spice'},
  'ageCategory': const {'name': 'Adult'},
  'representations': const <Object?>[],
  'languageLevel': 'clean',
  'kindleUnlimited': false,
  'favoritedBy': const <Object?>[],
};

class RecordingApiClient extends ApiClient {
  RecordingApiClient() : super(baseUrl: 'http://localhost');

  String? lastGetPath;
  String? lastPostPath;
  String? lastDeletePath;
  Object? nextGetJson;
  Object? nextPostJson;
  Object? nextDeleteJson;

  @override
  Future<ApiResult<T>> get<T>(
    String path, {
    required T Function(Object json) fromJson,
    Map<String, String>? queryParams,
    Map<String, String>? headers,
  }) async {
    lastGetPath = path;
    return Success(fromJson(nextGetJson!));
  }

  @override
  Future<ApiResult<T>> post<T>(
    String path, {
    required T Function(Object json) fromJson,
    Object? body,
    Map<String, String>? headers,
  }) async {
    lastPostPath = path;
    return Success(fromJson(nextPostJson!));
  }

  @override
  Future<ApiResult<T>> delete<T>(
    String path, {
    required T Function(Object json) fromJson,
    Map<String, String>? headers,
  }) async {
    lastDeletePath = path;
    return Success(fromJson(nextDeleteJson!));
  }
}
