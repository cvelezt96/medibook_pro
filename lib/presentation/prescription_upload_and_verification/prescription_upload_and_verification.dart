import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/camera_viewfinder_widget.dart';
import './widgets/image_preview_widget.dart';
import './widgets/ocr_processing_widget.dart';
import './widgets/verification_checklist_widget.dart';
import './widgets/verification_progress_widget.dart';

class PrescriptionUploadAndVerification extends StatefulWidget {
  const PrescriptionUploadAndVerification({Key? key}) : super(key: key);

  @override
  State<PrescriptionUploadAndVerification> createState() =>
      _PrescriptionUploadAndVerificationState();
}

class _PrescriptionUploadAndVerificationState
    extends State<PrescriptionUploadAndVerification> {
  int _currentStep = 0;
  XFile? _capturedImage;
  XFile? _processedImage;
  Map<String, dynamic> _extractedData = {};
  bool _isFlashOn = false;
  bool _checklistComplete = false;
  String _verificationStatus = 'Ready to capture';
  final ImagePicker _imagePicker = ImagePicker();

  final List<String> _stepTitles = [
    'Capture Prescription',
    'Preview & Enhance',
    'Extract Information',
    'Verify Details',
    'Submit for Verification',
  ];

  void _onImageCaptured(XFile image) {
    setState(() {
      _capturedImage = image;
      _currentStep = 1;
    });
  }

  void _onRetakePhoto() {
    setState(() {
      _capturedImage = null;
      _processedImage = null;
      _currentStep = 0;
    });
  }

  void _onImageProcessed(XFile processedImage) {
    setState(() {
      _processedImage = processedImage;
      _currentStep = 2;
    });
  }

  void _onOcrComplete(Map<String, dynamic> extractedData) {
    setState(() {
      _extractedData = extractedData;
      _currentStep = 3;
    });
  }

  void _onChecklistComplete(bool isComplete) {
    setState(() {
      _checklistComplete = isComplete;
    });
  }

  void _onStatusUpdate(String status) {
    setState(() {
      _verificationStatus = status;
    });
  }

  Future<void> _selectFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image != null) {
        _onImageCaptured(image);
      }
    } catch (e) {
      // Handle error silently
    }
  }

  void _submitForVerification() {
    setState(() {
      _currentStep = 4;
    });
  }

  void _navigateToRoute(String route) {
    Navigator.pushNamed(context, route);
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        children: [
          Row(
            children: List.generate(_stepTitles.length, (index) {
              final isActive = index <= _currentStep;
              final isCompleted = index < _currentStep;

              return Expanded(
                child: Container(
                  height: 0.5.h,
                  margin: EdgeInsets.symmetric(horizontal: 1.w),
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? AppTheme.successLight
                        : isActive
                            ? AppTheme.lightTheme.primaryColor
                            : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
          SizedBox(height: 1.h),
          Text(
            _currentStep < _stepTitles.length
                ? _stepTitles[_currentStep]
                : 'Complete',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStepContent() {
    switch (_currentStep) {
      case 0:
        return Column(
          children: [
            Expanded(
              child: CameraViewfinderWidget(
                onImageCaptured: _onImageCaptured,
                onFlashToggle: () {
                  setState(() {
                    _isFlashOn = !_isFlashOn;
                  });
                },
                isFlashOn: _isFlashOn,
              ),
            ),
            Container(
              padding: EdgeInsets.all(4.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _selectFromGallery,
                    child: Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                      child: CustomIconWidget(
                        iconName: 'photo_library',
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'Or select from gallery',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );

      case 1:
        return _capturedImage != null
            ? ImagePreviewWidget(
                capturedImage: _capturedImage!,
                onImageProcessed: _onImageProcessed,
                onRetake: _onRetakePhoto,
              )
            : Container();

      case 2:
        return _processedImage != null
            ? OcrProcessingWidget(
                processedImage: _processedImage!,
                onOcrComplete: _onOcrComplete,
              )
            : Container();

      case 3:
        return _extractedData.isNotEmpty
            ? Column(
                children: [
                  Expanded(
                    child: VerificationChecklistWidget(
                      extractedData: _extractedData,
                      onChecklistComplete: _onChecklistComplete,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(4.w),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            _checklistComplete ? _submitForVerification : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _checklistComplete
                              ? AppTheme.lightTheme.primaryColor
                              : Colors.grey.shade400,
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                        ),
                        child: Text(
                          'Submit for Verification',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Container();

      case 4:
        return VerificationProgressWidget(
          onStatusUpdate: _onStatusUpdate,
        );

      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _currentStep == 0 || _currentStep == 1
          ? Colors.black
          : AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: _currentStep == 0 || _currentStep == 1
            ? Colors.black
            : AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: _currentStep == 0 || _currentStep == 1
                  ? Colors.white
                  : AppTheme.lightTheme.primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        title: Text(
          'Prescription Upload',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: _currentStep == 0 || _currentStep == 1
                ? Colors.white
                : AppTheme.lightTheme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          if (_currentStep == 4)
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Done',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.successLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator (hidden during camera and preview)
            if (_currentStep != 0 && _currentStep != 1)
              _buildProgressIndicator(),

            // Main content
            Expanded(
              child: _buildCurrentStepContent(),
            ),
          ],
        ),
      ),

      // Bottom navigation for other screens
      bottomNavigationBar: _currentStep == 4
          ? Container(
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Explore Other Services',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _navigateToRoute('/appointment-booking'),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.primaryColor
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                CustomIconWidget(
                                  iconName: 'calendar_today',
                                  color: AppTheme.lightTheme.primaryColor,
                                  size: 24,
                                ),
                                SizedBox(height: 1.h),
                                Text(
                                  'Book Appointment',
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: AppTheme.lightTheme.primaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              _navigateToRoute('/medicine-search-and-ordering'),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                            decoration: BoxDecoration(
                              color: AppTheme.secondaryLight
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                CustomIconWidget(
                                  iconName: 'local_pharmacy',
                                  color: AppTheme.secondaryLight,
                                  size: 24,
                                ),
                                SizedBox(height: 1.h),
                                Text(
                                  'Order Medicine',
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: AppTheme.secondaryLight,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
