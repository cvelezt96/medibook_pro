import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OcrProcessingWidget extends StatefulWidget {
  final XFile processedImage;
  final Function(Map<String, dynamic>) onOcrComplete;

  const OcrProcessingWidget({
    Key? key,
    required this.processedImage,
    required this.onOcrComplete,
  }) : super(key: key);

  @override
  State<OcrProcessingWidget> createState() => _OcrProcessingWidgetState();
}

class _OcrProcessingWidgetState extends State<OcrProcessingWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  
  int _currentStep = 0;
  bool _isProcessing = true;
  Map<String, dynamic> _extractedData = {};

  final List<String> _processingSteps = [
    'Analyzing image quality...',
    'Detecting text regions...',
    'Extracting medicine names...',
    'Reading dosage information...',
    'Identifying doctor details...',
    'Verifying prescription format...',
  ];

  final List<Map<String, dynamic>> _mockExtractedData = [
{ 'medicine': 'Amoxicillin 500mg',
'dosage': '1 tablet twice daily',
'confidence': 0.95,
'type': 'antibiotic' },
{ 'medicine': 'Ibuprofen 400mg',
'dosage': '1 tablet as needed for pain',
'confidence': 0.92,
'type': 'pain_relief' },
{ 'medicine': 'Vitamin D3 1000 IU',
'dosage': '1 capsule daily',
'confidence': 0.88,
'type': 'supplement' },
];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(seconds: 6),
      vsync: this,
    );
    
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _startOcrProcessing();
  }

  Future<void> _startOcrProcessing() async {
    _animationController.forward();
    
    for (int i = 0; i < _processingSteps.length; i++) {
      if (mounted) {
        setState(() {
          _currentStep = i;
        });
      }
      await Future.delayed(Duration(milliseconds: 1000));
    }

    // Simulate OCR completion
    await Future.delayed(Duration(milliseconds: 500));
    
    if (mounted) {
      setState(() {
        _isProcessing = false;
        _extractedData = {
          'medicines': _mockExtractedData,
          'doctor_name': 'Dr. Sarah Johnson',
          'doctor_license': 'MD12345',
          'patient_name': 'John Smith',
          'prescription_date': '2025-07-24',
          'pharmacy_name': 'HealthCare Pharmacy',
          'overall_confidence': 0.92,
        };
      });
      
      widget.onOcrComplete(_extractedData);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildProcessingStep(String step, int index) {
    final isActive = index <= _currentStep;
    final isCompleted = index < _currentStep;
    
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        children: [
          Container(
            width: 6.w,
            height: 6.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted 
                ? AppTheme.successLight
                : isActive 
                  ? AppTheme.lightTheme.primaryColor
                  : Colors.grey.shade300,
            ),
            child: isCompleted
              ? CustomIconWidget(
                  iconName: 'check',
                  color: Colors.white,
                  size: 16,
                )
              : isActive
                ? SizedBox(
                    width: 3.w,
                    height: 3.w,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : null,
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Text(
              step,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: isActive 
                  ? AppTheme.lightTheme.colorScheme.onSurface
                  : Colors.grey.shade600,
                fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExtractedMedicine(Map<String, dynamic> medicine) {
    final confidence = (medicine['confidence'] as double) * 100;
    final confidenceColor = confidence >= 90 
      ? AppTheme.successLight
      : confidence >= 80 
        ? AppTheme.warningLight
        : AppTheme.errorLight;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  medicine['medicine'] as String,
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: confidenceColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${confidence.toInt()}%',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: confidenceColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            medicine['dosage'] as String,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            _isProcessing ? 'Processing Prescription...' : 'Extraction Complete',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          
          if (_isProcessing) ...[
            // Progress indicator
            Container(
              margin: EdgeInsets.symmetric(vertical: 2.h),
              child: Column(
                children: [
                  AnimatedBuilder(
                    animation: _progressAnimation,
                    builder: (context, child) {
                      return LinearProgressIndicator(
                        value: _progressAnimation.value,
                        backgroundColor: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.lightTheme.primaryColor,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'This may take a few moments...',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            
            // Processing steps
            Expanded(
              child: ListView.builder(
                itemCount: _processingSteps.length,
                itemBuilder: (context, index) {
                  return _buildProcessingStep(_processingSteps[index], index);
                },
              ),
            ),
          ] else ...[
            // Extraction results
            SizedBox(height: 2.h),
            
            // Overall confidence
            Container(
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
                    iconName: 'verified',
                    color: AppTheme.successLight,
                    size: 24,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'High Confidence Extraction',
                          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                            color: AppTheme.successLight,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${(_extractedData['overall_confidence'] as double * 100).toInt()}% accuracy',
                          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.successLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 3.h),
            
            // Extracted medicines
            Text(
              'Extracted Medicines',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            
            Expanded(
              child: ListView.builder(
                itemCount: (_extractedData['medicines'] as List).length,
                itemBuilder: (context, index) {
                  final medicine = (_extractedData['medicines'] as List)[index] as Map<String, dynamic>;
                  return _buildExtractedMedicine(medicine);
                },
              ),
            ),
            
            // Doctor and prescription info
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Prescription Details',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Doctor: ${_extractedData['doctor_name']}',
                              style: AppTheme.lightTheme.textTheme.bodySmall,
                            ),
                            Text(
                              'Patient: ${_extractedData['patient_name']}',
                              style: AppTheme.lightTheme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        _extractedData['prescription_date'] as String,
                        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}