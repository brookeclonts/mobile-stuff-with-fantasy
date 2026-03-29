import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pretext/pretext.dart';
import 'package:swf_app/l10n/app_localizations.dart';
import 'package:swf_app/src/api/service_locator.dart';
import 'package:swf_app/src/reader/models/reader_book.dart';
import 'package:swf_app/src/theme/swf_colors.dart';

/// Full-screen EPUB reading experience powered by pretext.
class ReaderPage extends StatefulWidget {
  const ReaderPage({super.key, required this.book, required this.epubResult});

  final ReaderBook book;
  final EpubLoadResult epubResult;

  @override
  State<ReaderPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  static const double _minFontSize = 15;
  static const double _maxFontSize = 22;

  final _readerKey = GlobalKey<PagedReaderState>();
  late _ReaderAppearance _appearance;
  double _fontSize = 17;
  double _progress = 0.0;
  double _scrubProgress = 0.0;
  bool _isScrubbing = false;
  bool _showChrome = true;
  bool _appearanceInitialized = false;

  /// Decoded images from the EPUB, lazily populated.
  final _imageCache = <String, ui.Image?>{};

  DocumentCursor? get _initialCursor {
    final cfi = widget.book.lastCfi;
    if (cfi == null || cfi.isEmpty) return null;
    return DocumentCursor.deserialize(cfi);
  }

