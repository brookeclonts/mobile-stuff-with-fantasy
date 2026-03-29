import 'package:swf_app/src/catalog/models/book.dart';

enum BookReadAccessType {
  none,
  purchased,
  owner;

  String get label => switch (this) {
    BookReadAccessType.owner => 'Your upload',
    BookReadAccessType.purchased => 'Purchased',
    BookReadAccessType.none => 'No access',
  };

  static BookReadAccessType fromApiValue(String? value) {
    return switch (value) {
      'owner' => BookReadAccessType.owner,
      'purchased' => BookReadAccessType.purchased,
      _ => BookReadAccessType.none,
    };
  }
}

class BookReadAccess {
  const BookReadAccess({
    required this.hasAccess,
    required this.accessType,
    required this.freeViaEvent,
  });

  final bool hasAccess;
  final BookReadAccessType accessType;
  final bool freeViaEvent;

  factory BookReadAccess.fromJson(Object json) {
    final map = json as Map<String, Object?>;
    return BookReadAccess(
      hasAccess: map['hasAccess'] as bool? ?? false,
      accessType: BookReadAccessType.fromApiValue(map['accessType'] as String?),
      freeViaEvent: map['freeViaEvent'] as bool? ?? false,
    );
  }
}

class SignedBookFile {
  const SignedBookFile({required this.url, required this.expiresInMinutes});

  final String url;
  final int expiresInMinutes;

  factory SignedBookFile.fromJson(Object json) {
    final map = json as Map<String, Object?>;
    return SignedBookFile(
      url: map['url'] as String? ?? '',
      expiresInMinutes: (map['expiresInMinutes'] as num?)?.toInt() ?? 0,
    );
  }
}

class ReadableBook {
  const ReadableBook({
    required this.book,
    required this.accessType,
    this.acquiredAt,
  });

  final Book book;
  final BookReadAccessType accessType;
  final DateTime? acquiredAt;

  bool get canReadInApp => book.distribution?.hasEpub ?? false;
  String get accessLabel => accessType.label;

  factory ReadableBook.fromJson(Object json) {
    final map = json as Map<String, Object?>;
    return ReadableBook(
      book: Book.fromDetailJson(map['book'] as Map<String, Object?>),
      accessType: BookReadAccessType.fromApiValue(map['accessType'] as String?),
      acquiredAt: DateTime.tryParse(map['acquiredAt'] as String? ?? ''),
    );
  }
}
