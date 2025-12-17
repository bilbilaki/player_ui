import 'package:flutter/material.dart';

import 'adaptive_context.dart';
import 'breakpoints.dart';
import 'capabilities.dart';

/// Design tokens that adapt to device class (size, input, platform).
///
/// Include common scales: spacing, icon sizes, text sizes, control heights.
class AdaptiveThemeTokens extends ThemeExtension<AdaptiveThemeTokens> {
  // Spacing scale
  final double spaceXS;
  final double spaceS;
  final double spaceM;
  final double spaceL;
  final double spaceXL;

  // Icon sizes
  final double iconSmall;
  final double iconMedium;
  final double iconLarge;

  // Text sizes (raw font sizes; styles still live in AppTheme)
  final double textSmall;
  final double textMedium;
  final double textLarge;
  final double textXL;

  // Control dimensions
  final double controlButtonSmall;
  final double controlButtonLarge;
  final double bottomControlsHeight;
  final double volumeSliderWidth;
  final double volumeDisplayWidth;
  final double listRowHeight;
  final double rightPanelTabsHeight;

  const AdaptiveThemeTokens({
    required this.spaceXS,
    required this.spaceS,
    required this.spaceM,
    required this.spaceL,
    required this.spaceXL,
    required this.iconSmall,
    required this.iconMedium,
    required this.iconLarge,
    required this.textSmall,
    required this.textMedium,
    required this.textLarge,
    required this.textXL,
    required this.controlButtonSmall,
    required this.controlButtonLarge,
    required this.bottomControlsHeight,
    required this.volumeSliderWidth,
    required this.volumeDisplayWidth,
    required this.listRowHeight,
    required this.rightPanelTabsHeight,
  });

  static AdaptiveThemeTokens forContext(BuildContext context) {
    final ac = AdaptiveContext.from(context);
    return forAdaptive(ac);
  }

  /// Build tokens from an [AdaptiveContext].
  static AdaptiveThemeTokens forAdaptive(AdaptiveContext ac) {
    // Defaults tuned around medium density.
    double spaceXS = 6;
    double spaceS = 10;
    double spaceM = 14;
    double spaceL = 18;
    double spaceXL = 26;

    double iconSmall = 20;
    double iconMedium = 24;
    double iconLarge = 28;

    double textSmall = 12;
    double textMedium = 13;
    double textLarge = 15;
    double textXL = 17;

    double controlButtonSmall = 34;
    double controlButtonLarge = 42;
    double bottomControlsHeight = 90;
    double volumeSliderWidth = 130;
    double volumeDisplayWidth = 38;
    double listRowHeight = 34;
    double rightPanelTabsHeight = 38;

    switch (ac.sizeClass) {
      case WindowSizeClass.compact:
        spaceXS = 4;
        spaceS = 8;
        spaceM = 12;
        spaceL = 16;
        spaceXL = 24;

        iconSmall = 18;
        iconMedium = 22;
        iconLarge = 26;

        textSmall = 11;
        textMedium = 12;
        textLarge = 14;
        textXL = 16;

        controlButtonSmall = 30;
        controlButtonLarge = 38;
        bottomControlsHeight = 82;
        volumeSliderWidth = 120;
        volumeDisplayWidth = 36;
        listRowHeight = 32;
        rightPanelTabsHeight = 36;
        break;
      case WindowSizeClass.medium:
        // Use defaults defined above.
        break;
      case WindowSizeClass.expanded:
        spaceXS = 8;
        spaceS = 12;
        spaceM = 16;
        spaceL = 22;
        spaceXL = 32;

        iconSmall = 22;
        iconMedium = 26;
        iconLarge = 30;

        textSmall = 13;
        textMedium = 14;
        textLarge = 16;
        textXL = 18;

        controlButtonSmall = 36;
        controlButtonLarge = 46;
        bottomControlsHeight = 96;
        volumeSliderWidth = 140;
        volumeDisplayWidth = 40;
        listRowHeight = 36;
        rightPanelTabsHeight = 40;
        break;
    }

    // Adjust for coarse input (touch-first): increase hit targets and icons.
    if (ac.inputKind == InputKind.coarse) {
      controlButtonSmall += 2;
      controlButtonLarge += 2;
      bottomControlsHeight += 2;
      iconSmall += 2;
      iconMedium += 2;
      iconLarge += 2;
      // Slightly bump spacing at larger scales for touch comfort.
      spaceL += 2;
      spaceXL += 2;
    }

    return AdaptiveThemeTokens(
      spaceXS: spaceXS,
      spaceS: spaceS,
      spaceM: spaceM,
      spaceL: spaceL,
      spaceXL: spaceXL,
      iconSmall: iconSmall,
      iconMedium: iconMedium,
      iconLarge: iconLarge,
      textSmall: textSmall,
      textMedium: textMedium,
      textLarge: textLarge,
      textXL: textXL,
      controlButtonSmall: controlButtonSmall,
      controlButtonLarge: controlButtonLarge,
      bottomControlsHeight: bottomControlsHeight,
      volumeSliderWidth: volumeSliderWidth,
      volumeDisplayWidth: volumeDisplayWidth,
      listRowHeight: listRowHeight,
      rightPanelTabsHeight: rightPanelTabsHeight,
    );
  }

