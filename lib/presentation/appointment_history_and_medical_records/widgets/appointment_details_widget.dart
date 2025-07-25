import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './medical_document_widget.dart';

class AppointmentDetailsWidget extends StatelessWidget {
  final Map<String, dynamic> appointment;
  final VoidCallback? onClose;

  const AppointmentDetailsWidget({
    Key? key,
    required this.appointment,
    this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String doctorName = appointment['doctorName'] as String;
    final String specialization = appointment['specialization'] as String;
    final DateTime appointmentDate = appointment['date'] as DateTime;
    final String visitType = appointment['visitType'] as String;
    final String diagnosis =
        appointment['diagnosis'] as String? ?? 'No diagnosis recorded';
    final List<dynamic> medications = appointment['medications'] as List? ?? [];
    final String followUpInstructions =
        appointment['followUpInstructions'] as String? ??
            'No follow-up instructions';
    final List<dynamic> documents = appointment['documents'] as List? ?? [];

    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Container(
                  width: 12.w,
                  height: 0.5.h,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.outline,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Appointment Details',
                            style: AppTheme.lightTheme.textTheme.headlineSmall
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            '${appointmentDate.day}/${appointmentDate.month}/${appointmentDate.year} at ${appointmentDate.hour.toString().padLeft(2, '0')}:${appointmentDate.minute.toString().padLeft(2, '0')}',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: onClose,
                      icon: CustomIconWidget(
                        iconName: 'close',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 6.w,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Doctor Information
                  _buildSection(
                    title: 'Doctor Information',
                    icon: 'person',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doctorName,
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          specialization,
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          'Visit Type: $visitType',
                          style: AppTheme.lightTheme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Diagnosis
                  _buildSection(
                    title: 'Diagnosis & Notes',
                    icon: 'medical_services',
                    child: Text(
                      diagnosis,
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Medications
                  if (medications.isNotEmpty) ...[
                    _buildSection(
                      title: 'Prescribed Medications',
                      icon: 'medication',
                      child: Column(
                        children: medications.map<Widget>((medication) {
                          final Map<String, dynamic> med =
                              medication as Map<String, dynamic>;
                          return Container(
                            margin: EdgeInsets.only(bottom: 1.h),
                            padding: EdgeInsets.all(3.w),
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.colorScheme.secondary
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppTheme.lightTheme.colorScheme.secondary
                                    .withValues(alpha: 0.3),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  med['name'] as String,
                                  style: AppTheme
                                      .lightTheme.textTheme.titleSmall
                                      ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 0.5.h),
                                Text(
                                  'Dosage: ${med['dosage']} | Duration: ${med['duration']}',
                                  style:
                                      AppTheme.lightTheme.textTheme.bodySmall,
                                ),
                                if (med['instructions'] != null) ...[
                                  SizedBox(height: 0.5.h),
                                  Text(
                                    'Instructions: ${med['instructions']}',
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                      color: AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 3.h),
                  ],

                  // Follow-up Instructions
                  _buildSection(
                    title: 'Follow-up Instructions',
                    icon: 'schedule',
                    child: Text(
                      followUpInstructions,
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Documents
                  if (documents.isNotEmpty) ...[
                    _buildSection(
                      title: 'Attached Documents',
                      icon: 'attach_file',
                      child: Column(
                        children: documents.map<Widget>((document) {
                          return MedicalDocumentWidget(
                            document: document as Map<String, dynamic>,
                            onView: () => _viewDocument(context, document),
                            onShare: () => _shareDocument(context, document),
                            onDownload: () =>
                                _downloadDocument(context, document),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String icon,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 5.w,
            ),
            SizedBox(width: 2.w),
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: child,
        ),
      ],
    );
  }

  void _viewDocument(BuildContext context, Map<String, dynamic> document) {
    // Implement document viewing functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening ${document['fileName']}...'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _shareDocument(BuildContext context, Map<String, dynamic> document) {
    // Implement secure document sharing
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Share Document'),
        content: Text(
            'Share ${document['fileName']} securely with healthcare providers?'),
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
                  content: Text('Document shared securely'),
                  backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
                ),
              );
            },
            child: Text('Share'),
          ),
        ],
      ),
    );
  }

  void _downloadDocument(BuildContext context, Map<String, dynamic> document) {
    // Implement document download functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Downloading ${document['fileName']}...'),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
      ),
    );
  }
}
