import 'package:flutter/material.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/home_screen/home_screen.dart';
import '../presentation/search_screen/search_screen.dart';
import '../presentation/admin_dashboard_screen/admin_dashboard_screen.dart';
import '../presentation/video_player_screen/video_player_screen.dart';
import '../presentation/content_management_screen/content_management_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String loginScreen = '/login-screen';
  static const String homeScreen = '/home-screen';
  static const String searchScreen = '/search-screen';
  static const String adminDashboardScreen = '/admin-dashboard-screen';
  static const String videoPlayerScreen = '/video-player-screen';
  static const String contentManagementScreen = '/content-management-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => LoginScreen(),
    loginScreen: (context) => LoginScreen(),
    homeScreen: (context) => HomeScreen(),
    searchScreen: (context) => SearchScreen(),
    adminDashboardScreen: (context) => AdminDashboardScreen(),
    videoPlayerScreen: (context) => VideoPlayerScreen(),
    contentManagementScreen: (context) => ContentManagementScreen(),
    // TODO: Add your other routes here
  };
}
