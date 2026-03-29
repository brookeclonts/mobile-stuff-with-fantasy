import 'package:flutter/material.dart';
import 'package:swf_app/l10n/app_localizations.dart';

const _sheetBg = Color(0xFF2A2235);
const _sheetRadius = BorderRadius.vertical(top: Radius.circular(24));

/// Shows a bottom sheet for opting in/out of the realm leaderboard.
Future<bool?> showLeaderboardOptInSheet(
  BuildContext context, {
  required Color accentColor,
  required bool isOptedIn,
  required ValueChanged<bool> onChanged,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) => _LeaderboardOptInSheet(
      accentColor: accentColor,
      isOptedIn: isOptedIn,
      onChanged: onChanged,
    ),
  );
}

class _LeaderboardOptInSheet extends StatefulWidget {
  const _LeaderboardOptInSheet({
    required this.accentColor,
    required this.isOptedIn,
    required this.onChanged,
  });

  final Color accentColor;
  final bool isOptedIn;
  final ValueChanged<bool> onChanged;

  @override
  State<_LeaderboardOptInSheet> createState() => _LeaderboardOptInSheetState();
}

class _LeaderboardOptInSheetState extends State<_LeaderboardOptInSheet> {
  late bool _optedIn;

  @override
  void initState() {
    super.initState();
    _optedIn = widget.isOptedIn;
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
          // Handle bar
          Container(
            width: 36,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20, top: 8),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(60),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header icon
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accent.withAlpha(20),
              border: Border.all(color: accent.withAlpha(60)),
            ),
            child: Icon(
              Icons.emoji_events_rounded,
              size: 28,
              color: accent,
            ),
          ),
          const SizedBox(height: 14),

          Text(
            l10n.leaderboardOptInTitle,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.leaderboardOptInDescription,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withAlpha(170),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.leaderboardOptInPrivacy,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white.withAlpha(120),
              fontStyle: FontStyle.italic,
            ),
          ),

          const SizedBox(height: 24),

          // Toggle row
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _optedIn
                  ? accent.withAlpha(15)
                  : Colors.white.withAlpha(8),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _optedIn
                    ? accent.withAlpha(80)
                    : Colors.white.withAlpha(30),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _optedIn
                      ? Icons.shield_rounded
                      : Icons.shield_outlined,
                  color: _optedIn
                      ? accent
                      : Colors.white.withAlpha(120),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    _optedIn
                        ? l10n.leaderboardOptInActive
                        : l10n.leaderboardOptInInactive,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: Colors.white.withAlpha(220),
                    ),
                  ),
                ),
                Switch.adaptive(
                  value: _optedIn,
                  activeTrackColor: accent.withAlpha(180),
                  activeThumbColor: accent,
                  onChanged: (value) {
                    setState(() => _optedIn = value);
                    widget.onChanged(value);
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // CTA button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: accent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () => Navigator.pop(context, _optedIn),
              child: Text(
                _optedIn
                    ? l10n.leaderboardOptInJoinButton
                    : l10n.leaderboardOptInLeaveButton,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
