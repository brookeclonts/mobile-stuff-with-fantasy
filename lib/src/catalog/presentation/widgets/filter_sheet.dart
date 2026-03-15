import 'package:flutter/material.dart';
import 'package:swf_app/src/catalog/models/book.dart';
import 'package:swf_app/src/catalog/presentation/widgets/filter_bar.dart';
import 'package:swf_app/src/theme/swf_colors.dart';

const List<String> _allSubgenres = [
  'Epic Fantasy',
  'Urban Fantasy',
  'Dark Fantasy',
  'Romantic Fantasy',
  'High Fantasy',
  'Low Fantasy',
  'Sword & Sorcery',
  'Mythological Fantasy',
  'Portal Fantasy',
  'Cozy Fantasy',
];

const List<String> _allTropes = [
  'Chosen One',
  'Enemies to Lovers',
  'Found Family',
  'Slow Burn',
  'Revenge Quest',
  'Hidden Royalty',
  'Forbidden Love',
  'Anti-Hero',
  'Magic Academy',
  'Fated Mates',
  'Morally Grey',
  'Forced Proximity',
  'Quest Narrative',
  'Prophecy',
  'Heist',
];

const List<String> _allAgeCategories = ['Adult', 'New Adult', 'Young Adult'];

const List<String> _allRepresentations = [
  'LGBTQ+',
  'BIPOC',
  'Disability',
  'Neurodivergent',
];

class FilterSheet extends StatefulWidget {
  const FilterSheet({
    super.key,
    required this.filters,
    required this.onApply,
  });

  final ActiveFilters filters;
  final ValueChanged<ActiveFilters> onApply;

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  late ActiveFilters _draft;

  @override
  void initState() {
    super.initState();
    _draft = widget.filters;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle + header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 12, 0),
                child: Row(
                  children: [
                    Text('Filters', style: theme.textTheme.titleLarge),
                    const Spacer(),
                    if (_draft.hasActiveFilters)
                      TextButton(
                        onPressed: () => setState(
                          () => _draft = const ActiveFilters(),
                        ),
                        child: const Text('Reset'),
                      ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(),

              // Filter sections
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _FilterSection(
                      title: 'Subgenres',
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: _allSubgenres.map((s) {
                            final selected = _draft.subgenres.contains(s);
                            return FilterChip(
                              label: Text(s),
                              selected: selected,
                              selectedColor: SwfColors.tropePill,
                              checkmarkColor: SwfColors.color3,
                              onSelected: (v) => _toggleSubgenre(s, v),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    _FilterSection(
                      title: 'Tropes',
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: _allTropes.map((t) {
                            final selected = _draft.tropes.contains(t);
                            return FilterChip(
                              label: Text(t),
                              selected: selected,
                              selectedColor: SwfColors.tropePill,
                              checkmarkColor: SwfColors.color3,
                              onSelected: (v) => _toggleTrope(t, v),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    _FilterSection(
                      title: 'Spice Level',
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: SpiceLevel.values.map((level) {
                            final selected =
                                _draft.spiceLevels.contains(level);
                            return FilterChip(
                              label: Text(level.label),
                              selected: selected,
                              selectedColor: SwfColors.spicinessPill,
                              checkmarkColor: SwfColors.color4,
                              onSelected: (v) => _toggleSpice(level, v),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    _FilterSection(
                      title: 'Age Category',
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: _allAgeCategories.map((a) {
                            final selected =
                                _draft.ageCategories.contains(a);
                            return FilterChip(
                              label: Text(a),
                              selected: selected,
                              selectedColor: SwfColors.representationPill,
                              checkmarkColor: SwfColors.color7,
                              onSelected: (v) => _toggleAge(a, v),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    _FilterSection(
                      title: 'Representation',
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: _allRepresentations.map((r) {
                            final selected =
                                _draft.representations.contains(r);
                            return FilterChip(
                              label: Text(r),
                              selected: selected,
                              selectedColor: SwfColors.representationPill,
                              checkmarkColor: SwfColors.color7,
                              onSelected: (v) => _toggleRepresentation(r, v),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    _FilterSection(
                      title: 'Language Level',
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: LanguageLevel.values.map((level) {
                            final selected =
                                _draft.languageLevels.contains(level);
                            return FilterChip(
                              label: Text(level.label),
                              selected: selected,
                              selectedColor: SwfColors.tropePill,
                              checkmarkColor: SwfColors.color3,
                              onSelected: (v) => _toggleLanguage(level, v),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),

              // Apply button
              Container(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(25),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onApply(_draft);
                      Navigator.pop(context);
                    },
                    child: Text(
                      _draft.hasActiveFilters
                          ? 'Apply Filters (${_draft.activeFilterCount})'
                          : 'Apply Filters',
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _toggleSubgenre(String value, bool selected) {
    setState(() {
      final updated = Set<String>.of(_draft.subgenres);
      selected ? updated.add(value) : updated.remove(value);
      _draft = _draft.copyWith(subgenres: updated);
    });
  }

  void _toggleTrope(String value, bool selected) {
    setState(() {
      final updated = Set<String>.of(_draft.tropes);
      selected ? updated.add(value) : updated.remove(value);
      _draft = _draft.copyWith(tropes: updated);
    });
  }

  void _toggleSpice(SpiceLevel value, bool selected) {
    setState(() {
      final updated = Set<SpiceLevel>.of(_draft.spiceLevels);
      selected ? updated.add(value) : updated.remove(value);
      _draft = _draft.copyWith(spiceLevels: updated);
    });
  }

  void _toggleAge(String value, bool selected) {
    setState(() {
      final updated = Set<String>.of(_draft.ageCategories);
      selected ? updated.add(value) : updated.remove(value);
      _draft = _draft.copyWith(ageCategories: updated);
    });
  }

  void _toggleRepresentation(String value, bool selected) {
    setState(() {
      final updated = Set<String>.of(_draft.representations);
      selected ? updated.add(value) : updated.remove(value);
      _draft = _draft.copyWith(representations: updated);
    });
  }

  void _toggleLanguage(LanguageLevel value, bool selected) {
    setState(() {
      final updated = Set<LanguageLevel>.of(_draft.languageLevels);
      selected ? updated.add(value) : updated.remove(value);
      _draft = _draft.copyWith(languageLevels: updated);
    });
  }
}

class _FilterSection extends StatelessWidget {
  const _FilterSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }
}
