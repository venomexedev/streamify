import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BottomNavigationWidget extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavigationWidget({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowDark,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 8.h,
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context,
                'Home',
                'home',
                0,
              ),
              _buildNavItem(
                context,
                'Search',
                'search',
                1,
              ),
              _buildNavItem(
                context,
                'Downloads',
                'download',
                2,
              ),
              _buildNavItem(
                context,
                'Profile',
                'person',
                3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    String label,
    String iconName,
    int index,
  ) {
    final bool isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () {
        onTap(index);
        _handleNavigation(context, index);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.secondaryBlue.withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: iconName,
              color:
                  isSelected ? AppTheme.secondaryBlue : AppTheme.textSecondary,
              size: isSelected ? 24 : 20,
            ),
            SizedBox(height: 0.5.h),
            Text(
              label,
              style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                color: isSelected
                    ? AppTheme.secondaryBlue
                    : AppTheme.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                fontSize: isSelected ? 10.sp : 9.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleNavigation(BuildContext context, int index) {
    switch (index) {
      case 0:
        // Already on home screen
        break;
      case 1:
        Navigator.pushNamed(context, '/search-screen');
        break;
      case 2:
        // Navigate to downloads screen (not implemented)
        break;
      case 3:
        // Navigate to profile screen (not implemented)
        break;
    }
  }
}
