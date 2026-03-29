import 'package:flutter/material.dart';
import 'package:swf_app/l10n/app_localizations.dart';
import 'package:swf_app/src/theme/swf_colors.dart';

// ---------------------------------------------------------------------------
// Shared styling constants for all rune config bottom sheets
// ---------------------------------------------------------------------------

const _sheetBg = Color(0xFF2A2235);
const _sheetRadius = BorderRadius.vertical(top: Radius.circular(24));

/// Shared handle bar at the top of every rune config sheet.
class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 4,
      margin: const EdgeInsets.only(bottom: 20, top: 8),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(60),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

/// Shared section label inside rune config sheets.
class _ConfigSectionLabel extends StatelessWidget {
  const _ConfigSectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          text.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: SwfColors.secondaryAccent,
            letterSpacing: 1.5,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// ARC Shield — toggle ARC availability
// ---------------------------------------------------------------------------

/// Bottom sheet for the ARC Shield rune — lets readers mark themselves
/// as open to receiving Advance Reader Copies.
Future<void> showArcShieldConfig(
  BuildContext context, {
  required Color accentColor,
  required bool isArcEnabled,
  required ValueChanged<bool> onChanged,
}) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) => _ArcShieldSheet(
      accentColor: accentColor,
      isArcEnabled: isArcEnabled,
      onChanged: onChanged,
    ),
  );
}

class _ArcShieldSheet extends StatefulWidget {
  const _ArcShieldSheet({
    required this.accentColor,
    required this.isArcEnabled,
    required this.onChanged,
  });

  final Color accentColor;
  final bool isArcEnabled;
  final ValueChanged<bool> onChanged;

  @override
  State<_ArcShieldSheet> createState() => _ArcShieldSheetState();
}

class _ArcShieldSheetState extends State<_ArcShieldSheet> {
  late bool _enabled;

  @override
  void initState() {
    super.initState();
    _enabled = widget.isArcEnabled;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final accent = widget.accentColor;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      decoration: const BoxDecoration(
        color: _sheetBg,
        borderRadius: _sheetRadius,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _SheetHandle(),

          // Header
          Icon(Icons.shield_rounded, size: 32, color: accent),
          const SizedBox(height: 12),
          Text(
            l10n.arcShieldTitle,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.arcShieldDescription,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withAlpha(170),
              height: 1.4,
            ),
          ),

          const SizedBox(height: 24),
          _ConfigSectionLabel(l10n.arcShieldSectionAvailability),

          // Toggle
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _enabled
                  ? accent.withAlpha(15)
                  : Colors.white.withAlpha(8),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _enabled
                    ? accent.withAlpha(80)
                    : Colors.white.withAlpha(30),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _enabled
                      ? Icons.shield_rounded
                      : Icons.shield_outlined,
                  color: _enabled ? accent : Colors.white.withAlpha(120),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _enabled ? l10n.arcShieldToggleOpenLabel : l10n.arcShieldToggleClosedLabel,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: Colors.white.withAlpha(220),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _enabled
                            ? l10n.arcShieldToggleOpenSubtitle
                            : l10n.arcShieldToggleClosedSubtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white.withAlpha(130),
                        ),
                      ),
                    ],
                  ),
                ),
                Switch.adaptive(
                  value: _enabled,
                  activeTrackColor: accent,
                  onChanged: (value) {
                    setState(() => _enabled = value);
                    widget.onChanged(value);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Genre Attunement — pick genres and tropes
// ---------------------------------------------------------------------------

/// Bottom sheet for the Genre Attunement rune — lets readers select
/// their preferred genres and tropes.
Future<void> showGenreAttunementConfig(
  BuildContext context, {
  required Color accentColor,
  required Set<String> selectedGenres,
  required ValueChanged<Set<String>> onChanged,
}) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => _GenreAttunementSheet(
      accentColor: accentColor,
      selectedGenres: selectedGenres,
      onChanged: onChanged,
    ),
  );
}

class _GenreAttunementSheet extends StatefulWidget {
  const _GenreAttunementSheet({
    required this.accentColor,
    required this.selectedGenres,
    required this.onChanged,
  });

  final Color accentColor;
  final Set<String> selectedGenres;
  final ValueChanged<Set<String>> onChanged;

  @override
  State<_GenreAttunementSheet> createState() => _GenreAttunementSheetState();
}

class _GenreAttunementSheetState extends State<_GenreAttunementSheet> {
  late Set<String> _selected;

  static List<String> _genres(AppLocalizations l10n) => [
    l10n.genreEpicFantasy,
    l10n.genreDarkFantasy,
    l10n.genreUrbanFantasy,
    l10n.genreRomantasy,
    l10n.genreCozyFantasy,
    l10n.genreGrimdark,
    l10n.genreLitRpg,
    l10n.genreSwordAndSorcery,
    l10n.genreMythicFantasy,
    l10n.genrePortalFantasy,
  ];

  static List<String> _tropes(AppLocalizations l10n) => [
    l10n.tropeFoundFamily,
    l10n.tropeEnemiesToLovers,
    l10n.tropeChosenOne,
    l10n.tropeMagicSchools,
    l10n.tropeMorallyGrey,
    l10n.tropeSlowBurn,
    l10n.tropePoliticalIntrigue,
    l10n.tropeQuestJourney,
    l10n.tropeHiddenRoyalty,
    l10n.tropeRevengeArc,
  ];

  @override
  void initState() {
    super.initState();
    _selected = Set<String>.from(widget.selectedGenres);
  }

