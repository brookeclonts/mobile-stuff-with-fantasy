import 'dart:async';

import 'package:flutter/material.dart';
import 'package:swf_app/src/api/service_locator.dart';
import 'package:swf_app/src/catalog/models/book.dart';
import 'package:swf_app/src/theme/swf_colors.dart';

const _sheetBg = Color(0xFF2A2235);
const _parchment = Color(0xFFF4F0E8);

/// Full-height modal bottom sheet for selecting a book.
///
/// Uses [BookRepository.getBooks] with search. Returns the selected [Book]
/// via [onBookSelected] and pops the sheet.
Future<void> showBookPicker(
  BuildContext context, {
  required ValueChanged<Book> onBookSelected,
  String? excludeBookId,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _BookPickerSheet(
      onBookSelected: onBookSelected,
      excludeBookId: excludeBookId,
    ),
  );
}

class _BookPickerSheet extends StatefulWidget {
  const _BookPickerSheet({
    required this.onBookSelected,
    this.excludeBookId,
  });

  final ValueChanged<Book> onBookSelected;
  final String? excludeBookId;

  @override
  State<_BookPickerSheet> createState() => _BookPickerSheetState();
}

class _BookPickerSheetState extends State<_BookPickerSheet> {
  final _searchController = TextEditingController();
  Timer? _debounce;
  List<Book> _results = [];
  bool _loading = false;
  bool _initialLoad = true;

  @override
  void initState() {
    super.initState();
    _search('');
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _search(query);
    });
  }

  Future<void> _search(String query) async {
    setState(() => _loading = true);

    final result = await ServiceLocator.bookRepository.getBooks(
      search: query.isEmpty ? null : query,
      limit: 30,
    );

    if (!mounted) return;

    result.when(
      success: (paginated) {
        var books = paginated.items;
        if (widget.excludeBookId != null) {
          books = books.where((b) => b.id != widget.excludeBookId).toList();
        }
        setState(() {
          _results = books;
          _loading = false;
          _initialLoad = false;
        });
      },
      failure: (_, _) {
        setState(() {
          _loading = false;
          _initialLoad = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.85;

    return Container(
      height: maxHeight,
      decoration: const BoxDecoration(
        color: _sheetBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 36,
            height: 4,
            margin: const EdgeInsets.only(top: 8, bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(60),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Title
          Text(
            'SELECT A BOOK',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: SwfColors.secondaryAccent,
              letterSpacing: 2.0,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),

          // Search field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              style: const TextStyle(color: Color(0xFF2A1F1A), fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Search by title or author...',
                hintStyle: TextStyle(
                  color: const Color(0xFF5C4F42).withAlpha(140),
                  fontSize: 14,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Color(0xFF5C4F42),
                  size: 20,
                ),
                filled: true,
                fillColor: _parchment,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: SwfColors.secondaryAccent.withAlpha(80),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: SwfColors.secondaryAccent.withAlpha(80),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: SwfColors.secondaryAccent,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Results
          Expanded(
            child: _loading && _initialLoad
                ? const Center(
                    child: CircularProgressIndicator(
                      color: SwfColors.secondaryAccent,
                    ),
                  )
                : _results.isEmpty
                    ? Center(
                        child: Text(
                          _searchController.text.isEmpty
                              ? 'No books available'
                              : 'No books found',
                          style: TextStyle(
                            color: Colors.white.withAlpha(140),
                            fontSize: 14,
                          ),
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.55,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: _results.length,
                        itemBuilder: (context, index) {
                          final book = _results[index];
                          return _BookPickerTile(
                            book: book,
                            onTap: () {
                              widget.onBookSelected(book);
                              Navigator.of(context).pop();
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class _BookPickerTile extends StatelessWidget {
  const _BookPickerTile({required this.book, required this.onTap});

  final Book book;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: book.imageUrl.isNotEmpty
                  ? Image.network(
                      book.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => _CoverFallback(book: book),
                    )
                  : _CoverFallback(book: book),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            book.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (book.authorName.isNotEmpty)
            Text(
              book.authorName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white.withAlpha(140),
                fontSize: 11,
              ),
            ),
        ],
      ),
    );
  }
}

class _CoverFallback extends StatelessWidget {
  const _CoverFallback({required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    final hue = (book.id.hashCode % 360).abs().toDouble();
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            HSLColor.fromAHSL(1, hue, 0.3, 0.25).toColor(),
            HSLColor.fromAHSL(1, (hue + 40) % 360, 0.3, 0.15).toColor(),
          ],
        ),
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8),
      child: Text(
        book.title,
        textAlign: TextAlign.center,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.white.withAlpha(180),
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
