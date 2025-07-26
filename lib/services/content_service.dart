import './supabase_service.dart';

class ContentService {
  static final ContentService _instance = ContentService._internal();
  factory ContentService() => _instance;
  ContentService._internal();

  final SupabaseService _supabaseService = SupabaseService();

  /// Get all active content with optional category filtering
  Future<List<Map<String, dynamic>>> getContent({
    String? categoryId,
    int? limit,
    bool onlyFeatured = false,
  }) async {
    try {
      final client = await _supabaseService.client;

      var query = client.from('content').select('''
            *,
            categories:category_id (
              id,
              name,
              description
            )
          ''').eq('status', 'active');

      if (categoryId != null) {
        query = query.eq('category_id', categoryId);
      }

      if (onlyFeatured) {
        query = query.eq('is_featured', true);
      }

      var orderedQuery = query.order('created_at', ascending: false);

      if (limit != null) {
        orderedQuery = orderedQuery.limit(limit);
      }

      final response = await orderedQuery;
      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      throw Exception('Failed to get content: $error');
    }
  }

  /// Get trending content based on view count
  Future<List<Map<String, dynamic>>> getTrendingContent({
    int limit = 10,
  }) async {
    try {
      final client = await _supabaseService.client;

      final response = await client
          .from('content')
          .select('''
            *,
            categories:category_id (
              id,
              name,
              description
            )
          ''')
          .eq('status', 'active')
          .order('view_count', ascending: false)
          .limit(limit);

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      throw Exception('Failed to get trending content: $error');
    }
  }

  /// Get user's continue watching list
  Future<List<Map<String, dynamic>>> getContinueWatching({
    required String userId,
    int limit = 10,
  }) async {
    try {
      final client = await _supabaseService.client;

      final response = await client
          .from('user_watch_history')
          .select('''
            *,
            content:content_id (
              *,
              categories:category_id (
                id,
                name,
                description
              )
            )
          ''')
          .eq('user_id', userId)
          .eq('completed', false)
          .order('last_watched_at', ascending: false)
          .limit(limit);

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      throw Exception('Failed to get continue watching: $error');
    }
  }

  /// Get user's watchlist
  Future<List<Map<String, dynamic>>> getUserWatchlist({
    required String userId,
    int limit = 20,
  }) async {
    try {
      final client = await _supabaseService.client;

      final response = await client
          .from('user_watchlist')
          .select('''
            *,
            content:content_id (
              *,
              categories:category_id (
                id,
                name,
                description
              )
            )
          ''')
          .eq('user_id', userId)
          .order('added_at', ascending: false)
          .limit(limit);

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      throw Exception('Failed to get watchlist: $error');
    }
  }

  /// Add content to user's watchlist
  Future<void> addToWatchlist({
    required String userId,
    required String contentId,
  }) async {
    try {
      final client = await _supabaseService.client;

      await client.from('user_watchlist').insert({
        'user_id': userId,
        'content_id': contentId,
      });
    } catch (error) {
      throw Exception('Failed to add to watchlist: $error');
    }
  }

  /// Remove content from user's watchlist
  Future<void> removeFromWatchlist({
    required String userId,
    required String contentId,
  }) async {
    try {
      final client = await _supabaseService.client;

      await client
          .from('user_watchlist')
          .delete()
          .eq('user_id', userId)
          .eq('content_id', contentId);
    } catch (error) {
      throw Exception('Failed to remove from watchlist: $error');
    }
  }

  /// Update user's watch progress
  Future<void> updateWatchProgress({
    required String userId,
    required String contentId,
    required double progressPercentage,
    required int watchDurationSeconds,
    bool completed = false,
  }) async {
    try {
      final client = await _supabaseService.client;

      await client.from('user_watch_history').upsert({
        'user_id': userId,
        'content_id': contentId,
        'watch_progress': progressPercentage,
        'watch_duration_seconds': watchDurationSeconds,
        'completed': completed,
        'last_watched_at': DateTime.now().toIso8601String(),
      });

      // Increment view count
      await client.rpc('increment_view_count', params: {
        'content_uuid': contentId,
      });
    } catch (error) {
      throw Exception('Failed to update watch progress: $error');
    }
  }

  /// Get all categories
  Future<List<Map<String, dynamic>>> getCategories() async {
    try {
      final client = await _supabaseService.client;

      final response = await client
          .from('categories')
          .select()
          .order('sort_order', ascending: true);

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      throw Exception('Failed to get categories: $error');
    }
  }

  /// Get content by ID with quality options
  Future<Map<String, dynamic>?> getContentById(String contentId) async {
    try {
      final client = await _supabaseService.client;

      final response = await client.from('content').select('''
            *,
            categories:category_id (
              id,
              name,
              description
            ),
            content_quality_options (
              quality,
              video_url,
              file_size_mb
            )
          ''').eq('id', contentId).single();

      return response;
    } catch (error) {
      throw Exception('Failed to get content by ID: $error');
    }
  }

  /// Search content by title or description
  Future<List<Map<String, dynamic>>> searchContent({
    required String query,
    int limit = 20,
  }) async {
    try {
      final client = await _supabaseService.client;

      final response = await client
          .from('content')
          .select('''
            *,
            categories:category_id (
              id,
              name,
              description
            )
          ''')
          .eq('status', 'active')
          .or('title.ilike.%$query%,description.ilike.%$query%')
          .order('view_count', ascending: false)
          .limit(limit);

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      throw Exception('Failed to search content: $error');
    }
  }

  /// Get new releases (content from the last 6 months)
  Future<List<Map<String, dynamic>>> getNewReleases({
    int limit = 10,
  }) async {
    try {
      final client = await _supabaseService.client;

      final sixMonthsAgo = DateTime.now().subtract(const Duration(days: 180));

      final response = await client
          .from('content')
          .select('''
            *,
            categories:category_id (
              id,
              name,
              description
            )
          ''')
          .eq('status', 'active')
          .gte('created_at', sixMonthsAgo.toIso8601String())
          .order('created_at', ascending: false)
          .limit(limit);

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      throw Exception('Failed to get new releases: $error');
    }
  }
}