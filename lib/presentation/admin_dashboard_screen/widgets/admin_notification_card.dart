import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AdminNotificationCard extends StatelessWidget {
  final Map<String, dynamic> notification;
  final VoidCallback? onDismiss;
  final VoidCallback? onAction;

  const AdminNotificationCard({
    super.key,
    required this.notification,
    this.onDismiss,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final String title = notification['title'] as String? ?? '';
    final String message = notification['message'] as String? ?? '';
    final String priority = notification['priority'] as String? ?? 'normal';
    final String actionText = notification['actionText'] as String? ?? '';
    final DateTime timestamp =
        notification['timestamp'] as DateTime? ?? DateTime.now();

    Color _getPriorityColor() {
      switch (priority) {
        case 'high':
          return AppTheme.errorRed;
        case 'medium':
          return AppTheme.warningOrange;
        case 'low':
          return AppTheme.successGreen;
        default:
          return AppTheme.secondaryBlue;
      }
    }

    String _getPriorityIcon() {
      switch (priority) {
        case 'high':
          return 'priority_high';
        case 'medium':
          return 'warning';
        case 'low':
          return 'info';
        default:
          return 'notifications';
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

    return Dismissible(
      key: Key(
          'notification_${notification['id'] ?? DateTime.now().millisecondsSinceEpoch}'),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => onDismiss?.call(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 4.w),
        decoration: BoxDecoration(
          color: AppTheme.errorRed.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: CustomIconWidget(
          iconName: 'delete',
          color: AppTheme.errorRed,
          size: 6.w,
        ),
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(4.w),
        margin: EdgeInsets.only(bottom: 2.h),
        decoration: BoxDecoration(
          color: AppTheme.darkTheme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _getPriorityColor().withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: _getPriorityColor().withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: _getPriorityIcon(),
                    color: _getPriorityColor(),
                    size: 4.w,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style:
                            AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textHighEmphasisDark,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        _formatTimestamp(timestamp),
                        style:
                            AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.textDisabledDark,
                        ),
                      ),
                    ],
                  ),
                ),
                if (onDismiss != null)
                  GestureDetector(
                    onTap: onDismiss,
                    child: Container(
                      padding: EdgeInsets.all(1.w),
                      child: CustomIconWidget(
                        iconName: 'close',
                        color: AppTheme.textMediumEmphasisDark,
                        size: 4.w,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 2.h),
            Text(
              message,
              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textMediumEmphasisDark,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            if (actionText.isNotEmpty && onAction != null) ...[
              SizedBox(height: 2.h),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: onAction,
                  style: TextButton.styleFrom(
                    foregroundColor: _getPriorityColor(),
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  ),
                  child: Text(
                    actionText,
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: _getPriorityColor(),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
