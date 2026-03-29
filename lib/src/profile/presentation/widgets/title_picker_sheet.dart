import 'package:flutter/material.dart';
import 'package:swf_app/src/profile/data/title_compendium.dart';
import 'package:swf_app/src/profile/models/earned_title.dart';
import 'package:swf_app/src/theme/swf_colors.dart';

const _sheetBg = Color(0xFF2A2235);
const _sheetRadius = BorderRadius.vertical(top: Radius.circular(24));

/// Shows the title picker as a modal bottom sheet.
///
/// Returns the selected title ID, or `null` to clear the title.
/// Returns the current [selectedTitleId] unchanged on swipe-dismiss.
Future<String?> showTitlePickerSheet(
  BuildContext context, {
  required String? selectedTitleId,
  required List<EarnedTitle> unlockedTitles,
  required Color accentColor,
}) {
  return showModalBottomSheet<String?>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => _TitlePickerSheet(
      selectedTitleId: selectedTitleId,
      unlockedTitles: unlockedTitles,
      accentColor: accentColor,
    ),
  );
}

class _TitlePickerSheet extends StatefulWidget {
  const _TitlePickerSheet({
    required this.selectedTitleId,
    required this.unlockedTitles,
    required this.accentColor,
  });

  final String? selectedTitleId;
  final List<EarnedTitle> unlockedTitles;
  final Color accentColor;

  @override
  State<_TitlePickerSheet> createState() => _TitlePickerSheetState();
}

class _TitlePickerSheetState extends State<_TitlePickerSheet> {
  late String? _selectedId;

  @override
  void initState() {
    super.initState();
    _selectedId = widget.selectedTitleId;
  }

  Set<String> get _unlockedIds =>
      widget.unlockedTitles.map((t) => t.id).toSet();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = widget.accentColor;

    // Group titles by category for display order.
    final categories = [
      ('QUEST TITLES', allTitles.where((t) => t.category == 'quest').toList()),
      ('GENRE TITLES', allTitles.where((t) => t.category == 'genre').toList()),
      (
        'SPECIAL TITLES',
        allTitles.where((t) => t.category == 'special').toList(),
      ),
    ];

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.4,
      builder: (context, scrollController) => Container(
        decoration: const BoxDecoration(
          color: _sheetBg,
          borderRadius: _sheetRadius,
        ),
        child: Column(
          children: [
            // Handle
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16, top: 8),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(60),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 4),
              child: Column(
                children: [
                  Icon(Icons.military_tech_rounded,
                      size: 32, color: accent),
                  const SizedBox(height: 12),
                  Text(
                    'Choose Your Title',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Select a title to display on your Guild Hall profile.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withAlpha(170),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Title list
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                children: [
                  // "No title" option
                  _TitleOption(
                    title: null,
                    isUnlocked: true,
                    isSelected: _selectedId == null,
                    accentColor: accent,
                    onTap: () => setState(() => _selectedId = null),
                  ),
                  const SizedBox(height: 12),

                  for (final (label, titles) in categories) ...[
                    _SectionLabel(label),
                    const SizedBox(height: 8),
                    for (final title in titles) ...[
                      _TitleOption(
                        title: title,
                        isUnlocked: _unlockedIds.contains(title.id),
                        isSelected: _selectedId == title.id,
                        accentColor: accent,
                        onTap: _unlockedIds.contains(title.id)
                            ? () => setState(() => _selectedId = title.id)
                            : null,
                      ),
                      const SizedBox(height: 8),
                    ],
                    const SizedBox(height: 8),
                  ],
                ],
              ),
            ),

            // Confirm button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, _selectedId),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    'Apply',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
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
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 2),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: SwfColors.secondaryAccent,
          letterSpacing: 1.5,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _TitleOption extends StatelessWidget {
  const _TitleOption({
    required this.title,
    required this.isUnlocked,
    required this.isSelected,
    required this.accentColor,
    this.onTap,
  });

  final EarnedTitle? title;
  final bool isUnlocked;
  final bool isSelected;
  final Color accentColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isNoneOption = title == null;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? accentColor.withAlpha(20)
              : isUnlocked
                  ? Colors.white.withAlpha(8)
                  : Colors.white.withAlpha(4),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? accentColor.withAlpha(120)
                : isUnlocked
                    ? Colors.white.withAlpha(25)
                    : Colors.white.withAlpha(10),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? accentColor.withAlpha(30)
                    : isUnlocked
                        ? Colors.white.withAlpha(10)
                        : Colors.white.withAlpha(5),
              ),
              child: Icon(
                isNoneOption
                    ? Icons.remove_circle_outline_rounded
                    : isUnlocked
                        ? title!.icon
                        : Icons.lock_rounded,
                size: 18,
                color: isSelected
                    ? accentColor
                    : isUnlocked
                        ? Colors.white.withAlpha(180)
                        : Colors.white.withAlpha(60),
              ),
            ),
            const SizedBox(width: 12),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isNoneOption ? 'No Title' : title!.label,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: isUnlocked
                          ? Colors.white.withAlpha(220)
                          : Colors.white.withAlpha(80),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isNoneOption
                        ? 'Show only your rank'
                        : isUnlocked
                            ? title!.description
                            : title!.unlockHint ?? 'Locked',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isUnlocked
                          ? Colors.white.withAlpha(120)
                          : Colors.white.withAlpha(50),
                      fontStyle:
                          isUnlocked ? FontStyle.normal : FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

            // Selection indicator
            if (isSelected)
              Icon(Icons.check_circle_rounded, size: 20, color: accentColor),
          ],
        ),
      ),
    );
  }
}
