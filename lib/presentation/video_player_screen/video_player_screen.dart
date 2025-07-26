import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/video_controls_widget.dart';
import './widgets/video_loading_widget.dart';
import './widgets/video_menu_overlay_widget.dart';
import './widgets/video_quality_selector_widget.dart';
import './widgets/video_seek_feedback_widget.dart';
import './widgets/video_top_overlay_widget.dart';
import './widgets/video_volume_brightness_widget.dart';
import './widgets/video_watermark_widget.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen>
    with TickerProviderStateMixin {
  // Mock video data
  final Map<String, dynamic> videoData = {
    "id": "video_001",
    "title": "The Future of Technology: AI Revolution",
    "description":
        "Explore the cutting-edge developments in artificial intelligence and how they're reshaping our world. From machine learning to neural networks, discover the innovations that will define the next decade.",
    "duration": "02:45:30",
    "quality": ["Auto", "1080p", "720p", "480p", "360p"],
    "thumbnail":
        "https://images.pexels.com/photos/8386440/pexels-photo-8386440.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    "videoUrl":
        "https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4",
    "genre": "Technology",
    "rating": 4.8,
    "views": "2.1M",
    "uploadDate": "2025-01-15",
  };

  // Video player state
  bool _isPlaying = false;
  bool _isLoading = true;
  bool _showControls = true;
  bool _showVolumeSlider = false;
  bool _showBrightnessSlider = false;
  bool _showRewindFeedback = false;
  bool _showForwardFeedback = false;
  bool _showMenuOverlay = false;
  bool _showQualitySelector = false;

  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = const Duration(hours: 2, minutes: 45, seconds: 30);

  double _volumeLevel = 0.7;
  double _brightnessLevel = 0.8;
  String _selectedQuality = "Auto";
  String _networkQuality = "Good";

  late AnimationController _controlsAnimationController;
  late AnimationController _zoomController;
  late Animation<double> _zoomAnimation;

  double _currentZoom = 1.0;
  bool _isZooming = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _setLandscapeOrientation();
    _hideSystemUI();
    _startVideoSimulation();
    _startControlsTimer();
  }

  void _initializeControllers() {
    _controlsAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _zoomController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _zoomAnimation = Tween<double>(
      begin: 1.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _zoomController,
      curve: Curves.easeInOut,
    ));
  }

  void _setLandscapeOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  void _hideSystemUI() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  void _restoreSystemUI() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  void _startVideoSimulation() {
    // Simulate video loading
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isPlaying = true;
        });
        _startProgressSimulation();
      }
    });
  }

  void _startProgressSimulation() {
    // Simulate video progress
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted && _isPlaying && !_isLoading) {
        setState(() {
          _currentPosition = Duration(
            seconds: _currentPosition.inSeconds + 1,
          );
          if (_currentPosition >= _totalDuration) {
            _currentPosition = _totalDuration;
            _isPlaying = false;
          }
        });
        return _currentPosition < _totalDuration;
      }
      return false;
    });
  }

  void _startControlsTimer() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _showControls) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });

    if (_isPlaying) {
      _startProgressSimulation();
    }

    _showControlsTemporarily();
  }

  void _seekTo(Duration position) {
    setState(() {
      _currentPosition = position;
    });
    _showControlsTemporarily();
  }

  void _showControlsTemporarily() {
    setState(() {
      _showControls = true;
    });
    _startControlsTimer();
  }

  void _handleDoubleTapLeft() {
    setState(() {
      _showRewindFeedback = true;
      final newPosition = Duration(
        seconds: (_currentPosition.inSeconds - 10)
            .clamp(0, _totalDuration.inSeconds),
      );
      _currentPosition = newPosition;
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() {
          _showRewindFeedback = false;
        });
      }
    });
  }

  void _handleDoubleTapRight() {
    setState(() {
      _showForwardFeedback = true;
      final newPosition = Duration(
        seconds: (_currentPosition.inSeconds + 10)
            .clamp(0, _totalDuration.inSeconds),
      );
      _currentPosition = newPosition;
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() {
          _showForwardFeedback = false;
        });
      }
    });
  }

  void _handlePinchUpdate(ScaleUpdateDetails details) {
    if (!_isZooming && details.scale != 1.0) {
      setState(() {
        _isZooming = true;
      });
    }

    setState(() {
      _currentZoom = (details.scale * 1.0).clamp(1.0, 3.0);
    });
  }

  void _handlePinchEnd(ScaleEndDetails details) {
    setState(() {
      _isZooming = false;
    });

    if (_currentZoom < 1.2) {
      _zoomAnimation = Tween<double>(
        begin: _currentZoom,
        end: 1.0,
      ).animate(_zoomController);

      _zoomController.forward().then((_) {
        setState(() {
          _currentZoom = 1.0;
        });
        _zoomController.reset();
      });
    }
  }

  void _showVolumeSliderUI() {
    setState(() {
      _showVolumeSlider = true;
      _showBrightnessSlider = false;
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showVolumeSlider = false;
        });
      }
    });
  }

  void _showBrightnessSliderUI() {
    setState(() {
      _showBrightnessSlider = true;
      _showVolumeSlider = false;
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showBrightnessSlider = false;
        });
      }
    });
  }

  void _handleVerticalDragLeft(DragUpdateDetails details) {
    final delta = details.delta.dy / 200;
    setState(() {
      _volumeLevel = (_volumeLevel - delta).clamp(0.0, 1.0);
    });
    _showVolumeSliderUI();
  }

  void _handleVerticalDragRight(DragUpdateDetails details) {
    final delta = details.delta.dy / 200;
    setState(() {
      _brightnessLevel = (_brightnessLevel - delta).clamp(0.0, 1.0);
    });
    _showBrightnessSliderUI();
  }

  void _toggleMenuOverlay() {
    setState(() {
      _showMenuOverlay = !_showMenuOverlay;
    });
  }

  void _closeMenuOverlay() {
    setState(() {
      _showMenuOverlay = false;
    });
  }

  void _showQualitySelectorUI() {
    setState(() {
      _showQualitySelector = true;
    });
  }

  void _closeQualitySelector() {
    setState(() {
      _showQualitySelector = false;
    });
  }

  void _selectQuality(String quality) {
    setState(() {
      _selectedQuality = quality;
      _isLoading = true;
    });

    // Simulate quality change loading
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  void _handleReportIssue() {
    // Show report issue dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceDark,
        title: Text(
          'Report Issue',
          style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.textPrimary,
          ),
        ),
        content: Text(
          'What issue are you experiencing with this video?',
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textPrimary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle report submission
            },
            child: Text(
              'Submit',
              style: TextStyle(color: AppTheme.secondaryBlue),
            ),
          ),
        ],
      ),
    );
  }

  void _handleAudioSubtitleSettings() {
    // Show audio/subtitle settings
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceDark,
        title: Text(
          'Audio & Subtitles',
          style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.textPrimary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(
                'Audio Track',
                style: TextStyle(color: AppTheme.textPrimary),
              ),
              subtitle: Text(
                'English (Default)',
                style: TextStyle(color: AppTheme.textSecondary),
              ),
              trailing: CustomIconWidget(
                iconName: 'chevron_right',
                color: AppTheme.textSecondary,
                size: 5.w,
              ),
            ),
            ListTile(
              title: Text(
                'Subtitles',
                style: TextStyle(color: AppTheme.textPrimary),
              ),
              subtitle: Text(
                'Off',
                style: TextStyle(color: AppTheme.textSecondary),
              ),
              trailing: CustomIconWidget(
                iconName: 'chevron_right',
                color: AppTheme.textSecondary,
                size: 5.w,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Done',
              style: TextStyle(color: AppTheme.secondaryBlue),
            ),
          ),
        ],
      ),
    );
  }

  void _handlePlaybackSpeed() {
    // Show playback speed options
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceDark,
        title: Text(
          'Playback Speed',
          style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.textPrimary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['0.5x', '0.75x', '1x', '1.25x', '1.5x', '2x']
              .map((speed) => ListTile(
                    title: Text(
                      speed,
                      style: TextStyle(color: AppTheme.textPrimary),
                    ),
                    trailing: speed == '1x'
                        ? CustomIconWidget(
                            iconName: 'check',
                            color: AppTheme.secondaryBlue,
                            size: 5.w,
                          )
                        : null,
                    onTap: () {
                      Navigator.pop(context);
                      // Handle speed change
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }

  void _handleBackPressed() {
    _restoreSystemUI();
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _controlsAnimationController.dispose();
    _zoomController.dispose();
    _restoreSystemUI();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: GestureDetector(
        onTap: () {
          setState(() {
            _showControls = !_showControls;
            _showMenuOverlay = false;
          });
          if (_showControls) {
            _startControlsTimer();
          }
        },
        child: Stack(
          children: [
            // Video player area with zoom and gestures
            Positioned.fill(
              child: GestureDetector(
                onScaleStart: (details) {},
                onScaleUpdate: _handlePinchUpdate,
                onScaleEnd: _handlePinchEnd,
                child: AnimatedBuilder(
                  animation: _zoomAnimation,
                  builder: (context, child) {
                    final zoom =
                        _isZooming ? _currentZoom : _zoomAnimation.value;
                    return Transform.scale(
                      scale: zoom,
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: AppTheme.backgroundDark,
                        child: Center(
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppTheme.backgroundDark,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: CustomImageWidget(
                                imageUrl: videoData["thumbnail"],
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Double tap areas for seek
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: 30.w,
              child: GestureDetector(
                onDoubleTap: _handleDoubleTapLeft,
                onPanUpdate: _handleVerticalDragLeft,
                child: Container(color: Colors.transparent),
              ),
            ),

            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: 30.w,
              child: GestureDetector(
                onDoubleTap: _handleDoubleTapRight,
                onPanUpdate: _handleVerticalDragRight,
                child: Container(color: Colors.transparent),
              ),
            ),

            // Watermark
            const VideoWatermarkWidget(),

            // Seek feedback animations
            VideoSeekFeedbackWidget(
              showRewind: _showRewindFeedback,
              showForward: _showForwardFeedback,
            ),

            // Volume and brightness sliders
            VideoVolumeBrightnessWidget(
              showVolumeSlider: _showVolumeSlider,
              showBrightnessSlider: _showBrightnessSlider,
              volumeLevel: _volumeLevel,
              brightnessLevel: _brightnessLevel,
              onVolumeChanged: (value) {
                setState(() {
                  _volumeLevel = value;
                });
              },
              onBrightnessChanged: (value) {
                setState(() {
                  _brightnessLevel = value;
                });
              },
            ),

            // Top overlay
            Positioned.fill(
              child: VideoTopOverlayWidget(
                videoTitle: videoData["title"],
                onBackPressed: _handleBackPressed,
                onMenuPressed: _toggleMenuOverlay,
                isVisible: _showControls,
              ),
            ),

            // Bottom controls
            Positioned.fill(
              child: VideoControlsWidget(
                isPlaying: _isPlaying,
                currentPosition: _currentPosition,
                totalDuration: _totalDuration,
                onPlayPause: _togglePlayPause,
                onSeek: _seekTo,
                onQualityTap: () => _showQualitySelectorUI(),
                isVisible: _showControls,
              ),
            ),

            // Loading overlay
            VideoLoadingWidget(
              isLoading: _isLoading,
              networkQuality: _networkQuality,
            ),

            // Menu overlay
            VideoMenuOverlayWidget(
              isVisible: _showMenuOverlay,
              onReportIssue: _handleReportIssue,
              onAudioSubtitleSettings: _handleAudioSubtitleSettings,
              onPlaybackSpeed: _handlePlaybackSpeed,
              onClose: _closeMenuOverlay,
            ),

            // Quality selector
            VideoQualitySelectorWidget(
              isVisible: _showQualitySelector,
              selectedQuality: _selectedQuality,
              availableQualities: (videoData["quality"] as List).cast<String>(),
              onQualitySelected: _selectQuality,
              onClose: _closeQualitySelector,
            ),
          ],
        ),
      ),
    );
  }
}