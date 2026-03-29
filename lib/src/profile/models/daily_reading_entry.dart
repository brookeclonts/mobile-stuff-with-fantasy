class DailyReadingEntry {
  const DailyReadingEntry({
    required this.dateKey,
    this.totalSeconds = 0,
    this.progressDelta = 0.0,
    this.sessionCount = 0,
  });

  /// Date in 'yyyy-MM-dd' format.
  final String dateKey;
  final int totalSeconds;
  final double progressDelta;
  final int sessionCount;

  Map<String, Object?> toJson() => {
        'dateKey': dateKey,
        'totalSeconds': totalSeconds,
        'progressDelta': progressDelta,
        'sessionCount': sessionCount,
      };

  factory DailyReadingEntry.fromJson(Map<String, Object?> json) {
    return DailyReadingEntry(
      dateKey: json['dateKey'] as String? ?? '',
      totalSeconds: (json['totalSeconds'] as num?)?.toInt() ?? 0,
      progressDelta: (json['progressDelta'] as num?)?.toDouble() ?? 0.0,
      sessionCount: (json['sessionCount'] as num?)?.toInt() ?? 0,
    );
  }

  DailyReadingEntry merge(DailyReadingEntry other) {
    return DailyReadingEntry(
      dateKey: dateKey,
      totalSeconds: totalSeconds + other.totalSeconds,
      progressDelta: progressDelta + other.progressDelta,
      sessionCount: sessionCount + other.sessionCount,
    );
  }
}
