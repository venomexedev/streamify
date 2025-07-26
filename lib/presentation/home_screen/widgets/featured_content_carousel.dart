import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FeaturedContentCarousel extends StatefulWidget {
  final List<Map<String, dynamic>> featuredContent;

  const FeaturedContentCarousel({
    super.key,
    required this.featuredContent,
  });

  @override
  State<FeaturedContentCarousel> createState() =>
      _FeaturedContentCarouselState();
}

class _FeaturedContentCarouselState extends State<FeaturedContentCarousel> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.9);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.featuredContent.isEmpty) {
      return SizedBox(
          height: 25.h,
          child: Center(
              child: Text('No featured content available',
                  style: AppTheme.darkTheme.textTheme.bodyMedium
                      ?.copyWith(color: AppTheme.textMediumEmphasisDark))));
    }

    return Column(children: [
      SizedBox(
          height: 25.h,
          child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemCount: widget.featuredContent.length,
              itemBuilder: (context, index) {
                final content = widget.featuredContent[index];
                return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/video-player-screen',
                          arguments: content);
                    },
                    child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 2.w),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5)),
                            ]),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Stack(fit: StackFit.expand, children: [
                              // Background Image
                              CustomImageWidget(
                                  imageUrl: content['imageUrl'] ?? '',
                                  fit: BoxFit.cover),

                              // Gradient Overlay
                              Container(
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                    Colors.transparent,
                                    Colors.black.withValues(alpha: 0.7),
                                  ]))),

                              // Content Info
                              Positioned(
                                  bottom: 4.h,
                                  left: 4.w,
                                  right: 4.w,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(content['title'] ?? 'Untitled',
                                            style: AppTheme.darkTheme.textTheme
                                                .headlineSmall
                                                ?.copyWith(
                                                    color: AppTheme.textPrimary,
                                                    fontWeight:
                                                        FontWeight.bold),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis),
                                        SizedBox(height: 1.h),
                                        Text(
                                            content['description'] ??
                                                'No description available',
                                            style: AppTheme
                                                .darkTheme.textTheme.bodyMedium
                                                ?.copyWith(
                                                    color: AppTheme
                                                        .textMediumEmphasisDark),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis),
                                        SizedBox(height: 2.h),
                                        Row(children: [
                                          // Play Button
                                          ElevatedButton.icon(
                                              onPressed: () {
                                                Navigator.pushNamed(context,
                                                    '/video-player-screen',
                                                    arguments: content);
                                              },
                                              icon: CustomIconWidget(
                                                  iconName: 'play_arrow',
                                                  color:
                                                      AppTheme.backgroundDark,
                                                  size: 5.w),
                                              label: Text('Play',
                                                  style: TextStyle(
                                                      color: AppTheme
                                                          .backgroundDark,
                                                      fontWeight:
                                                          FontWeight.w600)),
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      AppTheme.textPrimary,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 4.w,
                                                      vertical: 1.5.h))),
                                          SizedBox(width: 3.w),

                                          // Info Button
                                          OutlinedButton.icon(
                                              onPressed: () {
                                                // Show content details
                                              },
                                              icon: CustomIconWidget(
                                                  iconName: 'info',
                                                  color: AppTheme.textPrimary,
                                                  size: 5.w),
                                              label: Text('Info',
                                                  style: TextStyle(
                                                      color:
                                                          AppTheme.textPrimary,
                                                      fontWeight:
                                                          FontWeight.w600)),
                                              style: OutlinedButton.styleFrom(
                                                  side: BorderSide(
                                                      color:
                                                          AppTheme.textPrimary),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 4.w,
                                                      vertical: 1.5.h))),
                                        ]),
                                      ])),
                            ]))));
              })),

      // Page Indicators
      if (widget.featuredContent.length > 1) ...[
        SizedBox(height: 2.h),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
                widget.featuredContent.length,
                (index) => Container(
                    margin: EdgeInsets.symmetric(horizontal: 1.w),
                    width: _currentIndex == index ? 8.w : 2.w,
                    height: 1.h,
                    decoration: BoxDecoration(
                        color: _currentIndex == index
                            ? AppTheme.secondaryBlue
                            : AppTheme.textDisabledDark,
                        borderRadius: BorderRadius.circular(2))))),
      ],
    ]);
  }
}