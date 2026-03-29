import 'package:flutter/material.dart';
import 'package:swf_app/src/theme/swf_colors.dart';

// ---------------------------------------------------------------------------
// Attunement color definitions
// ---------------------------------------------------------------------------

/// A named accent color option for the Guild Hall.
class AttunementColor {
  const AttunementColor({
    required this.key,
    required this.label,
    required this.color,
  });

  /// Key persisted in preferences and sent to the server.
  final String key;

  /// Display label shown under the swatch.
  final String label;

  /// The actual [Color] value.
  final Color color;
}

/// Ordered list of accent options. The first entry is the campaign default.
const List<AttunementColor> attunementColors = [
  AttunementColor(key: 'tidewater', label: 'Tidewater', color: SwfColors.blue),
  AttunementColor(
      key: 'amethyst', label: 'Amethyst', color: SwfColors.purple),
  AttunementColor(key: 'arcane', label: 'Arcane', color: SwfColors.violet),
  AttunementColor(
      key: 'hearthfire', label: 'Hearthfire', color: SwfColors.secondaryAccent),
  AttunementColor(
      key: 'roseCourt', label: 'Rose Court', color: SwfColors.primaryButton),
  AttunementColor(
      key: 'sunforged', label: 'Sunforged', color: SwfColors.orange),
];

/// Resolves an accent color key to its [Color] value.
/// Returns the default campaign color for `null` or unknown keys.
Color resolveAccentColor(String? key) {
  if (key == null) return attunementColors.first.color;
  for (final option in attunementColors) {
    if (option.key == key) return option.color;
  }
  return attunementColors.first.color;
}

// ---------------------------------------------------------------------------
// Bottom sheet
// ---------------------------------------------------------------------------

const _sheetBg = Color(0xFF2A2235);
const _sheetRadius = BorderRadius.vertical(top: Radius.circular(24));

/// Shows the theme attunement picker as a modal bottom sheet.
///
/// [currentKey] is the currently selected key (or `null` for default).
/// Returns the newly selected key, or `null` if dismissed without change.
Future<String?> showThemeAttunementSheet(
  BuildContext context, {
  required String? currentKey,
  required Color accentColor,
}) {
  return showModalBottomSheet<String?>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _ThemeAttunementSheet(
      currentKey: currentKey,
      accentColor: accentColor,
    ),
  );
}

class _ThemeAttunementSheet extends StatefulWidget {
  const _ThemeAttunementSheet({
    required this.currentKey,
    required this.accentColor,
  });

  final String? currentKey;
  final Color accentColor;

  @override
  State<_ThemeAttunementSheet> createState() => _ThemeAttunementSheetState();
}

class _ThemeAttunementSheetState extends State<_ThemeAttunementSheet> {
  late String? _selectedKey;

  @override
  void initState() {
    super.initState();
    _selectedKey = widget.currentKey;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedColor = resolveAccentColor(_selectedKey);

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      decoration: const BoxDecoration(
        color: _sheetBg,
        borderRadius: _sheetRadius,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 36,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20, top: 8),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(60),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Icon(Icons.auto_awesome_rounded, size: 32, color: selectedColor),
          const SizedBox(height: 12),
          Text(
            'Theme Attunement',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Choose an accent color to attune your Guild Hall.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withAlpha(170),
              height: 1.4,
            ),
          ),

          const SizedBox(height: 28),

          // Color swatches
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Text(
                'ATTUNEMENT',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: SwfColors.secondaryAccent,
                  letterSpacing: 1.5,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: attunementColors.map((option) {
              final isSelected = _selectedKey == option.key ||
                  (_selectedKey == null && option == attunementColors.first);
              return _ColorSwatch(
                option: option,
                isSelected: isSelected,
                onTap: () {
                  setState(() {
                    // Selecting the first (default) option clears the key.
                    _selectedKey = option == attunementColors.first
                        ? null
                        : option.key;
                  });
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 28),

          // Confirm button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context, _selectedKey),
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedColor,
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
        ],
      ),
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  final AttunementColor option;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 64,
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: option.color,
                border: Border.all(
                  color: isSelected
                      ? Colors.white
                      : Colors.white.withAlpha(30),
                  width: isSelected ? 3 : 1.5,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: option.color.withAlpha(120),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
              child: isSelected
                  ? const Icon(Icons.check_rounded,
                      color: Colors.white, size: 22)
                  : null,
            ),
            const SizedBox(height: 6),
            Text(
              option.label,
              textAlign: TextAlign.center,
              style: theme.textTheme.labelSmall?.copyWith(
                color: isSelected
                    ? Colors.white
                    : Colors.white.withAlpha(140),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
