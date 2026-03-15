import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:swf_app/src/api/api_client.dart';
import 'package:swf_app/src/api/api_result.dart';
import 'package:swf_app/src/api/paginated.dart';
import 'package:swf_app/src/auth/data/auth_repository.dart';
import 'package:swf_app/src/auth/data/session_store.dart';
import 'package:swf_app/src/auth/models/user.dart';
import 'package:swf_app/src/catalog/data/book_repository.dart';
import 'package:swf_app/src/catalog/models/book.dart';
import 'package:swf_app/src/catalog/models/taxonomy.dart';
import 'package:swf_app/src/catalog/presentation/catalog_page.dart';
import 'package:swf_app/src/catalog/presentation/widgets/book_tile.dart';
import 'package:swf_app/src/catalog/presentation/widgets/filter_bar.dart';
import 'package:swf_app/src/catalog/presentation/widgets/filter_sheet.dart';

void main() {
  test('search query counts as an active filter', () {
    const filters = ActiveFilters(searchQuery: 'dragon');

    expect(filters.hasActiveFilters, isTrue);
    expect(filters.activeFilterCount, 1);
  });

  testWidgets('book tile handles books without subgenres', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 220,
              child: BookTile(
                book: _book('1', 'No Shelf', subgenres: const []),
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(BookTile), findsOneWidget);
    expect(find.text('No Shelf'), findsWidgets);
    expect(find.text('Author Name'), findsOneWidget);
  });

  testWidgets('filter sheet renders backend taxonomy options', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FilterSheet(
            taxonomy: _taxonomy,
            filters: const ActiveFilters(),
            onApply: (_) {},
          ),
        ),
      ),
    );

    expect(find.text('Urban Fantasy'), findsOneWidget);
    expect(find.text('Found Family'), findsOneWidget);
    expect(find.text('Scorching'), findsOneWidget);
    expect(find.text('Young Adult'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('LGBTQ+'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('LGBTQ+'), findsOneWidget);
  });

  testWidgets('clear all resets the visible search field', (
    WidgetTester tester,
  ) async {
    final repository = FakeBookRepository(
      taxonomy: _taxonomy,
      onGetBooks: (_) async => Success(_page(const <Book>[])),
    );

    await tester.pumpWidget(
      MaterialApp(home: CatalogPage(repository: repository)),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'dragon');
    await tester.pump();

    expect(find.text('Clear all'), findsOneWidget);
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller?.text,
      'dragon',
    );

    await tester.tap(find.text('Clear all'));
    await tester.pumpAndSettle();

    expect(
      tester.widget<TextField>(find.byType(TextField)).controller?.text,
      isEmpty,
    );
  });

  testWidgets('latest search response wins when older requests finish later', (
    WidgetTester tester,
  ) async {
    final repository = FakeBookRepository(
      taxonomy: _taxonomy,
      onGetBooks: (call) async {
        if (call.search == 'dragon') {
          await Future<void>.delayed(const Duration(milliseconds: 50));
          return Success(_page(<Book>[_book('2', 'Dragonfall')]));
        }

        if (call.search == 'dark') {
          await Future<void>.delayed(const Duration(milliseconds: 400));
          return Success(_page(<Book>[_book('3', 'Darkwater')]));
        }

        return Success(_page(<Book>[_book('1', 'Starter Book')]));
      },
    );

    await tester.pumpWidget(
      MaterialApp(home: CatalogPage(repository: repository)),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'dark');
    await tester.pump(const Duration(milliseconds: 300));

    await tester.enterText(find.byType(TextField), 'dragon');
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 60));

    expect(find.text('Dragonfall'), findsWidgets);

    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Dragonfall'), findsWidgets);
    expect(find.text('Darkwater'), findsNothing);
  });

  testWidgets('page-one failure does not leave stale results visible', (
    WidgetTester tester,
  ) async {
    final repository = FakeBookRepository(
      taxonomy: _taxonomy,
      onGetBooks: (call) async {
        if (call.search == 'dragon') {
          return const Failure<Paginated<Book>>('Search failed');
        }

        return Success(_page(<Book>[_book('1', 'Starter Book')]));
      },
    );

    await tester.pumpWidget(
      MaterialApp(home: CatalogPage(repository: repository)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Starter Book'), findsWidgets);

    await tester.enterText(find.byType(TextField), 'dragon');
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    expect(find.text('Starter Book'), findsNothing);
    expect(find.text('Search failed'), findsOneWidget);
  });

  testWidgets('profile button opens the dedicated profile page', (
    WidgetTester tester,
  ) async {
    final repository = FakeBookRepository(
      taxonomy: _taxonomy,
      onGetBooks: (_) async =>
          Success(_page(<Book>[_book('1', 'Starter Book')])),
    );
    final sessionStore = SessionStore()
      ..save(
        token: 'token-123',
        user: const User(
          id: 'user-1',
          email: 'reader@example.com',
          name: 'Reader',
          role: 'reader',
        ),
      );
    final httpClient = MockClient((request) async {
      if (request.url.path == '/api/auth/me') {
        expect(
          request.headers[HttpHeaders.cookieHeader],
          'better-auth.session_token=token-123',
        );
        return http.Response(
          jsonEncode({
            'success': true,
            'data': {
              'user': {
                'id': 'user-1',
                'email': 'reader@example.com',
                'name': 'Reader',
                'role': 'reader',
              },
            },
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }

      throw UnimplementedError('Unexpected request: ${request.url}');
    });
    final apiClient = ApiClient(
      baseUrl: 'http://localhost',
      httpClient: httpClient,
    )..setSessionToken('token-123');
    final authRepository = AuthRepository(
      baseUrl: 'http://localhost',
      apiClient: apiClient,
      sessionStore: sessionStore,
      httpClient: httpClient,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: CatalogPage(
          repository: repository,
          authRepository: authRepository,
          sessionStore: sessionStore,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byTooltip('Profile'), findsOneWidget);

    await tester.tap(find.byTooltip('Profile'));
    await tester.pumpAndSettle();

    expect(find.text('Field Journal'), findsWidgets);
    expect(find.text('Reader Field Journal'), findsOneWidget);
    expect(find.text('reader@example.com'), findsWidgets);
    expect(find.text('Character Sheet'), findsOneWidget);
  });
}

final TaxonomyData _taxonomy = TaxonomyData(
  subgenres: const <TaxonomyItem>[
    TaxonomyItem(id: 'sub-1', name: 'Urban Fantasy'),
  ],
  tropes: const <TaxonomyItem>[
    TaxonomyItem(id: 'trope-1', name: 'Found Family'),
  ],
  spiceLevels: const <TaxonomyItem>[
    TaxonomyItem(id: 'spice-1', name: 'Scorching'),
  ],
  ageCategories: const <TaxonomyItem>[
    TaxonomyItem(id: 'age-1', name: 'Young Adult'),
  ],
  representations: const <TaxonomyItem>[
    TaxonomyItem(id: 'rep-1', name: 'LGBTQ+'),
  ],
);

Paginated<Book> _page(List<Book> books) {
  return Paginated<Book>(
    items: books,
    total: books.length,
    page: 1,
    limit: 18,
    totalPages: 1,
    hasNext: false,
    hasPrev: false,
  );
}

Book _book(
  String id,
  String title, {
  List<String> subgenres = const <String>['Urban Fantasy'],
}) {
  return Book(
    id: id,
    title: title,
    authorName: 'Author Name',
    imageUrl: '',
    subgenres: subgenres,
    tropes: const <String>[],
    spiceLevel: SpiceLevel.none,
    ageCategory: 'Adult',
  );
}

class GetBooksCall {
  const GetBooksCall({
    required this.page,
    required this.limit,
    required this.search,
    required this.subgenreIds,
    required this.tropeIds,
    required this.spiceLevelIds,
    required this.ageCategoryIds,
    required this.representationIds,
    required this.languageLevels,
    required this.kindleUnlimited,
    required this.hasAudiobook,
  });

  final int page;
  final int limit;
  final String? search;
  final List<String>? subgenreIds;
  final List<String>? tropeIds;
  final List<String>? spiceLevelIds;
  final List<String>? ageCategoryIds;
  final List<String>? representationIds;
  final List<String>? languageLevels;
  final bool? kindleUnlimited;
  final bool? hasAudiobook;
}

class FakeBookRepository extends BookRepository {
  FakeBookRepository({
    required TaxonomyData taxonomy,
    required Future<ApiResult<Paginated<Book>>> Function(GetBooksCall call)
    onGetBooks,
    ApiResult<TaxonomyData>? taxonomyResult,
  }) : _taxonomyData = taxonomyResult is Success<TaxonomyData>
           ? taxonomyResult.value
           : taxonomy,
       _taxonomyResult = taxonomyResult ?? Success(taxonomy),
       _onGetBooks = onGetBooks,
       super(apiClient: ApiClient(baseUrl: 'http://localhost'));

  final Future<ApiResult<Paginated<Book>>> Function(GetBooksCall call)
  _onGetBooks;
  final ApiResult<TaxonomyData> _taxonomyResult;
  final List<GetBooksCall> calls = <GetBooksCall>[];
  TaxonomyData _taxonomyData;

  @override
  TaxonomyData get taxonomy => _taxonomyData;

  @override
  Future<ApiResult<TaxonomyData>> loadTaxonomy({String locale = 'en'}) async {
    if (_taxonomyResult case Success<TaxonomyData>(:final value)) {
      _taxonomyData = value;
    }
    return _taxonomyResult;
  }

  @override
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
    bool? kindleUnlimited,
    bool? hasAudiobook,
  }) {
    final call = GetBooksCall(
      page: page,
      limit: limit,
      search: search,
      subgenreIds: subgenreIds,
      tropeIds: tropeIds,
      spiceLevelIds: spiceLevelIds,
      ageCategoryIds: ageCategoryIds,
      representationIds: representationIds,
      languageLevels: languageLevels,
      kindleUnlimited: kindleUnlimited,
      hasAudiobook: hasAudiobook,
    );
    calls.add(call);
    return _onGetBooks(call);
  }
}
