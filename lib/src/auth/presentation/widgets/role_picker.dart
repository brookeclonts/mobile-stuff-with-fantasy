import 'package:flutter/material.dart';
import 'package:swf_app/l10n/app_localizations.dart';
import 'package:swf_app/src/auth/models/user.dart';
import 'package:swf_app/src/theme/swf_colors.dart';

/// Step 1: Choose your role — Reader, Influencer, or Author.
///
/// Three tappable cards with animated selection state.
class RolePicker extends StatelessWidget {
  const RolePicker({
    super.key,
    required this.selected,
    required this.onChanged,
    required this.onContinue,
  });

  final UserRole? selected;
  final ValueChanged<UserRole> onChanged;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 32),
          Text(
            l10n.rolePickerHeadline,
            style: theme.textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.rolePickerSubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          for (final role in UserRole.values) ...[
            _RoleCard(
              role: role,
              isSelected: selected == role,
              onTap: () => onChanged(role),
            ),
            if (role != UserRole.values.last) const SizedBox(height: 16),
          ],
          const Spacer(),
          AnimatedOpacity(
            opacity: selected != null ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            child: AnimatedSlide(
              offset: selected != null ? Offset.zero : const Offset(0, 0.15),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              child: ElevatedButton(
                onPressed: selected != null ? onContinue : null,
                child: Text(l10n.rolePickerContinue),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.role,
    required this.isSelected,
    required this.onTap,
  });

  final UserRole role;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark
                  ? SwfColors.color4.withAlpha(30)
                  : SwfColors.color4.withAlpha(20))
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? SwfColors.color4 : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: SwfColors.color4.withAlpha(30),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected
                    ? SwfColors.color4.withAlpha(40)
                    : (isDark
                        ? SwfColors.color3.withAlpha(80)
                        : SwfColors.color5.withAlpha(180)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                role.icon,
                color: isSelected
                    ? SwfColors.color4
                    : theme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    role.localizedLabel(AppLocalizations.of(context)!),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: isSelected
                          ? SwfColors.color4
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    role.localizedDescription(AppLocalizations.of(context)!),
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            AnimatedScale(
              scale: isSelected ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: SwfColors.color4,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
