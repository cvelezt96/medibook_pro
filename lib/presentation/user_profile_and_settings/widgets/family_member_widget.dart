import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FamilyMemberWidget extends StatelessWidget {
  final List<Map<String, dynamic>> familyMembers;
  final Function(int) onEditMember;
  final VoidCallback onAddMember;

  const FamilyMemberWidget({
    Key? key,
    required this.familyMembers,
    required this.onEditMember,
    required this.onAddMember,
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
                  "Family Members",
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimaryLight,
                  ),
                ),
                TextButton.icon(
                  onPressed: onAddMember,
                  icon: CustomIconWidget(
                    iconName: 'person_add',
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
          if (familyMembers.isEmpty)
            Padding(
              padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 3.h),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  children: [
                    CustomIconWidget(
                      iconName: 'family_restroom',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 8.w,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "No family members added",
                      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textPrimaryLight,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      "Add family members to manage their healthcare needs",
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
              itemCount: familyMembers.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: AppTheme.dividerLight,
                indent: 4.w,
                endIndent: 4.w,
              ),
              itemBuilder: (context, index) {
                final member = familyMembers[index];
                return _buildFamilyMemberItem(context, member, index);
              },
            ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildFamilyMemberItem(
      BuildContext context, Map<String, dynamic> member, int index) {
    return InkWell(
      onTap: () => onEditMember(index),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Row(
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  width: 2,
                ),
              ),
              child: ClipOval(
                child: CustomImageWidget(
                  imageUrl: member["profileImage"] as String,
                  width: 12.w,
                  height: 12.w,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          member["name"] as String,
                          style:
                              AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimaryLight,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (member["age"] != null && (member["age"] as int) < 18)
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.tertiary
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppTheme.lightTheme.colorScheme.tertiary
                                  .withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            "Minor",
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.tertiary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    member["relationship"] as String,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondaryLight,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'cake',
                        color: AppTheme.lightTheme.colorScheme.secondary,
                        size: 3.w,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        "${member["age"]} years old",
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondaryLight,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      if (member["hasInsurance"] == true) ...[
                        CustomIconWidget(
                          iconName: 'verified_user',
                          color: AppTheme.lightTheme.colorScheme.secondary,
                          size: 3.w,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          "Insured",
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.secondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'chevron_right',
              color: AppTheme.textSecondaryLight,
              size: 5.w,
            ),
          ],
        ),
      ),
    );
  }
}
