import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VideoMenuOverlayWidget extends StatelessWidget {
  final bool isVisible;
  final VoidCallback onReportIssue;
  final VoidCallback onAudioSubtitleSettings;
  final VoidCallback onPlaybackSpeed;
  final VoidCallback onClose;

  const VideoMenuOverlayWidget({
    super.key,
    required this.isVisible,
    required this.onReportIssue,
    required this.onAudioSubtitleSettings,
    required this.onPlaybackSpeed,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      top: isVisible ? 12.h : -50.h,
      right: 4.w,
      child: Container(
        width: 60.w,
        decoration: BoxDecoration(
          color: AppTheme.surfaceDark,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadowDark,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildMenuItem(
              icon: 'report_problem',
              title: 'Report Issue',
              onTap: () {
                onClose();
                onReportIssue();
              },
            ),
            _buildDivider(),
            _buildMenuItem(
              icon: 'settings',
              title: 'Audio & Subtitles',
              onTap: () {
                onClose();
                onAudioSubtitleSettings();
              },
            ),
            _buildDivider(),
            _buildMenuItem(
              icon: 'speed',
              title: 'Playback Speed',
              onTap: () {
                onClose();
                onPlaybackSpeed();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: AppTheme.textPrimary,
              size: 5.w,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                title,
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textPrimary,
                  fontSize: 14.sp,
                ),
              ),
            ),
            CustomIconWidget(
              iconName: 'chevron_right',
              color: AppTheme.textSecondary,
              size: 4.w,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      color: AppTheme.dividerDark,
    );
  }
}
