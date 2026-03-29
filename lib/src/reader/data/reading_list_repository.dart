import 'package:swf_app/src/api/api_client.dart';
import 'package:swf_app/src/api/api_result.dart';
import 'package:swf_app/src/catalog/models/book.dart';

class ReadingListSnapshot {
  const ReadingListSnapshot({required this.books, required this.ids});

  final List<Book> books;
  final Set<String> ids;

  factory ReadingListSnapshot.fromJson(Object json) {
    final map = json as Map<String, Object?>;
    final books = ((map['books'] as List?) ?? const [])
        .whereType<Map<String, Object?>>()
        .map(Book.fromDetailJson)
        .toList();
    final ids =
        (((map['ids'] as List?) ?? const [])
                .map((id) => id.toString())
                .where((id) => id.isNotEmpty))
            .toSet();

    return ReadingListSnapshot(
      books: books,
      ids: ids.isEmpty ? books.map((book) => book.id).toSet() : ids,
    );
  }
}

class ReadingListMutation {
  const ReadingListMutation({required this.bookId, required this.saved});

  final String bookId;
  final bool saved;

  factory ReadingListMutation.fromJson(Object json) {
    final map = json as Map<String, Object?>;
    return ReadingListMutation(
      bookId: map['bookId']?.toString() ?? '',
      saved: map['saved'] as bool? ?? false,
    );
  }
}

class ReadingListRepository {
  ReadingListRepository({required ApiClient apiClient}) : _api = apiClient;

  final ApiClient _api;

  final Map<String, Book> _booksById = {};
  final List<String> _orderedIds = [];
  final Set<String> _savedIds = <String>{};
  bool _hasLoaded = false;

  List<Book> get books =>
      _orderedIds.map((id) => _booksById[id]).whereType<Book>().toList();
  Set<String> get savedIds => Set<String>.unmodifiable(_savedIds);
  bool get hasLoaded => _hasLoaded;

  bool contains(String bookId) => _savedIds.contains(bookId);

  Future<ApiResult<List<Book>>> fetchReadingList({
    bool forceRefresh = false,
  }) async {
    if (_hasLoaded && !forceRefresh) {
      return Success(books);
    }

    final result = await _api.get<ReadingListSnapshot>(
      '/api/user/reading-list',
      fromJson: ReadingListSnapshot.fromJson,
    );

    if (result is Failure<ReadingListSnapshot> && result.statusCode == 401) {
      clear();
      _hasLoaded = true;
      return const Success(<Book>[]);
    }

    return result.when(
      success: (snapshot) {
        _replaceCache(snapshot.books);
        _savedIds
          ..clear()
          ..addAll(snapshot.ids);
        _hasLoaded = true;
        return Success(books);
      },
      failure: (message, statusCode) =>
          Failure(message, statusCode: statusCode),
    );
  }

  Future<ApiResult<bool>> save(Book book) async {
    final result = await _api.post<ReadingListMutation>(
      '/api/books/${book.id}/reading-list',
      fromJson: ReadingListMutation.fromJson,
    );

    return result.when(
      success: (mutation) {
        _cacheBook(book, toFront: true);
        _savedIds.add(mutation.bookId.isEmpty ? book.id : mutation.bookId);
        _hasLoaded = true;
        return const Success(true);
      },
      failure: (message, statusCode) =>
          Failure(message, statusCode: statusCode),
    );
  }

  Future<ApiResult<bool>> remove(String bookId) async {
    final result = await _api.delete<ReadingListMutation>(
      '/api/books/$bookId/reading-list',
      fromJson: ReadingListMutation.fromJson,
    );

    return result.when(
      success: (mutation) {
        final resolvedId = mutation.bookId.isEmpty ? bookId : mutation.bookId;
        _savedIds.remove(resolvedId);
        _booksById.remove(resolvedId);
        _orderedIds.remove(resolvedId);
        _hasLoaded = true;
        return const Success(false);
      },
      failure: (message, statusCode) =>
          Failure(message, statusCode: statusCode),
    );
  }

  void clear() {
    _booksById.clear();
    _orderedIds.clear();
    _savedIds.clear();
    _hasLoaded = false;
  }

  void _replaceCache(List<Book> nextBooks) {
    _booksById
      ..clear()
      ..addEntries(nextBooks.map((book) => MapEntry(book.id, book)));
    _orderedIds
      ..clear()
      ..addAll(nextBooks.map((book) => book.id));
  }

  void _cacheBook(Book book, {required bool toFront}) {
    _booksById[book.id] = book;
    _orderedIds.remove(book.id);
    if (toFront) {
      _orderedIds.insert(0, book.id);
    } else {
      _orderedIds.add(book.id);
    }
  }
}
