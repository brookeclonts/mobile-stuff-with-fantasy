import 'package:swf_app/l10n/app_localizations.dart';

class Book {
  const Book({
    required this.id,
    required this.title,
    required this.authorName,
    required this.imageUrl,
    required this.subgenres,
    required this.tropes,
    required this.spiceLevel,
    required this.ageCategory,
    this.description = '',
    this.purchaseLink = '',
    this.alternatePurchaseLink = '',
    this.audiobookLink = '',
    this.amazonAsin = '',
    this.representations = const [],
    this.languageLevel = LanguageLevel.clean,
    this.kindleUnlimited = false,
    this.hasAudiobook = false,
    this.distribution,
    this.userId,
    this.favoritedBy = const [],
  });

  /// Create a minimal Book with just display info (for use in review editing).
  factory Book.minimal({
    required String id,
    required String title,
    required String authorName,
    required String imageUrl,
  }) {
    return Book(
      id: id,
      title: title,
      authorName: authorName,
      imageUrl: imageUrl,
      subgenres: const [],
      tropes: const [],
      spiceLevel: SpiceLevel.none,
      ageCategory: '',
    );
  }

  /// Parse a book from the catalog list response.
  ///
  /// Taxonomy fields come as raw ObjectId strings from `/api/filter/books/all`.
  /// Pass [nameIndex] (from [TaxonomyData.nameIndex]) to resolve them to
  /// display names. If omitted, the raw IDs are used as-is.
  factory Book.fromJson(
    Map<String, Object?> json, {
    Map<String, String> nameIndex = const {},
  }) {
    /// Resolve an ObjectId to its display name via the taxonomy index.
    /// Returns null if the ID is unresolvable (missing from taxonomy).
    String? resolve(Object? id) {
      final key = id is String ? id : '';
      if (key.isEmpty) return null;
      return nameIndex[key] ??
          (RegExp(r'^[0-9a-f]{24}$').hasMatch(key) ? null : key);
    }

    List<String> resolveList(Object? raw) {
      if (raw is! List) return const [];
      return raw.map((e) => resolve(e)).whereType<String>().toList();
    }

    final audiobookLink = json['audiobook_link'] as String? ?? '';

    return Book(
      id: json['_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      authorName: json['author_name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? '',
      purchaseLink: json['purchase_link'] as String? ?? '',
      alternatePurchaseLink: json['alternate_purchase_link'] as String? ?? '',
      audiobookLink: audiobookLink,
      amazonAsin: json['amazonASIN'] as String? ?? '',
      subgenres: resolveList(json['subgenres']),
      tropes: resolveList(json['tropes']),
      spiceLevel: _parseSpiceLevel(resolve(json['spiceLevel']) ?? ''),
      ageCategory: resolve(json['ageCategory']) ?? '',
      representations: resolveList(json['representations']),
      languageLevel: _parseLanguageLevel(json['languageLevel']),
      kindleUnlimited: json['kindleUnlimited'] as bool? ?? false,
      hasAudiobook: audiobookLink.isNotEmpty,
      distribution: BookDistributionInfo.fromJson(json['distribution']),
      userId: json['user'] as String?,
      favoritedBy: (json['favoritedBy'] as List?)?.cast<String>() ?? const [],
    );
  }

  /// Parse a fully-populated book from `/api/books/[id]`.
  ///
  /// Taxonomy fields arrive as `{ _id, name }` objects instead of bare IDs.
  factory Book.fromDetailJson(Map<String, Object?> json) {
    String nameFrom(Object? obj) {
      if (obj is Map<String, Object?>) return obj['name'] as String? ?? '';
      return obj as String? ?? '';
    }

    List<String> namesFromList(Object? raw) {
      if (raw is! List) return const [];
      return raw.map(nameFrom).toList();
    }

    final audiobookLink = json['audiobook_link'] as String? ?? '';

    return Book(
      id: json['_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      authorName: json['author_name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? '',
      purchaseLink: json['purchase_link'] as String? ?? '',
      alternatePurchaseLink: json['alternate_purchase_link'] as String? ?? '',
      audiobookLink: audiobookLink,
      amazonAsin: json['amazonASIN'] as String? ?? '',
      subgenres: namesFromList(json['subgenres']),
      tropes: namesFromList(json['tropes']),
      spiceLevel: _parseSpiceLevel(nameFrom(json['spiceLevel'])),
      ageCategory: nameFrom(json['ageCategory']),
      representations: namesFromList(json['representations']),
      languageLevel: _parseLanguageLevel(json['languageLevel']),
      kindleUnlimited: json['kindleUnlimited'] as bool? ?? false,
      hasAudiobook: audiobookLink.isNotEmpty,
      distribution: BookDistributionInfo.fromJson(json['distribution']),
      userId: _extractUserId(json['userId']),
      favoritedBy: (json['favoritedBy'] as List?)?.cast<String>() ?? const [],
    );
  }

  final String id;
  final String title;
  final String authorName;
  final String description;
  final String imageUrl;
  final String purchaseLink;
  final String alternatePurchaseLink;
  final String audiobookLink;
  final String amazonAsin;
  final List<String> subgenres;
  final List<String> tropes;
  final SpiceLevel spiceLevel;
  final String ageCategory;
  final List<String> representations;
  final LanguageLevel languageLevel;
  final bool kindleUnlimited;
  final bool hasAudiobook;
  final BookDistributionInfo? distribution;
  final String? userId;
  final List<String> favoritedBy;

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  static SpiceLevel _parseSpiceLevel(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('scorching')) return SpiceLevel.scorching;
    if (lower.contains('hot')) return SpiceLevel.hot;
    if (lower.contains('medium')) return SpiceLevel.medium;
    if (lower.contains('mild')) return SpiceLevel.mild;
    return SpiceLevel.none;
  }

  static LanguageLevel _parseLanguageLevel(Object? raw) {
    final value = (raw as String?)?.toLowerCase() ?? '';
    return switch (value) {
      'strong' => LanguageLevel.strong,
      'moderate' => LanguageLevel.moderate,
      'mild' => LanguageLevel.mild,
      _ => LanguageLevel.clean,
    };
  }

  static String? _extractUserId(Object? raw) {
    if (raw is Map<String, Object?>) return raw['_id'] as String?;
    return raw as String?;
  }
}

class BookDistributionInfo {
  const BookDistributionInfo({
    this.enabled = false,
    this.price,
    this.epubUrl = '',
    this.pdfUrl = '',
  });

