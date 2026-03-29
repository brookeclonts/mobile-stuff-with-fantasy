import 'package:swf_app/l10n/app_localizations.dart';

class Event {
  const Event({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    this.description = '',
    this.bannerImage = '',
    this.eventType = 'stuffwithfantasy',
  });

  factory Event.fromJson(Map<String, Object?> json) {
    return Event(
      id: json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      startDate: _parseDate(json['startDate']),
      endDate: _parseDate(json['endDate']),
      bannerImage: json['bannerImage'] as String? ?? '',
      eventType: json['eventType'] as String? ?? 'stuffwithfantasy',
    );
  }

  final String id;
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String bannerImage;
  final String eventType;

  bool get isHappeningNow {
    final now = DateTime.now();
    return !now.isBefore(startDate) && !now.isAfter(endDate);
  }

  bool get isLastDay {
    final now = DateTime.now();
    return isHappeningNow &&
        now.year == endDate.year &&
        now.month == endDate.month &&
        now.day == endDate.day;
  }

  int get daysUntilStart {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final start = DateTime(startDate.year, startDate.month, startDate.day);
    return start.difference(today).inDays;
  }

  /// Whether this event should be shown in the banner (within 7 days or active).
  bool get shouldShowBanner => isHappeningNow || (daysUntilStart >= 0 && daysUntilStart <= 7);

  String localizedStatusLabel(AppLocalizations l10n) {
    if (isLastDay) return l10n.eventStatusLastDay;
    if (isHappeningNow) return l10n.eventStatusHappeningNow;
    final days = daysUntilStart;
    if (days == 0) return l10n.eventStatusStartsToday;
    if (days == 1) return l10n.eventStatusStartsTomorrow;
    return l10n.eventStatusStartsInDays(days);
  }

  String localizedDateRangeLabel(AppLocalizations l10n) {
    final start = _formatDate(startDate, l10n);
    final end = _formatDate(endDate, l10n);
    return '$start – $end';
  }

  static DateTime _parseDate(Object? raw) {
    if (raw is String) {
      return DateTime.tryParse(raw) ?? DateTime(2000);
    }
    return DateTime(2000);
  }

  static List<String> localizedMonths(AppLocalizations l10n) => [
        l10n.monthJan, l10n.monthFeb, l10n.monthMar, l10n.monthApr,
        l10n.monthMay, l10n.monthJun, l10n.monthJul, l10n.monthAug,
        l10n.monthSep, l10n.monthOct, l10n.monthNov, l10n.monthDec,
      ];

  static String _formatDate(DateTime date, AppLocalizations l10n) {
    final months = localizedMonths(l10n);
    return '${months[date.month - 1]} ${date.day}';
  }
}
