import 'package:flutter/material.dart';
import 'package:swf_app/src/theme/swf_colors.dart';

/// Ornamental section divider with gold lines and a centered title.
///
/// Used to break up sections of the Guild Hall profile with a
/// fantasy-themed visual separator.
class SectionDivider extends StatelessWidget {
  const SectionDivider({
    super.key,
    required this.title,
    this.subtitle,
  });

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        SwfColors.secondaryAccent.withAlpha(120),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _Diamond(),
                    const SizedBox(width: 10),
                    Text(
                      title.toUpperCase(),
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: SwfColors.secondaryAccent,
                        letterSpacing: 2.0,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(width: 10),
                    _Diamond(),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        SwfColors.secondaryAccent.withAlpha(120),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 6),
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white.withAlpha(170),
                height: 1.3,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Diamond extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 0.785398,
      child: Container(
        width: 5,
        height: 5,
        color: SwfColors.secondaryAccent.withAlpha(140),
      ),
    );
  }
}
