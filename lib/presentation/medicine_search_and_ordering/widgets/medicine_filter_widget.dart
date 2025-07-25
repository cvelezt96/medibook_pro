import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class MedicineFilterWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onFiltersChanged;
  final Map<String, dynamic> currentFilters;

  const MedicineFilterWidget({
    Key? key,
    required this.onFiltersChanged,
    required this.currentFilters,
  }) : super(key: key);

  @override
  State<MedicineFilterWidget> createState() => _MedicineFilterWidgetState();
}

class _MedicineFilterWidgetState extends State<MedicineFilterWidget> {
  late Map<String, dynamic> _filters;
  RangeValues _priceRange = const RangeValues(0, 500);

  final List<String> _categories = [
    'Pain Relief',
    'Antibiotics',
    'Vitamins',
    'Cold & Flu',
    'Digestive Health',
    'Heart Health',
    'Diabetes Care',
    'Skin Care',
  ];

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.currentFilters);
    _priceRange = RangeValues(
      (_filters['minPrice'] ?? 0).toDouble(),
      (_filters['maxPrice'] ?? 500).toDouble(),
    );
  }

  void _updateFilters() {
    _filters['minPrice'] = _priceRange.start.round();
    _filters['maxPrice'] = _priceRange.end.round();
    widget.onFiltersChanged(_filters);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filter Medicines',
                style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _filters.clear();
                    _priceRange = const RangeValues(0, 500);
                  });
                  _updateFilters();
                },
                child: Text(
                  'Clear All',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Prescription/OTC Toggle
          Text(
            'Medicine Type',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              Expanded(
                child: FilterChip(
                  label: Text('Prescription'),
                  selected: _filters['type'] == 'prescription',
                  onSelected: (selected) {
                    setState(() {
                      _filters['type'] = selected ? 'prescription' : null;
                    });
                    _updateFilters();
                  },
                  backgroundColor: AppTheme.lightTheme.colorScheme.surface,
                  selectedColor: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.2),
                  checkmarkColor: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: FilterChip(
                  label: Text('Over-the-Counter'),
                  selected: _filters['type'] == 'otc',
                  onSelected: (selected) {
                    setState(() {
                      _filters['type'] = selected ? 'otc' : null;
                    });
                    _updateFilters();
                  },
                  backgroundColor: AppTheme.lightTheme.colorScheme.surface,
                  selectedColor: AppTheme.lightTheme.colorScheme.secondary
                      .withValues(alpha: 0.2),
                  checkmarkColor: AppTheme.lightTheme.colorScheme.secondary,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Categories
          Text(
            'Categories',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: _categories.map((category) {
              final isSelected = (_filters['categories'] as List<String>?)
                      ?.contains(category) ??
                  false;
              return FilterChip(
                label: Text(category),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    final categories =
                        (_filters['categories'] as List<String>?) ?? <String>[];
                    if (selected) {
                      categories.add(category);
                    } else {
                      categories.remove(category);
                    }
                    _filters['categories'] = categories;
                  });
                  _updateFilters();
                },
                backgroundColor: AppTheme.lightTheme.colorScheme.surface,
                selectedColor: AppTheme.lightTheme.colorScheme.tertiary
                    .withValues(alpha: 0.2),
                checkmarkColor: AppTheme.lightTheme.colorScheme.tertiary,
              );
            }).toList(),
          ),
          SizedBox(height: 3.h),

          // Price Range
          Text(
            'Price Range',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          RangeSlider(
            values: _priceRange,
            min: 0,
            max: 500,
            divisions: 50,
            labels: RangeLabels(
              '\$${_priceRange.start.round()}',
              '\$${_priceRange.end.round()}',
            ),
            onChanged: (values) {
              setState(() {
                _priceRange = values;
              });
            },
            onChangeEnd: (values) {
              _updateFilters();
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${_priceRange.start.round()}',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              Text(
                '\$${_priceRange.end.round()}',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
            ],
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }
}
