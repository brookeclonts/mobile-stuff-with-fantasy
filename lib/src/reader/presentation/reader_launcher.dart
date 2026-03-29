import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pretext/pretext.dart';
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

  if (!context.mounted) return;

  await result.when(
    success: (signedBookFile) async {
      // Download the EPUB bytes.
      final response = await http.get(Uri.parse(signedBookFile.url));

      if (!context.mounted) return;
      Navigator.of(context, rootNavigator: true).pop();

      if (response.statusCode != 200) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to download book')),
          );
        }
        return;
      }

      // Parse the EPUB.
      final EpubLoadResult epubResult;
      try {
        epubResult = loadEpub(response.bodyBytes);
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to open book: $e')),
          );
        }
        return;
      }

      final readerBook = ServiceLocator.readerRepository.cacheBook(
        book,
        epubUrl: signedBookFile.url,
      );

      if (!context.mounted) return;

      unawaited(Navigator.push<void>(
        context,
        MaterialPageRoute<void>(
          builder: (_) => ReaderPage(
            book: readerBook,
            epubResult: epubResult,
          ),
        ),
      ));
    },
    failure: (message, _) {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
    },
  );
}
