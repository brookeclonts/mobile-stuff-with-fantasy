import 'package:flutter/material.dart';
import 'package:swf_app/src/theme/swf_colors.dart';

/// A rune-stone themed progress bar for the Book Oath.
///
/// Shows milestone markers at 25%, 50%, 75%, and 100%.
/// Glows when the oath is complete.
class OathProgressBar extends StatelessWidget {
  const OathProgressBar({
    super.key,
    required this.progress,
    required this.accentColor,
    this.height = 14,
  });

  final double progress;
  final Color accentColor;
  final double height;

  @override
  Widget build(BuildContext context) {
    final clamped = progress.clamp(0.0, 1.0);
    final isComplete = clamped >= 1.0;

    return SizedBox(
      height: height + 16, // Extra space for milestone markers
      child: LayoutBuilder(
        builder: (context, constraints) {
          final barWidth = constraints.maxWidth;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              // Background track
              Positioned(
                top: 8,
                left: 0,
                right: 0,
                child: Container(
                  height: height,
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(15),
                    borderRadius: BorderRadius.circular(height / 2),
                    border: Border.all(
                      color: Colors.white.withAlpha(20),
                    ),
                  ),
                ),
              ),

              // Filled portion
              Positioned(
                top: 8,
                left: 0,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOutCubic,
                  width: barWidth * clamped,
                  height: height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(height / 2),
                    gradient: LinearGradient(
                      colors: [
                        accentColor.withAlpha(180),
                        accentColor,
                      ],
                    ),
                    boxShadow: isComplete
                        ? [
                            BoxShadow(
                              color: accentColor.withAlpha(80),
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                ),
              ),

              // Milestone markers
              for (final milestone in const [0.25, 0.5, 0.75, 1.0])
                Positioned(
                  top: 4,
                  left: (barWidth * milestone) - 4,
                  child: _MilestoneRune(
                    reached: clamped >= milestone,
                    accentColor: accentColor,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _MilestoneRune extends StatelessWidget {
  const _MilestoneRune({
    required this.reached,
    required this.accentColor,
  });

  final bool reached;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 0.785398, // 45 degrees
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: reached
              ? accentColor
              : SwfColors.primaryBackground,
          border: Border.all(
            color: reached
                ? accentColor.withAlpha(200)
                : Colors.white.withAlpha(40),
            width: 1.5,
          ),
          boxShadow: reached
              ? [
                  BoxShadow(
                    color: accentColor.withAlpha(60),
                    blurRadius: 6,
                  ),
                ]
              : null,
        ),
      ),
    );
  }
}
