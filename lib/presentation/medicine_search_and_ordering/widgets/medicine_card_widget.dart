import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MedicineCardWidget extends StatelessWidget {
  final Map<String, dynamic> medicine;
  final VoidCallback onAddToCart;
  final VoidCallback onUploadPrescription;
  final VoidCallback onAddToWishlist;
  final VoidCallback onSetReminder;
  final VoidCallback onQuickView;

  const MedicineCardWidget({
    Key? key,
    required this.medicine,
    required this.onAddToCart,
    required this.onUploadPrescription,
    required this.onAddToWishlist,
    required this.onSetReminder,
    required this.onQuickView,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isPrescriptionRequired =
        medicine['prescriptionRequired'] ?? false;
    final bool isAvailable = medicine['isAvailable'] ?? true;
    final String availability = medicine['availability'] ?? 'In Stock';

    return GestureDetector(
      onLongPress: onQuickView,
      child: Dismissible(
        key: Key(medicine['id'].toString()),
        direction: DismissDirection.startToEnd,
        background: Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.secondary
                .withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              SizedBox(width: 6.w),
              CustomIconWidget(
                iconName: 'favorite_border',
                color: AppTheme.lightTheme.colorScheme.secondary,
                size: 6.w,
              ),
              SizedBox(width: 4.w),
              Text(
                'Add to Wishlist',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.secondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              CustomIconWidget(
                iconName: 'alarm',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 6.w,
              ),
              SizedBox(width: 4.w),
              Text(
                'Set Reminder',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 6.w),
            ],
          ),
        ),
        onDismissed: (direction) {
          onAddToWishlist();
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightTheme.colorScheme.shadow,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(3.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Medicine Image
                Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppTheme.lightTheme.colorScheme.surface,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CustomImageWidget(
                      imageUrl: medicine['image'] ?? '',
                      width: 20.w,
                      height: 20.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 3.w),

                // Medicine Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              medicine['name'] ?? '',
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isPrescriptionRequired)
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 0.5.h),
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.colorScheme.error
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Rx',
                                style: AppTheme.lightTheme.textTheme.labelSmall
                                    ?.copyWith(
                                  color: AppTheme.lightTheme.colorScheme.error,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 0.5.h),

                      Text(
                        medicine['dosage'] ?? '',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: 1.h),

                      Row(
                        children: [
                          Text(
                            medicine['price'] ?? '',
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color: isAvailable
                                  ? AppTheme.lightTheme.colorScheme.secondary
                                      .withValues(alpha: 0.1)
                                  : AppTheme.lightTheme.colorScheme.error
                                      .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              availability,
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: isAvailable
                                    ? AppTheme.lightTheme.colorScheme.secondary
                                    : AppTheme.lightTheme.colorScheme.error,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.h),

                      // Pharmacy availability
                      Text(
                        'Available at ${medicine['pharmacyCount'] ?? 0} nearby pharmacies',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: 1.5.h),

                      // Action Buttons
                      Row(
                        children: [
                          if (isPrescriptionRequired)
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: onUploadPrescription,
                                icon: CustomIconWidget(
                                  iconName: 'camera_alt',
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  size: 4.w,
                                ),
                                label: Text(
                                  'Upload Rx',
                                  style:
                                      AppTheme.lightTheme.textTheme.bodySmall,
                                ),
                                style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 2.w, vertical: 1.h),
                                  minimumSize: Size(0, 5.h),
                                ),
                              ),
                            ),
                          if (isPrescriptionRequired) SizedBox(width: 2.w),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: isAvailable ? onAddToCart : null,
                              icon: CustomIconWidget(
                                iconName: 'add_shopping_cart',
                                color:
                                    AppTheme.lightTheme.colorScheme.onPrimary,
                                size: 4.w,
                              ),
                              label: Text(
                                'Add to Cart',
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.onPrimary,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 2.w, vertical: 1.h),
                                minimumSize: Size(0, 5.h),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
