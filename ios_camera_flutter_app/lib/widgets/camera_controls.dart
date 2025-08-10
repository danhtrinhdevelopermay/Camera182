import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraControls extends StatelessWidget {
  final FlashMode flashMode;
  final String cameraMode;
  final bool isRecording;
  final bool isFrontCamera;
  final VoidCallback onFlashToggle;
  final VoidCallback onCameraToggle;
  final Function(String) onModeChange;
  final VoidCallback onCapture;

  const CameraControls({
    super.key,
    required this.flashMode,
    required this.cameraMode,
    required this.isRecording,
    required this.isFrontCamera,
    required this.onFlashToggle,
    required this.onCameraToggle,
    required this.onModeChange,
    required this.onCapture,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top controls
        SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Flash control
                _buildTopButton(
                  icon: _getFlashIcon(),
                  onPressed: onFlashToggle,
                ),
                // Settings or other controls
                _buildTopButton(
                  icon: Icons.settings_outlined,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
        
        Spacer(),
        
        // Bottom controls
        Container(
          height: 200,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.6),
              ],
            ),
          ),
          child: Column(
            children: [
              // Mode selector
              _buildModeSelector(),
              SizedBox(height: 24),
              
              // Camera controls row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Gallery/photos button
                  _buildControlButton(
                    icon: Icons.photo_library_outlined,
                    size: 40,
                    onPressed: () {},
                  ),
                  
                  // Capture button
                  _buildCaptureButton(),
                  
                  // Camera flip button
                  _buildControlButton(
                    icon: Icons.flip_camera_ios_outlined,
                    size: 40,
                    onPressed: onCameraToggle,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTopButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white, size: 20),
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildModeSelector() {
    List<String> modes = ['PHOTO', 'VIDEO', 'PORTRAIT'];
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: modes.map((mode) {
        bool isSelected = mode.toLowerCase() == cameraMode.toLowerCase();
        return GestureDetector(
          onTap: () => onModeChange(mode.toLowerCase()),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            margin: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white.withOpacity(0.2) : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              border: isSelected ? Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ) : null,
            ),
            child: Text(
              mode,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCaptureButton() {
    return GestureDetector(
      onTap: onCapture,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isRecording ? Colors.red : Colors.white,
          border: Border.all(
            color: Colors.white,
            width: 4,
          ),
        ),
        child: isRecording
            ? Center(
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required double size,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(size / 2),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white, size: size * 0.5),
        padding: EdgeInsets.zero,
      ),
    );
  }

  IconData _getFlashIcon() {
    switch (flashMode) {
      case FlashMode.auto:
        return Icons.flash_auto;
      case FlashMode.always:
        return Icons.flash_on;
      case FlashMode.off:
        return Icons.flash_off;
      default:
        return Icons.flash_auto;
    }
  }
}