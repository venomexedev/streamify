import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ContentEditModalWidget extends StatefulWidget {
  final Map<String, dynamic> content;
  final Function(Map<String, dynamic>) onSave;

  const ContentEditModalWidget({
    Key? key,
    required this.content,
    required this.onSave,
  }) : super(key: key);

  @override
  State<ContentEditModalWidget> createState() => _ContentEditModalWidgetState();
}

class _ContentEditModalWidgetState extends State<ContentEditModalWidget> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _tagsController;
  String _selectedGenre = 'Action';
  bool _isVisible = true;
  String _selectedThumbnail = '';

  final List<String> _genres = [
    'Action',
    'Comedy',
    'Drama',
    'Horror',
    'Romance',
    'Sci-Fi',
    'Thriller',
    'Documentary',
    'Animation',
    'Adventure'
  ];

  final List<String> _thumbnailOptions = [
    'https://images.pexels.com/photos/7991579/pexels-photo-7991579.jpeg',
    'https://images.pexels.com/photos/3945313/pexels-photo-3945313.jpeg',
    'https://images.pexels.com/photos/1117132/pexels-photo-1117132.jpeg',
    'https://images.pexels.com/photos/2873486/pexels-photo-2873486.jpeg',
  ];

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.content['title'] ?? '');
    _descriptionController =
        TextEditingController(text: widget.content['description'] ?? '');
    _tagsController = TextEditingController(
        text: (widget.content['tags'] as List?)?.join(', ') ?? '');
    _selectedGenre = widget.content['genre'] ?? 'Action';
    _isVisible = widget.content['isVisible'] ?? true;
    _selectedThumbnail = widget.content['thumbnail'] ?? _thumbnailOptions.first;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      insetPadding: EdgeInsets.all(4.w),
      child: Container(
        constraints: BoxConstraints(maxHeight: 85.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context, isDarkMode),
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitleField(context),
                    SizedBox(height: 3.h),
                    _buildDescriptionField(context),
                    SizedBox(height: 3.h),
                    _buildGenreDropdown(context, isDarkMode),
                    SizedBox(height: 3.h),
                    _buildTagsField(context),
                    SizedBox(height: 3.h),
                    _buildThumbnailSelection(context, isDarkMode),
                    SizedBox(height: 3.h),
                    _buildVisibilityToggle(context, isDarkMode),
                  ],
                ),
              ),
            ),
            _buildActionButtons(context, isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDarkMode) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: isDarkMode ? AppTheme.surfaceDark : AppTheme.surfaceLight,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Edit Content',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 18.sp,
                  ),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: CustomIconWidget(
              iconName: 'close',
              color: isDarkMode
                  ? AppTheme.textMediumEmphasisDark
                  : AppTheme.textMediumEmphasisLight,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Title',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
              ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: _titleController,
          decoration: InputDecoration(
            hintText: 'Enter video title',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'title',
                color: AppTheme.textSecondary,
                size: 20,
              ),
            ),
          ),
          maxLines: 1,
        ),
      ],
    );
  }

  Widget _buildDescriptionField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
              ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: _descriptionController,
          decoration: InputDecoration(
            hintText: 'Enter video description',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'description',
                color: AppTheme.textSecondary,
                size: 20,
              ),
            ),
          ),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildGenreDropdown(BuildContext context, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Genre',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
              ),
        ),
        SizedBox(height: 1.h),
        DropdownButtonFormField<String>(
          value: _selectedGenre,
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'category',
                color: AppTheme.textSecondary,
                size: 20,
              ),
            ),
          ),
          items: _genres.map((genre) {
            return DropdownMenuItem(
              value: genre,
              child: Text(genre),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedGenre = value ?? 'Action';
            });
          },
        ),
      ],
    );
  }

  Widget _buildTagsField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tags',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
              ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: _tagsController,
          decoration: InputDecoration(
            hintText: 'Enter tags separated by commas',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'local_offer',
                color: AppTheme.textSecondary,
                size: 20,
              ),
            ),
          ),
          maxLines: 1,
        ),
      ],
    );
  }

  Widget _buildThumbnailSelection(BuildContext context, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Thumbnail',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
              ),
        ),
        SizedBox(height: 1.h),
        SizedBox(
          height: 15.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _thumbnailOptions.length,
            itemBuilder: (context, index) {
              final thumbnail = _thumbnailOptions[index];
              final isSelected = thumbnail == _selectedThumbnail;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedThumbnail = thumbnail;
                  });
                },
                child: Container(
                  width: 25.w,
                  margin: EdgeInsets.only(right: 2.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.secondaryBlue
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: CustomImageWidget(
                      imageUrl: thumbnail,
                      width: 25.w,
                      height: 15.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildVisibilityToggle(BuildContext context, bool isDarkMode) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Visibility',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                    ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                _isVisible
                    ? 'Content is visible to users'
                    : 'Content is hidden from users',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isDarkMode
                          ? AppTheme.textMediumEmphasisDark
                          : AppTheme.textMediumEmphasisLight,
                      fontSize: 11.sp,
                    ),
              ),
            ],
          ),
        ),
        Switch(
          value: _isVisible,
          onChanged: (value) {
            setState(() {
              _isVisible = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isDarkMode) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: isDarkMode ? AppTheme.surfaceDark : AppTheme.surfaceLight,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: ElevatedButton(
              onPressed: _saveChanges,
              child: Text('Save Changes'),
            ),
          ),
        ],
      ),
    );
  }

  void _saveChanges() {
    final updatedContent = Map<String, dynamic>.from(widget.content);
    updatedContent['title'] = _titleController.text;
    updatedContent['description'] = _descriptionController.text;
    updatedContent['genre'] = _selectedGenre;
    updatedContent['tags'] =
        _tagsController.text.split(',').map((tag) => tag.trim()).toList();
    updatedContent['thumbnail'] = _selectedThumbnail;
    updatedContent['isVisible'] = _isVisible;

    widget.onSave(updatedContent);
    Navigator.pop(context);
  }
}
