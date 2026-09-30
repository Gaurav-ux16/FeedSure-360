import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/web_camera_helper.dart';
import '../../providers/testing_workflow_provider.dart';

class GuidedCameraScreen extends ConsumerStatefulWidget {
  const GuidedCameraScreen({super.key});

  @override
  ConsumerState<GuidedCameraScreen> createState() => _GuidedCameraScreenState();
}

class _GuidedCameraScreenState extends ConsumerState<GuidedCameraScreen> {
  final WebCameraManager _cameraManager = WebCameraManager();
  bool _isCameraActive = false;
  bool _isInitializingCamera = false;
  bool _isProcessing = false;
  String? _cameraErrorMessage;
  Uint8List? _previewBytes;

  @override
  void initState() {
    super.initState();
    // Pre-populate preview if already present in workflow
    final existingBytes = ref.read(testingWorkflowProvider).imageBytes;
    if (existingBytes != null) {
      _previewBytes = existingBytes;
    }
  }

  @override
  void dispose() {
    _cameraManager.stopCamera();
    super.dispose();
  }

  Future<void> _startCamera() async {
    setState(() {
      _isInitializingCamera = true;
      _cameraErrorMessage = null;
    });

    final success = await _cameraManager.startCamera();

    if (!mounted) return;

    setState(() {
      _isInitializingCamera = false;
      if (success) {
        _isCameraActive = true;
        _previewBytes = null;
      } else {
        _isCameraActive = false;
        _cameraErrorMessage = _cameraManager.errorMessage ??
            "Camera access is unavailable. You can upload an image instead.";
      }
    });
  }

  Future<void> _captureFrame() async {
    setState(() {
      _isProcessing = true;
    });

    final bytes = await _cameraManager.captureFrame();
    _cameraManager.stopCamera();

    if (!mounted) return;

    if (bytes != null && bytes.isNotEmpty) {
      setState(() {
        _isCameraActive = false;
        _previewBytes = bytes;
        _isProcessing = false;
      });
      ref.read(testingWorkflowProvider.notifier).setCapturedImage(
            bytes: bytes,
            path: 'camera_capture_${DateTime.now().millisecondsSinceEpoch}.jpg',
          );
    } else {
      setState(() {
        _isCameraActive = false;
        _isProcessing = false;
        _cameraErrorMessage = "Could not capture image from webcam. Please try again or upload an image.";
      });
    }
  }

  Future<void> _uploadImage() async {
    // Stop camera if running
    if (_isCameraActive) {
      _cameraManager.stopCamera();
      setState(() {
        _isCameraActive = false;
      });
    }

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'webp'],
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        final bytes = file.bytes;

