import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DashboardMetricsCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final String iconName;
  final Color iconColor;
  final double? percentage;
  final bool isPositive;

  const DashboardMetricsCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.iconName,
    required this.iconColor,
    this.percentage,
    this.isPositive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.darkTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.darkTheme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textMediumEmphasisDark,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: iconName,
                  color: iconColor,
                  size: 5.w,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            value,
            style: AppTheme.darkTheme.textTheme.headlineMedium?.copyWith(
              color: AppTheme.textHighEmphasisDark,
              fontWeight: FontWeight.w700,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              if (percentage != null) ...[
                CustomIconWidget(
                  iconName: isPositive ? 'trending_up' : 'trending_down',
                  color: isPositive ? AppTheme.successGreen : AppTheme.errorRed,
                  size: 4.w,
                ),
                SizedBox(width: 1.w),
                Text(
                  '${percentage!.toStringAsFixed(1)}%',
                  style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                    color:
                        isPositive ? AppTheme.successGreen : AppTheme.errorRed,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 2.w),
              ],
              Expanded(
                child: Text(
                  subtitle,
                  style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textMediumEmphasisDark,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
