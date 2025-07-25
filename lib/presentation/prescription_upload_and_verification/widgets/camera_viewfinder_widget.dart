import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CameraViewfinderWidget extends StatefulWidget {
  final Function(XFile) onImageCaptured;
  final VoidCallback? onFlashToggle;
  final bool isFlashOn;

  const CameraViewfinderWidget({
    Key? key,
    required this.onImageCaptured,
    this.onFlashToggle,
    this.isFlashOn = false,
  }) : super(key: key);

  @override
  State<CameraViewfinderWidget> createState() => _CameraViewfinderWidgetState();
}

class _CameraViewfinderWidgetState extends State<CameraViewfinderWidget> {
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  bool _isInitializing = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true;
    return (await Permission.camera.request()).isGranted;
  }

  Future<void> _initializeCamera() async {
    if (_isInitializing) return;

    setState(() {
      _isInitializing = true;
    });

    try {
      final hasPermission = await _requestCameraPermission();
      if (!hasPermission) {
        setState(() {
          _isInitializing = false;
        });
        return;
      }

      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        setState(() {
          _isInitializing = false;
        });
        return;
      }

      final camera = kIsWeb
          ? _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.front,
              orElse: () => _cameras.first)
          : _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.back,
              orElse: () => _cameras.first);

      _cameraController = CameraController(
          camera, kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high);

      await _cameraController!.initialize();
      await _applySettings();

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
          _isInitializing = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isInitializing = false;
        });
      }
    }
  }

  Future<void> _applySettings() async {
    if (_cameraController == null) return;

    try {
      await _cameraController!.setFocusMode(FocusMode.auto);
    } catch (e) {}

    if (!kIsWeb) {
      try {
        await _cameraController!.setFlashMode(FlashMode.auto);
      } catch (e) {}
    }
  }

  Future<void> _capturePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      final XFile photo = await _cameraController!.takePicture();
      widget.onImageCaptured(photo);
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> _toggleFlash() async {
    if (kIsWeb || _cameraController == null) return;

    try {
      final currentFlashMode = _cameraController!.value.flashMode;
      final newFlashMode =
          currentFlashMode == FlashMode.off ? FlashMode.torch : FlashMode.off;

      await _cameraController!.setFlashMode(newFlashMode);
      widget.onFlashToggle?.call();
    } catch (e) {}
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 70.h,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Camera Preview
            if (_isCameraInitialized && _cameraController != null)
              Positioned.fill(
                child: AspectRatio(
                  aspectRatio: _cameraController!.value.aspectRatio,
                  child: CameraPreview(_cameraController!),
                ),
              )
            else if (_isInitializing)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: AppTheme.lightTheme.primaryColor,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Initializing Camera...',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              )
            else
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'camera_alt',
                      color: Colors.white54,
                      size: 48,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Camera not available',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
              ),

            // Prescription positioning overlay
            if (_isCameraInitialized)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppTheme.lightTheme.primaryColor
                          .withValues(alpha: 0.8),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: EdgeInsets.all(8.w),
                  child: Stack(
                    children: [
                      // Corner guides
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          width: 6.w,
                          height: 6.w,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                  color: AppTheme.lightTheme.primaryColor,
                                  width: 3),
                              left: BorderSide(
                                  color: AppTheme.lightTheme.primaryColor,
                                  width: 3),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          width: 6.w,
                          height: 6.w,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                  color: AppTheme.lightTheme.primaryColor,
                                  width: 3),
                              right: BorderSide(
                                  color: AppTheme.lightTheme.primaryColor,
                                  width: 3),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: Container(
                          width: 6.w,
                          height: 6.w,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  color: AppTheme.lightTheme.primaryColor,
                                  width: 3),
                              left: BorderSide(
                                  color: AppTheme.lightTheme.primaryColor,
                                  width: 3),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 6.w,
                          height: 6.w,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  color: AppTheme.lightTheme.primaryColor,
                                  width: 3),
                              right: BorderSide(
                                  color: AppTheme.lightTheme.primaryColor,
                                  width: 3),
                            ),
                          ),
                        ),
                      ),
                      // Center instruction
                      Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.w, vertical: 1.h),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Position prescription within frame',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Flash toggle button (mobile only)
            if (!kIsWeb && _isCameraInitialized)
              Positioned(
                top: 2.h,
                right: 4.w,
                child: GestureDetector(
                  onTap: _toggleFlash,
                  child: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    child: CustomIconWidget(
                      iconName: widget.isFlashOn ? 'flash_on' : 'flash_off',
                      color: widget.isFlashOn
                          ? AppTheme.lightTheme.primaryColor
                          : Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),

            // Capture button
            if (_isCameraInitialized)
              Positioned(
                bottom: 3.h,
                left: 0,
                right: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: _capturePhoto,
                    child: Container(
                      width: 20.w,
                      height: 20.w,
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.primaryColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 4,
                        ),
                      ),
                      child: CustomIconWidget(
                        iconName: 'camera_alt',
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
