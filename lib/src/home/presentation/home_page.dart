import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset('assets/images/sykfantasylogo.svg', height: 38),
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
                      children: const <Widget>[
                        _FeatureChip(
                          icon: Icons.auto_awesome_rounded,
                          label: 'Material 3',
                        ),
                        _FeatureChip(
                          icon: Icons.rule_folder_outlined,
                          label: 'Structured starter',
                        ),
                        _FeatureChip(
                          icon: Icons.fact_check_outlined,
                          label: 'Widget tests',
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Stuff With Fantasy',
                      style: theme.textTheme.displaySmall,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Your fantasy reading companion.',
                      style: theme.textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Discover, track, and share the fantasy books you love.',
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
                              child: const _InfoCard(
                                icon: Icons.foundation_outlined,
                                title: 'What is ready',
                                items: <String>[
                                  'A branded app shell with light and dark themes.',
                                  'A stricter analyzer baseline using flutter_lints.',
                                  'A widget test to protect the starter experience.',
                                ],
                              ),
                            ),
                            SizedBox(
                              width: cardWidth,
                              child: const _InfoCard(
                                icon: Icons.explore_outlined,
                                title: 'Where to go next',
                                items: <String>[
                                  'Add features under lib/src by domain instead of growing main.dart.',
                                  'Replace placeholder assets, launcher icons, and product copy.',
                                  'Run flutter analyze and flutter test as you add screens.',
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
                            'assets/images/sykfantasylogo.svg',
                            height: 100,
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                child: const Text('Get Started'),
                              ),
                              const SizedBox(width: 16),
                              OutlinedButton(
                                onPressed: () {},
                                child: const Text('Browse Books'),
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
