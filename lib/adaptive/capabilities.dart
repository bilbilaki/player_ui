import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// High-level platform grouping for adaptive UX decisions.
enum PlatformFamily { mobile, desktop, web }

/// Pointer input kind granularity.
/// - coarse: touch-first (finger)
/// - fine:   precise (mouse, stylus, trackpad)
enum InputKind { coarse, fine }

/// Detected runtime capabilities useful for adaptive behaviors.
class Capabilities {
  final TargetPlatform platform;
  final PlatformFamily family;
  final bool hasMouse;
  final bool hasHover;
  final bool hasTouch;
  final bool hasKeyboard;

  const Capabilities({
    required this.platform,
    required this.family,
    required this.hasMouse,
    required this.hasHover,
    required this.hasTouch,
    required this.hasKeyboard,
  });

  /// Create capabilities using simple heuristics.
  /// Note: These are best-effort checks and may need refinement for edge cases.
  static Capabilities of(BuildContext context) {
    final platform = defaultTargetPlatform;

    // Determine platform family.
    final family = kIsWeb
        ? PlatformFamily.web
        : switch (platform) {
            TargetPlatform.android ||
            TargetPlatform.iOS => PlatformFamily.mobile,
            TargetPlatform.macOS ||
            TargetPlatform.windows ||
            TargetPlatform.linux => PlatformFamily.desktop,
            _ => PlatformFamily.desktop,
          };

    // Mouse presence: if mouse device connected according to renderer.
    final mouseConnected =
        RendererBinding.instance.mouseTracker.mouseIsConnected;

    // Hover capability: usually tied to fine pointer environments (mouse/trackpad or web/desktop).
    final hoverSupported =
        mouseConnected || family == PlatformFamily.desktop || kIsWeb;

    // Touch heuristic: mobile always has touch; desktop may have touch, but assume false.
    final touchSupported = family == PlatformFamily.mobile;

    // Keyboard heuristic: desktop/web typically have hardware keyboards; mobile may have soft keyboards.
    final keyboardSupported =
        family == PlatformFamily.desktop ||
        kIsWeb ||
        family == PlatformFamily.mobile;

    return Capabilities(
      platform: platform,
      family: family,
      hasMouse: mouseConnected,
      hasHover: hoverSupported,
      hasTouch: touchSupported,
      hasKeyboard: keyboardSupported,
    );
  }

  /// Derive input kind from capabilities.
  InputKind get primaryInputKind =>
      hasMouse ? InputKind.fine : InputKind.coarse;

  /// Get the appropriate directory for saving screenshots per platform.
  /// Desktop: uses [Directory.current]/screenshot
  /// Mobile: uses app-specific application documents directory (to be filled by path_provider)
  /// Web: returns null (not applicable)
  String? getScreenshotDirectory() {
    switch (family) {
      case PlatformFamily.desktop:
        return '${Directory.current.path}/screenshot';
      case PlatformFamily.mobile:
        // Future: integrate path_provider to get proper mobile app directory
        // For now, indicate that mobile should handle this differently
        if (Platform.isAndroid) {
          return '/storage/emulated/0/Pictures/PlayerScreenshot';
        } else if (Platform.isIOS) {
          // iOS typically saves to app's documents directory (handled by path_provider)
          return null;
        }
        return null;
      case PlatformFamily.web:
        return null; // Web screenshots are handled by browser
    }
  }

  /// Check if this platform supports file system operations for screenshots.
  bool get supportsFileSystemScreenshots =>
      family == PlatformFamily.desktop || family == PlatformFamily.mobile;
}

/// Convenience helpers.
extension CapabilitiesX on BuildContext {
  Capabilities get capabilities => Capabilities.of(this);
  PlatformFamily get platformFamily => capabilities.family;
  InputKind get inputKind => capabilities.primaryInputKind;
}
