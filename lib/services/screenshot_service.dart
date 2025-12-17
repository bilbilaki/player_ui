import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../adaptive/capabilities.dart';

/// Service for handling screenshot operations across platforms.
///
/// Abstracts away platform-specific path handling, permissions, and file I/O.
class ScreenshotService {
  const ScreenshotService();

  /// Save screenshot bytes to disk.
  ///
  /// Returns the file path on success, or null if the operation is not supported
  /// (e.g., on web) or fails.
  Future<String?> saveScreenshot(List<int> imageBytes) async {
    // Get capabilities for current platform
    // Note: In real usage, pass BuildContext to get full Capabilities
    final caps = _getDefaultCapabilities();

    if (!caps.supportsFileSystemScreenshots) {
      return null;
    }

    final directory = caps.getScreenshotDirectory();
    if (directory == null) {
      return null;
    }

    try {
      // Create directory if it doesn't exist
      final dir = Directory(directory);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      // Generate filename with timestamp
      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
      final filename = 'screenshot_$timestamp.png';
      final filepath = '$directory/$filename';

      // Write file
      final file = File(filepath);
      await file.writeAsBytes(imageBytes);

      return filepath;
    } catch (e) {
      return null;
    }
  }

  /// Get the default capabilities object (simplified version without BuildContext).
  /// In a real app, you'd pass BuildContext to get full detection.
  static Capabilities _getDefaultCapabilities() {
    return Capabilities(
      platform: defaultTargetPlatform,
      family: _determinePlatformFamily(),
      hasMouse: false, // Simplified; full version would check RendererBinding
      hasHover: false,
      hasTouch: false,
      hasKeyboard: false,
    );
  }

  static PlatformFamily _determinePlatformFamily() {
    if (Platform.isAndroid || Platform.isIOS) {
      return PlatformFamily.mobile;
    } else if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      return PlatformFamily.desktop;
    }
    return PlatformFamily.web;
  }
}

/// Get the default target platform outside of Flutter context.
TargetPlatform get defaultTargetPlatform {
  if (Platform.isWindows) return TargetPlatform.windows;
  if (Platform.isLinux) return TargetPlatform.linux;
  if (Platform.isMacOS) return TargetPlatform.macOS;
  if (Platform.isAndroid) return TargetPlatform.android;
  if (Platform.isIOS) return TargetPlatform.iOS;
  return TargetPlatform.android; // Fallback
}
