// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:async';
import 'dart:html' as html;
import 'dart:typed_data';
import 'dart:ui_web' as ui_web;
import 'package:flutter/foundation.dart';

class WebCameraManager {
  html.VideoElement? _videoElement;
  html.MediaStream? _mediaStream;
  String? _viewType;
  bool _isInitialized = false;
  String? _errorMessage;

  bool get isInitialized => _isInitialized;
  String? get viewType => _viewType;
  String? get errorMessage => _errorMessage;

  Future<bool> startCamera() async {
    _errorMessage = null;
    try {
      final mediaDevices = html.window.navigator.mediaDevices;
      if (mediaDevices == null) {
        _errorMessage = "Camera not supported on this browser.";
        return false;
      }

      // Stop any existing stream
      stopCamera();

      final stream = await mediaDevices.getUserMedia({
        'video': {
          'facingMode': 'environment',
          'width': {'ideal': 1280},
          'height': {'ideal': 720}
        },
        'audio': false,
      });

      _mediaStream = stream;
      _viewType = 'webcam-view-${DateTime.now().microsecondsSinceEpoch}';

      _videoElement = html.VideoElement()
        ..autoplay = true
        ..muted = true
        ..setAttribute('playsinline', 'true')
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.objectFit = 'cover'
        ..srcObject = _mediaStream;

      // Wait until metadata is loaded to ensure play starts
      _videoElement!.play();

      ui_web.platformViewRegistry.registerViewFactory(
        _viewType!,
        (int viewId) => _videoElement!,
      );

      _isInitialized = true;
      return true;
    } catch (e) {
      debugPrint('WebCam initialization error: $e');
      _errorMessage = "Camera access was denied or is unavailable.";
      _isInitialized = false;
      return false;
    }
  }

  Future<Uint8List?> captureFrame() async {
    if (_videoElement == null || !_isInitialized) return null;
    try {
      int width = _videoElement!.videoWidth;
      int height = _videoElement!.videoHeight;

      if (width <= 0) width = 640;
      if (height <= 0) height = 480;

      final canvas = html.CanvasElement(width: width, height: height);
      final ctx = canvas.context2D;
      ctx.drawImageScaled(_videoElement!, 0, 0, width, height);

      final dataUrl = canvas.toDataUrl('image/jpeg', 0.90);
      final commaIndex = dataUrl.indexOf(',');
      if (commaIndex != -1) {
        final base64Str = dataUrl.substring(commaIndex + 1);
        final binaryString = html.window.atob(base64Str);
        final bytes = Uint8List(binaryString.length);
        for (int i = 0; i < binaryString.length; i++) {
          bytes[i] = binaryString.codeUnitAt(i);
        }
        return bytes;
      }
      return null;
    } catch (e) {
      debugPrint('Frame capture error: $e');
      return null;
    }
  }

  void stopCamera() {
    try {
      if (_mediaStream != null) {
        for (final track in _mediaStream!.getTracks()) {
          track.stop();
        }
        _mediaStream = null;
      }
      if (_videoElement != null) {
        _videoElement!.pause();
        _videoElement!.srcObject = null;
        _videoElement = null;
      }
      _isInitialized = false;
    } catch (e) {
      debugPrint('Stop camera error: $e');
    }
  }
}
