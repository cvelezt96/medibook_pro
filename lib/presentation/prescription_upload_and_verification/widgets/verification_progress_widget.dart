import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VerificationProgressWidget extends StatefulWidget {
  final Function(String) onStatusUpdate;

  const VerificationProgressWidget({
    Key? key,
    required this.onStatusUpdate,
  }) : super(key: key);

  @override
  State<VerificationProgressWidget> createState() =>
      _VerificationProgressWidgetState();
}

class _VerificationProgressWidgetState extends State<VerificationProgressWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  int _currentStage = 0;
  bool _isComplete = false;
  String _estimatedTime = '5-10 minutes';

  final List<Map<String, dynamic>> _verificationStages = [
    {
      'title': 'Upload Complete',
      'description': 'Prescription image uploaded successfully',
      'icon': 'cloud_upload',
      'duration': 1000,
    },
    {
      'title': 'Pharmacist Review',
      'description': 'Licensed pharmacist reviewing prescription',
      'icon': 'person',
      'duration': 3000,
    },
    {
      'title': 'Insurance Check',
      'description': 'Verifying insurance coverage and benefits',
      'icon': 'verified_user',
      'duration': 2000,
    },
    {
      'title': 'Ready for Pickup/Delivery',
      'description': 'Prescription verified and ready for fulfillment',
      'icon': 'local_pharmacy',
      'duration': 1000,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(seconds: 8),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _startVerificationProcess();
  }

  Future<void> _startVerificationProcess() async {
    _animationController.forward();

    for (int i = 0; i < _verificationStages.length; i++) {
      if (mounted) {
        setState(() {
          _currentStage = i;
        });

        widget.onStatusUpdate(_verificationStages[i]['title'] as String);

        // Update estimated time based on current stage
        switch (i) {
          case 0:
            _estimatedTime = '5-10 minutes';
            break;
          case 1:
            _estimatedTime = '3-5 minutes';
            break;
          case 2:
            _estimatedTime = '1-2 minutes';
            break;
          case 3:
            _estimatedTime = 'Complete';
            break;
        }
      }

      await Future.delayed(Duration(
        milliseconds: _verificationStages[i]['duration'] as int,
      ));
    }

    if (mounted) {
      setState(() {
        _isComplete = true;
      });
      widget.onStatusUpdate('Verification Complete');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildStageItem(Map<String, dynamic> stage, int index) {
    final isActive = index <= _currentStage;
    final isCompleted = index < _currentStage || _isComplete;
    final isCurrent = index == _currentStage && !_isComplete;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stage indicator
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted
                  ? AppTheme.successLight
                  : isActive
                      ? AppTheme.lightTheme.primaryColor
                      : Colors.grey.shade300,
              border: Border.all(
                color: isCompleted
                    ? AppTheme.successLight
                    : isActive
                        ? AppTheme.lightTheme.primaryColor
                        : Colors.grey.shade300,
                width: 2,
              ),
            ),
            child: isCompleted
                ? CustomIconWidget(
                    iconName: 'check',
                    color: Colors.white,
                    size: 24,
                  )
                : isCurrent
                    ? SizedBox(
                        width: 6.w,
                        height: 6.w,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : CustomIconWidget(
                        iconName: stage['icon'] as String,
                        color: isActive ? Colors.white : Colors.grey.shade500,
                        size: 24,
                      ),
          ),

          SizedBox(width: 4.w),

          // Stage content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stage['title'] as String,
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isActive
                        ? AppTheme.lightTheme.colorScheme.onSurface
                        : Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  stage['description'] as String,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: isActive
                        ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                        : Colors.grey.shade500,
                  ),
                ),
                if (isCurrent && !_isComplete) ...[
                  SizedBox(height: 1.h),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.primaryColor
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'In Progress...',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Connecting line
          if (index < _verificationStages.length - 1)
            Positioned(
              left: 6.w,
              top: 12.w,
              child: Container(
                width: 2,
                height: 8.h,
                color:
                    isCompleted ? AppTheme.successLight : Colors.grey.shade300,
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress =
        _isComplete ? 1.0 : (_currentStage + 1) / _verificationStages.length;

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
                      _isComplete
                          ? 'Verification Complete!'
                          : 'Verification in Progress',
                      style:
                          AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: _isComplete
                            ? AppTheme.successLight
                            : AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      _isComplete
                          ? 'Your prescription has been verified and is ready'
                          : 'Estimated completion time: $_estimatedTime',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (!_isComplete)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color:
                        AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${(progress * 100).toInt()}%',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),

          SizedBox(height: 2.h),

          // Overall progress bar
          Container(
            width: double.infinity,
            height: 1.h,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(4),
            ),
            child: AnimatedBuilder(
              animation: _progressAnimation,
              builder: (context, child) {
                return FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progress * _progressAnimation.value,
                  child: Container(
                    decoration: BoxDecoration(
                      color: _isComplete
                          ? AppTheme.successLight
                          : AppTheme.lightTheme.primaryColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 4.h),

          // Verification stages
          Expanded(
            child: ListView.builder(
              itemCount: _verificationStages.length,
              itemBuilder: (context, index) {
                return _buildStageItem(_verificationStages[index], index);
              },
            ),
          ),

          // Completion message
          if (_isComplete)
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
              child: Column(
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'check_circle',
                        color: AppTheme.successLight,
                        size: 32,
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ready for Pickup/Delivery',
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                color: AppTheme.successLight,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Estimated fulfillment: 2-4 hours',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.successLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Pharmacy Contact: HealthCare Pharmacy\nPhone: (555) 123-4567',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.successLight,
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
    );
  }
}
