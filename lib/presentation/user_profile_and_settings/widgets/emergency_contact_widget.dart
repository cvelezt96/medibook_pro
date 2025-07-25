import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmergencyContactWidget extends StatelessWidget {
  final List<Map<String, dynamic>> emergencyContacts;
  final Function(int) onEditContact;
  final VoidCallback onAddContact;

  const EmergencyContactWidget({
    Key? key,
    required this.emergencyContacts,
    required this.onEditContact,
    required this.onAddContact,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 3.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(4.w, 3.h, 4.w, 2.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Emergency Contacts",
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimaryLight,
                  ),
                ),
                TextButton.icon(
                  onPressed: onAddContact,
                  icon: CustomIconWidget(
                    iconName: 'add',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 4.w,
                  ),
                  label: Text(
                    "Add",
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (emergencyContacts.isEmpty)
            Padding(
              padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 3.h),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.secondary
                      .withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.secondary
                        .withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  children: [
                    CustomIconWidget(
                      iconName: 'contact_emergency',
                      color: AppTheme.lightTheme.colorScheme.secondary,
                      size: 8.w,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "No emergency contacts added",
                      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textPrimaryLight,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      "Add emergency contacts for quick access during medical emergencies",
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondaryLight,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: emergencyContacts.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: AppTheme.dividerLight,
                indent: 4.w,
                endIndent: 4.w,
              ),
              itemBuilder: (context, index) {
                final contact = emergencyContacts[index];
                return _buildContactItem(context, contact, index);
              },
            ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildContactItem(
      BuildContext context, Map<String, dynamic> contact, int index) {
    return InkWell(
      onTap: () => onEditContact(index),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Row(
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.error
                    .withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: contact["relationship"] == "Family"
                      ? 'family_restroom'
                      : 'person',
                  color: AppTheme.lightTheme.colorScheme.error,
                  size: 6.w,
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact["name"] as String,
                    style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimaryLight,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    contact["relationship"] as String,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondaryLight,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'phone',
                        color: AppTheme.lightTheme.colorScheme.secondary,
                        size: 3.w,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        contact["phone"] as String,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: contact["isPrimary"] == true
                    ? AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: contact["isPrimary"] == true
                    ? Border.all(
                        color: AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.3))
                    : null,
              ),
              child: Text(
                contact["isPrimary"] == true ? "Primary" : "Secondary",
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: contact["isPrimary"] == true
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.textSecondaryLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
