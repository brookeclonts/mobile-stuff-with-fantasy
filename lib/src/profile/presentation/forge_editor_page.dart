import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swf_app/src/api/service_locator.dart';
import 'package:swf_app/src/catalog/models/book.dart';
import 'package:swf_app/src/profile/presentation/widgets/book_picker_sheet.dart';
import 'package:swf_app/src/theme/swf_colors.dart';

const _parchment = Color(0xFFF4F0E8);
const _inkDark = Color(0xFF2A1F1A);
const _inkMedium = Color(0xFF5C4F42);

/// Full-screen page for creating a recommendation pairing.
///
/// Two-step flow: select two books, then provide a reason why they pair well.
class ForgeEditorPage extends StatefulWidget {
  const ForgeEditorPage({super.key});

  @override
  State<ForgeEditorPage> createState() => _ForgeEditorPageState();
}

class _ForgeEditorPageState extends State<ForgeEditorPage> {
  Book? _sourceBook;
  Book? _targetBook;
  final _reasonController = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  bool get _bothSelected => _sourceBook != null && _targetBook != null;

  bool get _isValid =>
      _bothSelected && _reasonController.text.trim().isNotEmpty;

  void _pickSource() {
    showBookPicker(
      context,
      onBookSelected: (book) => setState(() => _sourceBook = book),
      excludeBookId: _targetBook?.id,
    );
  }

  void _pickTarget() {
    showBookPicker(
      context,
      onBookSelected: (book) => setState(() => _targetBook = book),
      excludeBookId: _sourceBook?.id,
    );
  }

  Future<void> _forge() async {
    if (!_isValid || _saving) return;

    setState(() => _saving = true);

    final result = await ServiceLocator.recommendationRepository.createPairing(
      sourceBookId: _sourceBook!.id,
      targetBookId: _targetBook!.id,
      reason: _reasonController.text.trim(),
    );

    if (!mounted) return;

    result.when(
      success: (_) => Navigator.of(context).pop(true),
      failure: (message, _) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SwfColors.primaryBackground,
      appBar: AppBar(
        backgroundColor: SwfColors.primaryBackground,
        foregroundColor: Colors.white,
        title: Text(
          'Recommendation Forge',
          style: GoogleFonts.playfairDisplay(
            fontSize: 19,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Source book slot ──
                    _SectionLabel('IF YOU LIKED...'),
                    const SizedBox(height: 8),
                    _BookSlot(
                      book: _sourceBook,
                      onTap: _pickSource,
                      accentColor: SwfColors.secondaryAccent,
                    ),
                    const SizedBox(height: 16),

                    // ── Chain divider ──
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 1,
                            height: 20,
                            color: SwfColors.secondaryAccent.withAlpha(80),
                          ),
                          Icon(
                            Icons.link_rounded,
                            color: SwfColors.secondaryAccent.withAlpha(180),
                            size: 24,
                          ),
                          Container(
                            width: 1,
                            height: 20,
                            color: SwfColors.secondaryAccent.withAlpha(80),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── Target book slot ──
                    _SectionLabel('TRY...'),
                    const SizedBox(height: 8),
                    _BookSlot(
                      book: _targetBook,
                      onTap: _pickTarget,
                      accentColor: SwfColors.blue,
                    ),
                    const SizedBox(height: 24),

                    // ── Reason (slides in when both selected) ──
                    AnimatedCrossFade(
                      duration: const Duration(milliseconds: 300),
                      crossFadeState: _bothSelected
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      firstChild: const SizedBox.shrink(),
                      secondChild: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SectionLabel('WHY DO THESE PAIR WELL?'),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _reasonController,
                            onChanged: (_) => setState(() {}),
                            maxLength: 500,
                            minLines: 3,
                            maxLines: null,
                            style: const TextStyle(
                              color: _inkDark,
                              fontSize: 14,
                            ),
                            decoration: InputDecoration(
                              hintText:
                                  'Similar vibes, shared tropes, perfect follow-up...',
                              hintStyle: TextStyle(
                                color: _inkMedium.withAlpha(120),
                                fontSize: 14,
                              ),
                              filled: true,
                              fillColor: _parchment,
                              counterStyle: TextStyle(
                                color: _inkMedium.withAlpha(100),
                                fontSize: 10,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 12,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color:
                                      SwfColors.secondaryAccent.withAlpha(80),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color:
                                      SwfColors.secondaryAccent.withAlpha(80),
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Forge button ──
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isValid && !_saving ? _forge : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: SwfColors.blue,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: SwfColors.blue.withAlpha(80),
                    disabledForegroundColor: Colors.white.withAlpha(100),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: _saving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Forge the Bond',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: SwfColors.secondaryAccent,
        letterSpacing: 1.5,
        fontSize: 10,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _BookSlot extends StatelessWidget {
  const _BookSlot({
    required this.book,
    required this.onTap,
    required this.accentColor,
  });

  final Book? book;
  final VoidCallback onTap;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 240),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: book != null ? _parchment : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: book != null
                ? accentColor.withAlpha(120)
                : Colors.white.withAlpha(60),
            width: book != null ? 1.5 : 1,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        child: book != null
            ? _SelectedBookRow(book: book!, theme: theme)
            : _EmptySlot(accentColor: accentColor),
      ),
    );
  }
}

class _SelectedBookRow extends StatelessWidget {
  const _SelectedBookRow({required this.book, required this.theme});

  final Book book;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: SizedBox(
            width: 44,
            height: 62,
            child: book.imageUrl.isNotEmpty
                ? Image.network(book.imageUrl, fit: BoxFit.cover)
                : Container(
                    color: SwfColors.brandPurple.withAlpha(40),
                    child: const Icon(Icons.menu_book_rounded, size: 18),
                  ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                book.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: _inkDark,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (book.authorName.isNotEmpty)
                Text(
                  book.authorName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: _inkMedium.withAlpha(180),
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        ),
        Icon(
          Icons.swap_horiz_rounded,
          color: _inkMedium.withAlpha(100),
          size: 20,
        ),
      ],
    );
  }
}

class _EmptySlot extends StatelessWidget {
  const _EmptySlot({required this.accentColor});

  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 62,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_circle_outline,
            color: Colors.white.withAlpha(100),
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            'Tap to select a book',
            style: TextStyle(
              color: Colors.white.withAlpha(140),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
