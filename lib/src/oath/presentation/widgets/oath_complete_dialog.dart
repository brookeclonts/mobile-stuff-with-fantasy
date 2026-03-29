import 'package:flutter/material.dart';
import 'package:swf_app/l10n/app_localizations.dart';

/// Shows a ceremony dialog when the user fulfills their book oath.
///
/// Follows the same pattern as [showRewardReveal] from the quest system.
Future<void> showOathComplete(
  BuildContext context, {
  required Color accentColor,
}) {
  final l10n = AppLocalizations.of(context)!;

  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: l10n.oathCompleteTitle,
    barrierColor: Colors.black87,
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (_, _, _) => _OathCompleteDialog(
      accentColor: accentColor,
    ),
    transitionBuilder: (_, animation, _, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutBack,
        reverseCurve: Curves.easeIn,
      );
      return FadeTransition(
        opacity: animation,
        child: ScaleTransition(scale: curved, child: child),
      );
    },
  );
}

class _OathCompleteDialog extends StatelessWidget {
  const _OathCompleteDialog({required this.accentColor});

  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.fromLTRB(28, 32, 28, 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: const Color(0xFF2A2235),
              border: Border.all(
                color: accentColor.withAlpha(100),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: accentColor.withAlpha(40),
                  blurRadius: 40,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Glowing oath icon
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.7, end: 1),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.elasticOut,
                  builder: (context, scale, child) {
                    return Transform.scale(scale: scale, child: child);
                  },
                  child: Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: accentColor.withAlpha(30),
                      border: Border.all(
                        color: accentColor.withAlpha(80),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: accentColor.withAlpha(50),
                          blurRadius: 24,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.auto_stories_rounded,
                      size: 40,
                      color: accentColor,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  l10n.oathCompleteTitle,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: accentColor,
                    letterSpacing: 2.0,
                    fontSize: 11,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  l10n.oathCompleteHeadline,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  l10n.oathCompleteBody,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withAlpha(180),
                    height: 1.45,
                  ),
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(l10n.oathCompleteContinue),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
