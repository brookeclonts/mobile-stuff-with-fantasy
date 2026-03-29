import 'package:swf_app/l10n/app_localizations.dart';
import 'package:swf_app/src/catalog/models/book.dart';
import 'package:swf_app/src/creators/models/social_links.dart';

enum CreatorRole {
  author,
  influencer,
  admin;

  factory CreatorRole.fromString(String value) {
    return switch (value) {
      'author' => CreatorRole.author,
      'admin' => CreatorRole.admin,
      _ => CreatorRole.influencer,
    };
  }

  String localizedLabel(AppLocalizations l10n) => switch (this) {
        CreatorRole.author || CreatorRole.admin => l10n.creatorRoleAuthor,
        CreatorRole.influencer => l10n.creatorRoleInfluencer,
      };

  bool get isAuthor => this == CreatorRole.author || this == CreatorRole.admin;
}

class Creator {
  const Creator({
    required this.id,
    required this.name,
    required this.slug,
    required this.role,
    this.bio = '',
    this.imageUrl = '',
    this.favoriteBook = '',
    this.favoriteSubgenres = '',
    this.books = const [],
    this.favoriteBooks = const [],
    this.socialLinks = const SocialLinks(),
  });

  /// Parse from the GET /api/influencers list response (minimal fields).
  factory Creator.fromListJson(Map<String, Object?> json) {
    return Creator(
      id: json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? '',
      role: CreatorRole.fromString(json['role'] as String? ?? ''),
      socialLinks: _parseSocialLinks(json['socialLinks']),
    );
  }

  /// Parse from the GET /api/influencer/[identifier] detail response.
  factory Creator.fromDetailJson(Map<String, Object?> json) {
    return Creator(
      id: json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? '',
      role: CreatorRole.fromString(json['role'] as String? ?? ''),
      bio: json['bio'] as String? ?? '',
      favoriteBook: json['favorite_book'] as String? ?? '',
      favoriteSubgenres: json['favoriteSubgenres'] as String? ?? '',
      books: _parseBooks(json['books']),
      favoriteBooks: _parseBooks(json['favoriteBooks']),
      socialLinks: _parseSocialLinks(json['socialLinks']),
    );
  }

  final String id;
  final String name;
  final String slug;
  final String imageUrl;
  final CreatorRole role;
  final String bio;
  final String favoriteBook;
  final String favoriteSubgenres;
  final List<Book> books;
  final List<Book> favoriteBooks;
  final SocialLinks socialLinks;

  /// Books to display — authors show their own books, influencers show favorites.
  List<Book> get displayBooks => role.isAuthor ? books : favoriteBooks;

  String localizedBooksLabel(AppLocalizations l10n) =>
      role.isAuthor ? l10n.creatorDetailBooksBy(name) : l10n.creatorDetailRecommendedBy(name);

  static SocialLinks _parseSocialLinks(Object? raw) {
    if (raw is Map<String, Object?>) return SocialLinks.fromJson(raw);
    return const SocialLinks();
  }

  static List<Book> _parseBooks(Object? raw) {
    if (raw is! List) return const [];
    return raw
        .whereType<Map<String, Object?>>()
        .map((b) => Book.fromDetailJson(b))
        .toList();
  }
}
