import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class VideoWatermarkWidget extends StatelessWidget {
  const VideoWatermarkWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 4.h,
      right: 4.w,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: AppTheme.backgroundDark.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          'STREAMIFY',
          style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 10.sp,
          ),
        ),
      ),
    );
  }
}
