import 'package:flutter/material.dart';
import 'package:swf_app/l10n/app_localizations.dart';
import 'package:swf_app/src/guild/models/guild.dart';
import 'package:swf_app/src/theme/swf_colors.dart';

/// Card shown in the Guild Hub list for each guild the user belongs to.
///
/// Displays guild name, member count, and a gold accent left border.
class GuildCard extends StatelessWidget {
  const GuildCard({
    super.key,
    required this.guild,
    required this.onTap,
  });

  final Guild guild;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    const accent = SwfColors.secondaryAccent;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2235),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: accent.withAlpha(50)),
        ),
        child: Row(
          children: [
            // Gold accent bar
            Container(
              width: 4,
              height: 72,
              decoration: BoxDecoration(
                color: accent,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  bottomLeft: Radius.circular(14),
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      guild.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.guildMemberCountLabel(guild.memberCount),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withAlpha(140),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Chevron
            Padding(
              padding: const EdgeInsets.only(right: 14),
              child: Icon(
                Icons.chevron_right_rounded,
                color: Colors.white.withAlpha(80),
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
