import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ImagePreviewWidget extends StatefulWidget {
  final XFile capturedImage;
  final Function(XFile) onImageProcessed;
  final VoidCallback onRetake;

  const ImagePreviewWidget({
    Key? key,
    required this.capturedImage,
    required this.onImageProcessed,
    required this.onRetake,
  }) : super(key: key);

  @override
  State<ImagePreviewWidget> createState() => _ImagePreviewWidgetState();
}

class _ImagePreviewWidgetState extends State<ImagePreviewWidget> {
  double _brightness = 0.0;
  double _contrast = 1.0;
  int _rotationAngle = 0;
  bool _isProcessing = false;

  void _adjustBrightness(double value) {
    setState(() {
      _brightness = value;
    });
  }

  void _adjustContrast(double value) {
    setState(() {
      _contrast = value;
    });
  }

  void _rotateImage() {
    setState(() {
      _rotationAngle = (_rotationAngle + 90) % 360;
    });
  }

  Future<void> _processImage() async {
    setState(() {
      _isProcessing = true;
    });

    // Simulate image processing
    await Future.delayed(Duration(seconds: 2));

    widget.onImageProcessed(widget.capturedImage);

    setState(() {
      _isProcessing = false;
    });
  }

  Widget _buildImageDisplay() {
    if (kIsWeb) {
      return FutureBuilder<Uint8List>(
        future: widget.capturedImage.readAsBytes(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Transform.rotate(
              angle: _rotationAngle * 3.14159 / 180,
              child: ColorFiltered(
                colorFilter: ColorFilter.matrix([
                  _contrast,
                  0,
                  0,
                  0,
                  _brightness * 255,
                  0,
                  _contrast,
                  0,
                  0,
                  _brightness * 255,
                  0,
                  0,
                  _contrast,
                  0,
                  _brightness * 255,
                  0,
                  0,
                  0,
                  1,
                  0,
                ]),
                child: Image.memory(
                  snapshot.data!,
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(
              color: AppTheme.lightTheme.primaryColor,
            ),
          );
        },
      );
    } else {
      return Transform.rotate(
        angle: _rotationAngle * 3.14159 / 180,
        child: ColorFiltered(
          colorFilter: ColorFilter.matrix([
            _contrast,
            0,
            0,
            0,
            _brightness * 255,
            0,
            _contrast,
            0,
            0,
            _brightness * 255,
            0,
            0,
            _contrast,
            0,
            _brightness * 255,
            0,
            0,
            0,
            1,
            0,
          ]),
          child: Image.file(
            File(widget.capturedImage.path),
            fit: BoxFit.contain,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black,
      child: Column(
        children: [
          // Image preview area
          Expanded(
            flex: 3,
            child: Container(
              margin: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _buildImageDisplay(),
              ),
            ),
          ),

          // Enhancement controls
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Column(
                children: [
                  // Brightness control
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'brightness_6',
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Slider(
                          value: _brightness,
                          min: -0.5,
                          max: 0.5,
                          divisions: 20,
                          activeColor: AppTheme.lightTheme.primaryColor,
                          inactiveColor: Colors.white24,
                          onChanged: _adjustBrightness,
                        ),
                      ),
                    ],
                  ),

                  // Contrast control
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'contrast',
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Slider(
                          value: _contrast,
                          min: 0.5,
                          max: 2.0,
                          divisions: 15,
                          activeColor: AppTheme.lightTheme.primaryColor,
                          inactiveColor: Colors.white24,
                          onChanged: _adjustContrast,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Action buttons
          Container(
            padding: EdgeInsets.all(4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Retake button
                GestureDetector(
                  onTap: widget.onRetake,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Colors.white, width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: 'camera_alt',
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Retake',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Rotate button
                GestureDetector(
                  onTap: _rotateImage,
                  child: Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: CustomIconWidget(
                      iconName: 'rotate_right',
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),

                // Process button
                GestureDetector(
                  onTap: _isProcessing ? null : _processImage,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: _isProcessing
                          ? AppTheme.lightTheme.primaryColor
                              .withValues(alpha: 0.5)
                          : AppTheme.lightTheme.primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _isProcessing
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : CustomIconWidget(
                                iconName: 'check',
                                color: Colors.white,
                                size: 20,
                              ),
                        SizedBox(width: 2.w),
                        Text(
                          _isProcessing ? 'Processing...' : 'Use Image',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
