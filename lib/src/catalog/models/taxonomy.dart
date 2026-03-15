/// A single taxonomy item (subgenre, trope, spice level, age category, or representation).
///
/// All taxonomy endpoints return `{ _id, name, ... }` objects.
class TaxonomyItem {
  const TaxonomyItem({required this.id, required this.name});

  factory TaxonomyItem.fromJson(Map<String, Object?> json) {
    return TaxonomyItem(
      id: json['_id'] as String,
      name: json['name'] as String,
    );
  }

  final String id;
  final String name;

  Map<String, Object?> toJson() => {'_id': id, 'name': name};

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaxonomyItem &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'TaxonomyItem($id, $name)';
}

/// All taxonomy data needed by the filter UI, fetched once and cached.
class TaxonomyData {
  const TaxonomyData({
    this.subgenres = const [],
    this.tropes = const [],
    this.spiceLevels = const [],
    this.ageCategories = const [],
    this.representations = const [],
  });

  final List<TaxonomyItem> subgenres;
  final List<TaxonomyItem> tropes;
  final List<TaxonomyItem> spiceLevels;
  final List<TaxonomyItem> ageCategories;
  final List<TaxonomyItem> representations;

  /// Build a lookup from ObjectId → display name across all categories.
  Map<String, String> get nameIndex {
    final index = <String, String>{};
    for (final list in [subgenres, tropes, spiceLevels, ageCategories, representations]) {
      for (final item in list) {
        index[item.id] = item.name;
      }
    }
    return index;
  }

  bool get isEmpty =>
      subgenres.isEmpty &&
      tropes.isEmpty &&
      spiceLevels.isEmpty &&
      ageCategories.isEmpty &&
      representations.isEmpty;
}
