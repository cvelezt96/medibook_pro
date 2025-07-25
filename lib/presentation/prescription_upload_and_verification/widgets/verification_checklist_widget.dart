import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VerificationChecklistWidget extends StatefulWidget {
  final Map<String, dynamic> extractedData;
  final Function(bool) onChecklistComplete;

  const VerificationChecklistWidget({
    Key? key,
    required this.extractedData,
    required this.onChecklistComplete,
  }) : super(key: key);

  @override
  State<VerificationChecklistWidget> createState() =>
      _VerificationChecklistWidgetState();
}

class _VerificationChecklistWidgetState
    extends State<VerificationChecklistWidget> {
  Map<String, bool> _checklistItems = {
    'doctor_signature': false,
    'patient_name_match': false,
    'prescription_date_valid': false,
    'pharmacy_info_clear': false,
    'medicine_names_legible': false,
    'dosage_instructions_clear': false,
  };

  final Map<String, String> _checklistLabels = {
    'doctor_signature': 'Doctor signature is visible and clear',
    'patient_name_match': 'Patient name matches your profile',
    'prescription_date_valid': 'Prescription date is within validity period',
    'pharmacy_info_clear': 'Pharmacy information is clearly visible',
    'medicine_names_legible': 'All medicine names are legible',
    'dosage_instructions_clear': 'Dosage instructions are clear and complete',
  };

  final Map<String, String> _checklistDescriptions = {
    'doctor_signature':
        'Ensure the doctor\'s signature is present and not cut off',
    'patient_name_match':
        'Verify the patient name matches your registered profile',
    'prescription_date_valid':
        'Check that the prescription is not expired (usually valid for 30 days)',
    'pharmacy_info_clear':
        'Pharmacy name and contact details should be readable',
    'medicine_names_legible':
        'All prescribed medicines should be clearly readable',
    'dosage_instructions_clear':
        'Dosage, frequency, and duration should be clear',
  };

  @override
  void initState() {
    super.initState();
    _autoCheckItems();
  }

  void _autoCheckItems() {
    // Auto-check items based on extracted data confidence
    final overallConfidence =
        widget.extractedData['overall_confidence'] as double;

    setState(() {
      if (overallConfidence >= 0.9) {
        _checklistItems['medicine_names_legible'] = true;
        _checklistItems['dosage_instructions_clear'] = true;
      }

      if (widget.extractedData['doctor_name'] != null &&
          (widget.extractedData['doctor_name'] as String).isNotEmpty) {
        _checklistItems['doctor_signature'] = true;
      }

      if (widget.extractedData['patient_name'] != null &&
          (widget.extractedData['patient_name'] as String).isNotEmpty) {
        _checklistItems['patient_name_match'] = true;
      }

      // Check prescription date (mock validation)
      final prescriptionDate =
          DateTime.tryParse(widget.extractedData['prescription_date'] ?? '');
      if (prescriptionDate != null) {
        final daysDifference =
            DateTime.now().difference(prescriptionDate).inDays;
        if (daysDifference <= 30 && daysDifference >= 0) {
          _checklistItems['prescription_date_valid'] = true;
        }
      }

      if (widget.extractedData['pharmacy_name'] != null &&
          (widget.extractedData['pharmacy_name'] as String).isNotEmpty) {
        _checklistItems['pharmacy_info_clear'] = true;
      }
    });

    _updateChecklistStatus();
  }

  void _toggleChecklistItem(String key, bool? value) {
    setState(() {
      _checklistItems[key] = value ?? false;
    });
    _updateChecklistStatus();
  }

  void _updateChecklistStatus() {
    final allChecked = _checklistItems.values.every((checked) => checked);
    widget.onChecklistComplete(allChecked);
  }

  Widget _buildChecklistItem(String key) {
    final isChecked = _checklistItems[key] ?? false;
    final label = _checklistLabels[key] ?? '';
    final description = _checklistDescriptions[key] ?? '';

    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: isChecked
            ? AppTheme.successLight.withValues(alpha: 0.05)
            : AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isChecked
              ? AppTheme.successLight.withValues(alpha: 0.3)
              : AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Checkbox
          GestureDetector(
            onTap: () => _toggleChecklistItem(key, !isChecked),
            child: Container(
              width: 6.w,
              height: 6.w,
              decoration: BoxDecoration(
                color: isChecked ? AppTheme.successLight : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color:
                      isChecked ? AppTheme.successLight : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: isChecked
                  ? CustomIconWidget(
                      iconName: 'check',
                      color: Colors.white,
                      size: 16,
                    )
                  : null,
            ),
          ),

          SizedBox(width: 4.w),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: isChecked
                        ? AppTheme.successLight
                        : AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  description,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final checkedCount =
        _checklistItems.values.where((checked) => checked).length;
    final totalCount = _checklistItems.length;
    final progress = checkedCount / totalCount;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Verification Checklist',
                      style:
                          AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Please verify the following items before submission',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: progress == 1.0
                      ? AppTheme.successLight.withValues(alpha: 0.1)
                      : AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$checkedCount/$totalCount',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: progress == 1.0
                        ? AppTheme.successLight
                        : AppTheme.lightTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Progress indicator
          Container(
            width: double.infinity,
            height: 0.8.h,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  color: progress == 1.0
                      ? AppTheme.successLight
                      : AppTheme.lightTheme.primaryColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),

          SizedBox(height: 3.h),

          // Checklist items
          Expanded(
            child: ListView(
              children: _checklistItems.keys
                  .map((key) => _buildChecklistItem(key))
                  .toList(),
            ),
          ),

          // Status message
          if (progress == 1.0)
            Container(
              margin: EdgeInsets.only(top: 2.h),
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.successLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.successLight.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'check_circle',
                    color: AppTheme.successLight,
                    size: 24,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ready for Submission',
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                            color: AppTheme.successLight,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'All verification items have been checked',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.successLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
