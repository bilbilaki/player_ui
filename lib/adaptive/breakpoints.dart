import 'package:flutter/widgets.dart';

/// Material 3-inspired window size classes.
/// Compact: < 600
/// Medium:  600–839
/// Expanded: >= 840
enum WindowSizeClass { compact, medium, expanded }

/// Standard breakpoints for responsive layout.
class Breakpoints {
  static const double compactMaxWidth = 599;
  static const double mediumMinWidth = 600;
  static const double mediumMaxWidth = 839;
  static const double expandedMinWidth = 840;

  /// Determine size class from a given width.
  static WindowSizeClass fromWidth(double width) {
    if (width < mediumMinWidth) return WindowSizeClass.compact;
    if (width <= mediumMaxWidth) return WindowSizeClass.medium;
    return WindowSizeClass.expanded;
  }

  /// Determine size class from [BuildContext].
  static WindowSizeClass fromContext(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return fromWidth(width);
  }
}

/// Convenience extension for accessing the current window size class.
extension WindowSizeClassX on BuildContext {
  WindowSizeClass get windowSizeClass => Breakpoints.fromContext(this);
}
