import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MedicalDocumentWidget extends StatelessWidget {
  final Map<String, dynamic> document;
  final VoidCallback? onView;
  final VoidCallback? onShare;
  final VoidCallback? onDownload;

  const MedicalDocumentWidget({
    Key? key,
    required this.document,
    this.onView,
    this.onShare,
    this.onDownload,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String fileName = document['fileName'] as String;
    final String fileType = document['fileType'] as String;
    final DateTime uploadDate = document['uploadDate'] as DateTime;
    final double fileSize = document['fileSize'] as double;
    final bool isSecure = document['isSecure'] as bool? ?? true;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          // File type icon
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: _getFileTypeColor(fileType).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: _getFileTypeIcon(fileType),
              color: _getFileTypeColor(fileType),
              size: 6.w,
            ),
          ),

          SizedBox(width: 3.w),

          // File info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        fileName,
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isSecure) ...[
                      SizedBox(width: 2.w),
                      CustomIconWidget(
                        iconName: 'lock',
                        color: AppTheme.lightTheme.colorScheme.secondary,
                        size: 4.w,
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 0.5.h),
                Text(
                  '${fileType.toUpperCase()} • ${_formatFileSize(fileSize)}',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'Uploaded ${uploadDate.day}/${uploadDate.month}/${uploadDate.year}',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          // Action buttons
          PopupMenuButton<String>(
            icon: CustomIconWidget(
              iconName: 'more_vert',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 5.w,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'view',
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'visibility',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 5.w,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      'View Document',
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'download',
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'download',
                      color: AppTheme.lightTheme.colorScheme.secondary,
                      size: 5.w,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      'Download',
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'share',
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                      size: 5.w,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      'Share Securely',
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              switch (value) {
                case 'view':
                  onView?.call();
                  break;
                case 'download':
                  onDownload?.call();
                  break;
                case 'share':
                  onShare?.call();
                  break;
              }
            },
          ),
        ],
      ),
    );
  }

  String _getFileTypeIcon(String fileType) {
    switch (fileType.toLowerCase()) {
      case 'pdf':
        return 'picture_as_pdf';
      case 'jpg':
      case 'jpeg':
      case 'png':
        return 'image';
      case 'doc':
      case 'docx':
        return 'description';
      default:
        return 'insert_drive_file';
    }
  }

  Color _getFileTypeColor(String fileType) {
    switch (fileType.toLowerCase()) {
      case 'pdf':
        return AppTheme.errorLight;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'doc':
      case 'docx':
        return AppTheme.lightTheme.colorScheme.primary;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  String _formatFileSize(double bytes) {
    if (bytes < 1024) return '${bytes.toInt()} B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
