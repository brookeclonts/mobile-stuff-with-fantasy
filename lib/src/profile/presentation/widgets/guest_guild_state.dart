import 'package:flutter/material.dart';
import 'package:swf_app/l10n/app_localizations.dart';
import 'package:swf_app/src/theme/swf_colors.dart';

/// The unauthenticated guild hall — shows a reader-focused CTA
/// to create an account. Styled to match the dark guild hall aesthetic.
class GuestGuildState extends StatelessWidget {
  const GuestGuildState({
    super.key,
    required this.onCreateAccount,
  });

  final VoidCallback onCreateAccount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [SwfColors.brandDark, SwfColors.primaryBackground],
            ),
            border: Border.all(
              color: SwfColors.secondaryAccent.withAlpha(80),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.shield_rounded,
                    size: 20,
                    color: SwfColors.secondaryAccent,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    l10n.guestGuildHallLabel,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: SwfColors.secondaryAccent,
                      letterSpacing: 2.0,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                l10n.guestGuildHeadline,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.guestGuildBody,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withAlpha(180),
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onCreateAccount,
                  child: Text(l10n.guestGuildButtonCreateAccount),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
