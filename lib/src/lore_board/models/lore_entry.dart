enum LoreEntryType {
  questSealed,
  relicClaimed,
  oathSworn,
  oathProgress,
  oathFulfilled,
  guildFounded,
  guildJoined,
  bookLogged,
  unknown;

  static LoreEntryType fromString(String value) {
    return switch (value) {
      'quest_sealed' => questSealed,
      'relic_claimed' => relicClaimed,
      'oath_sworn' => oathSworn,
      'oath_progress' => oathProgress,
      'oath_fulfilled' => oathFulfilled,
      'guild_founded' => guildFounded,
      'guild_joined' => guildJoined,
      'book_logged' => bookLogged,
      _ => unknown,
    };
  }
}

class LoreEntry {
  const LoreEntry({
    required this.id,
    required this.userId,
    this.userName,
    required this.type,
    required this.message,
    required this.metadata,
    required this.createdAt,
  });

  final String id;
  final String userId;
  final String? userName;
  final LoreEntryType type;
  final String message;
  final Map<String, Object?> metadata;
  final DateTime createdAt;

  factory LoreEntry.fromJson(Map<String, Object?> json) {
    // userId can be populated { _id, name } or plain string
    final rawUser = json['userId'];
    final String userId;
    final String? userName;
    if (rawUser is Map<String, Object?>) {
      userId = (rawUser['_id'] ?? rawUser['id'] ?? '').toString();
      userName = rawUser['name']?.toString();
    } else {
      userId = (rawUser ?? '').toString();
      userName = null;
    }

    return LoreEntry(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      userId: userId,
      userName: userName,
      type: LoreEntryType.fromString(
        (json['type'] ?? '').toString(),
      ),
      message: (json['message'] ?? '').toString(),
      metadata: (json['metadata'] as Map<String, Object?>?) ?? const {},
      createdAt: DateTime.parse(
        (json['createdAt'] ?? '').toString(),
      ),
    );
  }
}