        if (bytes != null && bytes.isNotEmpty) {
          setState(() {
            _previewBytes = bytes;
            _cameraErrorMessage = null;
          });
          ref.read(testingWorkflowProvider.notifier).setCapturedImage(
                bytes: bytes,
                path: file.name,
              );
        }
      }
    } catch (e) {
      debugPrint('File picker error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to select file. Please try again.')),
        );
      }
    }
  }

  void _resetSelection() {
    _cameraManager.stopCamera();
    setState(() {
      _isCameraActive = false;
      _previewBytes = null;
      _cameraErrorMessage = null;
    });
    ref.read(testingWorkflowProvider.notifier).clearCapturedImage();
  }

  void _proceedToAnalysis() {
    if (_previewBytes != null) {
      ref.read(testingWorkflowProvider.notifier).setCapturedImage(bytes: _previewBytes!);
    }
    context.push('/test/analysis');
  }

  @override
  Widget build(BuildContext context) {
    final workflow = ref.watch(testingWorkflowProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Visual Inspection", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            _cameraManager.stopCamera();
            context.pop();
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
              child: Text(
                _previewBytes != null
                    ? "Sample image ready for screening"
                    : (_isCameraActive
                        ? "Align sample in frame and tap Capture"
                        : "Take a photo or upload a silage/feed sample"),
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ),

            // Main Viewfinder / Image Preview Area
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E281F),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _previewBytes != null ? AppColors.accentGreen : Colors.white24,
                    width: _previewBytes != null ? 2 : 1,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(19),
                  child: Stack(
                    fit: StackFit.expand,
                    alignment: Alignment.center,
                    children: [
                      // Layer 1: Content (Preview Image / Webcam View / Placeholder / Error)
                      _buildViewfinderContent(),

                      // Layer 2: Viewfinder Alignment Brackets
                      if (_previewBytes == null && _cameraErrorMessage == null)
                        Center(
                          child: Container(
                            width: 230,
                            height: 230,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: _isCameraActive
                                    ? AppColors.accentGreen
                                    : Colors.white.withOpacity(0.5),
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),

                      // Layer 3: Overlay Indicator Badges
                      if (_previewBytes != null)
                        Positioned(
                          top: 12,
                          left: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: AppColors.primaryGreen.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.check_circle, size: 14, color: Colors.white),
                                SizedBox(width: 4),
                                Text(
                                  "Image Ready",
                                  style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),

                      if (_isCameraActive)
                        Positioned(
                          top: 12,
                          left: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.redAccent.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.videocam, size: 14, color: Colors.white),
                                SizedBox(width: 4),
                                Text(
                                  "LIVE WEBCAM",
                                  style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            // Pre-Capture Quality Checks Strip
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF1E281F),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _checkItem("Lighting", workflow.lightingOk),
                  _checkItem("Focus", workflow.focusOk),
                  _checkItem("Coverage", workflow.coverageOk),
                ],
              ),
            ),

            // Action Buttons Section
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: _buildActionButtons(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewfinderContent() {
    if (_previewBytes != null) {
      return Image.memory(
        _previewBytes!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    if (_isInitializingCamera) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: AppColors.accentGreen),
            SizedBox(height: 16),
            Text(
              "Requesting camera access...",
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ],
        ),
      );
    }

    if (_isProcessing) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: AppColors.accentGreen),
            SizedBox(height: 16),
            Text(
              "Processing image frame...",
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ],
        ),
      );
    }

    if (_isCameraActive && _cameraManager.viewType != null) {
      return HtmlElementView(viewType: _cameraManager.viewType!);
    }

    if (_cameraErrorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.videocam_off_rounded, size: 48, color: AppColors.statusWarning),
              const SizedBox(height: 12),
              Text(
                _cameraErrorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _uploadImage,
                icon: const Icon(Icons.upload_file, size: 18),
                label: const Text("Upload Image Instead"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Default Guide Visual
    return Container(
      color: const Color(0xFF2A3628),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.grain_rounded, size: 110, color: Colors.white.withOpacity(0.22)),
            const SizedBox(height: 8),
            Text(
              "Center feed / silage sample",
              style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    // State 1: Image Captured/Uploaded & Preview Ready
    if (_previewBytes != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: _proceedToAnalysis,
              icon: const Icon(Icons.arrow_forward_rounded, size: 20),
              label: const Text(
                "Use This Image & Continue",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton.icon(
              onPressed: _resetSelection,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text("Retake / Choose Another"),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white70,
                side: const BorderSide(color: Colors.white38),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      );
    }

    // State 2: Live Webcam Active
    if (_isCameraActive) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: _captureFrame,
              icon: const Icon(Icons.camera_alt, size: 20),
              label: const Text(
                "Capture Frame",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton(
              onPressed: () {
                _cameraManager.stopCamera();
                setState(() {
                  _isCameraActive = false;
                });
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white70,
                side: const BorderSide(color: Colors.white38),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Cancel Camera"),
            ),
          ),
        ],
      );
    }

    // State 3: Initial / Selection State
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 48,
            child: ElevatedButton.icon(
              onPressed: _startCamera,
              icon: const Icon(Icons.camera_alt, size: 18),
              label: const Text("Take Photo", style: TextStyle(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SizedBox(
            height: 48,
            child: OutlinedButton.icon(
              onPressed: _uploadImage,
              icon: const Icon(Icons.upload_file, size: 18),
              label: const Text("Upload Image", style: TextStyle(fontWeight: FontWeight.bold)),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white70, width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _checkItem(String title, bool isOk) {
    return Row(
      children: [
        Icon(
          isOk ? Icons.check_circle : Icons.error_outline,
          color: isOk ? AppColors.accentGreen : AppColors.statusWarning,
          size: 16,
        ),
        const SizedBox(width: 5),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          isOk ? "Good" : "Check",
          style: TextStyle(
            color: isOk ? AppColors.accentGreen : AppColors.statusWarning,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
