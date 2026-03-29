/// Tracks a user's progress within a single seasonal campaign.
class SeasonalProgress {
  const SeasonalProgress({
    required this.campaignId,
    this.completedObjectiveIds = const {},
    this.revealedRewardIds = const {},
  });

  final String campaignId;
  final Set<String> completedObjectiveIds;
  final Set<String> revealedRewardIds;

  factory SeasonalProgress.fromJson(Object json) {
    final map = json as Map<String, dynamic>;
    return SeasonalProgress(
      campaignId: map['campaignId'] as String? ?? '',
      completedObjectiveIds: _toStringSet(map['completedObjectiveIds']),
      revealedRewardIds: _toStringSet(map['revealedRewardIds']),
    );
  }

  static Set<String> _toStringSet(Object? value) {
    if (value is List) {
      return value.map((e) => e.toString()).toSet();
    }
    return const {};
  }
}
