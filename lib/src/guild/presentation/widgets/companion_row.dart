import 'package:flutter/material.dart';
import 'package:swf_app/l10n/app_localizations.dart';
import 'package:swf_app/src/guild/models/guild.dart';
import 'package:swf_app/src/theme/swf_colors.dart';

/// Displays guild members as a vertical list with role badges.
class CompanionRow extends StatelessWidget {
  const CompanionRow({
    super.key,
    required this.members,
  });

  final List<GuildMember> members;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    if (members.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final member in members)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                // Avatar circle with initials
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: SwfColors.secondaryAccent.withAlpha(25),
                    border: Border.all(
                      color: SwfColors.secondaryAccent.withAlpha(60),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      _initialsFor(member.name),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: SwfColors.secondaryAccent,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Name
                Expanded(
                  child: Text(
                    member.name.isNotEmpty ? member.name : member.userId,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Role badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: member.role == 'guildmaster'
                        ? SwfColors.secondaryAccent.withAlpha(30)
                        : Colors.white.withAlpha(10),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    member.role == 'guildmaster'
                        ? l10n.guildRoleGuildmaster
                        : l10n.guildRoleCompanion,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: member.role == 'guildmaster'
                          ? SwfColors.secondaryAccent
                          : Colors.white.withAlpha(120),
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  String _initialsFor(String name) {
    if (name.isEmpty) return '?';
    final parts = name
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .take(2)
        .toList();
    if (parts.isEmpty) return '?';
    return parts.map((p) => p.substring(0, 1)).join().toUpperCase();
  }
}
