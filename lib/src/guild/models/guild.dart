class GuildMember {
  const GuildMember({
    required this.userId,
    required this.name,
    required this.role,
    required this.joinedAt,
  });

  final String userId;
  final String name;
  final String role; // 'guildmaster' | 'companion'
  final DateTime joinedAt;

  /// userId might be a populated object `{ _id, name }` or a plain string.
  factory GuildMember.fromJson(Map<String, Object?> json) {
    final rawUser = json['userId'];
    final String userId;
    final String fallbackName;
    if (rawUser is Map<String, Object?>) {
      userId = (rawUser['_id'] ?? rawUser['id'] ?? '').toString();
      fallbackName = rawUser['name']?.toString() ?? '';
    } else {
      userId = (rawUser ?? '').toString();
      fallbackName = '';
    }

    return GuildMember(
      userId: userId,
      name: (json['name'] ?? fallbackName).toString(),
      role: (json['role'] ?? 'companion').toString(),
      joinedAt: DateTime.parse(
        (json['joinedAt'] ?? json['createdAt'] ?? DateTime.now().toIso8601String())
            .toString(),
      ),
    );
  }
}

class GuildLedgerEntry {
  const GuildLedgerEntry({
    required this.id,
    required this.bookId,
    required this.addedBy,
    required this.addedAt,
  });

  final String id;
  final String bookId;
  final String addedBy;
  final DateTime addedAt;

  factory GuildLedgerEntry.fromJson(Map<String, Object?> json) {
    final rawAddedBy = json['addedBy'];
    final String addedBy;
    if (rawAddedBy is Map<String, Object?>) {
      addedBy = (rawAddedBy['_id'] ?? rawAddedBy['id'] ?? '').toString();
    } else {
      addedBy = (rawAddedBy ?? '').toString();
    }

    return GuildLedgerEntry(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      bookId: (json['bookId'] ?? '').toString(),
      addedBy: addedBy,
      addedAt: DateTime.parse(
        (json['addedAt'] ?? json['createdAt'] ?? DateTime.now().toIso8601String())
            .toString(),
      ),
    );
  }
}

class Guild {
  const Guild({
    required this.id,
    required this.name,
    required this.description,
    required this.createdBy,
    required this.memberCount,
    required this.isPublic,
    required this.members,
    required this.ledger,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String description;
  final String createdBy;
  final int memberCount;
  final bool isPublic;
  final List<GuildMember> members;
  final List<GuildLedgerEntry> ledger;
  final DateTime createdAt;

  factory Guild.fromJson(Object json) {
    final map = json as Map<String, Object?>;

    final rawCreatedBy = map['createdBy'];
    final String createdBy;
    if (rawCreatedBy is Map<String, Object?>) {
      createdBy = (rawCreatedBy['_id'] ?? rawCreatedBy['id'] ?? '').toString();
    } else {
      createdBy = (rawCreatedBy ?? '').toString();
    }

    final members = ((map['members'] as List?) ?? const [])
        .whereType<Map<String, Object?>>()
        .map(GuildMember.fromJson)
        .toList();

    final ledger = ((map['ledger'] as List?) ?? const [])
        .whereType<Map<String, Object?>>()
        .map(GuildLedgerEntry.fromJson)
        .toList();

    final rawMemberCount = map['memberCount'];
    final memberCount =
        rawMemberCount is int ? rawMemberCount : members.length;

    return Guild(
      id: (map['_id'] ?? map['id'] ?? '').toString(),
      name: (map['name'] ?? '').toString(),
      description: (map['description'] ?? '').toString(),
      createdBy: createdBy,
      memberCount: memberCount,
      isPublic: map['isPublic'] as bool? ?? true,
      members: members,
      ledger: ledger,
      createdAt: DateTime.parse(
        (map['createdAt'] ?? DateTime.now().toIso8601String()).toString(),
      ),
    );
  }
}
