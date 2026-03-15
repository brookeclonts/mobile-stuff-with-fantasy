import 'package:flutter/material.dart';
import 'package:swf_app/src/catalog/models/book.dart';
import 'package:swf_app/src/theme/swf_colors.dart';

class ActiveFilters {
  const ActiveFilters({
    this.searchQuery = '',
    this.subgenres = const {},
    this.tropes = const {},
    this.spiceLevels = const {},
    this.ageCategories = const {},
    this.representations = const {},
    this.languageLevels = const {},
    this.kindleUnlimitedOnly = false,
    this.audiobookOnly = false,
  });

  final String searchQuery;
  final Set<String> subgenres;
  final Set<String> tropes;
  final Set<SpiceLevel> spiceLevels;
  final Set<String> ageCategories;
  final Set<String> representations;
  final Set<LanguageLevel> languageLevels;
  final bool kindleUnlimitedOnly;
  final bool audiobookOnly;

  bool get hasActiveFilters =>
      subgenres.isNotEmpty ||
      tropes.isNotEmpty ||
      spiceLevels.isNotEmpty ||
      ageCategories.isNotEmpty ||
      representations.isNotEmpty ||
      languageLevels.isNotEmpty ||
      kindleUnlimitedOnly ||
      audiobookOnly;

  int get activeFilterCount =>
      subgenres.length +
      tropes.length +
      spiceLevels.length +
      ageCategories.length +
      representations.length +
      languageLevels.length +
      (kindleUnlimitedOnly ? 1 : 0) +
      (audiobookOnly ? 1 : 0);

  ActiveFilters copyWith({
    String? searchQuery,
    Set<String>? subgenres,
    Set<String>? tropes,
    Set<SpiceLevel>? spiceLevels,
    Set<String>? ageCategories,
    Set<String>? representations,
    Set<LanguageLevel>? languageLevels,
    bool? kindleUnlimitedOnly,
    bool? audiobookOnly,
  }) {
    return ActiveFilters(
      searchQuery: searchQuery ?? this.searchQuery,
      subgenres: subgenres ?? this.subgenres,
      tropes: tropes ?? this.tropes,
      spiceLevels: spiceLevels ?? this.spiceLevels,
      ageCategories: ageCategories ?? this.ageCategories,
      representations: representations ?? this.representations,
      languageLevels: languageLevels ?? this.languageLevels,
      kindleUnlimitedOnly: kindleUnlimitedOnly ?? this.kindleUnlimitedOnly,
      audiobookOnly: audiobookOnly ?? this.audiobookOnly,
    );
  }

  List<Book> apply(List<Book> books) {
    var result = books;

    if (searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      result = result
          .where(
            (b) =>
                b.title.toLowerCase().contains(q) ||
                b.authorName.toLowerCase().contains(q),
          )
          .toList();
    }
    if (subgenres.isNotEmpty) {
      result = result
          .where((b) => b.subgenres.any((s) => subgenres.contains(s)))
          .toList();
    }
    if (tropes.isNotEmpty) {
      result =
          result.where((b) => b.tropes.any((t) => tropes.contains(t))).toList();
    }
    if (spiceLevels.isNotEmpty) {
      result =
          result.where((b) => spiceLevels.contains(b.spiceLevel)).toList();
    }
    if (ageCategories.isNotEmpty) {
      result =
          result.where((b) => ageCategories.contains(b.ageCategory)).toList();
    }
    if (representations.isNotEmpty) {
      result = result
          .where(
            (b) => b.representations.any((r) => representations.contains(r)),
          )
          .toList();
    }
    if (languageLevels.isNotEmpty) {
      result = result
          .where((b) => languageLevels.contains(b.languageLevel))
          .toList();
    }
    if (kindleUnlimitedOnly) {
      result = result.where((b) => b.kindleUnlimited).toList();
    }
    if (audiobookOnly) {
      result = result.where((b) => b.hasAudiobook).toList();
    }

    return result;
  }
}

class FilterBar extends StatelessWidget {
  const FilterBar({
    super.key,
    required this.filters,
    required this.onFiltersChanged,
    required this.resultCount,
    required this.onOpenFilterSheet,
  });

  final ActiveFilters filters;
  final ValueChanged<ActiveFilters> onFiltersChanged;
  final int resultCount;
  final VoidCallback onOpenFilterSheet;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Search + filter button row
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (value) =>
                      onFiltersChanged(filters.copyWith(searchQuery: value)),
                  decoration: InputDecoration(
                    hintText: 'Search by title or author...',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    suffixIcon: filters.searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () => onFiltersChanged(
                              filters.copyWith(searchQuery: ''),
                            ),
                          )
                        : null,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Badge(
                isLabelVisible: filters.hasActiveFilters,
                label: Text('${filters.activeFilterCount}'),
                child: IconButton.filled(
                  onPressed: onOpenFilterSheet,
                  style: IconButton.styleFrom(
                    backgroundColor: filters.hasActiveFilters
                        ? colorScheme.primary
                        : colorScheme.surfaceContainerHighest,
                    foregroundColor: filters.hasActiveFilters
                        ? colorScheme.onPrimary
                        : colorScheme.onSurface,
                  ),
                  icon: const Icon(Icons.tune_rounded, size: 20),
                ),
              ),
            ],
          ),
        ),

        // Quick filter chips
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _QuickChip(
                label: 'KU',
                icon: Icons.auto_stories_outlined,
                selected: filters.kindleUnlimitedOnly,
                onSelected: (v) =>
                    onFiltersChanged(filters.copyWith(kindleUnlimitedOnly: v)),
              ),
              const SizedBox(width: 8),
              _QuickChip(
                label: 'Audiobook',
                icon: Icons.headphones_rounded,
                selected: filters.audiobookOnly,
                onSelected: (v) =>
                    onFiltersChanged(filters.copyWith(audiobookOnly: v)),
              ),
              const SizedBox(width: 8),
              ...SpiceLevel.values.map(
                (level) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _QuickChip(
                    label: level.label,
                    selected: filters.spiceLevels.contains(level),
                    onSelected: (selected) {
                      final updated = Set<SpiceLevel>.of(filters.spiceLevels);
                      selected ? updated.add(level) : updated.remove(level);
                      onFiltersChanged(
                        filters.copyWith(spiceLevels: updated),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),

        // Active filter pills + result count
        if (filters.hasActiveFilters)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Row(
              children: [
                Text(
                  '$resultCount ${resultCount == 1 ? 'book' : 'books'}',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () =>
                      onFiltersChanged(const ActiveFilters()),
                  icon: const Icon(Icons.clear_all, size: 16),
                  label: const Text('Clear all'),
                ),
              ],
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Text(
              '$resultCount ${resultCount == 1 ? 'book' : 'books'}',
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
      ],
    );
  }
}

class _QuickChip extends StatelessWidget {
  const _QuickChip({
    required this.label,
    required this.selected,
    required this.onSelected,
    this.icon,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      avatar: icon != null ? Icon(icon, size: 16) : null,
      selected: selected,
      onSelected: onSelected,
      selectedColor: SwfColors.color4.withAlpha(50),
      checkmarkColor: SwfColors.color4,
      visualDensity: VisualDensity.compact,
    );
  }
}
