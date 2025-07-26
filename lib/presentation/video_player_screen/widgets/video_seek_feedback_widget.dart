import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VideoSeekFeedbackWidget extends StatefulWidget {
  final bool showRewind;
  final bool showForward;

  const VideoSeekFeedbackWidget({
    super.key,
    required this.showRewind,
    required this.showForward,
  });

  @override
  State<VideoSeekFeedbackWidget> createState() =>
      _VideoSeekFeedbackWidgetState();
}

class _VideoSeekFeedbackWidgetState extends State<VideoSeekFeedbackWidget>
    with TickerProviderStateMixin {
  late AnimationController _rewindController;
  late AnimationController _forwardController;
  late Animation<double> _rewindAnimation;
  late Animation<double> _forwardAnimation;

  @override
  void initState() {
    super.initState();
    _rewindController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _forwardController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _rewindAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rewindController,
      curve: Curves.elasticOut,
    ));

    _forwardAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _forwardController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void didUpdateWidget(VideoSeekFeedbackWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.showRewind && !oldWidget.showRewind) {
      _rewindController.forward().then((_) {
        _rewindController.reverse();
      });
    }

    if (widget.showForward && !oldWidget.showForward) {
      _forwardController.forward().then((_) {
        _forwardController.reverse();
      });
    }
  }

  @override
  void dispose() {
    _rewindController.dispose();
    _forwardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Rewind feedback
        Positioned(
          left: 10.w,
          top: 0,
          bottom: 0,
          child: AnimatedBuilder(
            animation: _rewindAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _rewindAnimation.value,
                child: Opacity(
                  opacity: _rewindAnimation.value,
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: AppTheme.backgroundDark.withValues(alpha: 0.8),
                        shape: BoxShape.circle,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomIconWidget(
                            iconName: 'replay_10',
                            color: AppTheme.textPrimary,
                            size: 10.w,
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            '10s',
                            style: AppTheme.darkTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.textPrimary,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        // Forward feedback
        Positioned(
          right: 10.w,
          top: 0,
          bottom: 0,
          child: AnimatedBuilder(
            animation: _forwardAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _forwardAnimation.value,
                child: Opacity(
                  opacity: _forwardAnimation.value,
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: AppTheme.backgroundDark.withValues(alpha: 0.8),
                        shape: BoxShape.circle,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomIconWidget(
                            iconName: 'forward_10',
                            color: AppTheme.textPrimary,
                            size: 10.w,
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            '10s',
                            style: AppTheme.darkTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.textPrimary,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
