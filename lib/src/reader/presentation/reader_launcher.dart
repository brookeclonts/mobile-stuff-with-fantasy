import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_epub_viewer/flutter_epub_viewer.dart';
import 'package:swf_app/src/api/service_locator.dart';
import 'package:swf_app/src/catalog/models/book.dart';
import 'package:swf_app/src/reader/presentation/reader_page.dart';

Future<void> openBookReader(BuildContext context, {required Book book}) async {
  unawaited(
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    ),
  );

  final result = await ServiceLocator.readerAccessRepository.fetchSignedEpub(
    book.id,
  );

  if (context.mounted) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  if (!context.mounted) return;

  result.when(
    success: (signedBookFile) {
      final readerBook = ServiceLocator.readerRepository.cacheBook(
        book,
        epubUrl: signedBookFile.url,
      );

      Navigator.push<void>(
        context,
        MaterialPageRoute<void>(
          builder: (_) => ReaderPage(
            book: readerBook,
            epubSource: EpubSource.fromUrl(signedBookFile.url),
          ),
        ),
      );
    },
    failure: (message, _) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    },
  );
}
