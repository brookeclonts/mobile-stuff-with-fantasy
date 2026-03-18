import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_epub_viewer/flutter_epub_viewer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swf_app/src/api/service_locator.dart';
import 'package:swf_app/src/reader/models/reader_book.dart';
import 'package:swf_app/src/theme/swf_colors.dart';

/// Full-screen EPUB reading experience.
class ReaderPage extends StatefulWidget {
  const ReaderPage({
    super.key,
    required this.book,
    required this.epubSource,
  });

  final ReaderBook book;
  final EpubSource epubSource;

  @override
  State<ReaderPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  final EpubController _epubController = EpubController();
  List<EpubChapter> _chapters = [];
  double _progress = 0.0;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    // Dim the status bar for a more immersive feel.
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  void _showChapterList() {
    if (_chapters.isEmpty) return;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _ChapterSheet(
        chapters: _chapters,
        onSelected: (chapter) {
          _epubController.display(cfi: chapter.href);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? SwfColors.brandDark : SwfColors.color8,
      appBar: AppBar(
        title: Text(
          widget.book.title,
          style: GoogleFonts.playfairDisplay(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          if (_chapters.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.list_rounded),
              tooltip: 'Chapters',
              onPressed: _showChapterList,
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                EpubViewer(
                  epubSource: widget.epubSource,
                  epubController: _epubController,
                  displaySettings: EpubDisplaySettings(
                    flow: EpubFlow.paginated,
                    snap: true,
                    theme: EpubTheme.custom(
                      customCss: {
                        'body': {
                          'color': isDark ? '#EFEDE9' : '#2F2E2E',
                          'background-color': isDark ? '#1E364B' : '#EFEDE9',
                        },
                        'a': {
                          'color': 'inherit',
                          'text-decoration': 'none',
                        },
                        '::selection': {
                          'background-color': '#B96D9A66',
                        },
                      },
                    ),
                  ),
                  initialCfi: widget.book.lastCfi,
                  onChaptersLoaded: (chapters) {
                    if (!mounted) return;
                    setState(() => _chapters = chapters);
                  },
                  onEpubLoaded: () {
                    if (!mounted) return;
                    setState(() => _isLoaded = true);
                  },
                  onRelocated: (location) {
                    if (!mounted) return;
                    setState(() {
                      _progress = location.progress;
                    });
                    ServiceLocator.readerRepository.updateProgress(
                      widget.book.id,
                      cfi: location.startCfi,
                      progress: location.progress,
                    );
                  },
                ),
                // Tap zones: left 30% = prev, right 30% = next
                if (_isLoaded)
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () => _epubController.prev(),
                          child: const SizedBox.expand(),
                        ),
                      ),
                      const Spacer(flex: 4),
                      Expanded(
                        flex: 3,
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () => _epubController.next(),
                          child: const SizedBox.expand(),
                        ),
                      ),
                    ],
                  ),
                if (!_isLoaded)
                  Center(
                    child: CircularProgressIndicator(
                      color: SwfColors.color4,
                    ),
                  ),
              ],
            ),
          ),
          // Thin progress bar along the bottom.
          LinearProgressIndicator(
            value: _progress,
            minHeight: 3,
            backgroundColor: isDark
                ? Colors.white.withAlpha(20)
                : SwfColors.color5,
            valueColor: const AlwaysStoppedAnimation(SwfColors.color4),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Chapter list bottom sheet
// ─────────────────────────────────────────────────────────────────────────────

class _ChapterSheet extends StatelessWidget {
  const _ChapterSheet({
    required this.chapters,
    required this.onSelected,
  });

  final List<EpubChapter> chapters;
  final ValueChanged<EpubChapter> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.6,
      ),
      decoration: BoxDecoration(
        color: isDark ? SwfColors.brandDark : SwfColors.color8,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 8),
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurfaceVariant.withAlpha(60),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Text(
              'Chapters',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const Divider(height: 1),
          Flexible(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: chapters.length,
              itemBuilder: (context, index) {
                final chapter = chapters[index];
                return ListTile(
                  dense: true,
                  title: Text(
                    chapter.title,
                    style: theme.textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () => onSelected(chapter),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
