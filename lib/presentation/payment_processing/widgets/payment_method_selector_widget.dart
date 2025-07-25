import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class PaymentMethodSelectorWidget extends StatefulWidget {
  final Function(String) onPaymentMethodSelected;
  final String selectedMethod;

  const PaymentMethodSelectorWidget({
    Key? key,
    required this.onPaymentMethodSelected,
    required this.selectedMethod,
  }) : super(key: key);

  @override
  State<PaymentMethodSelectorWidget> createState() =>
      _PaymentMethodSelectorWidgetState();
}

class _PaymentMethodSelectorWidgetState
    extends State<PaymentMethodSelectorWidget> {
  final List<Map<String, dynamic>> paymentMethods = [
    {
      "id": "card",
      "title": "Credit/Debit Card",
      "subtitle": "Visa, Mastercard, American Express",
      "icon": "credit_card",
      "enabled": true,
    },
    {
      "id": "apple_pay",
      "title": "Apple Pay",
      "subtitle": "Touch ID or Face ID",
      "icon": "phone_iphone",
      "enabled": true,
    },
    {
      "id": "google_pay",
      "title": "Google Pay",
      "subtitle": "Quick and secure",
      "icon": "account_balance_wallet",
      "enabled": true,
    },
    {
      "id": "insurance",
      "title": "Insurance Coverage",
      "subtitle": "BlueCross BlueShield - \$25 copay",
      "icon": "local_hospital",
      "enabled": true,
    },
    {
      "id": "hsa",
      "title": "HSA Account",
      "subtitle": "Available balance: \$1,250.00",
      "icon": "savings",
      "enabled": true,
    },
    {
      "id": "fsa",
      "title": "FSA Account",
      "subtitle": "Available balance: \$850.00",
      "icon": "account_balance",
      "enabled": true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'payment',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'Payment Method',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: paymentMethods.length,
            separatorBuilder: (context, index) => SizedBox(height: 2.h),
            itemBuilder: (context, index) {
              final method = paymentMethods[index];
              final isSelected = widget.selectedMethod == method["id"];

              return GestureDetector(
                onTap: method["enabled"] as bool
                    ? () =>
                        widget.onPaymentMethodSelected(method["id"] as String)
                    : null,
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.1)
                        : AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(2.w),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.3),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 12.w,
                        height: 12.w,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.lightTheme.colorScheme.primary
                                  .withValues(alpha: 0.2)
                              : AppTheme.lightTheme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(2.w),
                          border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.2),
                          ),
                        ),
                        child: Center(
                          child: CustomIconWidget(
                            iconName: method["icon"] as String,
                            color: isSelected
                                ? AppTheme.lightTheme.colorScheme.primary
                                : AppTheme.lightTheme.colorScheme.onSurface
                                    .withValues(alpha: 0.7),
                            size: 6.w,
                          ),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              method["title"] as String,
                              style: AppTheme.lightTheme.textTheme.bodyLarge
                                  ?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: method["enabled"] as bool
                                    ? AppTheme.lightTheme.colorScheme.onSurface
                                    : AppTheme.lightTheme.colorScheme.onSurface
                                        .withValues(alpha: 0.5),
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              method["subtitle"] as String,
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: method["enabled"] as bool
                                    ? AppTheme.lightTheme.colorScheme.onSurface
                                        .withValues(alpha: 0.7)
                                    : AppTheme.lightTheme.colorScheme.onSurface
                                        .withValues(alpha: 0.4),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        Container(
                          width: 6.w,
                          height: 6.w,
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: CustomIconWidget(
                              iconName: 'check',
                              color: AppTheme.lightTheme.colorScheme.onPrimary,
                              size: 4.w,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
