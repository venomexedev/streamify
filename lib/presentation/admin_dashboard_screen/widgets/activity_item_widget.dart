import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ActivityItemWidget extends StatelessWidget {
  final Map<String, dynamic> activity;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const ActivityItemWidget({
    super.key,
    required this.activity,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final String type = activity['type'] as String? ?? '';
    final String title = activity['title'] as String? ?? '';
    final String description = activity['description'] as String? ?? '';
    final DateTime timestamp =
        activity['timestamp'] as DateTime? ?? DateTime.now();
    final String priority = activity['priority'] as String? ?? 'normal';

    Color _getActivityColor() {
      switch (type) {
        case 'user_registration':
          return AppTheme.successGreen;
        case 'content_upload':
          return AppTheme.secondaryBlue;
        case 'system_event':
          return AppTheme.warningOrange;
        case 'content_moderation':
          return AppTheme.accentPurple;
        default:
          return AppTheme.textMediumEmphasisDark;
      }
    }

    String _getActivityIcon() {
      switch (type) {
        case 'user_registration':
          return 'person_add';
        case 'content_upload':
          return 'cloud_upload';
        case 'system_event':
          return 'settings';
        case 'content_moderation':
          return 'verified';
        default:
          return 'info';
      }
    }

    String _formatTimestamp(DateTime timestamp) {
      final now = DateTime.now();
      final difference = now.difference(timestamp);

      if (difference.inMinutes < 1) {
        return 'Just now';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h ago';
      } else {
        return '${difference.inDays}d ago';
      }
    }

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(4.w),
        margin: EdgeInsets.only(bottom: 2.h),
        decoration: BoxDecoration(
          color: AppTheme.darkTheme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: priority == 'high'
                ? AppTheme.errorRed.withValues(alpha: 0.3)
                : AppTheme.darkTheme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.5.w),
              decoration: BoxDecoration(
                color: _getActivityColor().withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: CustomIconWidget(
                iconName: _getActivityIcon(),
                color: _getActivityColor(),
                size: 5.w,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style:
                              AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textHighEmphasisDark,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (priority == 'high')
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: AppTheme.errorRed.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'HIGH',
                            style: AppTheme.darkTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: AppTheme.errorRed,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    description,
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textMediumEmphasisDark,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    _formatTimestamp(timestamp),
                    style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.textDisabledDark,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
