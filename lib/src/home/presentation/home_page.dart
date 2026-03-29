import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swf_app/l10n/app_localizations.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset('assets/images/swf_logo_cream.svg', height: 38),
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              colorScheme.surface,
              colorScheme.surfaceContainerHighest,
              colorScheme.primaryContainer.withValues(alpha: 0.65),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 960),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: <Widget>[
                        _FeatureChip(
                          icon: Icons.auto_awesome_rounded,
                          label: l10n.homeChipMaterial3,
                        ),
                        _FeatureChip(
                          icon: Icons.rule_folder_outlined,
                          label: l10n.homeChipStructuredStarter,
                        ),
                        _FeatureChip(
                          icon: Icons.fact_check_outlined,
                          label: l10n.homeChipWidgetTests,
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Text(
                      l10n.homeHeadline,
                      style: theme.textTheme.displaySmall,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.homeTagline,
                      style: theme.textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.homeSubtitle,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),
                    LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints) {
                        final cardWidth = constraints.maxWidth >= 760
                            ? (constraints.maxWidth - 16) / 2
                            : constraints.maxWidth;

                        return Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: <Widget>[
                            SizedBox(
                              width: cardWidth,
                              child: _InfoCard(
                                icon: Icons.foundation_outlined,
                                title: l10n.homeCardWhatIsReadyTitle,
                                items: <String>[
                                  l10n.homeCardWhatIsReadyItem1,
                                  l10n.homeCardWhatIsReadyItem2,
                                  l10n.homeCardWhatIsReadyItem3,
                                ],
                              ),
                            ),
                            SizedBox(
                              width: cardWidth,
                              child: _InfoCard(
                                icon: Icons.explore_outlined,
                                title: l10n.homeCardWhereToGoNextTitle,
                                items: <String>[
                                  l10n.homeCardWhereToGoNextItem1,
                                  l10n.homeCardWhereToGoNextItem2,
                                  l10n.homeCardWhereToGoNextItem3,
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 32),
                    Center(
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            'assets/images/swf_logo_cream.svg',
                            height: 100,
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                child: Text(l10n.homeGetStarted),
                              ),
                              const SizedBox(width: 16),
                              OutlinedButton(
                                onPressed: () {},
                                child: Text(l10n.homeBrowseBooks),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  const _FeatureChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Chip(
      avatar: Icon(icon, color: colorScheme.primary, size: 18),
      backgroundColor: colorScheme.surface.withValues(alpha: 0.8),
      label: Text(label),
      side: BorderSide(color: colorScheme.outlineVariant),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.items,
  });

  final IconData icon;
  final String title;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      color: colorScheme.surface.withValues(alpha: 0.8),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(icon, color: colorScheme.primary, size: 28),
            const SizedBox(height: 16),
            Text(title, style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            for (final item in items)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Icon(
                        Icons.arrow_outward_rounded,
                        color: colorScheme.secondary,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        item,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
