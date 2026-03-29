import 'package:swf_app/src/api/api_client.dart';
import 'package:swf_app/src/api/api_result.dart';
import 'package:swf_app/src/reader/models/readable_book.dart';

class MyBooksSnapshot {
  const MyBooksSnapshot({required this.books});

  final List<ReadableBook> books;

  factory MyBooksSnapshot.fromJson(Object json) {
    final map = json as Map<String, Object?>;
    final books = ((map['books'] as List?) ?? const [])
        .whereType<Map<String, Object?>>()
        .map(ReadableBook.fromJson)
        .where((book) => book.canReadInApp)
        .toList();

    return MyBooksSnapshot(books: books);
  }
}

class ReaderAccessRepository {
  ReaderAccessRepository({required ApiClient apiClient}) : _api = apiClient;

  final ApiClient _api;

  final List<ReadableBook> _myBooks = [];
  bool _hasLoadedMyBooks = false;

  List<ReadableBook> get myBooks => List<ReadableBook>.unmodifiable(_myBooks);
  bool get hasLoadedMyBooks => _hasLoadedMyBooks;

  Future<ApiResult<List<ReadableBook>>> fetchMyBooks({
    bool forceRefresh = false,
  }) async {
    if (_hasLoadedMyBooks && !forceRefresh) {
      return Success(myBooks);
    }

    final result = await _api.get<MyBooksSnapshot>(
      '/api/user/my-books',
      fromJson: MyBooksSnapshot.fromJson,
    );

    if (result is Failure<MyBooksSnapshot> && result.statusCode == 401) {
      clear();
      _hasLoadedMyBooks = true;
      return const Success(<ReadableBook>[]);
    }

    return result.when(
      success: (snapshot) {
        _myBooks
          ..clear()
          ..addAll(snapshot.books);
        _hasLoadedMyBooks = true;
        return Success(myBooks);
      },
      failure: (message, statusCode) =>
          Failure(message, statusCode: statusCode),
    );
  }

  Future<ApiResult<BookReadAccess>> checkAccess(String bookId) {
    return _api.get<BookReadAccess>(
      '/api/books/$bookId/access-check',
      fromJson: BookReadAccess.fromJson,
    );
  }

  Future<ApiResult<SignedBookFile>> fetchSignedEpub(String bookId) {
    return _api.get<SignedBookFile>(
      '/api/books/$bookId/signed-url',
      queryParams: const {'purpose': 'read', 'format': 'epub'},
      fromJson: SignedBookFile.fromJson,
    );
  }

  void clear() {
    _myBooks.clear();
    _hasLoadedMyBooks = false;
  }
}
