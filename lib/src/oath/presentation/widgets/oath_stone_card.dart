import 'package:flutter/material.dart';
import 'package:swf_app/l10n/app_localizations.dart';
import 'package:swf_app/src/oath/models/book_oath.dart';
import 'package:swf_app/src/oath/presentation/widgets/oath_progress_bar.dart';

/// Compact oath card for embedding in the profile page.
///
/// Shows the oath title, progress bar, and count.
/// Tappable to navigate to the full oath page.
class OathStoneCard extends StatelessWidget {
  const OathStoneCard({
    super.key,
    required this.oath,
    required this.accentColor,
    this.onTap,
  });

  final BookOath oath;
  final Color accentColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2235),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: accentColor.withAlpha(60),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: accentColor.withAlpha(20),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.auto_stories_rounded,
                  size: 18,
                  color: accentColor,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    oath.title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (oath.isComplete)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: accentColor.withAlpha(30),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      l10n.oathProgressComplete,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: accentColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            OathProgressBar(
              progress: oath.progress,
              accentColor: accentColor,
              height: 10,
            ),
            const SizedBox(height: 6),
            Text(
              l10n.oathProgressLabel(oath.currentCount, oath.targetCount),
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white.withAlpha(140),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// CTA card shown when the user has no active oath.
class OathSwearCta extends StatelessWidget {
  const OathSwearCta({
    super.key,
    required this.accentColor,
    required this.onTap,
  });

  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2235),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.white.withAlpha(20),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accentColor.withAlpha(20),
                border: Border.all(
                  color: accentColor.withAlpha(50),
                ),
              ),
              child: Icon(
                Icons.auto_stories_rounded,
                size: 20,
                color: accentColor.withAlpha(160),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.oathSwearCta,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.oathSwearSubtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withAlpha(120),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.white.withAlpha(60),
            ),
          ],
        ),
      ),
    );
  }
}
