import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_epub_viewer/flutter_epub_viewer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swf_app/l10n/app_localizations.dart';
import 'package:swf_app/src/api/service_locator.dart';
import 'package:swf_app/src/reader/models/reader_book.dart';
import 'package:swf_app/src/theme/swf_colors.dart';

/// Full-screen EPUB reading experience.
class ReaderPage extends StatefulWidget {
  const ReaderPage({super.key, required this.book, required this.epubSource});

  final ReaderBook book;
  final EpubSource epubSource;

  @override
  State<ReaderPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  static const double _minFontSize = 15;
  static const double _maxFontSize = 22;
  static const double _tapThreshold = 0.03;

  final EpubController _epubController = EpubController();
  List<EpubChapter> _chapters = const [];
  late _ReaderAppearance _appearance;
  Offset? _touchDownPosition;
  double _fontSize = 17;
  double _progress = 0.0;
  double _scrubProgress = 0.0;
  bool _isLoaded = false;
  bool _isScrubbing = false;
  bool _showChrome = true;
  bool _appearanceInitialized = false;

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
        systemNavigationBarIconBrightness: isDark
            ? Brightness.light
            : Brightness.dark,
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
        systemNavigationBarColor: _showChrome
            ? _appearance.chromeColor
            : Colors.transparent,
        statusBarBrightness: _appearance.isDark
            ? Brightness.dark
            : Brightness.light,
        statusBarIconBrightness: _appearance.isDark
            ? Brightness.light
            : Brightness.dark,
        systemNavigationBarIconBrightness: _appearance.isDark
            ? Brightness.light
            : Brightness.dark,
      ),
    );
  }

  void _setChromeVisible(bool visible) {
    if (_showChrome == visible) return;
    setState(() => _showChrome = visible);
    _applySystemUi();
  }

  void _handleTouchDown(double x, double y) {
    _touchDownPosition = Offset(x, y);
  }

  void _handleTouchUp(double x, double y) {
    final touchDownPosition = _touchDownPosition;
    _touchDownPosition = null;
    if (!_isLoaded || touchDownPosition == null) return;

    final deltaX = (touchDownPosition.dx - x).abs();
    final deltaY = (touchDownPosition.dy - y).abs();
    final isTap = deltaX <= _tapThreshold && deltaY <= _tapThreshold;
    final isCenterTap = x >= 0.2 && x <= 0.8 && y >= 0.15 && y <= 0.85;

    if (isTap && isCenterTap) {
      _setChromeVisible(!_showChrome);
    }
  }

  void _adjustFontSize(double delta) {
    final nextSize =
        ((_fontSize + delta).clamp(_minFontSize, _maxFontSize) as num)
            .toDouble();
    if (nextSize == _fontSize) return;

    setState(() => _fontSize = nextSize);
    if (_isLoaded) {
      _epubController.setFontSize(fontSize: nextSize);
    }
  }

  void _setAppearance(_ReaderAppearance appearance) {
    if (_appearance == appearance) return;

    setState(() => _appearance = appearance);
    _applySystemUi();

    if (_isLoaded) {
      _epubController.updateTheme(theme: _appearance.epubTheme);
    }
  }

  void _jumpToProgress(double progress) {
    final normalized = _normalizeProgress(progress);
    setState(() {
      _isScrubbing = false;
      _progress = normalized;
      _scrubProgress = normalized;
    });
    if (_isLoaded) {
      _epubController.toProgressPercentage(normalized);
    }
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
    if (_chapters.isEmpty) return;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _ChapterSheet(
        appearance: _appearance,
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
    final l10n = AppLocalizations.of(context)!;
    final currentProgress = _isScrubbing ? _scrubProgress : _progress;
    final progressLabel = '${(currentProgress * 100).round()}%';

    return Scaffold(
      backgroundColor: _appearance.pageColor,
      body: Stack(
        fit: StackFit.expand,
        children: [
          EpubViewer(
            epubSource: widget.epubSource,
            epubController: _epubController,
            displaySettings: EpubDisplaySettings(
              fontSize: _fontSize.round(),
              flow: EpubFlow.paginated,
              snap: true,
              theme: _appearance.epubTheme,
            ),
            initialCfi: widget.book.lastCfi,
            onTouchDown: _handleTouchDown,
            onTouchUp: _handleTouchUp,
            onChaptersLoaded: (chapters) {
              if (!mounted) return;
              setState(() => _chapters = chapters);
            },
            onEpubLoaded: () {
              if (!mounted) return;
              setState(() => _isLoaded = true);
              _epubController.setFontSize(fontSize: _fontSize);
              _epubController.updateTheme(theme: _appearance.epubTheme);
            },
            onRelocated: (location) {
              if (!mounted) return;
              final normalized = _normalizeProgress(location.progress);
              setState(() {
                _progress = normalized;
                if (!_isScrubbing) {
                  _scrubProgress = normalized;
                }
              });
              ServiceLocator.readerRepository.updateProgress(
                widget.book.id,
                cfi: location.startCfi,
                progress: normalized,
              );
              ServiceLocator.readingStatsRepository.recordProgress(
                widget.book.id,
                normalized,
              );
            },
          ),
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
                                    style: Theme.of(context).textTheme.bodySmall
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
                              onPressed: _chapters.isEmpty
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
                                  style: Theme.of(context).textTheme.labelLarge
                                      ?.copyWith(
                                        color: _appearance.chromeTextColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                                const Spacer(),
                                Text(
                                  _isLoaded
                                      ? l10n.readerHintSwipeToTurn
                                      : l10n.readerHintOpeningBook,
                                  style: Theme.of(context).textTheme.bodySmall
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
                                onChanged: _isLoaded
                                    ? (value) {
                                        setState(() {
                                          _isScrubbing = true;
                                          _scrubProgress = value;
                                        });
                                      }
                                    : null,
                                onChangeEnd: _isLoaded ? _jumpToProgress : null,
                              ),
                            ),
                            Row(
                              children: [
                                _ReaderControlButton(
                                  appearance: _appearance,
                                  tooltip: l10n.readerTooltipPreviousPage,
                                  icon: Icons.chevron_left_rounded,
                                  label: l10n.readerButtonPrev,
                                  onPressed: _isLoaded
                                      ? () => _epubController.prev()
                                      : null,
                                ),
                                const Spacer(),
                                Text(
                                  l10n.readerHintTapToHide,
                                  style: Theme.of(context).textTheme.bodySmall
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
                                  onPressed: _isLoaded
                                      ? () => _epubController.next()
                                      : null,
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
          if (!_isLoaded)
            Center(child: CircularProgressIndicator(color: SwfColors.color4)),
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
    required this.chapters,
    required this.onSelected,
  });

  final _ReaderAppearance appearance;
  final List<EpubChapter> chapters;
  final ValueChanged<EpubChapter> onSelected;

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
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: chapters.length,
              itemBuilder: (context, index) {
                final chapter = chapters[index];
                return ListTile(
                  dense: true,
                  title: Text(
                    chapter.title,
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
                    label: Text(_localizedAppearanceLabel(l10n, readerAppearance)),
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
    required this.selectionColor,
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
    selectionColor: '#B96D9A55',
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
    selectionColor: '#BC8D6050',
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
    selectionColor: '#82B1A155',
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
  final String selectionColor;

  EpubTheme get epubTheme => EpubTheme.custom(
    foregroundColor: pageTextColor,
    customCss: {
      'html': {'background-color': _cssColor(pageColor)},
      'body': {
        'background-color': '${_cssColor(pageColor)} !important',
        'color': '${_cssColor(pageTextColor)} !important',
        'font-family': '"Iowan Old Style", "Palatino Linotype", Georgia, serif',
        'line-height': '1.65',
        '-webkit-font-smoothing': 'antialiased',
      },
      'p': {'line-height': '1.65'},
      'img': {'max-width': '100%', 'height': 'auto'},
      'a': {'color': 'inherit !important', 'text-decoration': 'none'},
      'a:link': {'color': 'inherit !important'},
      '::selection': {'background-color': selectionColor},
    },
  );
}

String _cssColor(Color color) {
  final red = color.r.toInt().toRadixString(16).padLeft(2, '0');
  final green = color.g.toInt().toRadixString(16).padLeft(2, '0');
  final blue = color.b.toInt().toRadixString(16).padLeft(2, '0');
  return '#$red$green$blue';
}