  static AdaptiveThemeTokens get fallback => const AdaptiveThemeTokens(
    spaceXS: 6,
    spaceS: 10,
    spaceM: 14,
    spaceL: 18,
    spaceXL: 26,
    iconSmall: 20,
    iconMedium: 24,
    iconLarge: 28,
    textSmall: 12,
    textMedium: 13,
    textLarge: 15,
    textXL: 17,
    controlButtonSmall: 34,
    controlButtonLarge: 42,
    bottomControlsHeight: 90,
    volumeSliderWidth: 130,
    volumeDisplayWidth: 38,
    listRowHeight: 34,
    rightPanelTabsHeight: 38,
  );

  @override
  AdaptiveThemeTokens copyWith({
    double? spaceXS,
    double? spaceS,
    double? spaceM,
    double? spaceL,
    double? spaceXL,
    double? iconSmall,
    double? iconMedium,
    double? iconLarge,
    double? textSmall,
    double? textMedium,
    double? textLarge,
    double? textXL,
    double? controlButtonSmall,
    double? controlButtonLarge,
    double? bottomControlsHeight,
    double? volumeSliderWidth,
    double? volumeDisplayWidth,
    double? listRowHeight,
    double? rightPanelTabsHeight,
  }) {
    return AdaptiveThemeTokens(
      spaceXS: spaceXS ?? this.spaceXS,
      spaceS: spaceS ?? this.spaceS,
      spaceM: spaceM ?? this.spaceM,
      spaceL: spaceL ?? this.spaceL,
      spaceXL: spaceXL ?? this.spaceXL,
      iconSmall: iconSmall ?? this.iconSmall,
      iconMedium: iconMedium ?? this.iconMedium,
      iconLarge: iconLarge ?? this.iconLarge,
      textSmall: textSmall ?? this.textSmall,
      textMedium: textMedium ?? this.textMedium,
      textLarge: textLarge ?? this.textLarge,
      textXL: textXL ?? this.textXL,
      controlButtonSmall: controlButtonSmall ?? this.controlButtonSmall,
      controlButtonLarge: controlButtonLarge ?? this.controlButtonLarge,
      bottomControlsHeight: bottomControlsHeight ?? this.bottomControlsHeight,
      volumeSliderWidth: volumeSliderWidth ?? this.volumeSliderWidth,
      volumeDisplayWidth: volumeDisplayWidth ?? this.volumeDisplayWidth,
      listRowHeight: listRowHeight ?? this.listRowHeight,
      rightPanelTabsHeight: rightPanelTabsHeight ?? this.rightPanelTabsHeight,
    );
  }

  @override
  AdaptiveThemeTokens lerp(
    ThemeExtension<AdaptiveThemeTokens>? other,
    double t,
  ) {
    if (other is! AdaptiveThemeTokens) return this;
    double lerpDoubleLocal(double a, double b) => a + (b - a) * t;
    return AdaptiveThemeTokens(
      spaceXS: lerpDoubleLocal(spaceXS, other.spaceXS),
      spaceS: lerpDoubleLocal(spaceS, other.spaceS),
      spaceM: lerpDoubleLocal(spaceM, other.spaceM),
      spaceL: lerpDoubleLocal(spaceL, other.spaceL),
      spaceXL: lerpDoubleLocal(spaceXL, other.spaceXL),
      iconSmall: lerpDoubleLocal(iconSmall, other.iconSmall),
      iconMedium: lerpDoubleLocal(iconMedium, other.iconMedium),
      iconLarge: lerpDoubleLocal(iconLarge, other.iconLarge),
      textSmall: lerpDoubleLocal(textSmall, other.textSmall),
      textMedium: lerpDoubleLocal(textMedium, other.textMedium),
      textLarge: lerpDoubleLocal(textLarge, other.textLarge),
      textXL: lerpDoubleLocal(textXL, other.textXL),
      controlButtonSmall: lerpDoubleLocal(
        controlButtonSmall,
        other.controlButtonSmall,
      ),
      controlButtonLarge: lerpDoubleLocal(
        controlButtonLarge,
        other.controlButtonLarge,
      ),
      bottomControlsHeight: lerpDoubleLocal(
        bottomControlsHeight,
        other.bottomControlsHeight,
      ),
      volumeSliderWidth: lerpDoubleLocal(
        volumeSliderWidth,
        other.volumeSliderWidth,
      ),
      volumeDisplayWidth: lerpDoubleLocal(
        volumeDisplayWidth,
        other.volumeDisplayWidth,
      ),
      listRowHeight: lerpDoubleLocal(listRowHeight, other.listRowHeight),
      rightPanelTabsHeight: lerpDoubleLocal(
        rightPanelTabsHeight,
        other.rightPanelTabsHeight,
      ),
    );
  }
}
