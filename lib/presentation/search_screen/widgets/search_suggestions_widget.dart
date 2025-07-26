import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SearchSuggestionsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> suggestions;
  final Function(String) onSuggestionTap;

  const SearchSuggestionsWidget({
    Key? key,
    required this.suggestions,
    required this.onSuggestionTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (suggestions.isEmpty) {
      return SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: AppTheme.darkTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.darkTheme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: suggestions.length > 8 ? 8 : suggestions.length,
        separatorBuilder: (context, index) => Divider(
          color: AppTheme.darkTheme.colorScheme.outline.withValues(alpha: 0.1),
          height: 1,
        ),
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          final type = suggestion['type'] as String;
          final title = suggestion['title'] as String;

          IconData iconData;
          switch (type) {
            case 'movie':
              iconData = Icons.movie;
              break;
            case 'show':
              iconData = Icons.tv;
              break;
            case 'actor':
              iconData = Icons.person;
              break;
            case 'genre':
              iconData = Icons.category;
              break;
            default:
              iconData = Icons.search;
          }

          return ListTile(
            leading: CustomIconWidget(
              iconName: iconData.toString().split('.').last,
              color: AppTheme.secondaryBlue,
              size: 20,
            ),
            title: Text(
              title,
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.darkTheme.colorScheme.onSurface,
              ),
            ),
            subtitle: suggestion['subtitle'] != null
                ? Text(
                    suggestion['subtitle'] as String,
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.darkTheme.colorScheme.onSurfaceVariant,
                    ),
                  )
                : null,
            trailing: CustomIconWidget(
              iconName: 'north_west',
              color: AppTheme.darkTheme.colorScheme.onSurfaceVariant,
              size: 16,
            ),
            onTap: () => onSuggestionTap(title),
          );
        },
      ),
    );
  }
}
