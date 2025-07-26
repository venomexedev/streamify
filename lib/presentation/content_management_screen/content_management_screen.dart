import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/bulk_actions_widget.dart';
import './widgets/content_card_widget.dart';
import './widgets/content_edit_modal_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_chips_widget.dart';
import './widgets/upload_bottom_sheet_widget.dart';

class ContentManagementScreen extends StatefulWidget {
  const ContentManagementScreen({Key? key}) : super(key: key);

  @override
  State<ContentManagementScreen> createState() =>
      _ContentManagementScreenState();
}

class _ContentManagementScreenState extends State<ContentManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _sortBy = 'Date Added';
  String _selectedStatus = 'all';
  String _selectedGenre = 'all';
  String _selectedDateRange = 'all';
  bool _isMultiSelectMode = false;
  Set<int> _selectedItems = {};
  bool _showFilters = false;

  final List<String> _sortOptions = [
    'Date Added',
    'Title',
    'Views',
    'Status',
  ];

  // Mock content data
  final List<Map<String, dynamic>> _allContent = [
    {
      "id": 1,
      "title": "Epic Action Adventure",
      "description":
          "An thrilling action-packed adventure that takes viewers on a journey through stunning landscapes and heart-pounding sequences.",
      "thumbnail":
          "https://images.pexels.com/photos/7991579/pexels-photo-7991579.jpeg",
      "duration": "2:45:30",
      "status": "published",
      "views": 15420,
      "uploadDate": "2 days ago",
      "genre": "action",
      "tags": ["action", "adventure", "thriller"],
      "isVisible": true,
      "progress": 100,
    },
    {
      "id": 2,
      "title": "Comedy Night Special",
      "description":
          "A hilarious comedy special featuring the best stand-up comedians delivering non-stop laughs and entertainment.",
      "thumbnail":
          "https://images.pexels.com/photos/3945313/pexels-photo-3945313.jpeg",
      "duration": "1:30:15",
      "status": "processing",
      "views": 0,
      "uploadDate": "1 hour ago",
      "genre": "comedy",
      "tags": ["comedy", "entertainment", "stand-up"],
      "isVisible": false,
      "progress": 65,
    },
    {
      "id": 3,
      "title": "Dramatic Love Story",
      "description":
          "A touching romantic drama that explores the complexities of love, relationships, and human emotions in modern times.",
      "thumbnail":
          "https://images.pexels.com/photos/1117132/pexels-photo-1117132.jpeg",
      "duration": "2:10:45",
      "status": "draft",
      "views": 0,
      "uploadDate": "5 days ago",
      "genre": "drama",
      "tags": ["drama", "romance", "emotional"],
      "isVisible": false,
      "progress": 0,
    },
    {
      "id": 4,
      "title": "Horror Night Terror",
      "description":
          "A spine-chilling horror experience that will keep you on the edge of your seat with supernatural thrills and scares.",
      "thumbnail":
          "https://images.pexels.com/photos/2873486/pexels-photo-2873486.jpeg",
      "duration": "1:55:20",
      "status": "published",
      "views": 8750,
      "uploadDate": "1 week ago",
      "genre": "horror",
      "tags": ["horror", "supernatural", "thriller"],
      "isVisible": true,
      "progress": 100,
    },
    {
      "id": 5,
      "title": "Sci-Fi Future World",
      "description":
          "An innovative science fiction adventure set in a futuristic world with advanced technology and alien encounters.",
      "thumbnail":
          "https://images.pixabay.com/photo/2016/11/29/13/14/attractive-1869761_1280.jpg",
      "duration": "2:25:10",
      "status": "published",
      "views": 12300,
      "uploadDate": "3 days ago",
      "genre": "sci-fi",
      "tags": ["sci-fi", "future", "technology"],
      "isVisible": true,
      "progress": 100,
    },
  ];

  List<Map<String, dynamic>> get _filteredContent {
    List<Map<String, dynamic>> filtered = List.from(_allContent);

    // Filter by search query
    if (_searchController.text.isNotEmpty) {
      filtered = filtered.where((content) {
        final title = (content['title'] as String).toLowerCase();
        final description = (content['description'] as String).toLowerCase();
        final query = _searchController.text.toLowerCase();
        return title.contains(query) || description.contains(query);
      }).toList();
    }

    // Filter by status
    if (_selectedStatus != 'all') {
      filtered = filtered
          .where((content) => (content['status'] as String) == _selectedStatus)
          .toList();
    }

    // Filter by genre
    if (_selectedGenre != 'all') {
      filtered = filtered
          .where((content) => (content['genre'] as String) == _selectedGenre)
          .toList();
    }

    // Sort content
    switch (_sortBy) {
      case 'Title':
        filtered.sort(
            (a, b) => (a['title'] as String).compareTo(b['title'] as String));
        break;
      case 'Views':
        filtered
            .sort((a, b) => (b['views'] as int).compareTo(a['views'] as int));
        break;
      case 'Status':
        filtered.sort(
            (a, b) => (a['status'] as String).compareTo(b['status'] as String));
        break;
      case 'Date Added':
      default:
        // Keep original order for date added
        break;
    }

    return filtered;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final filteredContent = _filteredContent;

    return Scaffold(
      appBar: _buildAppBar(context, isDarkMode),
      body: Column(
        children: [
          _buildSearchAndSort(context, isDarkMode),
          if (_showFilters) _buildFilters(),
          Expanded(
            child: filteredContent.isEmpty
                ? EmptyStateWidget(onAddContent: _showUploadBottomSheet)
                : _buildContentList(filteredContent),
          ),
          BulkActionsWidget(
            selectedCount: _selectedItems.length,
            onSelectAll: _selectAllItems,
            onDeselectAll: _deselectAllItems,
            onBulkDelete: _bulkDelete,
            onBulkVisibilityToggle: _bulkVisibilityToggle,
            onBulkCategoryUpdate: _bulkCategoryUpdate,
            onCancel: _exitMultiSelectMode,
          ),
        ],
      ),
      floatingActionButton: _selectedItems.isEmpty
          ? FloatingActionButton(
              onPressed: _showUploadBottomSheet,
              child: CustomIconWidget(
                iconName: 'add',
                color: Colors.white,
                size: 24,
              ),
            )
          : null,
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isDarkMode) {
    return AppBar(
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: AppTheme.textPrimary,
          size: 24,
        ),
      ),
      title: Text(
        _isMultiSelectMode
            ? '${_selectedItems.length} Selected'
            : 'Content Management',
        style: Theme.of(context).appBarTheme.titleTextStyle,
      ),
      actions: [
        if (_isMultiSelectMode)
          IconButton(
            onPressed: _exitMultiSelectMode,
            icon: CustomIconWidget(
              iconName: 'close',
              color: AppTheme.textPrimary,
              size: 24,
            ),
          )
        else ...[
          IconButton(
            onPressed: () {
              setState(() {
                _showFilters = !_showFilters;
              });
            },
            icon: CustomIconWidget(
              iconName: _showFilters ? 'filter_list_off' : 'filter_list',
              color: AppTheme.textPrimary,
              size: 24,
            ),
          ),
          IconButton(
            onPressed: _enterMultiSelectMode,
            icon: CustomIconWidget(
              iconName: 'checklist',
              color: AppTheme.textPrimary,
              size: 24,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSearchAndSort(BuildContext context, bool isDarkMode) {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search content...',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'search',
                    color: AppTheme.textSecondary,
                    size: 20,
                  ),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                        icon: CustomIconWidget(
                          iconName: 'clear',
                          color: AppTheme.textSecondary,
                          size: 20,
                        ),
                      )
                    : null,
              ),
              onChanged: (value) => setState(() {}),
            ),
          ),
          SizedBox(width: 3.w),
          PopupMenuButton<String>(
            initialValue: _sortBy,
            onSelected: (value) {
              setState(() {
                _sortBy = value;
              });
            },
            child: Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                border: Border.all(
                  color:
                      isDarkMode ? AppTheme.dividerDark : AppTheme.dividerLight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'sort',
                    color: isDarkMode
                        ? AppTheme.textMediumEmphasisDark
                        : AppTheme.textMediumEmphasisLight,
                    size: 20,
                  ),
                  SizedBox(width: 1.w),
                  CustomIconWidget(
                    iconName: 'arrow_drop_down',
                    color: isDarkMode
                        ? AppTheme.textMediumEmphasisDark
                        : AppTheme.textMediumEmphasisLight,
                    size: 20,
                  ),
                ],
              ),
            ),
            itemBuilder: (context) => _sortOptions.map((option) {
              return PopupMenuItem(
                value: option,
                child: Text(option),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return FilterChipsWidget(
      selectedStatus: _selectedStatus,
      selectedGenre: _selectedGenre,
      selectedDateRange: _selectedDateRange,
      onStatusChanged: (status) {
        setState(() {
          _selectedStatus = status;
        });
      },
      onGenreChanged: (genre) {
        setState(() {
          _selectedGenre = genre;
        });
      },
      onDateRangeChanged: (dateRange) {
        setState(() {
          _selectedDateRange = dateRange;
        });
      },
    );
  }

  Widget _buildContentList(List<Map<String, dynamic>> content) {
    return ListView.builder(
      padding: EdgeInsets.only(bottom: 10.h),
      itemCount: content.length,
      itemBuilder: (context, index) {
        final item = content[index];
        final isSelected = _selectedItems.contains(item['id']);

        return GestureDetector(
          onLongPress: () {
            if (!_isMultiSelectMode) {
              _enterMultiSelectMode();
            }
            _toggleItemSelection(item['id'] as int);
          },
          child: Stack(
            children: [
              ContentCardWidget(
                content: item,
                onTap: _isMultiSelectMode
                    ? () => _toggleItemSelection(item['id'] as int)
                    : () => _viewContent(item),
                onEdit: () => _editContent(item),
                onDelete: () => _deleteContent(item['id'] as int),
                onToggleVisibility: () => _toggleVisibility(item['id'] as int),
                onViewAnalytics: () => _viewAnalytics(item),
              ),
              if (_isMultiSelectMode)
                Positioned(
                  top: 2.h,
                  right: 6.w,
                  child: Container(
                    width: 6.w,
                    height: 6.w,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.secondaryBlue
                          : Colors.transparent,
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.secondaryBlue
                            : AppTheme.textSecondary,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(3.w),
                    ),
                    child: isSelected
                        ? Center(
                            child: CustomIconWidget(
                              iconName: 'check',
                              color: Colors.white,
                              size: 16,
                            ),
                          )
                        : null,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _showUploadBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => UploadBottomSheetWidget(
        onRecordVideo: _recordVideo,
        onChooseFromGallery: _chooseFromGallery,
        onImportFromUrl: _importFromUrl,
      ),
    );
  }

  void _recordVideo() {
    // Implement video recording functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content:
              Text('Recording video functionality would be implemented here')),
    );
  }

  void _chooseFromGallery() {
    // Implement gallery selection functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              'Gallery selection functionality would be implemented here')),
    );
  }

  void _importFromUrl() {
    // Implement URL import functionality
    _showUrlImportDialog();
  }

  void _showUrlImportDialog() {
    final TextEditingController urlController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Import from URL'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Enter the URL of the video you want to import:'),
            SizedBox(height: 2.h),
            TextFormField(
              controller: urlController,
              decoration: InputDecoration(
                hintText: 'https://example.com/video.mp4',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'link',
                    color: AppTheme.textSecondary,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(
                        'Importing video from URL: ${urlController.text}')),
              );
            },
            child: Text('Import'),
          ),
        ],
      ),
    );
  }

  void _editContent(Map<String, dynamic> content) {
    showDialog(
      context: context,
      builder: (context) => ContentEditModalWidget(
        content: content,
        onSave: (updatedContent) {
          final index = _allContent
              .indexWhere((item) => item['id'] == updatedContent['id']);
          if (index != -1) {
            setState(() {
              _allContent[index] = updatedContent;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Content updated successfully')),
            );
          }
        },
      ),
    );
  }

  void _deleteContent(int contentId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Content'),
        content: Text(
            'Are you sure you want to delete this content? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _allContent.removeWhere((item) => item['id'] == contentId);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Content deleted successfully')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.errorRed),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _toggleVisibility(int contentId) {
    final index = _allContent.indexWhere((item) => item['id'] == contentId);
    if (index != -1) {
      setState(() {
        _allContent[index]['isVisible'] =
            !(_allContent[index]['isVisible'] as bool);
      });
      final isVisible = _allContent[index]['isVisible'] as bool;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Content ${isVisible ? 'shown' : 'hidden'} successfully')),
      );
    }
  }

  void _viewAnalytics(Map<String, dynamic> content) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content:
              Text('Analytics for "${content['title']}" would be shown here')),
    );
  }

  void _viewContent(Map<String, dynamic> content) {
    Navigator.pushNamed(context, '/video-player-screen');
  }

  void _enterMultiSelectMode() {
    setState(() {
      _isMultiSelectMode = true;
      _selectedItems.clear();
    });
  }

  void _exitMultiSelectMode() {
    setState(() {
      _isMultiSelectMode = false;
      _selectedItems.clear();
    });
  }

  void _toggleItemSelection(int itemId) {
    setState(() {
      if (_selectedItems.contains(itemId)) {
        _selectedItems.remove(itemId);
      } else {
        _selectedItems.add(itemId);
      }
    });
  }

  void _selectAllItems() {
    setState(() {
      _selectedItems =
          _filteredContent.map((item) => item['id'] as int).toSet();
    });
  }

  void _deselectAllItems() {
    setState(() {
      _selectedItems.clear();
    });
  }

  void _bulkDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Selected Content'),
        content: Text(
            'Are you sure you want to delete ${_selectedItems.length} selected items? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _allContent
                    .removeWhere((item) => _selectedItems.contains(item['id']));
                _selectedItems.clear();
                _isMultiSelectMode = false;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Selected content deleted successfully')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.errorRed),
            child: Text('Delete All'),
          ),
        ],
      ),
    );
  }

  void _bulkVisibilityToggle() {
    setState(() {
      for (int id in _selectedItems) {
        final index = _allContent.indexWhere((item) => item['id'] == id);
        if (index != -1) {
          _allContent[index]['isVisible'] =
              !(_allContent[index]['isVisible'] as bool);
        }
      }
      _selectedItems.clear();
      _isMultiSelectMode = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Visibility updated for selected content')),
    );
  }

  void _bulkCategoryUpdate() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              'Bulk category update functionality would be implemented here')),
    );
  }
}
