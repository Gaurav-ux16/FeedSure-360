import 'dart:typed_data';

class WebCameraManager {
  bool get isInitialized => false;
  String? get viewType => null;
  String? get errorMessage => null;

  Future<bool> startCamera() async => false;
  Future<Uint8List?> captureFrame() async => null;
  void stopCamera() {}
}
