import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swf_app/l10n/app_localizations.dart';
import 'package:swf_app/src/api/service_locator.dart';
import 'package:swf_app/src/oath/models/book_oath.dart';
import 'package:swf_app/src/theme/swf_colors.dart';

/// Form to create (swear) a new book oath.
///
/// Returns the created [BookOath] via Navigator.pop on success.
class SwearOathPage extends StatefulWidget {
  const SwearOathPage({super.key});

  @override
  State<SwearOathPage> createState() => _SwearOathPageState();
}

class _SwearOathPageState extends State<SwearOathPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  int _targetCount = 12;
  int _year = DateTime.now().year;
  bool _isPublic = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);

    final title = _titleController.text.trim().isNotEmpty
        ? _titleController.text.trim()
        : 'I will read $_targetCount books in $_year';

    final result = await ServiceLocator.oathRepository.createOath(
      title: title,
      targetCount: _targetCount,
      year: _year,
      isPublic: _isPublic,
    );

    if (!mounted) return;

    result.when(
      success: (oath) => Navigator.pop(context, oath),
      failure: (message, _) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    const accent = SwfColors.secondaryAccent;

    return Scaffold(
      backgroundColor: SwfColors.primaryBackground,
      appBar: AppBar(
        title: Text(
          l10n.oathSwearPageTitle,
          style: GoogleFonts.playfairDisplay(
            fontSize: 19,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Icon(
                Icons.auto_stories_rounded,
                size: 32,
                color: accent,
              ),
              const SizedBox(height: 12),
              Text(
                l10n.oathSwearCta,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.oathSwearSubtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withAlpha(160),
                ),
              ),

              const SizedBox(height: 28),

              // Title field
              Text(
                l10n.oathFieldTitle,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: Colors.white.withAlpha(200),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  hintText: l10n.oathFieldTitleHint,
                  hintStyle: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withAlpha(60),
                  ),
                  filled: true,
                  fillColor: Colors.white.withAlpha(10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white.withAlpha(30)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white.withAlpha(30)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: accent.withAlpha(140)),
                  ),
                ),
                maxLength: 200,
              ),

              const SizedBox(height: 20),

              // Target count
              Text(
                l10n.oathFieldTarget,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: Colors.white.withAlpha(200),
                ),
              ),
              const SizedBox(height: 8),
              _CounterField(
                value: _targetCount,
                min: 1,
                max: 1000,
                accentColor: accent,
                onChanged: (v) => setState(() => _targetCount = v),
              ),

              const SizedBox(height: 20),

              // Year
              Text(
                l10n.oathFieldYear,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: Colors.white.withAlpha(200),
                ),
              ),
              const SizedBox(height: 8),
              _CounterField(
                value: _year,
                min: 2024,
                max: 2100,
                accentColor: accent,
                onChanged: (v) => setState(() => _year = v),
              ),

              const SizedBox(height: 20),

              // Public toggle
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(8),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withAlpha(20)),
                ),
                child: SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    l10n.oathFieldPublic,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    l10n.oathFieldPublicSubtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withAlpha(120),
                    ),
                  ),
                  value: _isPublic,
                  onChanged: (v) => setState(() => _isPublic = v),
                  activeTrackColor: accent,
                ),
              ),

              const SizedBox(height: 32),

              // Submit
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  child: Text(
                    _isSubmitting
                        ? l10n.oathSwearing
                        : l10n.oathSwearButton,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A simple integer counter with +/- buttons.
class _CounterField extends StatelessWidget {
  const _CounterField({
    required this.value,
    required this.min,
    required this.max,
    required this.accentColor,
    required this.onChanged,
  });

  final int value;
  final int min;
  final int max;
  final Color accentColor;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(10),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withAlpha(30)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove_rounded),
            color: Colors.white.withAlpha(160),
            onPressed: value > min ? () => onChanged(value - 1) : null,
          ),
          SizedBox(
            width: 60,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_rounded),
            color: Colors.white.withAlpha(160),
            onPressed: value < max ? () => onChanged(value + 1) : null,
          ),
        ],
      ),
    );
  }
}
