class ReadingStats {
  const ReadingStats({
    this.totalBooksCompleted = 0,
    this.totalSessionCount = 0,
    this.totalReadingSeconds = 0,
    this.totalProgressPoints = 0.0,
    this.currentStreakDays = 0,
    this.longestStreakDays = 0,
    this.lastReadDate,
    this.bookProgress = const {},
  });

  final int totalBooksCompleted;
  final int totalSessionCount;
  final int totalReadingSeconds;
  final double totalProgressPoints;
  final int currentStreakDays;
  final int longestStreakDays;
  final DateTime? lastReadDate;

  /// bookId → highest progress seen (0.0–1.0).
  final Map<String, double> bookProgress;

  /// Approximate pages read (heuristic: 1.0 progress ≈ 300 pages).
  int get estimatedPages => (totalProgressPoints * 300).round();

  Map<String, Object?> toJson() => {
        'totalBooksCompleted': totalBooksCompleted,
        'totalSessionCount': totalSessionCount,
        'totalReadingSeconds': totalReadingSeconds,
        'totalProgressPoints': totalProgressPoints,
        'currentStreakDays': currentStreakDays,
        'longestStreakDays': longestStreakDays,
        'lastReadDate': lastReadDate?.toIso8601String(),
        'bookProgress': bookProgress,
      };

  factory ReadingStats.fromJson(Map<String, Object?> json) {
    final lastRead = json['lastReadDate'] as String?;
    final bookProg = json['bookProgress'];
    return ReadingStats(
      totalBooksCompleted:
          (json['totalBooksCompleted'] as num?)?.toInt() ?? 0,
      totalSessionCount: (json['totalSessionCount'] as num?)?.toInt() ?? 0,
      totalReadingSeconds:
          (json['totalReadingSeconds'] as num?)?.toInt() ?? 0,
      totalProgressPoints:
          (json['totalProgressPoints'] as num?)?.toDouble() ?? 0.0,
      currentStreakDays: (json['currentStreakDays'] as num?)?.toInt() ?? 0,
      longestStreakDays: (json['longestStreakDays'] as num?)?.toInt() ?? 0,
      lastReadDate: lastRead != null ? DateTime.tryParse(lastRead) : null,
      bookProgress: bookProg is Map
          ? bookProg
              .map((k, v) => MapEntry(k.toString(), (v as num).toDouble()))
          : const {},
    );
  }

  ReadingStats copyWith({
    int? totalBooksCompleted,
    int? totalSessionCount,
    int? totalReadingSeconds,
    double? totalProgressPoints,
    int? currentStreakDays,
    int? longestStreakDays,
    DateTime? lastReadDate,
    Map<String, double>? bookProgress,
  }) {
    return ReadingStats(
      totalBooksCompleted: totalBooksCompleted ?? this.totalBooksCompleted,
      totalSessionCount: totalSessionCount ?? this.totalSessionCount,
      totalReadingSeconds: totalReadingSeconds ?? this.totalReadingSeconds,
      totalProgressPoints: totalProgressPoints ?? this.totalProgressPoints,
      currentStreakDays: currentStreakDays ?? this.currentStreakDays,
      longestStreakDays: longestStreakDays ?? this.longestStreakDays,
      lastReadDate: lastReadDate ?? this.lastReadDate,
      bookProgress: bookProgress ?? this.bookProgress,
    );
  }
}
