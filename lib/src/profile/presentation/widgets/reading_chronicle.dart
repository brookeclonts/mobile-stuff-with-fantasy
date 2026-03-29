import 'package:flutter/material.dart';
import 'package:swf_app/l10n/app_localizations.dart';
import 'package:swf_app/src/profile/models/daily_reading_entry.dart';
import 'package:swf_app/src/profile/models/reading_stats.dart';
import 'package:swf_app/src/theme/swf_colors.dart';

/// GitHub-style reading activity heatmap with a parchment aesthetic.
class ReadingChronicle extends StatelessWidget {
  const ReadingChronicle({
    super.key,
    required this.entries,
    required this.stats,
    required this.accentColor,
  });

  final List<DailyReadingEntry> entries;
  final ReadingStats stats;
  final Color accentColor;

  // Parchment palette.
  static const _parchment = Color(0xFFF4F0E8);
  static const _inkMedium = Color(0xFF5C4F42);

  static const _cellSize = 13.0;
  static const _cellGap = 2.5;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    // Compute weekly pages from the last 7 entries.
    final lastWeek = entries.length >= 7
        ? entries.sublist(entries.length - 7)
        : entries;
    final weekPages = lastWeek.fold<double>(
      0.0,
      (sum, e) => sum + e.progressDelta,
    );
    final weekPagesEstimate = (weekPages * 300).round();

    // Find max reading seconds in a single day for color scaling.
    final maxSeconds = entries.fold<int>(
      0,
      (max, e) => e.totalSeconds > max ? e.totalSeconds : max,
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: _parchment,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: SwfColors.secondaryAccent.withAlpha(80),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──
            _Header(accentColor: accentColor),
            const SizedBox(height: 14),

            // ── Summary row ──
            Row(
              children: [
                Icon(
                  Icons.import_contacts_rounded,
                  size: 16,
                  color: _inkMedium,
                ),
                const SizedBox(width: 6),
                Text(
                  l10n.chroniclePagesThisWeek(weekPagesEstimate),
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: _inkMedium,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 16),
                if (stats.currentStreakDays > 0) ...[
                  Icon(
                    Icons.local_fire_department_rounded,
                    size: 16,
                    color: accentColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    l10n.chronicleStreak(stats.currentStreakDays),
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: _inkMedium,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 14),

            // ── Heatmap grid ──
            _HeatmapGrid(
              entries: entries,
              maxSeconds: maxSeconds,
              accentColor: accentColor,
            ),
            const SizedBox(height: 10),

            // ── Legend ──
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  l10n.chronicleLess,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: _inkMedium.withAlpha(140),
                    fontSize: 10,
                  ),
                ),
                const SizedBox(width: 4),
                for (var i = 0; i < 5; i++)
                  Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.only(right: 2),
                    decoration: BoxDecoration(
                      color: _cellColor(
                        i == 0 ? 0 : (i / 4),
                        accentColor,
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                const SizedBox(width: 2),
                Text(
                  l10n.chronicleMore,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: _inkMedium.withAlpha(140),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Color _cellColor(double intensity, Color accent) {
    if (intensity <= 0) return const Color(0xFFE8E0D4);
    final clamped = intensity.clamp(0.0, 1.0);
    // Lerp from light parchment-tone to accent color.
    return Color.lerp(
      const Color(0xFFE8E0D4),
      accent,
      0.25 + clamped * 0.75,
    )!;
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.accentColor});
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _OrnamentDot(color: accentColor),
        const SizedBox(width: 10),
        Text(
          'READING CHRONICLE',
          style: theme.textTheme.labelLarge?.copyWith(
            color: SwfColors.secondaryAccent,
            letterSpacing: 2.0,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 10),
        _OrnamentDot(color: accentColor),
      ],
    );
  }
}

class _OrnamentDot extends StatelessWidget {
  const _OrnamentDot({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 0.785398, // 45°
      child: Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          color: color.withAlpha(150),
          borderRadius: BorderRadius.circular(1),
        ),
      ),
    );
  }
}

class _HeatmapGrid extends StatelessWidget {
  const _HeatmapGrid({
    required this.entries,
    required this.maxSeconds,
    required this.accentColor,
  });

  final List<DailyReadingEntry> entries;
  final int maxSeconds;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    // Organize entries into columns (weeks), 7 rows each (Mon=0, Sun=6).
    // The last entry is today. We pad leading entries so the grid aligns.
    final totalDays = entries.length;
    final totalWeeks = (totalDays / 7).ceil();

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate how many weeks fit.
        final maxWeeks =
            ((constraints.maxWidth + ReadingChronicle._cellGap) /
                    (ReadingChronicle._cellSize + ReadingChronicle._cellGap))
                .floor();
        final weeks = totalWeeks.clamp(1, maxWeeks);
        final visibleDays = weeks * 7;
        final startIndex =
            (totalDays - visibleDays).clamp(0, totalDays);

        return Wrap(
          direction: Axis.vertical,
          spacing: ReadingChronicle._cellGap,
          runSpacing: ReadingChronicle._cellGap,
          children: [
            for (var week = 0; week < weeks; week++)
              for (var day = 0; day < 7; day++)
                () {
                  final idx = startIndex + week * 7 + day;
                  final entry =
                      idx < totalDays ? entries[idx] : null;
                  final intensity = (entry != null && maxSeconds > 0)
                      ? (entry.totalSeconds / maxSeconds).clamp(0.0, 1.0)
                      : 0.0;
                  return Container(
                    width: ReadingChronicle._cellSize,
                    height: ReadingChronicle._cellSize,
                    decoration: BoxDecoration(
                      color: ReadingChronicle._cellColor(
                        intensity,
                        accentColor,
                      ),
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  );
                }(),
          ],
        );
      },
    );
  }
}
