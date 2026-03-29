/// Unified gamification state returned by the API.
///
/// Holds all progress data: completed objectives, revealed rewards,
/// seasonal progress, skill tree, and leaderboard opt-in status.
class GamificationState {
  const GamificationState({
    this.completedObjectiveIds = const {},
    this.revealedRewardIds = const {},
    this.leaderboardOptIn = false,
    this.leaderboardPosition,
  });

  final Set<String> completedObjectiveIds;
  final Set<String> revealedRewardIds;
  final bool leaderboardOptIn;
  final int? leaderboardPosition;

  factory GamificationState.fromJson(Object json) {
    final map = json as Map<String, dynamic>;
    return GamificationState(
      completedObjectiveIds: _toStringSet(map['completedObjectiveIds']),
      revealedRewardIds: _toStringSet(map['revealedRewardIds']),
      leaderboardOptIn: map['leaderboardOptIn'] as bool? ?? false,
      leaderboardPosition: map['leaderboardPosition'] as int?,
    );
  }

  static Set<String> _toStringSet(Object? value) {
    if (value is List) {
      return value.map((e) => e.toString()).toSet();
    }
    return const {};
  }
}
