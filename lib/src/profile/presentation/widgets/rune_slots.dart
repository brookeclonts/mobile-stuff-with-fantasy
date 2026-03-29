import 'package:flutter/material.dart';
import 'package:swf_app/l10n/app_localizations.dart';
import 'package:swf_app/src/profile/models/ability_rune.dart';
import 'package:swf_app/src/profile/models/skill_tree.dart';
import 'package:swf_app/src/profile/presentation/widgets/skill_tree_view.dart';
import 'package:swf_app/src/theme/swf_colors.dart';

/// Displays ability runes either as a skill tree visualization or as a
/// flat row of rune nodes.
///
/// When [skillTree] is provided, renders [SkillTreeView] instead of the
/// flat rune row. The flat row is kept as a fallback when [skillTree] is null.
class RuneSlots extends StatelessWidget {
  const RuneSlots({
    super.key,
    required this.runes,
    required this.completedScrollIds,
    required this.accentColor,
    this.onRuneTapped,
    this.skillTree,
    this.onTierTapped,
  });

  final List<AbilityRune> runes;
  final Set<String> completedScrollIds;
  final Color accentColor;

  /// Called when an unlocked rune is tapped. The rune ID is passed.
  final ValueChanged<String>? onRuneTapped;

  /// If non-null, show the skill tree view instead of the flat rune row.
  final SkillTree? skillTree;

  /// Called when a tier node is tapped in the skill tree.
  final void Function(String branchId, String tierId)? onTierTapped;

  @override
  Widget build(BuildContext context) {
    if (skillTree != null) {
      return SkillTreeView(
        skillTree: skillTree!,
        accentColor: accentColor,
        onTierTapped: onTierTapped,
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          for (int i = 0; i < runes.length; i++) ...[
            if (i > 0) const SizedBox(width: 10),
            Expanded(
              child: _RuneNode(
                rune: runes[i],
                isUnlocked: completedScrollIds.contains(
                  runes[i].unlocksAfterScrollId,
                ),
                accentColor: accentColor,
                onRuneTapped: onRuneTapped,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _RuneNode extends StatelessWidget {
  const _RuneNode({
    required this.rune,
    required this.isUnlocked,
    required this.accentColor,
    this.onRuneTapped,
  });

  final AbilityRune rune;
  final bool isUnlocked;
  final Color accentColor;
  final ValueChanged<String>? onRuneTapped;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => _showRuneDetail(context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isUnlocked
              ? accentColor.withAlpha(20)
              : Colors.white.withAlpha(12),
          border: Border.all(
            color: isUnlocked
                ? accentColor.withAlpha(100)
                : Colors.white.withAlpha(40),
            width: isUnlocked ? 1.5 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Rune icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isUnlocked
                    ? accentColor.withAlpha(30)
                    : Colors.white.withAlpha(12),
                border: Border.all(
                  color: isUnlocked
                      ? accentColor.withAlpha(120)
                      : Colors.white.withAlpha(50),
                  width: 1.5,
                ),
                boxShadow: isUnlocked
                    ? [
                        BoxShadow(
                          color: accentColor.withAlpha(35),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                isUnlocked ? rune.icon : Icons.lock_outline_rounded,
                size: 20,
                color: isUnlocked
                    ? accentColor
                    : Colors.white.withAlpha(80),
              ),
            ),

            const SizedBox(height: 10),

            // Title
            Text(
              rune.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelSmall?.copyWith(
                color: isUnlocked
                    ? Colors.white.withAlpha(220)
                    : Colors.white.withAlpha(120),
                fontWeight: FontWeight.w600,
                fontSize: 10,
                height: 1.2,
              ),
            ),

            const SizedBox(height: 4),

            // Status dot
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isUnlocked
                    ? accentColor
                    : Colors.white.withAlpha(50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRuneDetail(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          decoration: const BoxDecoration(
            color: Color(0xFF2A2235),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(60),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Rune icon
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isUnlocked
                      ? accentColor.withAlpha(30)
                      : Colors.white.withAlpha(15),
                  border: Border.all(
                    color: isUnlocked
                        ? accentColor.withAlpha(120)
                        : Colors.white.withAlpha(50),
                    width: 2,
                  ),
                  boxShadow: isUnlocked
                      ? [
                          BoxShadow(
                            color: accentColor.withAlpha(40),
                            blurRadius: 16,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                child: Icon(
                  isUnlocked ? rune.icon : Icons.lock_outline_rounded,
                  size: 28,
                  color: isUnlocked
                      ? accentColor
                      : Colors.white.withAlpha(90),
                ),
              ),

              const SizedBox(height: 18),

              // Status label
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: isUnlocked
                      ? accentColor.withAlpha(25)
                      : Colors.white.withAlpha(15),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: isUnlocked
                        ? accentColor.withAlpha(80)
                        : Colors.white.withAlpha(40),
                  ),
                ),
                child: Text(
                  isUnlocked ? l10n.runeStatusEngraved : l10n.runeStatusLocked,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isUnlocked
                        ? accentColor
                        : Colors.white.withAlpha(130),
                    letterSpacing: 1.5,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // Title
              Text(
                rune.title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 10),

              // Description
              Text(
                rune.description,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withAlpha(160),
                  height: 1.5,
                ),
              ),

              if (!isUnlocked) ...[
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 14,
                      color: SwfColors.secondaryAccent.withAlpha(120),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      l10n.runeDetailLockedHint,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: SwfColors.secondaryAccent.withAlpha(120),
                      ),
                    ),
                  ],
                ),
              ],

              if (isUnlocked) ...[
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onRuneTapped?.call(rune.id);
                    },
                    child: Text(l10n.runeDetailConfigure),
                  ),
                ),
              ],

              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}
