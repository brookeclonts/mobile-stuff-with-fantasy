import 'package:flutter/material.dart';
import 'package:swf_app/l10n/app_localizations.dart';
import 'package:swf_app/src/guild/models/guild.dart';
import 'package:swf_app/src/theme/swf_colors.dart';

/// Section displaying books in the guild's party ledger.
///
/// Shows each ledger entry with its book ID and an optional
/// remove action if the user is a member.
class PartyLedgerSection extends StatelessWidget {
  const PartyLedgerSection({
    super.key,
    required this.ledger,
    this.onRemove,
  });

  final List<GuildLedgerEntry> ledger;
  final ValueChanged<GuildLedgerEntry>? onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    const accent = SwfColors.secondaryAccent;

    if (ledger.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Text(
          l10n.guildDetailLedgerEmpty,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.white.withAlpha(100),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < ledger.length; i++)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2235),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white.withAlpha(10)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.menu_book_rounded,
                  size: 18,
                  color: accent.withAlpha(160),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ledger[i].bookId,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (onRemove != null)
                  GestureDetector(
                    onTap: () => onRemove!(ledger[i]),
                    child: Icon(
                      Icons.close_rounded,
                      size: 16,
                      color: Colors.white.withAlpha(60),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
