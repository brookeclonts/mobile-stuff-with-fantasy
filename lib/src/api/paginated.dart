/// Generic wrapper for paginated API responses.
///
/// Matches the shape returned by `/api/filter/books/all`:
/// ```json
/// { "books": [...], "total": 42, "page": 1, "limit": 18,
///   "totalPages": 3, "hasNext": true, "hasPrev": false }
/// ```
class Paginated<T> {
  const Paginated({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrev,
  });

  final List<T> items;
  final int total;
  final int page;
  final int limit;
  final int totalPages;
  final bool hasNext;
  final bool hasPrev;

  /// Parse a paginated response, using [itemsKey] to find the list
  /// and [fromJsonItem] to deserialize each element.
  static Paginated<T> fromJson<T>(
    Map<String, Object?> json, {
    required String itemsKey,
    required T Function(Map<String, Object?> json) fromJsonItem,
  }) {
    final rawItems = json[itemsKey] as List<Object?>? ?? [];
    return Paginated<T>(
      items: rawItems
          .cast<Map<String, Object?>>()
          .map(fromJsonItem)
          .toList(),
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 18,
      totalPages: json['totalPages'] as int? ?? 1,
      hasNext: json['hasNext'] as bool? ?? false,
      hasPrev: json['hasPrev'] as bool? ?? false,
    );
  }
}
