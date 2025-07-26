import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/activity_item_widget.dart';
import './widgets/admin_header_widget.dart';
import './widgets/admin_notification_card.dart';
import './widgets/analytics_chart_widget.dart';
import './widgets/dashboard_metrics_card.dart';
import './widgets/quick_action_button.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  bool _isRefreshing = false;
  List<Map<String, dynamic>> _notifications = [];
  List<Map<String, dynamic>> _recentActivities = [];

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  void _loadDashboardData() {
    // Mock notifications data
    _notifications = [
      {
        "id": 1,
        "title": "Content Moderation Required",
        "message":
            "5 new videos are pending approval for content guidelines compliance.",
        "priority": "high",
        "actionText": "Review Now",
        "timestamp": DateTime.now().subtract(Duration(minutes: 15)),
      },
      {
        "id": 2,
        "title": "System Maintenance Scheduled",
        "message":
            "Scheduled maintenance window on Sunday 2:00 AM - 4:00 AM EST.",
        "priority": "medium",
        "actionText": "View Details",
        "timestamp": DateTime.now().subtract(Duration(hours: 2)),
      },
      {
        "id": 3,
        "title": "New Premium Subscriptions",
        "message":
            "127 users upgraded to premium accounts in the last 24 hours.",
        "priority": "low",
        "actionText": "View Report",
        "timestamp": DateTime.now().subtract(Duration(hours: 6)),
      },
    ];

    // Mock recent activities data
    _recentActivities = [
      {
        "id": 1,
        "type": "user_registration",
        "title": "New User Registration",
        "description": "sarah.johnson@email.com joined the platform",
        "timestamp": DateTime.now().subtract(Duration(minutes: 5)),
        "priority": "normal",
      },
      {
        "id": 2,
        "type": "content_upload",
        "title": "Content Upload",
        "description":
            "\"The Future of AI\" documentary uploaded by ContentCreator123",
        "timestamp": DateTime.now().subtract(Duration(minutes: 12)),
        "priority": "normal",
      },
      {
        "id": 3,
        "type": "content_moderation",
        "title": "Content Flagged",
        "description":
            "Video \"Tech Review 2024\" flagged for copyright review",
        "timestamp": DateTime.now().subtract(Duration(minutes: 28)),
        "priority": "high",
      },
      {
        "id": 4,
        "type": "system_event",
        "title": "Server Performance Alert",
        "description": "High CPU usage detected on streaming server cluster",
        "timestamp": DateTime.now().subtract(Duration(hours: 1)),
        "priority": "high",
      },
      {
        "id": 5,
        "type": "user_registration",
        "title": "Bulk User Registration",
        "description": "15 new users registered in the last hour",
        "timestamp": DateTime.now().subtract(Duration(hours: 1, minutes: 30)),
        "priority": "normal",
      },
    ];
  }

  Future<void> _refreshDashboard() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call delay
    await Future.delayed(Duration(seconds: 2));

    _loadDashboardData();

    setState(() {
      _isRefreshing = false;
    });
  }

  void _handleNotificationAction(Map<String, dynamic> notification) {
    // Handle notification action based on type
    final String actionText = notification['actionText'] as String? ?? '';

    if (actionText == 'Review Now') {
      Navigator.pushNamed(context, '/content-management-screen');
    } else if (actionText == 'View Details' || actionText == 'View Report') {
      // Show detailed view or navigate to reports
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Opening ${actionText.toLowerCase()}...'),
          backgroundColor: AppTheme.secondaryBlue,
        ),
      );
    }
  }

  void _dismissNotification(int index) {
    setState(() {
      _notifications.removeAt(index);
    });
  }

  void _handleActivityTap(Map<String, dynamic> activity) {
    final String type = activity['type'] as String? ?? '';

    switch (type) {
      case 'user_registration':
        // Navigate to user management
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Opening user details...'),
            backgroundColor: AppTheme.successGreen,
          ),
        );
        break;
      case 'content_upload':
        Navigator.pushNamed(context, '/content-management-screen');
        break;
      case 'content_moderation':
        Navigator.pushNamed(context, '/content-management-screen');
        break;
      case 'system_event':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Opening system monitoring...'),
            backgroundColor: AppTheme.warningOrange,
          ),
        );
        break;
    }
  }

  void _handleActivityLongPress(Map<String, dynamic> activity) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.darkTheme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.textMediumEmphasisDark,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Activity Actions',
              style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.textHighEmphasisDark,
              ),
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'visibility',
                color: AppTheme.secondaryBlue,
                size: 5.w,
              ),
              title: Text(
                'View Details',
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textHighEmphasisDark,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _handleActivityTap(activity);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: AppTheme.accentPurple,
                size: 5.w,
              ),
              title: Text(
                'Share Activity',
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textHighEmphasisDark,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Activity shared successfully'),
                    backgroundColor: AppTheme.accentPurple,
                  ),
                );
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'bookmark',
                color: AppTheme.successGreen,
                size: 5.w,
              ),
              title: Text(
                'Bookmark',
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textHighEmphasisDark,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Activity bookmarked'),
                    backgroundColor: AppTheme.successGreen,
                  ),
                );
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Mock analytics data
    final List<Map<String, dynamic>> analyticsData = [
      {"label": "Mon", "value": 120},
      {"label": "Tue", "value": 190},
      {"label": "Wed", "value": 300},
      {"label": "Thu", "value": 250},
      {"label": "Fri", "value": 420},
      {"label": "Sat", "value": 380},
      {"label": "Sun", "value": 290},
    ];

    return Scaffold(
      backgroundColor: AppTheme.darkTheme.scaffoldBackgroundColor,
      body: RefreshIndicator(
        onRefresh: _refreshDashboard,
        color: AppTheme.secondaryBlue,
        backgroundColor: AppTheme.darkTheme.cardColor,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: AdminHeaderWidget(
                adminName: "Alex Thompson",
                notificationCount: _notifications.length,
                onNotificationTap: () {
                  // Scroll to notifications section
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Showing notifications...'),
                      backgroundColor: AppTheme.secondaryBlue,
                    ),
                  );
                },
                onMenuTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Opening admin settings...'),
                      backgroundColor: AppTheme.accentPurple,
                    ),
                  );
                },
                onProfileTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Opening admin profile...'),
                      backgroundColor: AppTheme.successGreen,
                    ),
                  );
                },
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.all(4.w),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Dashboard Metrics Section
                  Text(
                    'Platform Overview',
                    style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                      color: AppTheme.textHighEmphasisDark,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  DashboardMetricsCard(
                    title: 'Total Users',
                    value: '24,847',
                    subtitle: 'from last month',
                    iconName: 'people',
                    iconColor: AppTheme.successGreen,
                    percentage: 12.5,
                    isPositive: true,
                  ),
                  SizedBox(height: 2.h),
                  DashboardMetricsCard(
                    title: 'Active Streams',
                    value: '1,293',
                    subtitle: 'currently watching',
                    iconName: 'play_circle',
                    iconColor: AppTheme.secondaryBlue,
                    percentage: 8.3,
                    isPositive: true,
                  ),
                  SizedBox(height: 2.h),
                  DashboardMetricsCard(
                    title: 'Content Library',
                    value: '8,456',
                    subtitle: 'total videos',
                    iconName: 'video_library',
                    iconColor: AppTheme.accentPurple,
                    percentage: 15.2,
                    isPositive: true,
                  ),
                  SizedBox(height: 2.h),
                  DashboardMetricsCard(
                    title: 'Revenue Analytics',
                    value: '\$127,849',
                    subtitle: 'this month',
                    iconName: 'trending_up',
                    iconColor: AppTheme.warningOrange,
                    percentage: 3.7,
                    isPositive: false,
                  ),
                  SizedBox(height: 4.h),

                  // Quick Actions Section
                  Text(
                    'Quick Actions',
                    style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                      color: AppTheme.textHighEmphasisDark,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      QuickActionButton(
                        title: 'Add Content',
                        iconName: 'add_circle',
                        backgroundColor: AppTheme.secondaryBlue,
                        onTap: () {
                          Navigator.pushNamed(
                              context, '/content-management-screen');
                        },
                      ),
                      QuickActionButton(
                        title: 'User Management',
                        iconName: 'manage_accounts',
                        backgroundColor: AppTheme.successGreen,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Opening user management...'),
                              backgroundColor: AppTheme.successGreen,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      QuickActionButton(
                        title: 'Content Moderation',
                        iconName: 'verified_user',
                        backgroundColor: AppTheme.accentPurple,
                        onTap: () {
                          Navigator.pushNamed(
                              context, '/content-management-screen');
                        },
                      ),
                      QuickActionButton(
                        title: 'System Settings',
                        iconName: 'settings',
                        backgroundColor: AppTheme.warningOrange,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Opening system settings...'),
                              backgroundColor: AppTheme.warningOrange,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),

                  // Analytics Chart Section
                  Text(
                    'Weekly Analytics',
                    style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                      color: AppTheme.textHighEmphasisDark,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  AnalyticsChartWidget(
                    title: 'User Engagement',
                    chartData: analyticsData,
                    chartType: 'line',
                  ),
                  SizedBox(height: 4.h),

                  // Notifications Section
                  if (_notifications.isNotEmpty) ...[
                    Text(
                      'Admin Notifications',
                      style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                        color: AppTheme.textHighEmphasisDark,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    ..._notifications.asMap().entries.map((entry) {
                      final index = entry.key;
                      final notification = entry.value;
                      return AdminNotificationCard(
                        notification: notification,
                        onDismiss: () => _dismissNotification(index),
                        onAction: () => _handleNotificationAction(notification),
                      );
                    }).toList(),
                    SizedBox(height: 4.h),
                  ],

                  // Recent Activity Section
                  Text(
                    'Recent Activity',
                    style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                      color: AppTheme.textHighEmphasisDark,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  ..._recentActivities.map((activity) {
                    return ActivityItemWidget(
                      activity: activity,
                      onTap: () => _handleActivityTap(activity),
                      onLongPress: () => _handleActivityLongPress(activity),
                    );
                  }).toList(),
                  SizedBox(height: 4.h),

                  // Last Update Info
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color:
                          AppTheme.darkTheme.cardColor.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.darkTheme.colorScheme.outline
                            .withValues(alpha: 0.1),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: _isRefreshing ? 'sync' : 'check_circle',
                          color: _isRefreshing
                              ? AppTheme.warningOrange
                              : AppTheme.successGreen,
                          size: 5.w,
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _isRefreshing ? 'Updating...' : 'Last Updated',
                                style: AppTheme.darkTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme.textMediumEmphasisDark,
                                ),
                              ),
                              if (!_isRefreshing)
                                Text(
                                  'July 26, 2025 at 10:04 AM',
                                  style: AppTheme.darkTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    color: AppTheme.textHighEmphasisDark,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4.h),
                ]),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/content-management-screen');
        },
        backgroundColor: AppTheme.secondaryBlue,
        child: CustomIconWidget(
          iconName: 'add',
          color: AppTheme.backgroundDark,
          size: 7.w,
        ),
      ),
    );
  }
}
