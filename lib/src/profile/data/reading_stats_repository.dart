import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:swf_app/src/profile/models/daily_reading_entry.dart';
import 'package:swf_app/src/profile/models/reading_session.dart';
import 'package:swf_app/src/profile/models/reading_stats.dart';

class ReadingStatsRepository {
  static const _statsKey = 'reading_stats';
  static const _dailyKey = 'daily_reading';

  ReadingSession? _activeSession;

  // ── Session lifecycle ──────────────────────────────────────────────────────

  void startSession(String bookId, String bookTitle, double currentProgress) {
    _activeSession = ReadingSession(
      bookId: bookId,
      bookTitle: bookTitle,
      startedAt: DateTime.now(),
      progressStart: currentProgress,
    )..latestProgress = currentProgress;
  }

  void recordProgress(String bookId, double progress) {
    if (_activeSession == null || _activeSession!.bookId != bookId) return;
    _activeSession!.latestProgress = progress;
  }

  Future<void> endSession() async {
    final session = _activeSession;
    if (session == null) return;
    _activeSession = null;

    final now = DateTime.now();
    final durationSeconds = now.difference(session.startedAt).inSeconds;
    if (durationSeconds < 5) return; // ignore trivial opens

    final progressDelta =
        (session.latestProgress - session.progressStart).clamp(0.0, 1.0);

    // Update daily entry.
    final dateKey = _dateKey(now);
    final entry = DailyReadingEntry(
      dateKey: dateKey,
      totalSeconds: durationSeconds,
      progressDelta: progressDelta,
      sessionCount: 1,
    );
    await _mergeDailyEntry(entry);

    // Update aggregate stats.
    await _updateStats(
      bookId: session.bookId,
      durationSeconds: durationSeconds,
      progressDelta: progressDelta,
      latestProgress: session.latestProgress,
      now: now,
    );
  }

  // ── Queries ────────────────────────────────────────────────────────────────

  Future<ReadingStats> getStats() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_statsKey);
    if (raw == null) return const ReadingStats();
    return ReadingStats.fromJson(
      json.decode(raw) as Map<String, Object?>,
    );
  }

  Future<List<DailyReadingEntry>> getDailyEntries({int days = 180}) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_dailyKey);
    final map = raw != null
        ? (json.decode(raw) as Map<String, Object?>)
            .map((k, v) => MapEntry(k, v as Map<String, Object?>))
        : <String, Map<String, Object?>>{};

    final now = DateTime.now();
    final entries = <DailyReadingEntry>[];
    for (var i = days - 1; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final key = _dateKey(date);
      final data = map[key];
      entries.add(
        data != null
            ? DailyReadingEntry.fromJson(data)
            : DailyReadingEntry(dateKey: key),
      );
    }
    return entries;
  }

  // ── Internals ──────────────────────────────────────────────────────────────

  Future<void> _mergeDailyEntry(DailyReadingEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_dailyKey);
    final map = raw != null
        ? (json.decode(raw) as Map<String, Object?>)
            .map((k, v) => MapEntry(k, v as Map<String, Object?>))
        : <String, Map<String, Object?>>{};

    final existing = map[entry.dateKey];
    if (existing != null) {
      entry = DailyReadingEntry.fromJson(existing).merge(entry);
    }
    map[entry.dateKey] = entry.toJson();

    // Prune entries older than 365 days to prevent unbounded growth.
    final cutoff =
        _dateKey(DateTime.now().subtract(const Duration(days: 365)));
    map.removeWhere((key, _) => key.compareTo(cutoff) < 0);

    await prefs.setString(_dailyKey, json.encode(map));
  }

  Future<void> _updateStats({
    required String bookId,
    required int durationSeconds,
    required double progressDelta,
    required double latestProgress,
    required DateTime now,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_statsKey);
    var stats = raw != null
        ? ReadingStats.fromJson(json.decode(raw) as Map<String, Object?>)
        : const ReadingStats();

    // Update book progress map.
    final updatedBookProgress = Map<String, double>.from(stats.bookProgress);
    final previousBest = updatedBookProgress[bookId] ?? 0.0;
    if (latestProgress > previousBest) {
      updatedBookProgress[bookId] = latestProgress;
    }

    // Count newly completed books (>= 0.95 progress).
    final wasCompleted = previousBest >= 0.95;
    final isCompleted = latestProgress >= 0.95;
    final newCompletions = (!wasCompleted && isCompleted) ? 1 : 0;

    // Compute streak.
    final today = DateTime(now.year, now.month, now.day);
    var currentStreak = stats.currentStreakDays;
    var longestStreak = stats.longestStreakDays;

    if (stats.lastReadDate != null) {
      final lastDay = DateTime(
        stats.lastReadDate!.year,
        stats.lastReadDate!.month,
        stats.lastReadDate!.day,
      );
      final gap = today.difference(lastDay).inDays;
      if (gap == 0) {
        // Same day — no streak change.
      } else if (gap == 1) {
        currentStreak += 1;
      } else {
        currentStreak = 1;
      }
    } else {
      currentStreak = 1;
    }
    if (currentStreak > longestStreak) longestStreak = currentStreak;

    stats = stats.copyWith(
      totalBooksCompleted: stats.totalBooksCompleted + newCompletions,
      totalSessionCount: stats.totalSessionCount + 1,
      totalReadingSeconds: stats.totalReadingSeconds + durationSeconds,
      totalProgressPoints: stats.totalProgressPoints + progressDelta,
      currentStreakDays: currentStreak,
      longestStreakDays: longestStreak,
      lastReadDate: now,
      bookProgress: updatedBookProgress,
    );

    await prefs.setString(_statsKey, json.encode(stats.toJson()));
  }

  static String _dateKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
