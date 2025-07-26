import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VideoQualitySelectorWidget extends StatelessWidget {
  final bool isVisible;
  final String selectedQuality;
  final List<String> availableQualities;
  final Function(String) onQualitySelected;
  final VoidCallback onClose;

  const VideoQualitySelectorWidget({
    super.key,
    required this.isVisible,
    required this.selectedQuality,
    required this.availableQualities,
    required this.onQualitySelected,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: isVisible
          ? Container(
              color: AppTheme.backgroundDark.withValues(alpha: 0.8),
              child: Center(
                child: Container(
                  width: 80.w,
                  constraints: BoxConstraints(maxHeight: 60.h),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceDark,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.shadowDark,
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header
                      Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: AppTheme.dividerDark,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Video Quality',
                                style: AppTheme.darkTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  color: AppTheme.textPrimary,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: onClose,
                              child: Container(
                                padding: EdgeInsets.all(2.w),
                                child: CustomIconWidget(
                                  iconName: 'close',
                                  color: AppTheme.textSecondary,
                                  size: 5.w,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Quality options
                      Flexible(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: availableQualities.length,
                          itemBuilder: (context, index) {
                            final quality = availableQualities[index];
                            final isSelected = quality == selectedQuality;

                            return GestureDetector(
                              onTap: () {
                                onQualitySelected(quality);
                                onClose();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 4.w,
                                  vertical: 3.h,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppTheme.secondaryBlue
                                          .withValues(alpha: 0.1)
                                      : Colors.transparent,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 5.w,
                                      height: 5.w,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isSelected
                                              ? AppTheme.secondaryBlue
                                              : AppTheme.textSecondary,
                                          width: 2,
                                        ),
                                        color: isSelected
                                            ? AppTheme.secondaryBlue
                                            : Colors.transparent,
                                      ),
                                      child: isSelected
                                          ? Center(
                                              child: Container(
                                                width: 2.w,
                                                height: 2.w,
                                                decoration: const BoxDecoration(
                                                  color: AppTheme.textPrimary,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                            )
                                          : null,
                                    ),
                                    SizedBox(width: 3.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            quality,
                                            style: AppTheme
                                                .darkTheme.textTheme.bodyMedium
                                                ?.copyWith(
                                              color: isSelected
                                                  ? AppTheme.secondaryBlue
                                                  : AppTheme.textPrimary,
                                              fontSize: 14.sp,
                                              fontWeight: isSelected
                                                  ? FontWeight.w600
                                                  : FontWeight.w400,
                                            ),
                                          ),
                                          if (_getQualityDescription(quality)
                                              .isNotEmpty)
                                            Text(
                                              _getQualityDescription(quality),
                                              style: AppTheme
                                                  .darkTheme.textTheme.bodySmall
                                                  ?.copyWith(
                                                color: AppTheme.textSecondary,
                                                fontSize: 12.sp,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    if (isSelected)
                                      CustomIconWidget(
                                        iconName: 'check',
                                        color: AppTheme.secondaryBlue,
                                        size: 4.w,
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  String _getQualityDescription(String quality) {
    switch (quality) {
      case 'Auto':
        return 'Adjusts automatically';
      case '1080p':
        return 'Full HD • Uses more data';
      case '720p':
        return 'HD • Recommended';
      case '480p':
        return 'SD • Uses less data';
      case '360p':
        return 'Low • Saves data';
      default:
        return '';
    }
  }
}
