import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Controls fullscreen state and UI visibility for the video player
class FullscreenState extends ChangeNotifier {
  bool _isFullscreen = false;
  bool _controlsVisible = true;
  Timer? _hideControlsTimer;

  // Fullscreen UI visibility durations
  static const Duration controlsVisibilityDuration = Duration(seconds: 3);
  static const Duration controlsHideAnimationDuration = Duration(
    milliseconds: 300,
  );
  static const Duration controlsShowAnimationDuration = Duration(
    milliseconds: 200,
  );

  bool get isFullscreen => _isFullscreen;
  bool get controlsVisible => _controlsVisible;

  /// Toggle fullscreen mode
  Future<void> toggleFullscreen() async {
    _isFullscreen = !_isFullscreen;

    if (_isFullscreen) {
      // Enter fullscreen
      if (Platform.isAndroid) {
        // Lock to landscape on Android
        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      }

      // Hide system UI
      await SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.immersiveSticky,
        overlays: [],
      );

      // Show controls initially
      _showControls();
    } else {
      // Exit fullscreen
      // Restore normal orientation
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);

      // Restore system UI
      await SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: SystemUiOverlay.values,
      );

      _showControls();
    }

    notifyListeners();
  }

  /// Show controls and set auto-hide timer
  void _showControls() {
    _hideControlsTimer?.cancel();
    _controlsVisible = true;
    _scheduleControlsHide();
    notifyListeners();
  }

  /// Hide controls
  void _hideControls() {
    _controlsVisible = false;
    notifyListeners();
  }

  /// Schedule controls to hide after duration
  void _scheduleControlsHide() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(controlsVisibilityDuration, () {
      if (_isFullscreen && _controlsVisible) {
        _hideControls();
      }
    });
  }

  /// Show controls when user interacts
  void onUserInteraction() {
    if (_isFullscreen) {
      _showControls();
    }
  }

  /// Toggle controls visibility on user interaction
  void toggleControlsVisibility() {
    if (_isFullscreen) {
      if (_controlsVisible) {
        _hideControls();
      } else {
        _showControls();
      }
    }
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    super.dispose();
  }
}
