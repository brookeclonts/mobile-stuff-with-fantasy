/// Metrics that can be used to rank users on the leaderboard.
enum LeaderboardMetric { questsSealed, booksRead, relicsCollected }

/// A single entry (row) in the leaderboard.
class LeaderboardEntry {
  const LeaderboardEntry({
    required this.userId,
    required this.userName,
    required this.rankTitle,
    required this.score,
    required this.position,
    this.isCurrentUser = false,
  });

  final String userId;
  final String userName;
  final String rankTitle;
  final int score;
  final int position;
  final bool isCurrentUser;

  factory LeaderboardEntry.fromJson(Object json) {
    final map = json as Map<String, dynamic>;
    return LeaderboardEntry(
      userId: map['userId'] as String? ?? '',
      userName: map['userName'] as String? ?? '',
      rankTitle: map['rankTitle'] as String? ?? '',
      score: map['score'] as int? ?? 0,
      position: map['position'] as int? ?? 0,
      isCurrentUser: map['isCurrentUser'] as bool? ?? false,
    );
  }
}

/// A page of leaderboard results including the user's own position.
class LeaderboardPage {
  const LeaderboardPage({
    required this.entries,
    required this.metric,
    required this.userPosition,
    required this.total,
  });

  final List<LeaderboardEntry> entries;
  final LeaderboardMetric metric;
  final int userPosition;
  final int total;

  factory LeaderboardPage.fromJson(Object json) {
    final map = json as Map<String, dynamic>;
    final metricStr = map['metric'] as String? ?? 'questsSealed';
    final metric = LeaderboardMetric.values.firstWhere(
      (m) => m.name == metricStr,
      orElse: () => LeaderboardMetric.questsSealed,
    );
    final entriesJson = map['entries'] as List<dynamic>? ?? [];
    return LeaderboardPage(
      entries: entriesJson
          .map((e) => LeaderboardEntry.fromJson(e as Object))
          .toList(),
      metric: metric,
      userPosition: map['userPosition'] as int? ?? 0,
      total: map['total'] as int? ?? 0,
    );
  }
}
