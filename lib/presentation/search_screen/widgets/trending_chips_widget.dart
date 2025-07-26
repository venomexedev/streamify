import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class TrendingChipsWidget extends StatelessWidget {
  final Function(String) onChipTap;

  const TrendingChipsWidget({
    Key? key,
    required this.onChipTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> trendingSearches = [
      'Action Movies',
      'Marvel',
      'Comedy Shows',
      'Thriller',
      'Sci-Fi',
      'Romance',
      'Horror',
      'Documentary',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          child: Text(
            'Trending Searches',
            style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.darkTheme.colorScheme.onSurface,
            ),
          ),
        ),
        Container(
          height: 5.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            itemCount: trendingSearches.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(right: 2.w),
                child: ActionChip(
                  label: Text(
                    trendingSearches[index],
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.darkTheme.colorScheme.onSurface,
                    ),
                  ),
                  backgroundColor: AppTheme.darkTheme.colorScheme.surface,
                  side: BorderSide(
                    color: AppTheme.secondaryBlue.withValues(alpha: 0.3),
                    width: 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  onPressed: () => onChipTap(trendingSearches[index]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
