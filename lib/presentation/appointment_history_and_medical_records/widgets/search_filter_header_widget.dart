import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './filter_chip_widget.dart';

class SearchFilterHeaderWidget extends StatefulWidget {
  final Function(String) onSearchChanged;
  final Function(String) onFilterChanged;
  final VoidCallback onDateRangeFilter;
  final VoidCallback onExportRecords;

  const SearchFilterHeaderWidget({
    Key? key,
    required this.onSearchChanged,
    required this.onFilterChanged,
    required this.onDateRangeFilter,
    required this.onExportRecords,
  }) : super(key: key);

  @override
  State<SearchFilterHeaderWidget> createState() =>
      _SearchFilterHeaderWidgetState();
}

class _SearchFilterHeaderWidgetState extends State<SearchFilterHeaderWidget> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';

  final List<Map<String, String>> _filterOptions = [
    {'label': 'All', 'icon': 'all_inclusive'},
    {'label': 'Cardiology', 'icon': 'favorite'},
    {'label': 'Neurology', 'icon': 'psychology'},
    {'label': 'Orthopedics', 'icon': 'accessible'},
    {'label': 'Dermatology', 'icon': 'face'},
    {'label': 'Pediatrics', 'icon': 'child_care'},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Search bar and export button
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: widget.onSearchChanged,
                    decoration: InputDecoration(
                      hintText: 'Search doctors, conditions, medications...',
                      hintStyle:
                          AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(3.w),
                        child: CustomIconWidget(
                          iconName: 'search',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 5.w,
                        ),
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                _searchController.clear();
                                widget.onSearchChanged('');
                              },
                              icon: CustomIconWidget(
                                iconName: 'clear',
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                                size: 5.w,
                              ),
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 2.h,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(width: 3.w),

              // Export button
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: widget.onExportRecords,
                  icon: CustomIconWidget(
                    iconName: 'file_download',
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    size: 6.w,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Filter chips and date range
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 6.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _filterOptions.length,
                    itemBuilder: (context, index) {
                      final filter = _filterOptions[index];
                      return FilterChipWidget(
                        label: filter['label']!,
                        iconName: filter['icon'],
                        isSelected: _selectedFilter == filter['label'],
                        onTap: () {
                          setState(() {
                            _selectedFilter = filter['label']!;
                          });
                          widget.onFilterChanged(filter['label']!);
                        },
                      );
                    },
                  ),
                ),
              ),

              SizedBox(width: 2.w),

              // Date range filter button
              GestureDetector(
                onTap: widget.onDateRangeFilter,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: 'date_range',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 5.w,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        'Date',
                        style:
                            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
