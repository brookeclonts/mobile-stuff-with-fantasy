import 'package:swf_app/src/catalog/models/book.dart';

/// A book added to the user's reading library.
class ReaderBook {
  const ReaderBook({
    required this.id,
    required this.title,
    required this.author,
    this.coverUrl = '',
    this.epubUrl = '',
    this.lastCfi,
    this.progress = 0.0,
  });

  /// Create a [ReaderBook] from a catalog [Book].
  factory ReaderBook.fromBook(Book book, {required String epubUrl}) {
    return ReaderBook(
      id: book.id,
      title: book.title,
      author: book.authorName,
      coverUrl: book.imageUrl,
      epubUrl: epubUrl,
    );
  }

  final String id;
  final String title;
  final String author;
  final String coverUrl;
  final String epubUrl;

  /// Last reading position as an EPUB CFI string.
  final String? lastCfi;

  /// Reading progress from 0.0 to 1.0.
  final double progress;

  ReaderBook copyWith({
    String? lastCfi,
    double? progress,
  }) {
    return ReaderBook(
      id: id,
      title: title,
      author: author,
      coverUrl: coverUrl,
      epubUrl: epubUrl,
      lastCfi: lastCfi ?? this.lastCfi,
      progress: progress ?? this.progress,
    );
  }
}
