import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swf_app/src/api/api_result.dart';
import 'package:swf_app/src/api/service_locator.dart';
import 'package:swf_app/src/catalog/models/book.dart';
import 'package:swf_app/src/profile/models/review.dart';
import 'package:swf_app/src/profile/presentation/widgets/quill_rating.dart';
import 'package:swf_app/src/theme/swf_colors.dart';

const _parchment = Color(0xFFF4F0E8);
const _inkDark = Color(0xFF2A1F1A);
const _inkMedium = Color(0xFF5C4F42);

/// Full-screen page for creating or editing a book review.
///
/// Pass [book] for the target book and optionally [existingReview] for
/// edit mode.
class ReviewEditorPage extends StatefulWidget {
  const ReviewEditorPage({
    super.key,
    required this.book,
    this.existingReview,
  });

  final Book book;
  final Review? existingReview;

  @override
  State<ReviewEditorPage> createState() => _ReviewEditorPageState();
}

class _ReviewEditorPageState extends State<ReviewEditorPage> {
  late final TextEditingController _titleController;
  late final TextEditingController _bodyController;
  int _rating = 0;
  bool _saving = false;

  bool get _isEditing => widget.existingReview != null;

  @override
  void initState() {
    super.initState();
    final existing = widget.existingReview;
    _titleController = TextEditingController(text: existing?.title ?? '');
    _bodyController = TextEditingController(text: existing?.body ?? '');
    _rating = existing?.rating ?? 0;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  bool get _isValid =>
      _rating > 0 &&
      _titleController.text.trim().isNotEmpty &&
      _bodyController.text.trim().isNotEmpty;

  Future<void> _save() async {
    if (!_isValid || _saving) return;

    setState(() => _saving = true);

    final repo = ServiceLocator.reviewRepository;
    final ApiResult<dynamic> result;

    if (_isEditing) {
      result = await repo.updateReview(
        reviewId: widget.existingReview!.id,
        rating: _rating,
        title: _titleController.text.trim(),
        body: _bodyController.text.trim(),
      );
    } else {
      result = await repo.createReview(
        bookId: widget.book.id,
        rating: _rating,
        title: _titleController.text.trim(),
        body: _bodyController.text.trim(),
      );
    }

    if (!mounted) return;

    result.when(
      success: (_) {
        Navigator.of(context).pop(true);
      },
      failure: (message, _) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      },
    );
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Review'),
        content: const Text(
          'This will permanently remove your review. Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _saving = true);

    final result = await ServiceLocator.reviewRepository
        .deleteReview(widget.existingReview!.id);

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
          _isEditing ? 'Edit Inscription' : 'Inscribe Review',
          style: GoogleFonts.playfairDisplay(
            fontSize: 19,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          if (_isEditing)
            IconButton(
              onPressed: _saving ? null : _confirmDelete,
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            ),
        ],
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
                    // ── Book header ──
                    _BookHeader(book: widget.book),
                    const SizedBox(height: 24),

                    // ── Rating selector ──
                    _SectionLabel('YOUR RATING'),
                    const SizedBox(height: 8),
                    Center(
                      child: QuillRating(
                        rating: _rating,
                        size: 28,
                        interactive: true,
                        showLabel: true,
                        accentColor: SwfColors.blue,
                        onChanged: (r) => setState(() => _rating = r),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Title field ──
                    _SectionLabel('REVIEW TITLE'),
                    const SizedBox(height: 8),
                    _ParchmentTextField(
                      controller: _titleController,
                      hintText: 'A short headline for your review...',
                      maxLength: 100,
                      maxLines: 1,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 20),

                    // ── Body field ──
                    _SectionLabel('YOUR INSCRIPTION'),
                    const SizedBox(height: 8),
                    _ParchmentTextField(
                      controller: _bodyController,
                      hintText: 'Share your thoughts on this tome...',
                      maxLength: 2000,
                      minLines: 5,
                      maxLines: null,
                      onChanged: (_) => setState(() {}),
                    ),
                  ],
                ),
              ),
            ),

            // ── Save button ──
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isValid && !_saving ? _save : null,
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
                      : Text(
                          _isEditing ? 'Update Inscription' : 'Inscribe',
                          style: const TextStyle(
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

class _BookHeader extends StatelessWidget {
  const _BookHeader({required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _parchment,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: SwfColors.secondaryAccent.withAlpha(80)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              width: 48,
              height: 68,
              child: book.imageUrl.isNotEmpty
                  ? Image.network(book.imageUrl, fit: BoxFit.cover)
                  : Container(
                      color: SwfColors.brandPurple.withAlpha(40),
                      child: const Icon(Icons.menu_book_rounded, size: 20),
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
        ],
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

class _ParchmentTextField extends StatelessWidget {
  const _ParchmentTextField({
    required this.controller,
    required this.hintText,
    this.maxLength,
    this.minLines,
    this.maxLines = 1,
    this.onChanged,
  });

  final TextEditingController controller;
  final String hintText;
  final int? maxLength;
  final int? minLines;
  final int? maxLines;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      maxLength: maxLength,
      minLines: minLines,
      maxLines: maxLines,
      style: const TextStyle(color: _inkDark, fontSize: 14),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: _inkMedium.withAlpha(120), fontSize: 14),
        filled: true,
        fillColor: _parchment,
        counterStyle: TextStyle(color: _inkMedium.withAlpha(100), fontSize: 10),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
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
          borderSide: const BorderSide(color: SwfColors.secondaryAccent),
        ),
      ),
    );
  }
}
