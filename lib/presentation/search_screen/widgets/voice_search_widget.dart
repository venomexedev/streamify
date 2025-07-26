import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VoiceSearchWidget extends StatefulWidget {
  final Function(String) onVoiceResult;
  final VoidCallback onClose;

  const VoiceSearchWidget({
    Key? key,
    required this.onVoiceResult,
    required this.onClose,
  }) : super(key: key);

  @override
  State<VoiceSearchWidget> createState() => _VoiceSearchWidgetState();
}

class _VoiceSearchWidgetState extends State<VoiceSearchWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _waveController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _waveAnimation;

  bool _isListening = false;
  String _currentText = '';

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startListening();
  }

  void _setupAnimations() {
    _pulseController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    _waveController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _waveAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _waveController,
      curve: Curves.easeInOut,
    ));

    _pulseController.repeat(reverse: true);
    _waveController.repeat(reverse: true);
  }

  void _startListening() {
    setState(() {
      _isListening = true;
      _currentText = 'Listening...';
    });

    // Simulate voice recognition
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isListening = false;
          _currentText = 'Processing...';
        });

        Future.delayed(Duration(seconds: 1), () {
          if (mounted) {
            // Simulate voice result
            final mockResults = [
              'action movies',
              'marvel superhero films',
              'comedy shows',
              'thriller movies',
              'sci-fi series',
            ];
            final randomResult =
                mockResults[DateTime.now().millisecond % mockResults.length];
            widget.onVoiceResult(randomResult);
            widget.onClose();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppTheme.backgroundDark.withValues(alpha: 0.9),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Close button
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.only(top: 8.h, right: 4.w),
              child: GestureDetector(
                onTap: widget.onClose,
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppTheme.darkTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.darkTheme.colorScheme.onSurface,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),

          Spacer(),

          // Voice animation
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryBlue.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 25.w,
                      height: 25.w,
                      decoration: BoxDecoration(
                        color: AppTheme.secondaryBlue,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: CustomIconWidget(
                          iconName: _isListening ? 'mic' : 'mic_off',
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          SizedBox(height: 4.h),

          // Status text
          Text(
            _currentText,
            style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.darkTheme.colorScheme.onSurface,
            ),
          ),

          SizedBox(height: 2.h),

          // Voice waves animation
          if (_isListening)
            AnimatedBuilder(
              animation: _waveAnimation,
              builder: (context, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 1.w),
                      width: 1.w,
                      height: (2 +
                              (_waveAnimation.value *
                                  3 *
                                  (index % 2 == 0 ? 1 : 0.5)))
                          .h,
                      decoration: BoxDecoration(
                        color: AppTheme.secondaryBlue,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    );
                  }),
                );
              },
            ),

          Spacer(),

          // Instructions
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            child: Text(
              _isListening
                  ? 'Speak now... Say something like "action movies" or "Marvel films"'
                  : 'Processing your voice input...',
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.darkTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
