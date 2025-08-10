import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../widgets/camera_preview_widget.dart';
import '../widgets/camera_controls.dart';
import '../widgets/permission_dialog.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> with WidgetsBindingObserver {
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isInitialized = false;
  bool _isRecording = false;
  bool _isFrontCamera = false;
  FlashMode _flashMode = FlashMode.auto;
  String _cameraMode = 'photo'; // photo, video, portrait
  bool _permissionGranted = false;
  bool _showPermissionDialog = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _requestPermissions();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (_permissionGranted) {
        _initializeCamera();
      }
    }
  }

  Future<void> _requestPermissions() async {
    print('📱 Requesting camera permissions...');
    
    // Request camera permission
    PermissionStatus cameraStatus = await Permission.camera.request();
    print('📷 Camera permission status: $cameraStatus');
    
    // Request microphone permission (for video recording)
    PermissionStatus microphoneStatus = await Permission.microphone.request();
    print('🎤 Microphone permission status: $microphoneStatus');
    
    if (cameraStatus == PermissionStatus.granted) {
      setState(() {
        _permissionGranted = true;
        _showPermissionDialog = false;
      });
      await _initializeCamera();
    } else if (cameraStatus == PermissionStatus.denied) {
      setState(() {
        _showPermissionDialog = true;
      });
      print('❌ Camera permission denied');
    } else if (cameraStatus == PermissionStatus.permanentlyDenied) {
      setState(() {
        _showPermissionDialog = true;
      });
      print('❌ Camera permission permanently denied - need to open settings');
    }
  }

  Future<void> _initializeCamera() async {
    try {
      print('🎥 Initializing camera...');
      _cameras = await availableCameras();
      print('📷 Found ${_cameras.length} cameras');
      
      if (_cameras.isEmpty) {
        print('❌ No cameras found');
        return;
      }

      // Select camera (back camera by default)
      CameraDescription selectedCamera = _cameras.firstWhere(
        (camera) => camera.lensDirection == 
          (_isFrontCamera ? CameraLensDirection.front : CameraLensDirection.back),
        orElse: () => _cameras.first,
      );

      _cameraController = CameraController(
        selectedCamera,
        ResolutionPreset.high,
        enableAudio: true,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await _cameraController!.initialize();
      await _cameraController!.setFlashMode(_flashMode);

      setState(() {
        _isInitialized = true;
      });
      
      print('✅ Camera initialized successfully');
    } catch (e) {
      print('❌ Error initializing camera: $e');
    }
  }

  Future<void> _toggleCamera() async {
    if (_cameras.length < 2) return;

    setState(() {
      _isFrontCamera = !_isFrontCamera;
      _isInitialized = false;
    });

    await _cameraController?.dispose();
    await _initializeCamera();
  }

  Future<void> _toggleFlash() async {
    if (_cameraController == null) return;

    FlashMode newMode;
    switch (_flashMode) {
      case FlashMode.auto:
        newMode = FlashMode.always;
        break;
      case FlashMode.always:
        newMode = FlashMode.off;
        break;
      case FlashMode.off:
        newMode = FlashMode.auto;
        break;
      default:
        newMode = FlashMode.auto;
    }

    await _cameraController!.setFlashMode(newMode);
    setState(() {
      _flashMode = newMode;
    });
  }

  Future<void> _takePicture() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      print('📸 Taking picture...');
      final XFile image = await _cameraController!.takePicture();
      print('✅ Picture taken: ${image.path}');
      
      // Show capture animation
      _showCaptureAnimation();
      
      // Here you can add logic to save or process the image
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ảnh đã được lưu'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('❌ Error taking picture: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi chụp ảnh: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _startVideoRecording() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      print('🎬 Starting video recording...');
      await _cameraController!.startVideoRecording();
      setState(() {
        _isRecording = true;
      });
      print('✅ Video recording started');
    } catch (e) {
      print('❌ Error starting video recording: $e');
    }
  }

  Future<void> _stopVideoRecording() async {
    if (_cameraController == null || !_cameraController!.value.isRecordingVideo) {
      return;
    }

    try {
      print('⏹️ Stopping video recording...');
      final XFile video = await _cameraController!.stopVideoRecording();
      setState(() {
        _isRecording = false;
      });
      print('✅ Video saved: ${video.path}');
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Video đã được lưu'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('❌ Error stopping video recording: $e');
    }
  }

  void _showCaptureAnimation() {
    // Simple flash animation
    setState(() {});
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {});
    });
  }

  void _onModeChanged(String mode) {
    setState(() {
      _cameraMode = mode;
    });
    
    if (_isRecording && mode != 'video') {
      _stopVideoRecording();
    }
  }

  void _onCapturePressed() {
    if (_cameraMode == 'video') {
      if (_isRecording) {
        _stopVideoRecording();
      } else {
        _startVideoRecording();
      }
    } else {
      _takePicture();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera preview or permission dialog
          if (_showPermissionDialog) 
            PermissionDialog(
              onRetry: _requestPermissions,
              onSettings: () async {
                await openAppSettings();
              },
            )
          else if (_isInitialized && _cameraController != null)
            CameraPreviewWidget(
              controller: _cameraController!,
              onTap: (details) => _onTap(details),
            )
          else
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Đang khởi tạo camera...',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
          
          // Camera controls overlay
          if (_isInitialized && !_showPermissionDialog)
            CameraControls(
              flashMode: _flashMode,
              cameraMode: _cameraMode,
              isRecording: _isRecording,
              isFrontCamera: _isFrontCamera,
              onFlashToggle: _toggleFlash,
              onCameraToggle: _toggleCamera,
              onModeChange: _onModeChanged,
              onCapture: _onCapturePressed,
            ),
        ],
      ),
    );
  }

  void _onTap(TapDownDetails details) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset localPoint = renderBox.globalToLocal(details.globalPosition);
    final Size size = renderBox.size;

    // Convert tap position to camera coordinates
    final double x = localPoint.dx / size.width;
    final double y = localPoint.dy / size.height;

    // Set focus and exposure point
    _cameraController!.setExposurePoint(Offset(x, y));
    _cameraController!.setFocusPoint(Offset(x, y));

    print('📍 Focus set at: ($x, $y)');
  }
}