  LayoutConfig get _layoutConfig {
    final baseFontFamily =
        GoogleFonts.playfairDisplay().fontFamily ?? 'Georgia';
    final bodyFontFamily = GoogleFonts.inter().fontFamily ?? 'sans-serif';

    return LayoutConfig(
      baseTextStyle: TextStyle(
        color: _appearance.pageTextColor,
        fontSize: _fontSize,
        fontFamily: bodyFontFamily,
        height: 1.65,
      ),
      lineHeight: _fontSize * 1.65,
      blockSpacing: _fontSize * 0.8,
      margins: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
      enableDropCaps: true,
      dropCapLines: 3,
      headingMaxLines: 3,
      headingStyleResolver: (level) {
        final scale = switch (level) {
          1 => 1.8,
          2 => 1.4,
          3 => 1.2,
          _ => 1.1,
        };
        return TextStyle(
          color: _appearance.pageTextColor,
          fontSize: _fontSize * scale,
          fontFamily: baseFontFamily,
          fontWeight: FontWeight.bold,
          height: 1.3,
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _progress = _normalizeProgress(widget.book.progress);
    _scrubProgress = _progress;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    ServiceLocator.readingStatsRepository.startSession(
      widget.book.id,
      widget.book.title,
      _progress,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_appearanceInitialized) return;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    _appearance = isDark ? _ReaderAppearance.night : _ReaderAppearance.paper;
    _appearanceInitialized = true;
    _applySystemUi();
  }

  @override
  void dispose() {
    ServiceLocator.readingStatsRepository.endSession();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        systemNavigationBarIconBrightness:
            isDark ? Brightness.light : Brightness.dark,
      ),
    );
    super.dispose();
  }

  double _normalizeProgress(double value) {
    return (value.clamp(0.0, 1.0) as num).toDouble();
  }

  void _applySystemUi() {
    SystemChrome.setEnabledSystemUIMode(
      _showChrome ? SystemUiMode.edgeToEdge : SystemUiMode.immersiveSticky,
    );
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor:
            _showChrome ? _appearance.chromeColor : Colors.transparent,
        statusBarBrightness:
            _appearance.isDark ? Brightness.dark : Brightness.light,
        statusBarIconBrightness:
            _appearance.isDark ? Brightness.light : Brightness.dark,
        systemNavigationBarIconBrightness:
            _appearance.isDark ? Brightness.light : Brightness.dark,
      ),
    );
  }

  void _setChromeVisible(bool visible) {
    if (_showChrome == visible) return;
    setState(() => _showChrome = visible);
    _applySystemUi();
  }

  void _adjustFontSize(double delta) {
    final nextSize =
        ((_fontSize + delta).clamp(_minFontSize, _maxFontSize) as num)
            .toDouble();
    if (nextSize == _fontSize) return;
    setState(() => _fontSize = nextSize);
  }

  void _setAppearance(_ReaderAppearance appearance) {
    if (_appearance == appearance) return;
    setState(() => _appearance = appearance);
    _applySystemUi();
  }

  void _jumpToProgress(double progress) {
    final normalized = _normalizeProgress(progress);
    setState(() {
      _isScrubbing = false;
      _progress = normalized;
      _scrubProgress = normalized;
    });

    // Estimate page from progress.
    final reader = _readerKey.currentState;
    if (reader == null) return;
    final totalPages = reader.totalPages;
    if (totalPages != null && totalPages > 0) {
      reader.goToPage((normalized * (totalPages - 1)).round());
    }
  }

  ui.Image? _resolveImage(String src) {
    if (_imageCache.containsKey(src)) return _imageCache[src];

    final bytes = widget.epubResult.images[src];
    if (bytes == null) {
      _imageCache[src] = null;
      return null;
    }

    // Decode asynchronously and cache.
    ui.decodeImageFromList(bytes, (image) {
      if (mounted) {
        setState(() => _imageCache[src] = image);
      }
    });

    _imageCache[src] = null; // placeholder while decoding
    return null;
  }

  void _showSettings() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => _ReaderSettingsSheet(
          appearance: _appearance,
          currentAppearance: _appearance,
          fontSize: _fontSize,
          canDecreaseFont: _fontSize > _minFontSize,
          canIncreaseFont: _fontSize < _maxFontSize,
          onDecreaseFont: () {
            _adjustFontSize(-1);
            setSheetState(() {});
          },
          onIncreaseFont: () {
            _adjustFontSize(1);
            setSheetState(() {});
          },
          onAppearanceSelected: (appearance) {
            _setAppearance(appearance);
            setSheetState(() {});
          },
        ),
      ),
    );
  }

  void _showChapterList() {
    final toc = widget.epubResult.tableOfContents;
    if (toc.isEmpty) return;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _ChapterSheet(
        appearance: _appearance,
        entries: toc,
        onSelected: (entry) {
          Navigator.pop(context);
          // Navigate to the chapter by index.
          final doc = widget.epubResult.document;
          // Find the chapter matching the TOC entry href.
          for (int i = 0; i < doc.chapters.length; i++) {
            if (doc.chapters[i].title == entry.title || i.toString() == entry.href) {
              _readerKey.currentState?.goToCursor(DocumentCursor(
                chapterIndex: i,
                blockIndex: 0,
                textOffset: 0,
              ));
              break;
            }
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentProgress = _isScrubbing ? _scrubProgress : _progress;
    final progressLabel = '${(currentProgress * 100).round()}%';

    return Scaffold(
      backgroundColor: _appearance.pageColor,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Pretext PagedReader
          GestureDetector(
            onTapUp: (details) {
              final size = MediaQuery.sizeOf(context);
              final x = details.localPosition.dx / size.width;
              final y = details.localPosition.dy / size.height;
              final isCenterTap =
                  x >= 0.2 && x <= 0.8 && y >= 0.15 && y <= 0.85;
              if (isCenterTap) {
                _setChromeVisible(!_showChrome);
              }
            },
            child: PagedReader(
              key: _readerKey,
              document: widget.epubResult.document,
              config: _layoutConfig,
              initialCursor: _initialCursor,
              backgroundColor: _appearance.pageColor,
              imageResolver: _resolveImage,
              onProgressChanged: (progress) {
                final normalized = _normalizeProgress(progress);
                setState(() {
                  _progress = normalized;
                  if (!_isScrubbing) {
                    _scrubProgress = normalized;
                  }
                });
                ServiceLocator.readingStatsRepository.recordProgress(
                  widget.book.id,
                  normalized,
                );
              },
              onCursorChanged: (cursor) {
                ServiceLocator.readerRepository.updateProgress(
                  widget.book.id,
                  cfi: cursor.serialize(),
                  progress: _progress,
                );
              },
            ),
          ),

          // Gradient scrims
          IgnorePointer(
            child: AnimatedOpacity(
              opacity: _showChrome ? 1 : 0,
              duration: const Duration(milliseconds: 220),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withAlpha(55),
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withAlpha(70),
                    ],
                    stops: const [0.0, 0.14, 0.74, 1.0],
                  ),
                ),
              ),
            ),
          ),

          // Top chrome
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: IgnorePointer(
              ignoring: !_showChrome,
              child: AnimatedSlide(
                offset: _showChrome ? Offset.zero : const Offset(0, -1),
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                child: AnimatedOpacity(
                  opacity: _showChrome ? 1 : 0,
                  duration: const Duration(milliseconds: 160),
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
                      child: _ReaderChromeCard(
                        appearance: _appearance,
                        child: Row(
                          children: [
                            _ReaderControlButton(
                              appearance: _appearance,
                              tooltip: l10n.readerTooltipBack,
                              icon: Icons.arrow_back_rounded,
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    widget.book.title,
                                    style: GoogleFonts.playfairDisplay(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: _appearance.chromeTextColor,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    widget.book.author,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: _appearance.chromeMutedColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            _ReaderControlButton(
                              appearance: _appearance,
                              tooltip: l10n.readerTooltipChapters,
                              icon: Icons.list_rounded,
                              onPressed:
                                  widget.epubResult.tableOfContents.isEmpty
                                      ? null
                                      : _showChapterList,
                            ),
                            const SizedBox(width: 8),
                            _ReaderControlButton(
                              appearance: _appearance,
                              tooltip: l10n.readerTooltipReadingSettings,
                              icon: Icons.tune_rounded,
                              onPressed: _showSettings,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Bottom chrome
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: IgnorePointer(
              ignoring: !_showChrome,
              child: AnimatedSlide(
                offset: _showChrome ? Offset.zero : const Offset(0, 1),
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                child: AnimatedOpacity(
                  opacity: _showChrome ? 1 : 0,
                  duration: const Duration(milliseconds: 160),
                  child: SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 14),
                      child: _ReaderChromeCard(
                        appearance: _appearance,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  l10n.readerProgressRead(progressLabel),
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(
                                        color: _appearance.chromeTextColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                                const Spacer(),
                                Text(
                                  l10n.readerHintSwipeToTurn,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: _appearance.chromeMutedColor,
                                      ),
                                ),
                              ],
                            ),
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: SwfColors.color4,
                                inactiveTrackColor:
                                    _appearance.progressTrackColor,
                                thumbColor: SwfColors.color4,
                                overlayColor: SwfColors.color4.withAlpha(40),
                                trackHeight: 3,
                              ),
                              child: Slider(
                                value: currentProgress,
                                onChanged: (value) {
                                  setState(() {
                                    _isScrubbing = true;
                                    _scrubProgress = value;
                                  });
                                },
                                onChangeEnd: _jumpToProgress,
                              ),
                            ),
                            Row(
                              children: [
                                _ReaderControlButton(
                                  appearance: _appearance,
                                  tooltip: l10n.readerTooltipPreviousPage,
                                  icon: Icons.chevron_left_rounded,
                                  label: l10n.readerButtonPrev,
                                  onPressed: () {
                                    final reader = _readerKey.currentState;
                                    if (reader != null &&
                                        reader.currentPageIndex > 0) {
                                      reader.goToPage(
                                          reader.currentPageIndex - 1);
                                    }
                                  },
                                ),
                                const Spacer(),
                                Text(
                                  l10n.readerHintTapToHide,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: _appearance.chromeMutedColor,
                                      ),
                                ),
                                const Spacer(),
                                _ReaderControlButton(
                                  appearance: _appearance,
                                  tooltip: l10n.readerTooltipNextPage,
                                  icon: Icons.chevron_right_rounded,
                                  label: l10n.readerButtonNext,
                                  onPressed: () {
                                    final reader = _readerKey.currentState;
                                    if (reader != null) {
                                      reader.goToPage(
                                          reader.currentPageIndex + 1);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Always-visible thin progress bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: IgnorePointer(
              child: LinearProgressIndicator(
                value: _progress,
                minHeight: 2,
                backgroundColor: _appearance.progressTrackColor,
                valueColor: const AlwaysStoppedAnimation(SwfColors.color4),
              ),
            ),
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
    required this.appearance,
    required this.entries,
    required this.onSelected,
  });

  final _ReaderAppearance appearance;
  final List<TocEntry> entries;
  final ValueChanged<TocEntry> onSelected;

  List<Widget> _buildEntries(
    BuildContext context,
    List<TocEntry> entries,
    int depth,
  ) {
    final widgets = <Widget>[];
    for (final entry in entries) {
      widgets.add(
        ListTile(
          dense: depth > 0,
          contentPadding:
              EdgeInsets.only(left: 20.0 + depth * 16.0, right: 16),
          title: Text(
            entry.title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: appearance.chromeTextColor,
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Icon(
            Icons.chevron_right_rounded,
            color: appearance.chromeMutedColor,
          ),
          onTap: () => onSelected(entry),
        ),
      );
      if (entry.children.isNotEmpty) {
        widgets.addAll(_buildEntries(context, entry.children, depth + 1));
      }
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.6,
      ),
      decoration: BoxDecoration(
        color: appearance.sheetColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 8),
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: appearance.chromeMutedColor.withAlpha(110),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Text(
              AppLocalizations.of(context)!.readerChaptersTitle,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: appearance.chromeTextColor,
                  ),
            ),
          ),
          Divider(height: 1, color: appearance.dividerColor),
          Flexible(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: _buildEntries(context, entries, 0),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Settings bottom sheet
// ─────────────────────────────────────────────────────────────────────────────

class _ReaderSettingsSheet extends StatelessWidget {
  const _ReaderSettingsSheet({
    required this.appearance,
    required this.currentAppearance,
    required this.fontSize,
    required this.canDecreaseFont,
    required this.canIncreaseFont,
    required this.onDecreaseFont,
    required this.onIncreaseFont,
    required this.onAppearanceSelected,
  });

  final _ReaderAppearance appearance;
  final _ReaderAppearance currentAppearance;
  final double fontSize;
  final bool canDecreaseFont;
  final bool canIncreaseFont;
  final VoidCallback onDecreaseFont;
  final VoidCallback onIncreaseFont;
  final ValueChanged<_ReaderAppearance> onAppearanceSelected;

  String _localizedAppearanceLabel(
      AppLocalizations l10n, _ReaderAppearance appearance) {
    if (identical(appearance, _ReaderAppearance.paper)) {
      return l10n.readerAppearancePaper;
    }
    if (identical(appearance, _ReaderAppearance.sepia)) {
      return l10n.readerAppearanceSepia;
    }
    return l10n.readerAppearanceNight;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: appearance.sheetColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: appearance.chromeMutedColor.withAlpha(110),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                l10n.readerSettingsTitle,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: appearance.chromeTextColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                l10n.readerSettingsTextSize,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: appearance.chromeMutedColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              _ReaderChromeCard(
                appearance: appearance,
                child: Row(
                  children: [
                    _ReaderControlButton(
                      appearance: appearance,
                      tooltip: l10n.readerTooltipSmallerText,
                      icon: Icons.remove_rounded,
                      onPressed: canDecreaseFont ? onDecreaseFont : null,
                    ),
                    const Spacer(),
                    Text(
                      l10n.readerFontSizeLabel(fontSize.round()),
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: appearance.chromeTextColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    _ReaderControlButton(
                      appearance: appearance,
                      tooltip: l10n.readerTooltipLargerText,
                      icon: Icons.add_rounded,
                      onPressed: canIncreaseFont ? onIncreaseFont : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Text(
                l10n.readerSettingsPageTheme,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: appearance.chromeMutedColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _ReaderAppearance.values.map((readerAppearance) {
                  final selected = readerAppearance == currentAppearance;
                  return ChoiceChip(
                    label:
                        Text(_localizedAppearanceLabel(l10n, readerAppearance)),
                    selected: selected,
                    labelStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: selected
                          ? readerAppearance.pageTextColor
                          : appearance.chromeTextColor,
                      fontWeight: FontWeight.w600,
                    ),
                    selectedColor: readerAppearance.pageColor,
                    backgroundColor: appearance.cardColor,
                    shape: StadiumBorder(
                      side: BorderSide(
                        color: selected
                            ? readerAppearance.pageTextColor.withAlpha(70)
                            : appearance.dividerColor,
                      ),
                    ),
                    onSelected: (_) => onAppearanceSelected(readerAppearance),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared chrome widgets
// ─────────────────────────────────────────────────────────────────────────────

class _ReaderChromeCard extends StatelessWidget {
  const _ReaderChromeCard({required this.appearance, required this.child});

  final _ReaderAppearance appearance;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: appearance.chromeColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: appearance.dividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: child,
      ),
    );
  }
}

class _ReaderControlButton extends StatelessWidget {
  const _ReaderControlButton({
    required this.appearance,
    required this.tooltip,
    required this.icon,
    required this.onPressed,
    this.label,
  });

  final _ReaderAppearance appearance;
  final String tooltip;
  final IconData icon;
  final VoidCallback? onPressed;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final foregroundColor = onPressed == null
        ? appearance.chromeMutedColor.withAlpha(150)
        : appearance.chromeTextColor;
    final backgroundColor = onPressed == null
        ? appearance.cardColor.withAlpha(120)
        : appearance.cardColor;

    if (label == null) {
      return Tooltip(
        message: tooltip,
        child: IconButton.filledTonal(
          style: IconButton.styleFrom(backgroundColor: backgroundColor),
          onPressed: onPressed,
          icon: Icon(icon, size: 20, color: foregroundColor),
        ),
      );
    }

    return Tooltip(
      message: tooltip,
      child: FilledButton.tonalIcon(
        style: FilledButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
        ),
        onPressed: onPressed,
        icon: Icon(icon, size: 20, color: foregroundColor),
        label: Text(
          label!,
          style: TextStyle(color: foregroundColor, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Reader appearance (theme)
// ─────────────────────────────────────────────────────────────────────────────

class _ReaderAppearance {
  const _ReaderAppearance._({
    required this.label,
    required this.isDark,
    required this.pageColor,
    required this.pageTextColor,
    required this.chromeColor,
    required this.sheetColor,
    required this.cardColor,
    required this.chromeTextColor,
    required this.chromeMutedColor,
    required this.progressTrackColor,
    required this.dividerColor,
  });

  static const paper = _ReaderAppearance._(
    label: 'Paper',
    isDark: false,
    pageColor: SwfColors.color8,
    pageTextColor: SwfColors.gray,
    chromeColor: Color(0xF8FBF7F2),
    sheetColor: Color(0xFFF6F2ED),
    cardColor: Colors.white,
    chromeTextColor: SwfColors.gray,
    chromeMutedColor: SwfColors.mediumGray,
    progressTrackColor: Color(0xFFCFC5BC),
    dividerColor: Color(0xFFD9D0C9),
  );

  static const sepia = _ReaderAppearance._(
    label: 'Sepia',
    isDark: false,
    pageColor: Color(0xFFF3E6D0),
    pageTextColor: Color(0xFF3E3025),
    chromeColor: Color(0xF7FAEEDB),
    sheetColor: Color(0xFFF7EBD8),
    cardColor: Color(0xFFFDF4E7),
    chromeTextColor: Color(0xFF3E3025),
    chromeMutedColor: Color(0xFF6B5848),
    progressTrackColor: Color(0xFFD9C7AF),
    dividerColor: Color(0xFFD9C6AE),
  );

  static const night = _ReaderAppearance._(
    label: 'Night',
    isDark: true,
    pageColor: Color(0xFF141B23),
    pageTextColor: Color(0xFFE8E2D9),
    chromeColor: Color(0xEE1E2933),
    sheetColor: Color(0xFF1B2732),
    cardColor: Color(0xFF22313F),
    chromeTextColor: SwfColors.color8,
    chromeMutedColor: Color(0xFFB7C0C8),
    progressTrackColor: Color(0xFF314251),
    dividerColor: Color(0xFF314251),
  );

  static const values = [paper, sepia, night];

  final String label;
  final bool isDark;
  final Color pageColor;
  final Color pageTextColor;
  final Color chromeColor;
  final Color sheetColor;
  final Color cardColor;
  final Color chromeTextColor;
  final Color chromeMutedColor;
  final Color progressTrackColor;
  final Color dividerColor;
}
