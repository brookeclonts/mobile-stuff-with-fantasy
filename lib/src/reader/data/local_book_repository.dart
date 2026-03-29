import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:pretext/pretext.dart';
import 'package:swf_app/src/reader/models/reader_book.dart';

/// Manages locally imported EPUB files.
///
/// Books are stored in the app's documents directory under `imported_epubs/`.
/// Metadata is kept in memory and rebuilt on load by re-parsing headers.
class LocalBookRepository {
  final Map<String, _LocalBook> _books = {};

  List<ReaderBook> get books =>
      _books.values.map((b) => b.readerBook).toList();

  bool get isEmpty => _books.isEmpty;
  bool get isNotEmpty => _books.isNotEmpty;

  /// Load previously imported books from disk.
  Future<void> init() async {
    final dir = await _epubDir();
    if (!dir.existsSync()) return;

    for (final file in dir.listSync().whereType<File>()) {
      if (!file.path.endsWith('.epub')) continue;
      try {
        final bytes = await file.readAsBytes();
        final result = loadEpub(bytes);
        final id = _idFromPath(file.path);
        final title = result.document.metadata?.title ??
            _titleFromFilename(file.path);
        final author = result.document.metadata?.author ?? '';

        _books[id] = _LocalBook(
          id: id,
          filePath: file.path,
          epubResult: result,
          readerBook: ReaderBook(
            id: id,
            title: title,
            author: author,
          ),
        );
      } catch (_) {
        // Skip corrupt files.
      }
    }
  }

  /// Import an EPUB from raw bytes. Returns the ReaderBook on success.
  Future<ReaderBook?> importEpub({
    required String filename,
    required Uint8List bytes,
  }) async {
    final EpubLoadResult result;
    try {
      result = loadEpub(bytes);
    } catch (_) {
      return null;
    }

    final dir = await _epubDir();
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }

    final safeName = filename.replaceAll(RegExp(r'[^\w\-.]'), '_');
    final file = File('${dir.path}/$safeName');
    await file.writeAsBytes(bytes);

    final id = _idFromPath(file.path);
    final title =
        result.document.metadata?.title ?? _titleFromFilename(filename);
    final author = result.document.metadata?.author ?? '';

    final readerBook = ReaderBook(
      id: id,
      title: title,
      author: author,
    );

    _books[id] = _LocalBook(
      id: id,
      filePath: file.path,
      epubResult: result,
      readerBook: readerBook,
    );

    return readerBook;
  }

  /// Get the parsed EPUB result for a local book.
  EpubLoadResult? getEpubResult(String bookId) => _books[bookId]?.epubResult;

  /// Remove a locally imported book.
  Future<void> remove(String bookId) async {
    final book = _books.remove(bookId);
    if (book == null) return;
    final file = File(book.filePath);
    if (file.existsSync()) {
      await file.delete();
    }
  }

  Future<Directory> _epubDir() async {
    final appDir = await getApplicationDocumentsDirectory();
    return Directory('${appDir.path}/imported_epubs');
  }

  String _idFromPath(String path) =>
      'local:${path.split('/').last.hashCode.toRadixString(16)}';

  String _titleFromFilename(String path) {
    final name = path.split('/').last;
    return name.endsWith('.epub') ? name.substring(0, name.length - 5) : name;
  }
}

class _LocalBook {
  final String id;
  final String filePath;
  final EpubLoadResult epubResult;
  final ReaderBook readerBook;

  const _LocalBook({
    required this.id,
    required this.filePath,
    required this.epubResult,
    required this.readerBook,
  });
}
