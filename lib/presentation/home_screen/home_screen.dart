import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/auth_service.dart';
import '../../services/content_service.dart';
import './widgets/bottom_navigation_widget.dart';
import './widgets/content_category_row.dart';
import './widgets/featured_content_carousel.dart';
import './widgets/streamify_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  int _currentBottomNavIndex = 0;
  bool _isRefreshing = false;
  bool _isLoading = true;

  final AuthService _authService = AuthService();
  final ContentService _contentService = ContentService();

  // Data lists
  List<Map<String, dynamic>> continueWatchingList = [];
  List<Map<String, dynamic>> trendingNowList = [];
  List<Map<String, dynamic>> newReleasesList = [];
  List<Map<String, dynamic>> watchlistContent = [];
  List<Map<String, dynamic>> featuredContent = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadContent();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Handle scroll events for potential header transparency effects
  }

  Future<void> _loadContent() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userId = _authService.currentUserId;

      // Load all content in parallel
      final results = await Future.wait([
        _contentService.getContent(onlyFeatured: true, limit: 5),
        _contentService.getTrendingContent(limit: 10),
        _contentService.getNewReleases(limit: 10),
        if (userId != null)
          _contentService.getContinueWatching(userId: userId, limit: 10),
        if (userId != null)
          _contentService.getUserWatchlist(userId: userId, limit: 10),
      ]);

      setState(() {
        featuredContent = results[0];
        trendingNowList = results[1];
        newReleasesList = results[2];

        if (userId != null && results.length > 3) {
          continueWatchingList = results[3].map((item) {
            final content = item['content'] as Map<String, dynamic>;
            return {
              ...content,
              'progress': item['watch_progress'] ?? 0.0,
            };
          }).toList();

          if (results.length > 4) {
            watchlistContent = results[4].map((item) {
              return item['content'] as Map<String, dynamic>;
            }).toList();
          }
        }
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load content: $error'),
          backgroundColor: AppTheme.errorRed,
        ),
      );
    }
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    await _loadContent();

    setState(() {
      _isRefreshing = false;
    });

    // Show refresh feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Content updated'),
        backgroundColor: AppTheme.successGreen,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentBottomNavIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppTheme.backgroundDark,
        body: Center(
          child: CircularProgressIndicator(
            color: AppTheme.secondaryBlue,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            const StreamifyHeader(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _handleRefresh,
                color: AppTheme.secondaryBlue,
                backgroundColor: AppTheme.surfaceDark,
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 2.h),
                          FeaturedContentCarousel(
                            featuredContent: featuredContent,
                          ),
                          SizedBox(height: 4.h),

                          // Continue Watching (only show if user is authenticated and has history)
                          if (_authService.isAuthenticated &&
                              continueWatchingList.isNotEmpty) ...[
                            ContentCategoryRow(
                              categoryTitle: 'Continue Watching',
                              contentList: continueWatchingList,
                            ),
                            SizedBox(height: 3.h),
                          ],

                          ContentCategoryRow(
                            categoryTitle: 'Trending Now',
                            contentList: trendingNowList,
                          ),
                          SizedBox(height: 3.h),
                          ContentCategoryRow(
                            categoryTitle: 'New Releases',
                            contentList: newReleasesList,
                          ),
                          SizedBox(height: 3.h),

                          // Your Watchlist (only show if user is authenticated and has watchlist items)
                          if (_authService.isAuthenticated &&
                              watchlistContent.isNotEmpty) ...[
                            ContentCategoryRow(
                              categoryTitle: 'Your Watchlist',
                              contentList: watchlistContent,
                            ),
                            SizedBox(height: 3.h),
                          ],

                          SizedBox(
                              height: 10.h), // Bottom padding for navigation
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationWidget(
        currentIndex: _currentBottomNavIndex,
        onTap: _onBottomNavTap,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/search-screen');
        },
        backgroundColor: AppTheme.secondaryBlue,
        child: CustomIconWidget(
          iconName: 'search',
          color: AppTheme.backgroundDark,
          size: 24,
        ),
      ),
    );
  }
}