  final bool enabled;
  final double? price;
  final String epubUrl;
  final String pdfUrl;

  bool get hasEpub => epubUrl.isNotEmpty;
  bool get hasPdf => pdfUrl.isNotEmpty;

  factory BookDistributionInfo.fromJson(Object? json) {
    if (json is! Map<String, Object?>) return const BookDistributionInfo();
    return BookDistributionInfo(
      enabled: json['enabled'] as bool? ?? false,
      price: (json['price'] as num?)?.toDouble(),
      epubUrl: json['epubUrl'] as String? ?? '',
      pdfUrl: json['pdfUrl'] as String? ?? '',
    );
  }
}

enum SpiceLevel {
  none,
  mild,
  medium,
  hot,
  scorching;

  String localizedLabel(AppLocalizations l10n) => switch (this) {
        SpiceLevel.none => l10n.spiceLevelNone,
        SpiceLevel.mild => l10n.spiceLevelMild,
        SpiceLevel.medium => l10n.spiceLevelMedium,
        SpiceLevel.hot => l10n.spiceLevelHot,
        SpiceLevel.scorching => l10n.spiceLevelScorching,
      };
}

enum LanguageLevel {
  clean,
  mild,
  moderate,
  strong;

  String localizedLabel(AppLocalizations l10n) => switch (this) {
        LanguageLevel.clean => l10n.languageLevelClean,
        LanguageLevel.mild => l10n.languageLevelMild,
        LanguageLevel.moderate => l10n.languageLevelModerate,
        LanguageLevel.strong => l10n.languageLevelStrong,
      };
}
