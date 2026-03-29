class RecommendationPairing {
  const RecommendationPairing({
    required this.id,
    required this.userId,
    required this.sourceBookId,
    required this.targetBookId,
    required this.reason,
    required this.createdAt,
    this.sourceTitle = '',
    this.sourceAuthor = '',
    this.sourceImageUrl = '',
    this.targetTitle = '',
    this.targetAuthor = '',
    this.targetImageUrl = '',
    this.userName = '',
  });

  final String id;
  final String userId;
  final String sourceBookId;
  final String targetBookId;
  final String reason;
  final DateTime createdAt;
  final String sourceTitle;
  final String sourceAuthor;
  final String sourceImageUrl;
  final String targetTitle;
  final String targetAuthor;
  final String targetImageUrl;
  final String userName;

  factory RecommendationPairing.fromJson(Object json) {
    final map = json as Map<String, Object?>;
    return RecommendationPairing(
      id: (map['_id'] ?? map['id'] ?? '').toString(),
      userId: (map['userId'] ?? '').toString(),
      sourceBookId: (map['sourceBookId'] ?? '').toString(),
      targetBookId: (map['targetBookId'] ?? '').toString(),
      reason: map['reason']?.toString() ?? '',
      createdAt: DateTime.tryParse(map['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      sourceTitle: map['sourceTitle']?.toString() ?? '',
      sourceAuthor: map['sourceAuthor']?.toString() ?? '',
      sourceImageUrl: map['sourceImageUrl']?.toString() ?? '',
      targetTitle: map['targetTitle']?.toString() ?? '',
      targetAuthor: map['targetAuthor']?.toString() ?? '',
      targetImageUrl: map['targetImageUrl']?.toString() ?? '',
      userName: map['userName']?.toString() ?? '',
    );
  }
}
