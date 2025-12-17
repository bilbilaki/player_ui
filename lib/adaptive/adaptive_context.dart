import 'package:flutter/widgets.dart';

import 'breakpoints.dart';
import 'capabilities.dart';

/// Aggregated adaptive information for a given [BuildContext].
class AdaptiveContext {
  final WindowSizeClass sizeClass;
  final PlatformFamily platformFamily;
  final InputKind inputKind;
  final Capabilities capabilities;

  const AdaptiveContext({
    required this.sizeClass,
    required this.platformFamily,
    required this.inputKind,
    required this.capabilities,
  });

  /// Build an [AdaptiveContext] from a [BuildContext].
  factory AdaptiveContext.from(BuildContext context) {
    final caps = Capabilities.of(context);
    final size = Breakpoints.fromContext(context);
    return AdaptiveContext(
      sizeClass: size,
      platformFamily: caps.family,
      inputKind: caps.primaryInputKind,
      capabilities: caps,
    );
  }
}

/// Extension for easy access: `context.adaptive`.
extension AdaptiveContextX on BuildContext {
  AdaptiveContext get adaptive => AdaptiveContext.from(this);
}
