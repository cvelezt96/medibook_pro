import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class TimeSlotBottomSheet extends StatefulWidget {
  final DateTime selectedDate;
  final List<Map<String, dynamic>> timeSlots;
  final Function(Map<String, dynamic>) onTimeSlotSelected;

  const TimeSlotBottomSheet({
    Key? key,
    required this.selectedDate,
    required this.timeSlots,
    required this.onTimeSlotSelected,
  }) : super(key: key);

  @override
  State<TimeSlotBottomSheet> createState() => _TimeSlotBottomSheetState();
}

class _TimeSlotBottomSheetState extends State<TimeSlotBottomSheet> {
  Map<String, dynamic>? selectedSlot;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: 3.h),
          // Header
          Text(
            "Available Time Slots",
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            "${_formatDate(widget.selectedDate)}",
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 3.h),
          // Time slots grid
          SizedBox(
            height: 40.h,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildTimeSection("Morning", "09:00 AM - 12:00 PM"),
                  SizedBox(height: 2.h),
                  _buildTimeSection("Afternoon", "02:00 PM - 05:00 PM"),
                  SizedBox(height: 2.h),
                  _buildTimeSection("Evening", "06:00 PM - 08:00 PM"),
                ],
              ),
            ),
          ),
          SizedBox(height: 2.h),
          // Confirm button
          if (selectedSlot != null)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  widget.onTimeSlotSelected(selectedSlot!);
                  Navigator.pop(context);
                },
                child: Text("Confirm Time Slot"),
              ),
            ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildTimeSection(String title, String subtitle) {
    final sectionSlots = widget.timeSlots.where((slot) {
      final time = slot["time"] as String;
      if (title == "Morning") {
        return time.contains("AM") && !time.startsWith("12:");
      } else if (title == "Afternoon") {
        return time.contains("PM") &&
            (time.startsWith("02:") ||
                time.startsWith("03:") ||
                time.startsWith("04:") ||
                time.startsWith("05:"));
      } else {
        return time.contains("PM") &&
            (time.startsWith("06:") ||
                time.startsWith("07:") ||
                time.startsWith("08:"));
      }
    }).toList();

    if (sectionSlots.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          subtitle,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 1.5.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children:
              sectionSlots.map((slot) => _buildTimeSlotChip(slot)).toList(),
        ),
      ],
    );
  }

  Widget _buildTimeSlotChip(Map<String, dynamic> slot) {
    final isSelected = selectedSlot?["id"] == slot["id"];
    final isAvailable = slot["isAvailable"] as bool;

    return GestureDetector(
      onTap: isAvailable
          ? () {
              setState(() {
                selectedSlot = slot;
              });
            }
          : null,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.primary
              : isAvailable
                  ? AppTheme.lightTheme.colorScheme.surface
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                      .withValues(alpha: 0.1),
          border: Border.all(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.primary
                : isAvailable
                    ? AppTheme.lightTheme.colorScheme.outline
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                        .withValues(alpha: 0.3),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          slot["time"] as String,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.onPrimary
                : isAvailable
                    ? AppTheme.lightTheme.colorScheme.onSurface
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                        .withValues(alpha: 0.5),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    const weekdays = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday'
    ];

    return "${weekdays[date.weekday % 7]}, ${months[date.month - 1]} ${date.day}, ${date.year}";
  }
}
