import 'package:flutter/material.dart';
import 'package:swf_app/src/profile/models/recommendation_pairing.dart';
import 'package:swf_app/src/profile/presentation/widgets/forge_pairing_card.dart';
import 'package:swf_app/src/theme/swf_colors.dart';

/// Profile section showing the user's recommendation pairings in a
/// horizontally scrolling list of forge cards.
class RecommendationForgeSection extends StatelessWidget {
  const RecommendationForgeSection({
    super.key,
    required this.pairings,
    required this.accentColor,
    required this.onLightTheForge,
    this.onShare,
    this.onDelete,
    this.isLoading = false,
  });

  final List<RecommendationPairing> pairings;
  final Color accentColor;
  final VoidCallback onLightTheForge;
  final ValueChanged<RecommendationPairing>? onShare;
  final ValueChanged<RecommendationPairing>? onDelete;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: CircularProgressIndicator(color: SwfColors.secondaryAccent),
        ),
      );
    }

    if (pairings.isEmpty) {
      return _EmptyState(onLightTheForge: onLightTheForge);
    }

    return Column(
      children: [
        SizedBox(
          height: 280,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: pairings.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final pairing = pairings[index];
              return ForgePairingCard(
                pairing: pairing,
                accentColor: accentColor,
                onShare:
                    onShare != null ? () => onShare!(pairing) : null,
                onDelete:
                    onDelete != null ? () => onDelete!(pairing) : null,
              );
            },
          ),
        ),
        const SizedBox(height: 14),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onLightTheForge,
              icon: const Icon(Icons.auto_awesome, size: 16),
              label: const Text('Forge New Pairing'),
              style: OutlinedButton.styleFrom(
                foregroundColor: accentColor,
                side: BorderSide(color: accentColor.withAlpha(120)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onLightTheForge});

  final VoidCallback onLightTheForge;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2235),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: SwfColors.secondaryAccent.withAlpha(60),
          ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.auto_awesome,
              size: 36,
              color: SwfColors.secondaryAccent.withAlpha(180),
            ),
            const SizedBox(height: 12),
            Text(
              'THE FORGE IS COLD',
              style: theme.textTheme.labelSmall?.copyWith(
                color: Colors.white.withAlpha(220),
                letterSpacing: 1.5,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Bring two books together to forge a recommendation pairing. Your crafted bonds help fellow readers find their next obsession.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withAlpha(140),
                fontSize: 13,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onLightTheForge,
                style: ElevatedButton.styleFrom(
                  backgroundColor: SwfColors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  'Light the Forge',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
