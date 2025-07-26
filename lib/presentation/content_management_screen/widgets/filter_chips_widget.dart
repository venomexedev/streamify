import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterChipsWidget extends StatelessWidget {
  final String selectedStatus;
  final String selectedGenre;
  final String selectedDateRange;
  final Function(String) onStatusChanged;
  final Function(String) onGenreChanged;
  final Function(String) onDateRangeChanged;

  const FilterChipsWidget({
    Key? key,
    required this.selectedStatus,
    required this.selectedGenre,
    required this.selectedDateRange,
    required this.onStatusChanged,
    required this.onGenreChanged,
    required this.onDateRangeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filter by Status',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                ),
          ),
          SizedBox(height: 1.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip(
                  context,
                  isDarkMode,
                  label: 'All',
                  isSelected: selectedStatus == 'all',
                  onTap: () => onStatusChanged('all'),
                ),
                SizedBox(width: 2.w),
                _buildFilterChip(
                  context,
                  isDarkMode,
                  label: 'Published',
                  isSelected: selectedStatus == 'published',
                  onTap: () => onStatusChanged('published'),
                  color: AppTheme.successGreen,
                ),
                SizedBox(width: 2.w),
                _buildFilterChip(
                  context,
                  isDarkMode,
                  label: 'Draft',
                  isSelected: selectedStatus == 'draft',
                  onTap: () => onStatusChanged('draft'),
                  color: AppTheme.textSecondary,
                ),
                SizedBox(width: 2.w),
                _buildFilterChip(
                  context,
                  isDarkMode,
                  label: 'Processing',
                  isSelected: selectedStatus == 'processing',
                  onTap: () => onStatusChanged('processing'),
                  color: AppTheme.warningOrange,
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Filter by Genre',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                ),
          ),
          SizedBox(height: 1.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip(
                  context,
                  isDarkMode,
                  label: 'All Genres',
                  isSelected: selectedGenre == 'all',
                  onTap: () => onGenreChanged('all'),
                ),
                SizedBox(width: 2.w),
                ..._getGenreChips(context, isDarkMode),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Filter by Date',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                ),
          ),
          SizedBox(height: 1.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip(
                  context,
                  isDarkMode,
                  label: 'All Time',
                  isSelected: selectedDateRange == 'all',
                  onTap: () => onDateRangeChanged('all'),
                ),
                SizedBox(width: 2.w),
                _buildFilterChip(
                  context,
                  isDarkMode,
                  label: 'Today',
                  isSelected: selectedDateRange == 'today',
                  onTap: () => onDateRangeChanged('today'),
                ),
                SizedBox(width: 2.w),
                _buildFilterChip(
                  context,
                  isDarkMode,
                  label: 'This Week',
                  isSelected: selectedDateRange == 'week',
                  onTap: () => onDateRangeChanged('week'),
                ),
                SizedBox(width: 2.w),
                _buildFilterChip(
                  context,
                  isDarkMode,
                  label: 'This Month',
                  isSelected: selectedDateRange == 'month',
                  onTap: () => onDateRangeChanged('month'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _getGenreChips(BuildContext context, bool isDarkMode) {
    final genres = ['Action', 'Comedy', 'Drama', 'Horror', 'Romance', 'Sci-Fi'];

    return genres.map((genre) {
      return Padding(
        padding: EdgeInsets.only(right: 2.w),
        child: _buildFilterChip(
          context,
          isDarkMode,
          label: genre,
          isSelected: selectedGenre == genre.toLowerCase(),
          onTap: () => onGenreChanged(genre.toLowerCase()),
          color: AppTheme.accentPurple,
        ),
      );
    }).toList();
  }

  Widget _buildFilterChip(
    BuildContext context,
    bool isDarkMode, {
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    Color? color,
  }) {
    final chipColor = color ?? AppTheme.secondaryBlue;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isSelected ? chipColor : chipColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? chipColor : chipColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected) ...[
              CustomIconWidget(
                iconName: 'check',
                color: Colors.white,
                size: 14,
              ),
              SizedBox(width: 1.w),
            ],
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: isSelected ? Colors.white : chipColor,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 11.sp,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
