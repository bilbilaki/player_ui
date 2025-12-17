import 'package:flutter/material.dart';
import '../adaptive/adaptive_theme_tokens.dart';

/// App-wide color palette and theme definitions
class AppTheme {
  // Title Bar Colors
  static const Color titleBarGradientStart = Color.fromARGB(255, 90, 1, 128);
  static const Color titleBarGradientEnd = Color.fromARGB(255, 55, 0, 132);

  // Video Pane Colors
  static const Color videoPaneBackground = Color(0xFF05050A);
  static const Color videoPaneOverlayDark = Color(0xFF05050A);
static const Color videoPaneWatermarkColor = Color.fromARGB(255, 200, 200, 200);  
  // Right Pane Colors
  static const Color rightPaneBackground = Color(0xFF0A0E12);
  static const Color rightPaneAccent = Color.fromARGB(255, 4, 0, 42);
  static const Color rightPaneBorderLeftAccent = Color(0xFF00C8FF);
  static const Color rightPaneBorderBottomAccent = Color(0xFFFF2E7D);
  static const Color rightTabsBackground = Color(0xFF1A1F26);
  static const Color rightTabsToolbarBackground = Color(0xFF0F1B22);

  // Tab Colors
  static const Color tabBrowserActive = Color(0xFF00B5FF);
  static const Color tabPlaylistActive = Color(0xFF7CDA00);

  // Playlist Colors
  static const Color playlistCurrentIndicator = Color(0xFFFFD000);
  static const Color browserListAccent = Color(0xFF00B5FF);
  static const Color playlistAccent = Color(0xFF7CDA00);

  // Bottom Control Bar Colors
  static const Color bottomBarGradientStart = Color.fromARGB(255, 51, 3, 53);
  static const Color bottomBarGradientEnd = Color.fromARGB(255, 17, 1, 35);
  static const Color bottomBarControlText = Color.fromARGB(255, 252, 250, 249);
  static const Color bottomBarTrackActive = Color.fromARGB(255, 126, 122, 122);
  static const Color bottomBarThumb = Color.fromARGB(255, 120, 117, 117);

