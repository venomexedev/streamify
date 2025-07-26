import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/filter_chips_widget.dart';
import './widgets/recent_searches_widget.dart';
import './widgets/search_bar_widget.dart';
import './widgets/search_results_widget.dart';
import './widgets/search_suggestions_widget.dart';
import './widgets/trending_chips_widget.dart';
import './widgets/voice_search_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<String> _recentSearches = [
    'Avengers Endgame',
    'Breaking Bad',
    'The Dark Knight',
    'Stranger Things',
    'Game of Thrones',
  ];

  List<Map<String, dynamic>> _searchSuggestions = [];
  List<Map<String, dynamic>> _searchResults = [];
  Map<String, bool> _selectedFilters = {
    'movies': false,
    'shows': false,
    'actors': false,
    'recent': false,
    'popular': false,
    'rated': false,
  };

  bool _isSearching = false;
  bool _showSuggestions = false;
  bool _showVoiceSearch = false;
  bool _isLoading = false;
  String _currentQuery = '';

  // Mock data for search functionality
  final List<Map<String, dynamic>> _mockContent = [
    {
      'id': 1,
      'type': 'movie',
      'title': 'Avengers: Endgame',
      'year': 2019,
      'rating': 8.4,
      'genre': 'Action',
      'thumbnail':
          'https://images.unsplash.com/photo-1635805737707-575885ab0820?w=400&h=600&fit=crop',
      'description':
          'The Avengers assemble once more to reverse the damage caused by Thanos.',
    },
    {
      'id': 2,
      'type': 'show',
      'title': 'Breaking Bad',
      'year': 2008,
      'rating': 9.5,
      'genre': 'Drama',
      'thumbnail':
          'https://images.unsplash.com/photo-1489599162810-1e666c5b4b8e?w=400&h=600&fit=crop',
      'description':
          'A high school chemistry teacher turned methamphetamine manufacturer.',
    },
    {
      'id': 3,
      'type': 'movie',
      'title': 'The Dark Knight',
      'year': 2008,
      'rating': 9.0,
      'genre': 'Action',
      'thumbnail':
          'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400&h=600&fit=crop',
      'description': 'Batman faces the Joker in this epic superhero thriller.',
    },
    {
      'id': 4,
      'type': 'show',
      'title': 'Stranger Things',
      'year': 2016,
      'rating': 8.7,
      'genre': 'Sci-Fi',
      'thumbnail':
          'https://images.unsplash.com/photo-1518709268805-4e9042af2176?w=400&h=600&fit=crop',
      'description': 'Kids in a small town uncover supernatural mysteries.',
    },
    {
      'id': 5,
      'type': 'actor',
      'name': 'Robert Downey Jr.',
      'image':
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=400&fit=crop',
      'knownFor': 'Iron Man, Sherlock Holmes, Avengers series',
    },
    {
      'id': 6,
      'type': 'actor',
      'name': 'Scarlett Johansson',
      'image':
          'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=400&h=400&fit=crop',
      'knownFor': 'Black Widow, Marriage Story, Lost in Translation',
    },
    {
      'id': 7,
      'type': 'genre',
      'name': 'Action',
      'count': 245,
    },
    {
      'id': 8,
      'type': 'genre',
      'name': 'Comedy',
      'count': 189,
    },
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();

    if (query.isEmpty) {
      setState(() {
        _showSuggestions = false;
        _searchSuggestions.clear();
        _searchResults.clear();
        _isSearching = false;
        _currentQuery = '';
      });
      return;
    }

    setState(() {
      _currentQuery = query;
      _isSearching = true;
    });

    // Generate suggestions
    _generateSuggestions(query);

    // Perform search with debounce
    Future.delayed(Duration(milliseconds: 500), () {
      if (_currentQuery == query && mounted) {
        _performSearch(query);
      }
    });
  }

  void _generateSuggestions(String query) {
    final suggestions = <Map<String, dynamic>>[];

    // Add content suggestions
    for (final content in _mockContent) {
      if (content['type'] == 'movie' || content['type'] == 'show') {
        final title = content['title'] as String;
        if (title.toLowerCase().contains(query.toLowerCase())) {
          suggestions.add({
            'type': content['type'],
            'title': title,
            'subtitle': '${content['year']} • ${content['genre']}',
          });
        }
      } else if (content['type'] == 'actor') {
        final name = content['name'] as String;
        if (name.toLowerCase().contains(query.toLowerCase())) {
          suggestions.add({
            'type': 'actor',
            'title': name,
            'subtitle': content['knownFor'],
          });
        }
      } else if (content['type'] == 'genre') {
        final name = content['name'] as String;
        if (name.toLowerCase().contains(query.toLowerCase())) {
          suggestions.add({
            'type': 'genre',
            'title': name,
            'subtitle': '${content['count']} titles',
          });
        }
      }
    }

    setState(() {
      _searchSuggestions = suggestions;
      _showSuggestions = suggestions.isNotEmpty;
    });
  }

  void _performSearch(String query) {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call delay
    Future.delayed(Duration(seconds: 1), () {
      if (!mounted) return;

      final results = <Map<String, dynamic>>[];

      // Filter content based on query and selected filters
      for (final content in _mockContent) {
        bool matches = false;

        if (content['type'] == 'movie' || content['type'] == 'show') {
          final title = content['title'] as String;
          final genre = content['genre'] as String;
          matches = title.toLowerCase().contains(query.toLowerCase()) ||
              genre.toLowerCase().contains(query.toLowerCase());
        } else if (content['type'] == 'actor') {
          final name = content['name'] as String;
          matches = name.toLowerCase().contains(query.toLowerCase());
        } else if (content['type'] == 'genre') {
          final name = content['name'] as String;
          matches = name.toLowerCase().contains(query.toLowerCase());
        }

        if (matches) {
          // Apply filters
          if (_selectedFilters['movies'] == true && content['type'] != 'movie')
            continue;
          if (_selectedFilters['shows'] == true && content['type'] != 'show')
            continue;
          if (_selectedFilters['actors'] == true && content['type'] != 'actor')
            continue;

          results.add(content);
        }
      }

      setState(() {
        _searchResults = results;
        _isLoading = false;
        _showSuggestions = false;
      });

      // Add to recent searches
      if (!_recentSearches.contains(query)) {
        setState(() {
          _recentSearches.insert(0, query);
          if (_recentSearches.length > 10) {
            _recentSearches = _recentSearches.take(10).toList();
          }
        });
      }
    });
  }

  void _onTrendingChipTap(String search) {
    _searchController.text = search;
    _performSearch(search);
  }

  void _onRecentSearchTap(String search) {
    _searchController.text = search;
    _performSearch(search);
  }

  void _onRemoveRecentSearch(String search) {
    setState(() {
      _recentSearches.remove(search);
    });
  }

  void _onClearAllRecentSearches() {
    setState(() {
      _recentSearches.clear();
    });
  }

  void _onSuggestionTap(String suggestion) {
    _searchController.text = suggestion;
    _performSearch(suggestion);
  }

  void _onFilterChanged(String filter, bool selected) {
    setState(() {
      _selectedFilters[filter] = selected;
    });

    if (_currentQuery.isNotEmpty) {
      _performSearch(_currentQuery);
    }
  }

  void _onResultTap(Map<String, dynamic> result) {
    final type = result['type'] as String;

    if (type == 'movie' || type == 'show') {
      Navigator.pushNamed(context, '/video-player-screen');
    } else if (type == 'actor') {
      // Navigate to actor profile (not implemented)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Actor profile: ${result['name']}')),
      );
    } else if (type == 'genre') {
      // Navigate to genre listing (not implemented)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Genre: ${result['name']}')),
      );
    }
  }

  void _onAddToWatchlist(Map<String, dynamic> result) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Added "${result['title'] ?? result['name']}" to watchlist'),
        backgroundColor: AppTheme.successGreen,
      ),
    );
  }

  void _onShare(Map<String, dynamic> result) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing "${result['title'] ?? result['name']}"'),
      ),
    );
  }

  void _onVoiceSearch() {
    setState(() {
      _showVoiceSearch = true;
    });
  }

  void _onVoiceResult(String result) {
    _searchController.text = result;
    _performSearch(result);
  }

  void _onCloseVoiceSearch() {
    setState(() {
      _showVoiceSearch = false;
    });
  }

  void _onClearSearch() {
    setState(() {
      _searchResults.clear();
      _searchSuggestions.clear();
      _showSuggestions = false;
      _isSearching = false;
      _currentQuery = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundDark,
        elevation: 0,
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.darkTheme.colorScheme.onSurface,
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Search',
          style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.darkTheme.colorScheme.onSurface,
          ),
        ),
        actions: [
          if (_isSearching)
            IconButton(
              icon: CustomIconWidget(
                iconName: 'clear',
                color: AppTheme.darkTheme.colorScheme.onSurface,
                size: 24,
              ),
              onPressed: () {
                _searchController.clear();
                _onClearSearch();
              },
            ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Search Bar
              SearchBarWidget(
                controller: _searchController,
                onChanged: (value) {}, // Handled by listener
                onVoiceSearch: _onVoiceSearch,
                onClear: _onClearSearch,
              ),

              // Filter Chips
              if (_isSearching)
                FilterChipsWidget(
                  selectedFilters: _selectedFilters,
                  onFilterChanged: _onFilterChanged,
                ),

              // Content Area
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Search Suggestions
                      if (_showSuggestions)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 1.h),
                          child: SearchSuggestionsWidget(
                            suggestions: _searchSuggestions,
                            onSuggestionTap: _onSuggestionTap,
                          ),
                        ),

                      // Search Results
                      if (_isSearching && !_showSuggestions)
                        SearchResultsWidget(
                          results: _searchResults,
                          isLoading: _isLoading,
                          onResultTap: _onResultTap,
                          onAddToWatchlist: _onAddToWatchlist,
                          onShare: _onShare,
                        ),

                      // Default Content (when not searching)
                      if (!_isSearching) ...[
                        // Trending Searches
                        TrendingChipsWidget(
                          onChipTap: _onTrendingChipTap,
                        ),

                        SizedBox(height: 2.h),

                        // Recent Searches
                        RecentSearchesWidget(
                          recentSearches: _recentSearches,
                          onSearchTap: _onRecentSearchTap,
                          onRemoveSearch: _onRemoveRecentSearch,
                          onClearAll: _onClearAllRecentSearches,
                        ),
                      ],

                      SizedBox(height: 4.h),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Voice Search Overlay
          if (_showVoiceSearch)
            VoiceSearchWidget(
              onVoiceResult: _onVoiceResult,
              onClose: _onCloseVoiceSearch,
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppTheme.darkTheme.colorScheme.surface,
        selectedItemColor: AppTheme.secondaryBlue,
        unselectedItemColor: AppTheme.darkTheme.colorScheme.onSurfaceVariant,
        currentIndex: 1, // Search tab
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'home',
              color: AppTheme.darkTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'home',
              color: AppTheme.secondaryBlue,
              size: 24,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'search',
              color: AppTheme.secondaryBlue,
              size: 24,
            ),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'video_library',
              color: AppTheme.darkTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'video_library',
              color: AppTheme.secondaryBlue,
              size: 24,
            ),
            label: 'Library',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'person',
              color: AppTheme.darkTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'person',
              color: AppTheme.secondaryBlue,
              size: 24,
            ),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home-screen');
              break;
            case 1:
              // Already on search screen
              break;
            case 2:
              // Navigate to library (not implemented)
              break;
            case 3:
              // Navigate to profile (not implemented)
              break;
          }
        },
      ),
    );
  }
}
