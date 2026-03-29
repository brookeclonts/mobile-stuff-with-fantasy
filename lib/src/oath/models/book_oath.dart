class OathEntry {
  const OathEntry({
    required this.id,
    required this.bookId,
    required this.bookTitle,
    required this.completedAt,
  });

  final String id;
  final String bookId;
  final String bookTitle;
  final DateTime completedAt;

  factory OathEntry.fromJson(Map<String, Object?> json) {
    return OathEntry(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      bookId: (json['bookId'] ?? '').toString(),
      bookTitle: (json['bookTitle'] ?? '').toString(),
      completedAt: DateTime.parse(
        (json['completedAt'] ?? json['createdAt'] ?? '').toString(),
      ),
    );
  }
}

class BookOath {
  const BookOath({
    required this.id,
    required this.userId,
    this.userName,
    required this.title,
    required this.targetCount,
    required this.currentCount,
    required this.year,
    required this.isPublic,
    required this.entries,
    required this.createdAt,
  });

  final String id;
  final String userId;
  final String? userName;
  final String title;
  final int targetCount;
  final int currentCount;
  final int year;
  final bool isPublic;
  final List<OathEntry> entries;
  final DateTime createdAt;

  double get progress => targetCount > 0 ? currentCount / targetCount : 0;
  bool get isComplete => currentCount >= targetCount;

  factory BookOath.fromJson(Object json) {
    final map = json as Map<String, Object?>;

    // userId can be a plain string or a populated object { _id, name }.
    final rawUser = map['userId'];
    final String userId;
    final String? userName;
    if (rawUser is Map<String, Object?>) {
      userId = (rawUser['_id'] ?? rawUser['id'] ?? '').toString();
      userName = rawUser['name']?.toString();
    } else {
      userId = (rawUser ?? '').toString();
      userName = null;
    }

    final entries = ((map['entries'] as List?) ?? const [])
        .whereType<Map<String, Object?>>()
        .map(OathEntry.fromJson)
        .toList();

    final rawCount = map['currentCount'];
    final currentCount =
        rawCount is int ? rawCount : entries.length;

    return BookOath(
      id: (map['_id'] ?? map['id'] ?? '').toString(),
      userId: userId,
      userName: userName,
      title: (map['title'] ?? '').toString(),
      targetCount: (map['targetCount'] as num?)?.toInt() ?? 0,
      currentCount: currentCount,
      year: (map['year'] as num?)?.toInt() ?? DateTime.now().year,
      isPublic: map['isPublic'] as bool? ?? true,
      entries: entries,
      createdAt: DateTime.parse(
        (map['createdAt'] ?? '').toString(),
      ),
    );
  }
}
