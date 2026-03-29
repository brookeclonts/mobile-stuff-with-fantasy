class ReadingSession {
  ReadingSession({
    required this.bookId,
    required this.bookTitle,
    required this.startedAt,
    required this.progressStart,
  });

  final String bookId;
  final String bookTitle;
  final DateTime startedAt;
  final double progressStart;

  double latestProgress = 0.0;
}
