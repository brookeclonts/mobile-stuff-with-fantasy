import 'package:flutter/material.dart';
import 'package:swf_app/src/profile/models/recommendation_pairing.dart';
import 'package:swf_app/src/theme/swf_colors.dart';

const _cardBg = Color(0xFF2A2235);

/// A card showing a "If you liked X, try Y" recommendation pairing.
///
/// Displays two book covers side-by-side connected by a gold chain icon,
/// with the pairing reason below.
class ForgePairingCard extends StatelessWidget {
  const ForgePairingCard({
    super.key,
    required this.pairing,
    required this.accentColor,
    this.onTap,
    this.onShare,
    this.onDelete,
  });

  final RecommendationPairing pairing;
  final Color accentColor;
  final VoidCallback? onTap;
  final VoidCallback? onShare;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: accentColor.withAlpha(80)),
          boxShadow: [
            BoxShadow(
              color: accentColor.withAlpha(20),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Book covers with chain link ──
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _BookCover(
                  imageUrl: pairing.sourceImageUrl,
                  title: pairing.sourceTitle,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Icon(
                    Icons.link_rounded,
                    color: SwfColors.secondaryAccent.withAlpha(200),
                    size: 18,
                  ),
                ),
                _BookCover(
                  imageUrl: pairing.targetImageUrl,
                  title: pairing.targetTitle,
                ),
              ],
            ),
            const SizedBox(height: 10),

            // ── "If you liked" label ──
            Text(
              'IF YOU LIKED',
              style: TextStyle(
                color: SwfColors.secondaryAccent.withAlpha(180),
                fontSize: 8,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              pairing.sourceTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),

            // ── "Try" label ──
            Text(
              'TRY',
              style: TextStyle(
                color: accentColor,
                fontSize: 8,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              pairing.targetTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),

            // ── Reason ──
            Expanded(
              child: Text(
                pairing.reason,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white.withAlpha(140),
                  fontSize: 11,
                  height: 1.3,
                ),
              ),
            ),

            // ── Actions ──
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (onShare != null)
                  GestureDetector(
                    onTap: onShare,
                    child: Icon(
                      Icons.share_outlined,
                      size: 16,
                      color: Colors.white.withAlpha(120),
                    ),
                  ),
                if (onDelete != null) ...[
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: onDelete,
                    child: Icon(
                      Icons.delete_outline,
                      size: 16,
                      color: Colors.white.withAlpha(120),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BookCover extends StatelessWidget {
  const _BookCover({required this.imageUrl, required this.title});

  final String imageUrl;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: SizedBox(
        width: 56,
        height: 80,
        child: imageUrl.isNotEmpty
            ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _CoverFallback(title: title),
              )
            : _CoverFallback(title: title),
      ),
    );
  }
}

class _CoverFallback extends StatelessWidget {
  const _CoverFallback({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: SwfColors.brandPurple.withAlpha(60),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(4),
      child: Text(
        title,
        textAlign: TextAlign.center,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.white.withAlpha(140),
          fontSize: 8,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
