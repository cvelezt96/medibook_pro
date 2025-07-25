import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NotesInputWidget extends StatefulWidget {
  final String notes;
  final Function(String) onNotesChanged;

  const NotesInputWidget({
    Key? key,
    required this.notes,
    required this.onNotesChanged,
  }) : super(key: key);

  @override
  State<NotesInputWidget> createState() => _NotesInputWidgetState();
}

class _NotesInputWidgetState extends State<NotesInputWidget> {
  late TextEditingController _controller;
  final int maxLength = 500;

  final List<String> medicalSuggestions = [
    "Chest pain",
    "Shortness of breath",
    "Headache",
    "Fever",
    "Nausea",
    "Dizziness",
    "Back pain",
    "Joint pain",
    "Fatigue",
    "Cough",
    "Sore throat",
    "Abdominal pain",
  ];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.notes);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Symptoms & Notes",
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            "Describe your symptoms or reason for visit",
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 3.h),
          TextField(
            controller: _controller,
            maxLines: 4,
            maxLength: maxLength,
            onChanged: widget.onNotesChanged,
            decoration: InputDecoration(
              hintText:
                  "Enter your symptoms, concerns, or questions for the doctor...",
              counterText: "${_controller.text.length}/$maxLength",
              counterStyle: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            "Common Symptoms",
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: medicalSuggestions
                .map((suggestion) => _buildSuggestionChip(suggestion))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionChip(String suggestion) {
    final isSelected =
        _controller.text.toLowerCase().contains(suggestion.toLowerCase());

    return GestureDetector(
      onTap: () {
        String currentText = _controller.text;
        if (!currentText.toLowerCase().contains(suggestion.toLowerCase())) {
          String newText =
              currentText.isEmpty ? suggestion : "$currentText, $suggestion";
          if (newText.length <= maxLength) {
            _controller.text = newText;
            widget.onNotesChanged(newText);
            setState(() {});
          }
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
              : AppTheme.lightTheme.colorScheme.surface,
          border: Border.all(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.outline,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              suggestion,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              ),
            ),
            if (!isSelected) ...[
              SizedBox(width: 1.w),
              CustomIconWidget(
                iconName: 'add',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 16,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
