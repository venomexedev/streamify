import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class UploadBottomSheetWidget extends StatelessWidget {
  final VoidCallback? onRecordVideo;
  final VoidCallback? onChooseFromGallery;
  final VoidCallback? onImportFromUrl;

  const UploadBottomSheetWidget({
    Key? key,
    this.onRecordVideo,
    this.onChooseFromGallery,
    this.onImportFromUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: isDarkMode
                  ? AppTheme.textDisabledDark
                  : AppTheme.textDisabledLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'Add New Content',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 18.sp,
                ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Choose how you want to add content to your library',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDarkMode
                      ? AppTheme.textMediumEmphasisDark
                      : AppTheme.textMediumEmphasisLight,
                  fontSize: 12.sp,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          _buildUploadOption(
            context,
            isDarkMode,
            icon: 'videocam',
            title: 'Record Video',
            subtitle: 'Use camera to record new content',
            onTap: onRecordVideo,
          ),
          SizedBox(height: 2.h),
          _buildUploadOption(
            context,
            isDarkMode,
            icon: 'photo_library',
            title: 'Choose from Gallery',
            subtitle: 'Select video from device storage',
            onTap: onChooseFromGallery,
          ),
          SizedBox(height: 2.h),
          _buildUploadOption(
            context,
            isDarkMode,
            icon: 'link',
            title: 'Import from URL',
            subtitle: 'Add video using web link',
            onTap: onImportFromUrl,
          ),
          SizedBox(height: 4.h),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 2.h),
              ),
              child: Text(
                'Cancel',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: isDarkMode
                          ? AppTheme.textMediumEmphasisDark
                          : AppTheme.textMediumEmphasisLight,
                    ),
              ),
            ),
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildUploadOption(
    BuildContext context,
    bool isDarkMode, {
    required String icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        onTap?.call();
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          border: Border.all(
            color: isDarkMode ? AppTheme.dividerDark : AppTheme.dividerLight,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: AppTheme.secondaryBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: icon,
                  color: AppTheme.secondaryBlue,
                  size: 24,
                ),
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                        ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isDarkMode
                              ? AppTheme.textMediumEmphasisDark
                              : AppTheme.textMediumEmphasisLight,
                          fontSize: 11.sp,
                        ),
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'arrow_forward_ios',
              color: isDarkMode
                  ? AppTheme.textDisabledDark
                  : AppTheme.textDisabledLight,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
