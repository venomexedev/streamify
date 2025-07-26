import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ContentCardWidget extends StatelessWidget {
  final Map<String, dynamic> content;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onToggleVisibility;
  final VoidCallback? onViewAnalytics;
  final VoidCallback? onTap;

  const ContentCardWidget({
    Key? key,
    required this.content,
    this.onEdit,
    this.onDelete,
    this.onToggleVisibility,
    this.onViewAnalytics,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Dismissible(
      key: Key(content['id'].toString()),
      background: _buildSwipeBackground(context, isDarkMode, true),
      secondaryBackground: _buildSwipeBackground(context, isDarkMode, false),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          onEdit?.call();
        } else {
          onDelete?.call();
        }
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(3.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildThumbnail(context),
                SizedBox(width: 3.w),
                Expanded(
                  child: _buildContentInfo(context, isDarkMode),
                ),
                _buildActionMenu(context, isDarkMode),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail(BuildContext context) {
    return Container(
      width: 20.w,
      height: 12.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            CustomImageWidget(
              imageUrl: content['thumbnail'] ?? '',
              width: 20.w,
              height: 12.h,
              fit: BoxFit.cover,
            ),
            if (content['status'] == 'processing')
              Container(
                color: Colors.black.withValues(alpha: 0.7),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 6.w,
                        height: 6.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.secondaryBlue,
                          ),
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        '${content['progress'] ?? 0}%',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              fontSize: 8.sp,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            Positioned(
              bottom: 1.w,
              right: 1.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  content['duration'] ?? '0:00',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontSize: 8.sp,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentInfo(BuildContext context, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          content['title'] ?? 'Untitled',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
              ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 0.5.h),
        Text(
          content['description'] ?? 'No description available',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isDarkMode
                    ? AppTheme.textMediumEmphasisDark
                    : AppTheme.textMediumEmphasisLight,
                fontSize: 11.sp,
              ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            _buildStatusChip(context, content['status'] ?? 'draft'),
            SizedBox(width: 2.w),
            Expanded(
              child: Text(
                '${content['views'] ?? 0} views',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: isDarkMode
                          ? AppTheme.textDisabledDark
                          : AppTheme.textDisabledLight,
                      fontSize: 10.sp,
                    ),
              ),
            ),
          ],
        ),
        SizedBox(height: 0.5.h),
        Text(
          'Uploaded ${content['uploadDate'] ?? 'Unknown'}',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: isDarkMode
                    ? AppTheme.textDisabledDark
                    : AppTheme.textDisabledLight,
                fontSize: 9.sp,
              ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(BuildContext context, String status) {
    Color chipColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'published':
        chipColor = AppTheme.successGreen.withValues(alpha: 0.2);
        textColor = AppTheme.successGreen;
        break;
      case 'processing':
        chipColor = AppTheme.warningOrange.withValues(alpha: 0.2);
        textColor = AppTheme.warningOrange;
        break;
      case 'draft':
        chipColor = AppTheme.textSecondary.withValues(alpha: 0.2);
        textColor = AppTheme.textSecondary;
        break;
      default:
        chipColor = AppTheme.errorRed.withValues(alpha: 0.2);
        textColor = AppTheme.errorRed;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 8.sp,
            ),
      ),
    );
  }

  Widget _buildActionMenu(BuildContext context, bool isDarkMode) {
    return PopupMenuButton<String>(
      icon: CustomIconWidget(
        iconName: 'more_vert',
        color: isDarkMode
            ? AppTheme.textMediumEmphasisDark
            : AppTheme.textMediumEmphasisLight,
        size: 20,
      ),
      onSelected: (value) {
        switch (value) {
          case 'edit':
            onEdit?.call();
            break;
          case 'delete':
            onDelete?.call();
            break;
          case 'toggle_visibility':
            onToggleVisibility?.call();
            break;
          case 'analytics':
            onViewAnalytics?.call();
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'edit',
                color: isDarkMode
                    ? AppTheme.textMediumEmphasisDark
                    : AppTheme.textMediumEmphasisLight,
                size: 18,
              ),
              SizedBox(width: 2.w),
              Text('Edit Details'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'toggle_visibility',
          child: Row(
            children: [
              CustomIconWidget(
                iconName: content['isVisible'] == true
                    ? 'visibility_off'
                    : 'visibility',
                color: isDarkMode
                    ? AppTheme.textMediumEmphasisDark
                    : AppTheme.textMediumEmphasisLight,
                size: 18,
              ),
              SizedBox(width: 2.w),
              Text(content['isVisible'] == true ? 'Hide' : 'Show'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'analytics',
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'analytics',
                color: isDarkMode
                    ? AppTheme.textMediumEmphasisDark
                    : AppTheme.textMediumEmphasisLight,
                size: 18,
              ),
              SizedBox(width: 2.w),
              Text('View Analytics'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'delete',
                color: AppTheme.errorRed,
                size: 18,
              ),
              SizedBox(width: 2.w),
              Text(
                'Delete',
                style: TextStyle(color: AppTheme.errorRed),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSwipeBackground(
      BuildContext context, bool isDarkMode, bool isLeftSwipe) {
    return Container(
      alignment: isLeftSwipe ? Alignment.centerLeft : Alignment.centerRight,
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      color: isLeftSwipe ? AppTheme.secondaryBlue : AppTheme.errorRed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: isLeftSwipe ? 'edit' : 'delete',
            color: Colors.white,
            size: 24,
          ),
          SizedBox(height: 0.5.h),
          Text(
            isLeftSwipe ? 'Edit' : 'Delete',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
