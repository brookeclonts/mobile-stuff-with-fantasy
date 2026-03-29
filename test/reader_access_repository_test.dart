import 'package:flutter_test/flutter_test.dart';
import 'package:swf_app/src/api/api_client.dart';
import 'package:swf_app/src/api/api_result.dart';
import 'package:swf_app/src/reader/data/reader_access_repository.dart';
import 'package:swf_app/src/reader/models/readable_book.dart';

void main() {
  test(
    'fetchMyBooks caches readable books from the library endpoint',
    () async {
      final apiClient = RecordingApiClient()
        ..nextGetJson = {
          'books': [
            {
              'book': _bookJson('book-1', hasEpub: true),
              'accessType': 'purchased',
              'acquiredAt': '2026-03-28T12:00:00.000Z',
            },
            {
              'book': _bookJson('book-2', hasEpub: false),
              'accessType': 'owner',
              'acquiredAt': '2026-03-27T12:00:00.000Z',
            },
          ],
        };
      final repository = ReaderAccessRepository(apiClient: apiClient);

      final result = await repository.fetchMyBooks(forceRefresh: true);

      expect(apiClient.lastGetPath, '/api/user/my-books');
      expect(result.isSuccess, isTrue);
      expect(result.data.single.book.id, 'book-1');
      expect(result.data.single.accessType, BookReadAccessType.purchased);
      expect(repository.myBooks.single.book.id, 'book-1');
    },
  );

  test(
    'checkAccess and fetchSignedEpub use the reader access endpoints',
    () async {
      final apiClient = RecordingApiClient()
        ..nextGetJson = {
          'hasAccess': true,
          'accessType': 'owner',
          'freeViaEvent': false,
        };
      final repository = ReaderAccessRepository(apiClient: apiClient);

      final accessResult = await repository.checkAccess('book-1');
      expect(apiClient.lastGetPath, '/api/books/book-1/access-check');
      expect(accessResult.isSuccess, isTrue);
      expect(accessResult.data.accessType, BookReadAccessType.owner);

      apiClient.nextGetJson = {
        'url': 'https://files.example.com/book-1.epub',
        'expiresInMinutes': 15,
      };

      final urlResult = await repository.fetchSignedEpub('book-1');
      expect(apiClient.lastGetPath, '/api/books/book-1/signed-url');
      expect(apiClient.lastQueryParams, const {
        'purpose': 'read',
        'format': 'epub',
      });
      expect(urlResult.isSuccess, isTrue);
      expect(urlResult.data.url, 'https://files.example.com/book-1.epub');
    },
  );
}

Map<String, Object?> _bookJson(String id, {required bool hasEpub}) => {
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
  'distribution': {
    'enabled': true,
    'epubUrl': hasEpub ? 'https://files.example.com/$id.epub' : '',
    'pdfUrl': 'https://files.example.com/$id.pdf',
  },
};

class RecordingApiClient extends ApiClient {
  RecordingApiClient() : super(baseUrl: 'http://localhost');

  String? lastGetPath;
  Map<String, String>? lastQueryParams;
  Object? nextGetJson;

  @override
  Future<ApiResult<T>> get<T>(
    String path, {
    required T Function(Object json) fromJson,
    Map<String, String>? queryParams,
    Map<String, String>? headers,
  }) async {
    lastGetPath = path;
    lastQueryParams = queryParams;
    return Success(fromJson(nextGetJson!));
  }
}
