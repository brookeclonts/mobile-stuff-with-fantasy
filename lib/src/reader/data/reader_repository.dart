import 'package:swf_app/src/catalog/models/book.dart';
import 'package:swf_app/src/reader/models/reader_book.dart';

/// In-memory store for the user's reading library and progress.
///
/// Tracks which books the user has added and their reading positions.
/// Persistence (local DB, API sync) can be layered in later.
class ReaderRepository {
  final Map<String, ReaderBook> _books = {};

  List<ReaderBook> get books => _books.values.toList();

  ReaderBook cacheBook(Book book, {required String epubUrl}) {
    final existing = _books[book.id];
    final readerBook = ReaderBook.fromBook(
      book,
      epubUrl: epubUrl,
      lastCfi: existing?.lastCfi,
      progress: existing?.progress ?? 0.0,
    );
    _books[book.id] = readerBook;
    return readerBook;
  }

  void addBook(ReaderBook book) {
    _books[book.id] = book;
  }

  void removeBook(String id) {
    _books.remove(id);
  }

  ReaderBook? getBook(String id) => _books[id];

  void updateProgress(String bookId, {String? cfi, double? progress}) {
    final book = _books[bookId];
    if (book == null) return;
    _books[bookId] = book.copyWith(lastCfi: cfi, progress: progress);
  }
}
