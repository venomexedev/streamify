import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecentSearchesWidget extends StatelessWidget {
  final List<String> recentSearches;
  final Function(String) onSearchTap;
  final Function(String) onRemoveSearch;
  final VoidCallback onClearAll;

  const RecentSearchesWidget({
    Key? key,
    required this.recentSearches,
    required this.onSearchTap,
    required this.onRemoveSearch,
    required this.onClearAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (recentSearches.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Searches',
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.darkTheme.colorScheme.onSurface,
                ),
              ),
              TextButton(
                onPressed: onClearAll,
                child: Text(
                  'Clear All',
                  style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.secondaryBlue,
                  ),
                ),
              ),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: recentSearches.length > 5 ? 5 : recentSearches.length,
          itemBuilder: (context, index) {
            final search = recentSearches[index];
            return ListTile(
              leading: CustomIconWidget(
                iconName: 'history',
                color: AppTheme.darkTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
              title: Text(
                search,
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.darkTheme.colorScheme.onSurface,
                ),
              ),
              trailing: GestureDetector(
                onTap: () => onRemoveSearch(search),
                child: CustomIconWidget(
                  iconName: 'close',
                  color: AppTheme.darkTheme.colorScheme.onSurfaceVariant,
                  size: 18,
                ),
              ),
              onTap: () => onSearchTap(search),
            );
          },
        ),
      ],
    );
  }
}
