import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/billing_address_widget.dart';
import './widgets/card_input_widget.dart';
import './widgets/insurance_coverage_widget.dart';
import './widgets/payment_method_selector_widget.dart';
import './widgets/security_indicators_widget.dart';
import './widgets/transaction_summary_widget.dart';

class PaymentProcessing extends StatefulWidget {
  const PaymentProcessing({Key? key}) : super(key: key);

  @override
  State<PaymentProcessing> createState() => _PaymentProcessingState();
}

class _PaymentProcessingState extends State<PaymentProcessing> {
  final ScrollController _scrollController = ScrollController();

  String _selectedPaymentMethod = 'card';
  Map<String, String> _cardData = {};
  Map<String, dynamic> _insuranceData = {};
  Map<String, String> _billingAddress = {};

  bool _isProcessing = false;
  bool _showSuccess = false;
  String _transactionId = '';

  // Mock transaction data
  final Map<String, dynamic> transactionData = {
    "type": "appointment", // or "medicine"
    "items": [
      {
        "name": "Dr. Sarah Johnson - Cardiology Consultation",
        "description": "Initial consultation and heart health assessment",
        "price": 250.00,
        "quantity": null,
      },
      {
        "name": "ECG Test",
        "description": "Electrocardiogram screening",
        "price": 75.00,
        "quantity": null,
      },
    ],
    "subtotal": 325.00,
    "tax": 26.00,
    "fees": 4.99,
    "discount": 25.00,
    "total": 330.99,
  };

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onPaymentMethodSelected(String method) {
    setState(() {
      _selectedPaymentMethod = method;
    });
  }

  void _onCardDataChanged(Map<String, String> data) {
    setState(() {
      _cardData = data;
    });
  }

  void _onCoverageVerified(Map<String, dynamic> data) {
    setState(() {
      _insuranceData = data;
    });
  }

  void _onAddressChanged(Map<String, String> data) {
    setState(() {
      _billingAddress = data;
    });
  }

  Future<void> _processPayment() async {
    if (!_validatePaymentData()) {
      _showErrorDialog('Please complete all required payment information.');
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      // Simulate payment processing
      await Future.delayed(const Duration(seconds: 4));

      // Generate transaction ID
      _transactionId = 'TXN${DateTime.now().millisecondsSinceEpoch}';

      setState(() {
        _isProcessing = false;
        _showSuccess = true;
      });

      _showSuccessDialog();
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      _showErrorDialog('Payment processing failed. Please try again.');
    }
  }

  bool _validatePaymentData() {
    switch (_selectedPaymentMethod) {
      case 'card':
        return _cardData['isValid'] == 'true';
      case 'insurance':
        return _insuranceData.isNotEmpty;
      case 'hsa':
      case 'fsa':
        return true; // HSA/FSA validation would be handled by the provider
      case 'apple_pay':
      case 'google_pay':
        return true; // Digital wallet validation handled by platform
      default:
        return false;
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'error',
              color: AppTheme.lightTheme.colorScheme.error,
              size: 6.w,
            ),
            SizedBox(width: 3.w),
            Text(
              'Payment Error',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'OK',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.secondary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'check',
                  color: AppTheme.lightTheme.colorScheme.onSecondary,
                  size: 5.w,
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                'Payment Successful',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.secondary,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your payment has been processed successfully.',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(2.w),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Transaction ID: $_transactionId',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Amount: \$${transactionData["total"].toStringAsFixed(2)}',
                    style: AppTheme.lightTheme.textTheme.bodySmall,
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    'Date: ${DateTime.now().toString().substring(0, 16)}',
                    style: AppTheme.lightTheme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Return to previous screen
            },
            child: Text(
              'Done',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        elevation: 1,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 6.w,
          ),
        ),
        title: Text(
          'Payment Processing',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 4.w),
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.secondary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(2.w),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'security',
                  color: AppTheme.lightTheme.colorScheme.secondary,
                  size: 4.w,
                ),
                SizedBox(width: 1.w),
                Text(
                  'Secure',
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Transaction Summary
                TransactionSummaryWidget(
                  transactionData: transactionData,
                ),
                SizedBox(height: 3.h),

                // Payment Method Selector
                PaymentMethodSelectorWidget(
                  onPaymentMethodSelected: _onPaymentMethodSelected,
                  selectedMethod: _selectedPaymentMethod,
                ),
                SizedBox(height: 3.h),

                // Card Input (visible when card is selected)
                CardInputWidget(
                  onCardDataChanged: _onCardDataChanged,
                  isVisible: _selectedPaymentMethod == 'card',
                ),

                // Insurance Coverage (visible when insurance is selected)
                InsuranceCoverageWidget(
                  isVisible: _selectedPaymentMethod == 'insurance',
                  onCoverageVerified: _onCoverageVerified,
                ),

                // Billing Address (visible for card payments)
                if (_selectedPaymentMethod == 'card') ...[
                  SizedBox(height: 3.h),
                  BillingAddressWidget(
                    onAddressChanged: _onAddressChanged,
                    isVisible: true,
                  ),
                ],

                SizedBox(height: 3.h),

                // Security Indicators
                const SecurityIndicatorsWidget(),

                SizedBox(height: 10.h), // Space for fixed button
              ],
            ),
          ),

          // Fixed Process Payment Button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                border: Border(
                  top: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.2),
                  ),
                ),
              ),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isProcessing ? null : _processPayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                      foregroundColor:
                          AppTheme.lightTheme.colorScheme.onPrimary,
                      padding: EdgeInsets.symmetric(vertical: 4.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3.w),
                      ),
                      elevation: 2,
                    ),
                    child: _isProcessing
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 6.w,
                                height: 6.w,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppTheme.lightTheme.colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                'Securing Payment...',
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.onPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomIconWidget(
                                iconName: 'lock',
                                color:
                                    AppTheme.lightTheme.colorScheme.onPrimary,
                                size: 6.w,
                              ),
                              SizedBox(width: 3.w),
                              Text(
                                'Process Payment - \$${transactionData["total"].toStringAsFixed(2)}',
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.onPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
