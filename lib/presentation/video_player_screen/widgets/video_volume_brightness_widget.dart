import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VideoVolumeBrightnessWidget extends StatelessWidget {
  final bool showVolumeSlider;
  final bool showBrightnessSlider;
  final double volumeLevel;
  final double brightnessLevel;
  final Function(double) onVolumeChanged;
  final Function(double) onBrightnessChanged;

  const VideoVolumeBrightnessWidget({
    super.key,
    required this.showVolumeSlider,
    required this.showBrightnessSlider,
    required this.volumeLevel,
    required this.brightnessLevel,
    required this.onVolumeChanged,
    required this.onBrightnessChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Volume slider (left side)
        if (showVolumeSlider)
          Positioned(
            left: 4.w,
            top: 20.h,
            bottom: 20.h,
            child: Container(
              width: 8.w,
              decoration: BoxDecoration(
                color: AppTheme.backgroundDark.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    child: CustomIconWidget(
                      iconName: volumeLevel > 0.5
                          ? 'volume_up'
                          : volumeLevel > 0
                              ? 'volume_down'
                              : 'volume_off',
                      color: AppTheme.textPrimary,
                      size: 5.w,
                    ),
                  ),
                  Expanded(
                    child: RotatedBox(
                      quarterTurns: -1,
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: AppTheme.secondaryBlue,
                          inactiveTrackColor:
                              AppTheme.textSecondary.withValues(alpha: 0.3),
                          thumbColor: AppTheme.secondaryBlue,
                          overlayColor:
                              AppTheme.secondaryBlue.withValues(alpha: 0.2),
                          trackHeight: 3.0,
                          thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 6.0),
                        ),
                        child: Slider(
                          value: volumeLevel,
                          onChanged: onVolumeChanged,
                          min: 0.0,
                          max: 1.0,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 1.h),
                    child: Text(
                      '${(volumeLevel * 100).round()}%',
                      style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textPrimary,
                        fontSize: 10.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        // Brightness slider (right side)
        if (showBrightnessSlider)
          Positioned(
            right: 4.w,
            top: 20.h,
            bottom: 20.h,
            child: Container(
              width: 8.w,
              decoration: BoxDecoration(
                color: AppTheme.backgroundDark.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    child: CustomIconWidget(
                      iconName: brightnessLevel > 0.5
                          ? 'brightness_high'
                          : brightnessLevel > 0.2
                              ? 'brightness_medium'
                              : 'brightness_low',
                      color: AppTheme.textPrimary,
                      size: 5.w,
                    ),
                  ),
                  Expanded(
                    child: RotatedBox(
                      quarterTurns: -1,
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: AppTheme.warningOrange,
                          inactiveTrackColor:
                              AppTheme.textSecondary.withValues(alpha: 0.3),
                          thumbColor: AppTheme.warningOrange,
                          overlayColor:
                              AppTheme.warningOrange.withValues(alpha: 0.2),
                          trackHeight: 3.0,
                          thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 6.0),
                        ),
                        child: Slider(
                          value: brightnessLevel,
                          onChanged: onBrightnessChanged,
                          min: 0.0,
                          max: 1.0,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 1.h),
                    child: Text(
                      '${(brightnessLevel * 100).round()}%',
                      style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textPrimary,
                        fontSize: 10.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
