import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class FilterChipsWidget extends StatelessWidget {
  final Map<String, bool> selectedFilters;
  final Function(String, bool) onFilterChanged;

  const FilterChipsWidget({
    Key? key,
    required this.selectedFilters,
    required this.onFilterChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> filters = [
      {'key': 'movies', 'label': 'Movies'},
      {'key': 'shows', 'label': 'TV Shows'},
      {'key': 'actors', 'label': 'Actors'},
      {'key': 'recent', 'label': 'Recent'},
      {'key': 'popular', 'label': 'Popular'},
      {'key': 'rated', 'label': 'Top Rated'},
    ];

    return Container(
      height: 5.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final key = filter['key']!;
          final label = filter['label']!;
          final isSelected = selectedFilters[key] ?? false;

          return Container(
            margin: EdgeInsets.only(right: 2.w),
            child: FilterChip(
              label: Text(
                label,
                style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                  color: isSelected
                      ? AppTheme.darkTheme.colorScheme.onPrimary
                      : AppTheme.darkTheme.colorScheme.onSurface,
                ),
              ),
              selected: isSelected,
              backgroundColor: AppTheme.darkTheme.colorScheme.surface,
              selectedColor: AppTheme.secondaryBlue,
              side: BorderSide(
                color: isSelected
                    ? AppTheme.secondaryBlue
                    : AppTheme.darkTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                width: 1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              onSelected: (selected) => onFilterChanged(key, selected),
            ),
          );
        },
      ),
    );
  }
}
