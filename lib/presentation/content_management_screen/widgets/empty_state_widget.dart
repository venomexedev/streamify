import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyStateWidget extends StatelessWidget {
  final VoidCallback? onAddContent;

  const EmptyStateWidget({
    Key? key,
    this.onAddContent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 30.w,
              height: 30.w,
              decoration: BoxDecoration(
                color: AppTheme.secondaryBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20.w),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'video_library',
                  color: AppTheme.secondaryBlue,
                  size: 60,
                ),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'No Content Yet',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 20.sp,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              'Start building your video library by adding your first piece of content. You can record videos, upload from gallery, or import from URL.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDarkMode
                        ? AppTheme.textMediumEmphasisDark
                        : AppTheme.textMediumEmphasisLight,
                    fontSize: 13.sp,
                    height: 1.5,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onAddContent,
                icon: CustomIconWidget(
                  iconName: 'add',
                  color: Colors.white,
                  size: 20,
                ),
                label: Text(
                  'Add Your First Content',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                ),
              ),
            ),
            SizedBox(height: 3.h),
            _buildTipCard(
              context,
              isDarkMode,
              icon: 'videocam',
              title: 'Record Videos',
              description:
                  'Use your device camera to create content directly in the app',
            ),
            SizedBox(height: 2.h),
            _buildTipCard(
              context,
              isDarkMode,
              icon: 'photo_library',
              title: 'Upload from Gallery',
              description: 'Select existing videos from your device storage',
            ),
            SizedBox(height: 2.h),
            _buildTipCard(
              context,
              isDarkMode,
              icon: 'link',
              title: 'Import from URL',
              description:
                  'Add videos using web links from supported platforms',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipCard(
    BuildContext context,
    bool isDarkMode, {
    required String icon,
    required String title,
    required String description,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: isDarkMode ? AppTheme.cardDark : AppTheme.cardLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode ? AppTheme.dividerDark : AppTheme.dividerLight,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(
              color: AppTheme.secondaryBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: icon,
                color: AppTheme.secondaryBlue,
                size: 20,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp,
                      ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDarkMode
                            ? AppTheme.textMediumEmphasisDark
                            : AppTheme.textMediumEmphasisLight,
                        fontSize: 10.sp,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
