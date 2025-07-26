import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VideoControlsWidget extends StatefulWidget {
  final bool isPlaying;
  final Duration currentPosition;
  final Duration totalDuration;
  final VoidCallback onPlayPause;
  final Function(Duration) onSeek;
  final VoidCallback onQualityTap;
  final bool isVisible;

  const VideoControlsWidget({
    super.key,
    required this.isPlaying,
    required this.currentPosition,
    required this.totalDuration,
    required this.onPlayPause,
    required this.onSeek,
    required this.onQualityTap,
    required this.isVisible,
  });

  @override
  State<VideoControlsWidget> createState() => _VideoControlsWidgetState();
}

class _VideoControlsWidgetState extends State<VideoControlsWidget> {
  bool _isDragging = false;
  double _dragValue = 0.0;

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}';
    }
    return '${twoDigits(minutes)}:${twoDigits(seconds)}';
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: widget.isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              AppTheme.backgroundDark.withValues(alpha: 0.8),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Progress bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                children: [
                  Text(
                    _formatDuration(_isDragging
                        ? Duration(
                            milliseconds: (_dragValue *
                                    widget.totalDuration.inMilliseconds)
                                .round())
                        : widget.currentPosition),
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textPrimary,
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
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
                            enabledThumbRadius: 8.0),
                      ),
                      child: Slider(
                        value: _isDragging
                            ? _dragValue
                            : widget.totalDuration.inMilliseconds > 0
                                ? widget.currentPosition.inMilliseconds /
                                    widget.totalDuration.inMilliseconds
                                : 0.0,
                        onChanged: (value) {
                          setState(() {
                            _isDragging = true;
                            _dragValue = value;
                          });
                        },
                        onChangeEnd: (value) {
                          final position = Duration(
                            milliseconds:
                                (value * widget.totalDuration.inMilliseconds)
                                    .round(),
                          );
                          widget.onSeek(position);
                          setState(() {
                            _isDragging = false;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    _formatDuration(widget.totalDuration),
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textPrimary,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.h),
            // Control buttons
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Play/Pause button
                  GestureDetector(
                    onTap: widget.onPlayPause,
                    child: Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: AppTheme.secondaryBlue.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: CustomIconWidget(
                        iconName: widget.isPlaying ? 'pause' : 'play_arrow',
                        color: AppTheme.textPrimary,
                        size: 8.w,
                      ),
                    ),
                  ),
                  // Quality selector
                  GestureDetector(
                    onTap: widget.onQualityTap,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 3.w, vertical: 1.5.h),
                      decoration: BoxDecoration(
                        color: AppTheme.backgroundDark.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.textSecondary.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'HD',
                            style: AppTheme.darkTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.textPrimary,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 1.w),
                          CustomIconWidget(
                            iconName: 'keyboard_arrow_down',
                            color: AppTheme.textPrimary,
                            size: 4.w,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
