import 'package:flutter/material.dart';
import 'package:swf_app/src/profile/data/sigil_compendium.dart';
import 'package:swf_app/src/profile/models/sigil_config.dart';
import 'package:swf_app/src/profile/models/sigil_part.dart';
import 'package:swf_app/src/profile/presentation/widgets/sigil_avatar.dart';

const _sheetBg = Color(0xFF2A2235);
const _sheetRadius = BorderRadius.vertical(top: Radius.circular(24));

/// Shows the sigil builder as a full-height modal bottom sheet.
///
/// Returns the saved [SigilConfig], or `null` on dismiss.
Future<SigilConfig?> showSigilBuilderSheet(
  BuildContext context, {
  required SigilConfig currentConfig,
  required Color accentColor,
  required Set<String> revealedRewardIds,
}) {
  return showModalBottomSheet<SigilConfig?>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => _SigilBuilderSheet(
      currentConfig: currentConfig,
      accentColor: accentColor,
      revealedRewardIds: revealedRewardIds,
    ),
  );
}

class _SigilBuilderSheet extends StatefulWidget {
  const _SigilBuilderSheet({
    required this.currentConfig,
    required this.accentColor,
    required this.revealedRewardIds,
  });

  final SigilConfig currentConfig;
  final Color accentColor;
  final Set<String> revealedRewardIds;

  @override
  State<_SigilBuilderSheet> createState() => _SigilBuilderSheetState();
}

class _SigilBuilderSheetState extends State<_SigilBuilderSheet>
    with SingleTickerProviderStateMixin {
  late SigilConfig _config;
  late TabController _tabController;

  static const _layers = SigilLayer.values;
  static const _layerLabels = ['Shield', 'Field', 'Charge', 'Border'];
  static const _layerIcons = [
    Icons.shield_outlined,
    Icons.format_color_fill_rounded,
    Icons.auto_fix_high_rounded,
    Icons.filter_frames_rounded,
  ];

  @override
  void initState() {
    super.initState();
    _config = widget.currentConfig;
    _tabController = TabController(length: _layers.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _selectedIdForLayer(SigilLayer layer) {
    switch (layer) {
      case SigilLayer.shield:
        return _config.shieldId;
      case SigilLayer.field:
        return _config.fieldId;
      case SigilLayer.charge:
        return _config.chargeId;
      case SigilLayer.border:
        return _config.borderId;
    }
  }

  void _selectPart(SigilPart part) {
    setState(() {
      switch (part.layer) {
        case SigilLayer.shield:
          _config = _config.copyWith(shieldId: part.id);
        case SigilLayer.field:
          _config = _config.copyWith(fieldId: part.id);
        case SigilLayer.charge:
          _config = _config.copyWith(chargeId: part.id);
        case SigilLayer.border:
          _config = _config.copyWith(borderId: part.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = widget.accentColor;

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.5,
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

            // Header + live preview
            Text(
              'Sigil Builder',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            // Live preview
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(8),
                shape: BoxShape.circle,
              ),
              child: SigilAvatar(
                config: _config,
                accentColor: accent,
                size: 88,
              ),
            ),

            const SizedBox(height: 20),

            // Tab bar
            TabBar(
              controller: _tabController,
              indicatorColor: accent,
              labelColor: accent,
              unselectedLabelColor: Colors.white.withAlpha(100),
              indicatorSize: TabBarIndicatorSize.label,
              dividerColor: Colors.transparent,
              tabs: List.generate(_layers.length, (i) {
                return Tab(
                  icon: Icon(_layerIcons[i], size: 20),
                  text: _layerLabels[i],
                );
              }),
            ),

            const SizedBox(height: 12),

            // Parts grid
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: _layers.map((layer) {
                  final parts = partsForLayer(layer);
                  final selectedId = _selectedIdForLayer(layer);

                  return GridView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: parts.length,
                    itemBuilder: (context, index) {
                      final part = parts[index];
                      final unlocked = isPartUnlocked(
                        part,
                        revealedRewardIds: widget.revealedRewardIds,
                      );
                      final selected = part.id == selectedId;

                      return _PartTile(
                        part: part,
                        isUnlocked: unlocked,
                        isSelected: selected,
                        accentColor: accent,
                        onTap: unlocked ? () => _selectPart(part) : null,
                      );
                    },
                  );
                }).toList(),
              ),
            ),

            // Save button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, _config),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    'Save Sigil',
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

// ---------------------------------------------------------------------------
// Part tile
// ---------------------------------------------------------------------------

class _PartTile extends StatelessWidget {
  const _PartTile({
    required this.part,
    required this.isUnlocked,
    required this.isSelected,
    required this.accentColor,
    this.onTap,
  });

  final SigilPart part;
  final bool isUnlocked;
  final bool isSelected;
  final Color accentColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected
              ? accentColor.withAlpha(25)
              : isUnlocked
                  ? Colors.white.withAlpha(8)
                  : Colors.white.withAlpha(4),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? accentColor.withAlpha(120)
                : isUnlocked
                    ? Colors.white.withAlpha(20)
                    : Colors.white.withAlpha(8),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isUnlocked ? part.icon : Icons.lock_rounded,
              size: 28,
              color: isSelected
                  ? accentColor
                  : isUnlocked
                      ? Colors.white.withAlpha(180)
                      : Colors.white.withAlpha(50),
            ),
            const SizedBox(height: 6),
            Text(
              part.name,
              style: theme.textTheme.labelSmall?.copyWith(
                color: isUnlocked
                    ? Colors.white.withAlpha(isSelected ? 255 : 160)
                    : Colors.white.withAlpha(50),
                fontSize: 11,
              ),
            ),
            if (isSelected)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Icon(
                  Icons.check_circle_rounded,
                  size: 14,
                  color: accentColor,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
