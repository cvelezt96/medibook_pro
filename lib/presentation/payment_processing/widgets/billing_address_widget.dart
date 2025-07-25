import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class BillingAddressWidget extends StatefulWidget {
  final Function(Map<String, String>) onAddressChanged;
  final bool isVisible;

  const BillingAddressWidget({
    Key? key,
    required this.onAddressChanged,
    required this.isVisible,
  }) : super(key: key);

  @override
  State<BillingAddressWidget> createState() => _BillingAddressWidgetState();
}

class _BillingAddressWidgetState extends State<BillingAddressWidget> {
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  bool _useProfileAddress = true;

  @override
  void initState() {
    super.initState();
    _loadProfileAddress();
    _streetController.addListener(_onAddressChanged);
    _cityController.addListener(_onAddressChanged);
    _stateController.addListener(_onAddressChanged);
    _zipController.addListener(_onAddressChanged);
    _countryController.addListener(_onAddressChanged);
  }

  @override
  void dispose() {
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  void _loadProfileAddress() {
    // Auto-fill from user profile
    _streetController.text = '123 Healthcare Ave, Suite 100';
    _cityController.text = 'San Francisco';
    _stateController.text = 'CA';
    _zipController.text = '94102';
    _countryController.text = 'United States';
    _onAddressChanged();
  }

  void _onAddressChanged() {
    widget.onAddressChanged({
      'street': _streetController.text,
      'city': _cityController.text,
      'state': _stateController.text,
      'zip': _zipController.text,
      'country': _countryController.text,
      'useProfileAddress': _useProfileAddress.toString(),
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible) return const SizedBox.shrink();

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
                iconName: 'location_on',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  'Billing Address',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(2.w),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Checkbox(
                  value: _useProfileAddress,
                  onChanged: (value) {
                    setState(() {
                      _useProfileAddress = value ?? true;
                      if (_useProfileAddress) {
                        _loadProfileAddress();
                      }
                    });
                    _onAddressChanged();
                  },
                  activeColor: AppTheme.lightTheme.colorScheme.primary,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Use profile address',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        'Same as your account billing address',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 3.h),
          TextFormField(
            controller: _streetController,
            enabled: !_useProfileAddress,
            decoration: InputDecoration(
              labelText: 'Street Address',
              hintText: '123 Main Street, Suite 100',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'home',
                  color: _useProfileAddress
                      ? AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.3)
                      : AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.7),
                  size: 5.w,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2.w),
                borderSide: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2.w),
                borderSide: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  width: 2,
                ),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: _cityController,
                  enabled: !_useProfileAddress,
                  decoration: InputDecoration(
                    labelText: 'City',
                    hintText: 'San Francisco',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: CustomIconWidget(
                        iconName: 'location_city',
                        color: _useProfileAddress
                            ? AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.3)
                            : AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.7),
                        size: 5.w,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2.w),
                      borderSide: BorderSide(
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2.w),
                      borderSide: BorderSide(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: TextFormField(
                  controller: _stateController,
                  enabled: !_useProfileAddress,
                  decoration: InputDecoration(
                    labelText: 'State',
                    hintText: 'CA',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2.w),
                      borderSide: BorderSide(
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2.w),
                      borderSide: BorderSide(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _zipController,
                  enabled: !_useProfileAddress,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'ZIP Code',
                    hintText: '94102',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: CustomIconWidget(
                        iconName: 'markunread_mailbox',
                        color: _useProfileAddress
                            ? AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.3)
                            : AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.7),
                        size: 5.w,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2.w),
                      borderSide: BorderSide(
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2.w),
                      borderSide: BorderSide(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: _countryController,
                  enabled: !_useProfileAddress,
                  decoration: InputDecoration(
                    labelText: 'Country',
                    hintText: 'United States',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: CustomIconWidget(
                        iconName: 'public',
                        color: _useProfileAddress
                            ? AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.3)
                            : AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.7),
                        size: 5.w,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2.w),
                      borderSide: BorderSide(
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2.w),
                      borderSide: BorderSide(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
