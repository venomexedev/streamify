import 'package:supabase_flutter/supabase_flutter.dart';
import './supabase_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final SupabaseService _supabaseService = SupabaseService();

  /// Sign up a new user with email and password
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    String? fullName,
  }) async {
    try {
      final client = await _supabaseService.client;

      final response = await client.auth.signUp(
        email: email,
        password: password,
        data: fullName != null ? {'full_name': fullName} : null,
      );

      return response;
    } catch (error) {
      throw Exception('Sign-up failed: $error');
    }
  }

  /// Sign in an existing user with email and password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final client = await _supabaseService.client;

      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      return response;
    } catch (error) {
      throw Exception('Sign-in failed: $error');
    }
  }

  /// Sign out the current user
  Future<void> signOut() async {
    try {
      final client = await _supabaseService.client;
      await client.auth.signOut();
    } catch (error) {
      throw Exception('Sign-out failed: $error');
    }
  }

  /// Get current user profile information
  Future<Map<String, dynamic>?> getCurrentUserProfile() async {
    try {
      final client = await _supabaseService.client;
      final userId = client.auth.currentUser?.id;

      if (userId == null) return null;

      final response =
          await client.from('user_profiles').select().eq('id', userId).single();

      return response;
    } catch (error) {
      throw Exception('Failed to get user profile: $error');
    }
  }

  /// Update user profile information
  Future<Map<String, dynamic>> updateUserProfile({
    required String userId,
    String? fullName,
    String? avatarUrl,
  }) async {
    try {
      final client = await _supabaseService.client;

      final updateData = <String, dynamic>{};
      if (fullName != null) updateData['full_name'] = fullName;
      if (avatarUrl != null) updateData['avatar_url'] = avatarUrl;
      updateData['updated_at'] = DateTime.now().toIso8601String();

      final response = await client
          .from('user_profiles')
          .update(updateData)
          .eq('id', userId)
          .select()
          .single();

      return response;
    } catch (error) {
      throw Exception('Failed to update user profile: $error');
    }
  }

  /// Check if current user is admin
  Future<bool> isCurrentUserAdmin() async {
    try {
      final profile = await getCurrentUserProfile();
      return profile?['role'] == 'admin';
    } catch (error) {
      return false;
    }
  }

  /// Listen to authentication state changes
  Stream<AuthState> get authStateChanges {
    return _supabaseService.syncClient.auth.onAuthStateChange;
  }

  /// Check if user is currently authenticated
  bool get isAuthenticated => _supabaseService.isAuthenticated;

  /// Get current user
  User? get currentUser => _supabaseService.currentUser;

  /// Get current user ID
  String? get currentUserId => _supabaseService.currentUserId;
}
