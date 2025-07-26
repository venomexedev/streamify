import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BulkActionsWidget extends StatelessWidget {
  final int selectedCount;
  final VoidCallback? onSelectAll;
  final VoidCallback? onDeselectAll;
  final VoidCallback? onBulkDelete;
  final VoidCallback? onBulkVisibilityToggle;
  final VoidCallback? onBulkCategoryUpdate;
  final VoidCallback? onCancel;

  const BulkActionsWidget({
    Key? key,
    required this.selectedCount,
    this.onSelectAll,
    this.onDeselectAll,
    this.onBulkDelete,
    this.onBulkVisibilityToggle,
    this.onBulkCategoryUpdate,
    this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: selectedCount > 0 ? 12.h : 0,
      child: selectedCount > 0
          ? Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              decoration: BoxDecoration(
                color:
                    isDarkMode ? AppTheme.surfaceDark : AppTheme.surfaceLight,
                boxShadow: [
                  BoxShadow(
                    color:
                        isDarkMode ? AppTheme.shadowDark : AppTheme.shadowLight,
                    blurRadius: 8,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$selectedCount item${selectedCount > 1 ? 's' : ''} selected',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.sp,
                                  ),
                        ),
                        SizedBox(height: 0.5.h),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: onSelectAll,
                              child: Text(
                                'Select All',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(
                                      color: AppTheme.secondaryBlue,
                                      fontSize: 11.sp,
                                    ),
                              ),
                            ),
                            Text(
                              ' • ',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(
                                    color: isDarkMode
                                        ? AppTheme.textDisabledDark
                                        : AppTheme.textDisabledLight,
                                    fontSize: 11.sp,
                                  ),
                            ),
                            GestureDetector(
                              onTap: onDeselectAll,
                              child: Text(
                                'Deselect All',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(
                                      color: AppTheme.secondaryBlue,
                                      fontSize: 11.sp,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      _buildActionButton(
                        context,
                        isDarkMode,
                        icon: 'visibility',
                        onTap: onBulkVisibilityToggle,
                      ),
                      SizedBox(width: 2.w),
                      _buildActionButton(
                        context,
                        isDarkMode,
                        icon: 'category',
                        onTap: onBulkCategoryUpdate,
                      ),
                      SizedBox(width: 2.w),
                      _buildActionButton(
                        context,
                        isDarkMode,
                        icon: 'delete',
                        onTap: onBulkDelete,
                        isDestructive: true,
                      ),
                      SizedBox(width: 2.w),
                      _buildActionButton(
                        context,
                        isDarkMode,
                        icon: 'close',
                        onTap: onCancel,
                      ),
                    ],
                  ),
                ],
              ),
            )
          : SizedBox.shrink(),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    bool isDarkMode, {
    required String icon,
    VoidCallback? onTap,
    bool isDestructive = false,
  }) {
    final color = isDestructive
        ? AppTheme.errorRed
        : (isDarkMode
            ? AppTheme.textMediumEmphasisDark
            : AppTheme.textMediumEmphasisLight);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 10.w,
        height: 10.w,
        decoration: BoxDecoration(
          color: isDestructive
              ? AppTheme.errorRed.withValues(alpha: 0.1)
              : (isDarkMode ? AppTheme.cardDark : AppTheme.cardLight),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDestructive
                ? AppTheme.errorRed.withValues(alpha: 0.3)
                : (isDarkMode ? AppTheme.dividerDark : AppTheme.dividerLight),
            width: 1,
          ),
        ),
        child: Center(
          child: CustomIconWidget(
            iconName: icon,
            color: color,
            size: 20,
          ),
        ),
      ),
    );
  }
}
