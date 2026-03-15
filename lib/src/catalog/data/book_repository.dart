import 'package:swf_app/src/api/api_client.dart';
import 'package:swf_app/src/api/api_result.dart';
import 'package:swf_app/src/api/paginated.dart';
import 'package:swf_app/src/catalog/models/book.dart';
import 'package:swf_app/src/catalog/models/taxonomy.dart';

/// Data access for books and taxonomy.
///
/// All methods return [ApiResult] so callers handle success/failure uniformly.
/// Taxonomy data is fetched once and cached in memory — call [loadTaxonomy]
/// on app startup or pull-to-refresh to populate it.
class BookRepository {
  BookRepository({required ApiClient apiClient}) : _api = apiClient;

  final ApiClient _api;

  /// Cached taxonomy lookup table (ObjectId → display name).
  TaxonomyData _taxonomy = const TaxonomyData();
  TaxonomyData get taxonomy => _taxonomy;

  // ---------------------------------------------------------------------------
  // Taxonomy
  // ---------------------------------------------------------------------------

  /// Fetch all five taxonomy lists in parallel and cache them.
  Future<ApiResult<TaxonomyData>> loadTaxonomy({String locale = 'en'}) async {
    final params = {'locale': locale};

    final results = await Future.wait([
      _api.get<List<TaxonomyItem>>(
        '/api/subgenres',
        queryParams: params,
        fromJson: _parseTaxonomyList,
      ),
      _api.get<List<TaxonomyItem>>(
        '/api/tropes',
        queryParams: params,
        fromJson: _parseTaxonomyList,
      ),
      _api.get<List<TaxonomyItem>>(
        '/api/spicelevels',
        queryParams: params,
        fromJson: _parseTaxonomyList,
      ),
      _api.get<List<TaxonomyItem>>(
        '/api/agecategories',
        queryParams: params,
        fromJson: _parseTaxonomyList,
      ),
      _api.get<List<TaxonomyItem>>(
        '/api/representation',
        queryParams: params,
        fromJson: _parseTaxonomyList,
      ),
    ]);

    // If any request failed, return the first failure.
    for (final r in results) {
      if (r is Failure<List<TaxonomyItem>>) {
        return Failure(r.message, statusCode: r.statusCode);
      }
    }

    _taxonomy = TaxonomyData(
      subgenres: results[0].data,
      tropes: results[1].data,
      spiceLevels: results[2].data,
      ageCategories: results[3].data,
      representations: results[4].data,
    );

    return Success(_taxonomy);
  }

  // ---------------------------------------------------------------------------
  // Book catalog (paginated + filtered)
  // ---------------------------------------------------------------------------

  /// Fetch the main book catalog with optional filters.
  ///
  /// Uses POST `/api/filter/books/all` so array filter values are sent cleanly
  /// in the request body.
  Future<ApiResult<Paginated<Book>>> getBooks({
    int page = 1,
    int limit = 18,
    String? search,
    List<String>? subgenreIds,
    List<String>? tropeIds,
    List<String>? spiceLevelIds,
    List<String>? ageCategoryIds,
    List<String>? representationIds,
    List<String>? languageLevels,
    bool? hasAudiobook,
  }) {
    final body = <String, Object?>{
      'page': page,
      'limit': limit,
      if (search != null && search.isNotEmpty) 'search': search,
      if (subgenreIds != null && subgenreIds.isNotEmpty)
        'subgenres': subgenreIds,
      if (tropeIds != null && tropeIds.isNotEmpty) 'tropes': tropeIds,
      if (spiceLevelIds != null && spiceLevelIds.isNotEmpty)
        'spiceLevel': spiceLevelIds,
      if (ageCategoryIds != null && ageCategoryIds.isNotEmpty)
        'ageCategory': ageCategoryIds,
      if (representationIds != null && representationIds.isNotEmpty)
        'representations': representationIds,
      if (languageLevels != null && languageLevels.isNotEmpty)
        'languageLevel': languageLevels,
      if (hasAudiobook == true) 'hasAudiobook': true,
    };

    final nameIndex = _taxonomy.nameIndex;

    return _api.post<Paginated<Book>>(
      '/api/filter/books/all',
      body: body,
      fromJson: (json) => Paginated.fromJson(
        json as Map<String, Object?>,
        itemsKey: 'books',
        fromJsonItem: (j) => Book.fromJson(j, nameIndex: nameIndex),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Single book detail
  // ---------------------------------------------------------------------------

  /// Fetch a single book with fully populated taxonomy fields.
  Future<ApiResult<Book>> getBook(String id) {
    return _api.get<Book>(
      '/api/books/$id',
      fromJson: (json) => Book.fromDetailJson(json as Map<String, Object?>),
    );
  }

  // ---------------------------------------------------------------------------
  // Similar books
  // ---------------------------------------------------------------------------

  /// Fetch up to 8 books similar to the given book.
  Future<ApiResult<List<Book>>> getSimilarBooks(String bookId) {
    return _api.get<List<Book>>(
      '/api/books/$bookId/similar',
      fromJson: (json) => (json as List)
          .cast<Map<String, Object?>>()
          .map((j) => Book.fromDetailJson(j))
          .toList(),
    );
  }

  // ---------------------------------------------------------------------------
  // Internals
  // ---------------------------------------------------------------------------

  static List<TaxonomyItem> _parseTaxonomyList(Object json) {
    final list = json as List;
    return list
        .cast<Map<String, Object?>>()
        .map(TaxonomyItem.fromJson)
        .toList();
  }
}
