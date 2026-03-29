import 'package:flutter/material.dart';
import 'package:swf_app/src/catalog/models/book.dart';
import 'package:swf_app/src/catalog/models/taxonomy.dart';
import 'package:swf_app/src/theme/swf_colors.dart';

class ActiveFilters {
  const ActiveFilters({
    this.searchQuery = '',
    this.subgenreIds = const {},
    this.tropeIds = const {},
    this.spiceLevelIds = const {},
    this.ageCategoryIds = const {},
    this.representationIds = const {},
    this.languageLevels = const {},
    this.kindleUnlimitedOnly = false,
    this.audiobookOnly = false,
  });

  final String searchQuery;
  final Set<String> subgenreIds;
  final Set<String> tropeIds;
  final Set<String> spiceLevelIds;
  final Set<String> ageCategoryIds;
  final Set<String> representationIds;
  final Set<LanguageLevel> languageLevels;
  final bool kindleUnlimitedOnly;
  final bool audiobookOnly;

  bool get hasActiveFilters =>
      searchQuery.trim().isNotEmpty ||
      hasSheetFilters;

  bool get hasSheetFilters =>
      subgenreIds.isNotEmpty ||
      tropeIds.isNotEmpty ||
      spiceLevelIds.isNotEmpty ||
      ageCategoryIds.isNotEmpty ||
      representationIds.isNotEmpty ||
      languageLevels.isNotEmpty ||
      kindleUnlimitedOnly ||
      audiobookOnly;

  int get activeFilterCount =>
      (searchQuery.trim().isNotEmpty ? 1 : 0) +
      activeSheetFilterCount;

  int get activeSheetFilterCount =>
      subgenreIds.length +
      tropeIds.length +
      spiceLevelIds.length +
      ageCategoryIds.length +
      representationIds.length +
      languageLevels.length +
      (kindleUnlimitedOnly ? 1 : 0) +
      (audiobookOnly ? 1 : 0);

  ActiveFilters copyWith({
    String? searchQuery,
    Set<String>? subgenreIds,
    Set<String>? tropeIds,
    Set<String>? spiceLevelIds,
    Set<String>? ageCategoryIds,
    Set<String>? representationIds,
    Set<LanguageLevel>? languageLevels,
    bool? kindleUnlimitedOnly,
    bool? audiobookOnly,
  }) {
    return ActiveFilters(
      searchQuery: searchQuery ?? this.searchQuery,
      subgenreIds: subgenreIds ?? this.subgenreIds,
      tropeIds: tropeIds ?? this.tropeIds,
      spiceLevelIds: spiceLevelIds ?? this.spiceLevelIds,
      ageCategoryIds: ageCategoryIds ?? this.ageCategoryIds,
      representationIds: representationIds ?? this.representationIds,
      languageLevels: languageLevels ?? this.languageLevels,
      kindleUnlimitedOnly: kindleUnlimitedOnly ?? this.kindleUnlimitedOnly,
      audiobookOnly: audiobookOnly ?? this.audiobookOnly,
    );
  }
}

class FilterBar extends StatelessWidget {
  const FilterBar({
    super.key,
    required this.filters,
    required this.taxonomy,
    required this.searchController,
    required this.onFiltersChanged,
    required this.onSearchChanged,
    required this.onClearAll,
    required this.resultCount,
    required this.onOpenFilterSheet,
  });

  final ActiveFilters filters;
  final TaxonomyData taxonomy;
  final TextEditingController searchController;
  final ValueChanged<ActiveFilters> onFiltersChanged;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClearAll;
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
                  controller: searchController,
                  onChanged: onSearchChanged,
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
                            onPressed: () {
                              searchController.clear();
                              onSearchChanged('');
                            },
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
                  onPressed: taxonomy.isEmpty ? null : onOpenFilterSheet,
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
              if (taxonomy.spiceLevels.isNotEmpty) const SizedBox(width: 8),
              ...taxonomy.spiceLevels.map(
                (level) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _QuickChip(
                    label: level.name,
                    selected: filters.spiceLevelIds.contains(level.id),
                    onSelected: (selected) {
                      final updated = Set<String>.of(filters.spiceLevelIds);
                      selected ? updated.add(level.id) : updated.remove(level.id);
                      onFiltersChanged(
                        filters.copyWith(spiceLevelIds: updated),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),

        // Clear-all row (only when filters active)
        if (filters.hasActiveFilters)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
            child: Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: onClearAll,
                icon: const Icon(Icons.clear_all, size: 16),
                label: const Text('Clear all'),
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
