import 'package:flutter/widgets.dart';

import 'adaptive_context.dart';
import 'breakpoints.dart';
import 'capabilities.dart';

/// Where the right panel should be rendered.
enum RightPanelMode {
  /// Panel is docked beside the video content.
  docked,

  /// Panel overlays the video (e.g., on compact/mobile layouts).
  overlay,
}

/// Where primary playback controls should live.
enum ControlsLocation {
  /// Controls pinned to a bottom bar.
  bottomBar,

  /// Controls overlayed on top of the video viewport.
  overlayOnVideo,
}

/// Centralized adaptive layout policy.
///
/// Provides decisions for:
/// - right panel mode (docked/overlay)
/// - default right panel width
/// - whether panel resizing is enabled
/// - controls location (bottom bar vs overlay)
class AdaptiveLayoutPolicy {
  final RightPanelMode panelMode;
  final double defaultRightPaneWidth;
  final double minRightPaneWidth;
  final double maxRightPaneWidth;
  final bool enablePanelResize;
  final ControlsLocation controlsLocation;

  const AdaptiveLayoutPolicy({
    required this.panelMode,
    required this.defaultRightPaneWidth,
    required this.minRightPaneWidth,
    required this.maxRightPaneWidth,
    required this.enablePanelResize,
    required this.controlsLocation,
  });

  /// Compute policy decisions from the current context.
  factory AdaptiveLayoutPolicy.fromContext(BuildContext context) {
    final ac = AdaptiveContext.from(context);
    return AdaptiveLayoutPolicy.fromAdaptive(ac);
  }

  /// Compute policy decisions from an [AdaptiveContext].
  factory AdaptiveLayoutPolicy.fromAdaptive(AdaptiveContext ac) {
    // Right panel mode: overlay for compact or mobile, docked otherwise.
    final panelMode =
        (ac.sizeClass == WindowSizeClass.compact ||
            ac.platformFamily == PlatformFamily.mobile)
        ? RightPanelMode.overlay
        : RightPanelMode.docked;

    // Default width tuned per size class.
    double defaultWidth;
    double minWidth;
    double maxWidth;
    switch (ac.sizeClass) {
      case WindowSizeClass.compact:
        defaultWidth = 300;
        minWidth = 260;
        maxWidth = 420;
        break;
      case WindowSizeClass.medium:
        defaultWidth = 360;
        minWidth = 280;
        maxWidth = 600;
        break;
      case WindowSizeClass.expanded:
        defaultWidth = 420;
        minWidth = 320;
        maxWidth = 720;
        break;
    }

    // Allow resizing for desktop/web with fine input; otherwise keep fixed.
    final enableResize =
        (ac.platformFamily == PlatformFamily.desktop ||
            ac.platformFamily == PlatformFamily.web) &&
        ac.inputKind == InputKind.fine;

    // Controls location: overlay for compact/mobile, bottom bar otherwise.
    final controlsLoc =
        (ac.sizeClass == WindowSizeClass.compact ||
            ac.platformFamily == PlatformFamily.mobile)
        ? ControlsLocation.overlayOnVideo
        : ControlsLocation.bottomBar;

    return AdaptiveLayoutPolicy(
      panelMode: panelMode,
      defaultRightPaneWidth: defaultWidth,
      minRightPaneWidth: minWidth,
      maxRightPaneWidth: maxWidth,
      enablePanelResize: enableResize,
      controlsLocation: controlsLoc,
    );
  }
}

/// Convenience extension: `context.layoutPolicy`.
extension AdaptiveLayoutPolicyX on BuildContext {
  AdaptiveLayoutPolicy get layoutPolicy =>
      AdaptiveLayoutPolicy.fromContext(this);
}
