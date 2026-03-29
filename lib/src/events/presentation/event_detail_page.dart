import 'package:flutter/material.dart';
import 'package:swf_app/l10n/app_localizations.dart';
import 'package:swf_app/src/api/service_locator.dart';
import 'package:swf_app/src/catalog/models/book.dart';
import 'package:swf_app/src/catalog/presentation/book_detail_page.dart';
import 'package:swf_app/src/catalog/presentation/widgets/book_tile.dart';
import 'package:swf_app/src/events/models/event.dart';
import 'package:swf_app/src/theme/swf_colors.dart';

class EventDetailPage extends StatefulWidget {
  const EventDetailPage({super.key, required this.event});

  final Event event;

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  List<Book> _books = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    final result = await ServiceLocator.eventRepository
        .fetchEventBooks(widget.event.id);
    if (!mounted) return;

    result.when(
      success: (paginated) => setState(() {
        _books = paginated.items;
        _isLoading = false;
      }),
      failure: (message, _) => setState(() {
        _error = message;
        _isLoading = false;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final event = widget.event;
    final hasImage = event.bannerImage.isNotEmpty;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── Hero app bar ──
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: SwfColors.brandDark,
            foregroundColor: SwfColors.color8,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (hasImage)
                    Image.network(
                      event.bannerImage,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => _gradientBackground(),
                    )
                  else
                    _gradientBackground(),
                  // Scrim
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black26,
                          Colors.transparent,
                          Colors.black54,
                        ],
                        stops: [0.0, 0.4, 1.0],
                      ),
                    ),
                  ),
                  // Event info overlay
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          event.name,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            _Pill(label: event.localizedStatusLabel(AppLocalizations.of(context)!)),
                            const SizedBox(width: 8),
                            Text(
                              event.localizedDateRangeLabel(AppLocalizations.of(context)!),
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Description ──
          if (event.description.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Text(
                  event.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
              ),
            ),

          // ── Books header ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Text(
                _isLoading
                    ? l10n.eventDetailLoadingBooks
                    : l10n.eventDetailBookCount(_books.length),
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          // ── Loading / error / grid ──
          if (_isLoading)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),

          if (_error != null)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: Text(
                    _error!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                ),
              ),
            ),

          if (!_isLoading && _books.isNotEmpty)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final book = _books[index];
                    return BookTile(
                      book: book,
                      onTap: () => Navigator.push<void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) => BookDetailPage(book: book),
                        ),
                      ),
                    );
                  },
                  childCount: _books.length,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      MediaQuery.sizeOf(context).width >= 600 ? 3 : 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.48,
                ),
              ),
            ),

          if (!_isLoading && _error == null && _books.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: Text(
                    l10n.eventDetailNoBooksYet,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),

          const SliverPadding(padding: EdgeInsets.only(bottom: 40)),
        ],
      ),
    );
  }

  Widget _gradientBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [SwfColors.color3, SwfColors.color2],
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(30),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withAlpha(50)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.white.withAlpha(220),
              fontWeight: FontWeight.w600,
              fontSize: 10,
            ),
      ),
    );
  }
}