  // Text Colors
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFF0A0A0A);
  static const Color textMuted = Color(
    0xFFA0A0A0,
  ); // Approximation for 0.65 alpha white

  // Divider and Border Colors
  static const Color dividerLight = Color(
    0xFF2A2A2A,
  ); // Approximation for 0.18 alpha black

  // ========== TEXT STYLES ==========

  // Title Bar
  static const TextStyle titleBarTitleStyle = TextStyle(
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
    color: textPrimary,
  );

  static const TextStyle titleBarPillStyle = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  // Video Pane Overlay
  static const TextStyle videoPaneOverlayTitleStyle = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 12,
    color: textPrimary,
  );

  static const TextStyle videoPaneWatermarkStyle = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 12,
    color: textPrimary,
  );

  // Right Pane
  static const TextStyle rightPaneToolbarLabelStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  static const TextStyle tabButtonSelectedStyle = TextStyle(
    fontWeight: FontWeight.w800,
    color: textSecondary,
    letterSpacing: 0.2,
  );

  static const TextStyle tabButtonUnselectedStyle = TextStyle(
    fontWeight: FontWeight.w800,
    color: textPrimary,
    letterSpacing: 0.2,
  );

  // List Items
  static const TextStyle listItemTitleStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle listItemTitleSelectedStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle listItemSubtitleStyle = TextStyle(fontSize: 11);

  // Empty State
  static const TextStyle emptyStateTitleStyle = TextStyle(
    fontWeight: FontWeight.w800,
    fontSize: 16,
    color: textPrimary,
  );

  static const TextStyle emptyStateBodyStyle = TextStyle(color: Colors.white);

  // Bottom Controls
  static const TextStyle bottomControlsTimeStyle = TextStyle(
    color: bottomBarControlText,
    fontWeight: FontWeight.w900,
    fontSize: 12,
  );

  static const TextStyle bottomControlsVolumeStyle = TextStyle(
    color: bottomBarControlText,
    fontWeight: FontWeight.w900,
    fontSize: 12,
  );

  // ========== DECORATIONS ==========

  // ========== DECORATIONS ==========

  // Title Bar
  static const BoxDecoration titleBarDecoration = BoxDecoration(
    gradient: LinearGradient(
      colors: <Color>[titleBarGradientStart, titleBarGradientEnd],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ),
  );

  static BoxDecoration titleBarIconBoxDecoration = BoxDecoration(
    color: Colors.white.withValues(alpha: 0.18),
    borderRadius: BorderRadius.circular(4),
  );

  static BoxDecoration titleBarPillDecoration = BoxDecoration(
    color: Colors.black.withValues(alpha: 0.28),
    borderRadius: BorderRadius.circular(6),
    border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
  );

  // Video Pane
  static BoxDecoration videoPaneOverlayDecoration = BoxDecoration(
    color: Colors.black.withValues(alpha: 0.35),
    borderRadius: BorderRadius.circular(8),
  );

  static BoxDecoration videoPaneTitleDecoration = BoxDecoration(
    color: Colors.black.withValues(alpha: 0.28),
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
  );

  // Right Pane
  static const BoxDecoration rightPaneContainerDecoration = BoxDecoration(
    color: rightPaneBackground,
  );

  static BoxDecoration rightPaneContentDecoration = BoxDecoration(
    color: rightPaneAccent,
    border: Border(
      left: BorderSide(
        color: rightPaneBorderLeftAccent.withValues(alpha: 0.7),
        width: 2,
      ),
      right: BorderSide(
        color: rightPaneBorderLeftAccent.withValues(alpha: 0.7),
        width: 2,
      ),
      bottom: BorderSide(
        color: rightPaneBorderBottomAccent.withValues(alpha: 0.8),
        width: 2,
      ),
    ),
  );

  static BoxDecoration rightTabsDecoration = BoxDecoration(
    color: rightTabsBackground,
    border: Border(
      bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
    ),
  );

  static BoxDecoration rightTabsToolbarDecoration = BoxDecoration(
    color: rightTabsToolbarBackground,
    border: Border(
      bottom: BorderSide(color: Colors.white.withValues(alpha: 0.06)),
    ),
  );

  static BoxDecoration tabButtonSelectedDecoration(Color accentColor) =>
      BoxDecoration(
        color: accentColor.withValues(alpha: 0.9),
        border: Border(
          bottom: BorderSide(color: Colors.black.withValues(alpha: 0.25)),
        ),
      );

  static BoxDecoration tabButtonUnselectedDecoration = BoxDecoration(
    color: rightTabsBackground,
    border: Border(
      bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
    ),
  );

  // List Items
  static BoxDecoration listItemSelectedDecoration(Color accentColor) =>
      BoxDecoration(color: accentColor.withValues(alpha: 0.18));

  static BoxDecoration controlButtonDecoration = BoxDecoration(
    color: Colors.black.withValues(alpha: 0.18),
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: Colors.black.withValues(alpha: 0.18)),
  );

  // Bottom Bar
  static const BoxDecoration bottomBarDecoration = BoxDecoration(
    gradient: LinearGradient(
      colors: <Color>[bottomBarGradientStart, bottomBarGradientEnd],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
  );

  static SliderThemeData getSliderThemeData(BuildContext context) =>
      Theme.of(context).sliderTheme.copyWith(
        activeTrackColor: bottomBarTrackActive,
        inactiveTrackColor: bottomBarTrackActive.withValues(alpha: 0.25),
        thumbColor: bottomBarThumb,
        overlayColor: bottomBarThumb.withValues(alpha: 0.12),
        trackHeight: 4.0,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8.0),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 16.0),
      );

  // ========== DIMENSIONS ==========
  // Static constants retained for backward compatibility, but prefer
  // context-aware getters below that read from AdaptiveThemeTokens.

  static const double titleBarHeight = 40.0;
  static const double rightPaneWidth = 360.0;

  // Context-aware dynamic dimensions (AdaptiveThemeTokens)
  static AdaptiveThemeTokens _tokens(BuildContext context) =>
      Theme.of(context).extension<AdaptiveThemeTokens>() ??
      AdaptiveThemeTokens.fallback;

  static double bottomControlsHeightOf(BuildContext context) =>
      _tokens(context).bottomControlsHeight;

  static double controlButtonSizeSmallOf(BuildContext context) =>
      _tokens(context).controlButtonSmall;

  static double controlButtonSizeLargeOf(BuildContext context) =>
      _tokens(context).controlButtonLarge;

  static double controlIconSizeSmallOf(BuildContext context) =>
      _tokens(context).iconSmall;

  static double controlIconSizeLargeOf(BuildContext context) =>
      _tokens(context).iconLarge;

  static double volumeSliderWidthOf(BuildContext context) =>
      _tokens(context).volumeSliderWidth;

  static double volumeDisplayWidthOf(BuildContext context) =>
      _tokens(context).volumeDisplayWidth;

  // Spacing getters derived from adaptive tokens
  static double spaceXSOf(BuildContext context) => _tokens(context).spaceXS;

  static double spaceSOf(BuildContext context) => _tokens(context).spaceS;

  static double spaceMOf(BuildContext context) => _tokens(context).spaceM;

  static double spaceLOf(BuildContext context) => _tokens(context).spaceL;

  static double spaceXLOf(BuildContext context) => _tokens(context).spaceXL;

  // Icon size getters derived from adaptive tokens
  static double iconSmallOf(BuildContext context) => _tokens(context).iconSmall;

  static double iconMediumOf(BuildContext context) =>
      _tokens(context).iconMedium;

  static double iconLargeOf(BuildContext context) => _tokens(context).iconLarge;

  // Text size getters derived from adaptive tokens
  static double textSmallOf(BuildContext context) => _tokens(context).textSmall;

  static double textMediumOf(BuildContext context) =>
      _tokens(context).textMedium;

  static double textLargeOf(BuildContext context) => _tokens(context).textLarge;

  static double textXLOf(BuildContext context) => _tokens(context).textXL;

  static double listRowHeightOf(BuildContext context) =>
      _tokens(context).listRowHeight;

  static double rightPanelTabsHeightOf(BuildContext context) =>
      _tokens(context).rightPanelTabsHeight;

  static const EdgeInsets titleBarPadding = EdgeInsets.symmetric(
    horizontal: 12,
  );
  static const EdgeInsets rightPanePadding = EdgeInsets.symmetric(
    horizontal: 10,
  );
  static const EdgeInsets bottomControlsPadding = EdgeInsets.symmetric(
    horizontal: 10,
  );

  // ========== BORDER RADIUS ==========

  static const BorderRadius borderRadiusSmall = BorderRadius.all(
    Radius.circular(4),
  );
  static const BorderRadius borderRadiusMedium = BorderRadius.all(
    Radius.circular(6),
  );
  static const BorderRadius borderRadiusLarge = BorderRadius.all(
    Radius.circular(8),
  );
  static const BorderRadius borderRadiusXLarge = BorderRadius.all(
    Radius.circular(10),
  );
}