  void _toggle(String item) {
    setState(() {
      if (_selected.contains(item)) {
        _selected.remove(item);
      } else {
        _selected.add(item);
      }
    });
    widget.onChanged(_selected);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final accent = widget.accentColor;
    final genres = _genres(l10n);
    final tropes = _tropes(l10n);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      decoration: const BoxDecoration(
        color: _sheetBg,
        borderRadius: _sheetRadius,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _SheetHandle(),

            Icon(Icons.auto_awesome_rounded, size: 32, color: accent),
            const SizedBox(height: 12),
            Text(
              l10n.genreAttunementTitle,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.genreAttunementDescription,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white.withAlpha(170),
                height: 1.4,
              ),
            ),

            const SizedBox(height: 24),
            _ConfigSectionLabel(l10n.genreAttunementSectionGenres),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: genres
                  .map((g) => _SelectableChip(
                        label: g,
                        isSelected: _selected.contains(g),
                        accentColor: accent,
                        onTap: () => _toggle(g),
                      ))
                  .toList(),
            ),

            const SizedBox(height: 20),
            _ConfigSectionLabel(l10n.genreAttunementSectionTropes),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: tropes
                  .map((t) => _SelectableChip(
                        label: t,
                        isSelected: _selected.contains(t),
                        accentColor: accent,
                        onTap: () => _toggle(t),
                      ))
                  .toList(),
            ),

            const SizedBox(height: 16),

            if (_selected.isNotEmpty)
              Text(
                l10n.genreAttunementCountAttuned(_selected.length),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SelectableChip extends StatelessWidget {
  const _SelectableChip({
    required this.label,
    required this.isSelected,
    required this.accentColor,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected
              ? accentColor.withAlpha(30)
              : Colors.white.withAlpha(8),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isSelected
                ? accentColor.withAlpha(120)
                : Colors.white.withAlpha(40),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: isSelected
                ? accentColor
                : Colors.white.withAlpha(180),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Event Watchtower — notification preferences
// ---------------------------------------------------------------------------

/// Bottom sheet for the Event Watchtower rune — lets readers configure
/// push notification preferences for events and new drops.
Future<void> showEventWatchtowerConfig(
  BuildContext context, {
  required Color accentColor,
  required Set<String> enabledNotifications,
  required ValueChanged<Set<String>> onChanged,
}) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) => _EventWatchtowerSheet(
      accentColor: accentColor,
      enabledNotifications: enabledNotifications,
      onChanged: onChanged,
    ),
  );
}

class _EventWatchtowerSheet extends StatefulWidget {
  const _EventWatchtowerSheet({
    required this.accentColor,
    required this.enabledNotifications,
    required this.onChanged,
  });

  final Color accentColor;
  final Set<String> enabledNotifications;
  final ValueChanged<Set<String>> onChanged;

  @override
  State<_EventWatchtowerSheet> createState() => _EventWatchtowerSheetState();
}

class _EventWatchtowerSheetState extends State<_EventWatchtowerSheet> {
  late Set<String> _enabled;

  static List<({String id, String title, String description, IconData icon})> _notificationTypes(AppLocalizations l10n) => [
    (
      id: 'events',
      title: l10n.notifNewEventsTitle,
      description: l10n.notifNewEventsDescription,
      icon: Icons.celebration_rounded,
    ),
    (
      id: 'drops',
      title: l10n.notifBookDropsTitle,
      description: l10n.notifBookDropsDescription,
      icon: Icons.library_add_rounded,
    ),
    (
      id: 'recommendations',
      title: l10n.notifRecommendationsTitle,
      description: l10n.notifRecommendationsDescription,
      icon: Icons.recommend_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _enabled = Set<String>.from(widget.enabledNotifications);
  }

  void _toggle(String id) {
    setState(() {
      if (_enabled.contains(id)) {
        _enabled.remove(id);
      } else {
        _enabled.add(id);
      }
    });
    widget.onChanged(_enabled);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final accent = widget.accentColor;
    final notifTypes = _notificationTypes(l10n);

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      decoration: const BoxDecoration(
        color: _sheetBg,
        borderRadius: _sheetRadius,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _SheetHandle(),

          Icon(
            Icons.notifications_active_rounded,
            size: 32,
            color: accent,
          ),
          const SizedBox(height: 12),
          Text(
            l10n.eventWatchtowerTitle,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.eventWatchtowerDescription,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withAlpha(170),
              height: 1.4,
            ),
          ),

          const SizedBox(height: 24),
          _ConfigSectionLabel(l10n.eventWatchtowerSectionSignals),

          ...notifTypes.map(
            (type) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _NotificationToggle(
                title: type.title,
                description: type.description,
                icon: type.icon,
                isEnabled: _enabled.contains(type.id),
                accentColor: accent,
                onChanged: (_) => _toggle(type.id),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationToggle extends StatelessWidget {
  const _NotificationToggle({
    required this.title,
    required this.description,
    required this.icon,
    required this.isEnabled,
    required this.accentColor,
    required this.onChanged,
  });

  final String title;
  final String description;
  final IconData icon;
  final bool isEnabled;
  final Color accentColor;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isEnabled
            ? accentColor.withAlpha(12)
            : Colors.white.withAlpha(6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isEnabled
              ? accentColor.withAlpha(70)
              : Colors.white.withAlpha(25),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 22,
            color: isEnabled ? accentColor : Colors.white.withAlpha(100),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: Colors.white.withAlpha(220),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withAlpha(130),
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: isEnabled,
            activeTrackColor: accentColor,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
