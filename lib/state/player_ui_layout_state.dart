import 'package:flutter/foundation.dart';

import '../models/enums.dart';

/// App-level layout state for right panel visibility, width, and active tab.
class PlayerUiLayoutState extends ChangeNotifier {
  bool _rightPanelVisible = true;
  double _rightPanelWidth = 360.0;
  double _minRightPanelWidth = 280.0;
  double _maxRightPanelWidth = 600.0;
  RightTab _tab = RightTab.playlist;

  bool get rightPanelVisible => _rightPanelVisible;
  double get rightPanelWidth => _rightPanelWidth;
  double get minRightPanelWidth => _minRightPanelWidth;
  double get maxRightPanelWidth => _maxRightPanelWidth;
  RightTab get tab => _tab;

  /// Set the clamping bounds for right panel width, typically from policy.
  void setRightPanelWidthBounds(double min, double max) {
    if (_minRightPanelWidth == min && _maxRightPanelWidth == max) return;
    _minRightPanelWidth = min;
    _maxRightPanelWidth = max;
    // Re-clamp current width against new bounds
    final clamped = _rightPanelWidth.clamp(
      _minRightPanelWidth,
      _maxRightPanelWidth,
    );
    if (clamped != _rightPanelWidth) {
      _rightPanelWidth = clamped;
    }
    notifyListeners();
  }

  void setPanelVisible(bool visible) {
    if (_rightPanelVisible == visible) return;
    _rightPanelVisible = visible;
    notifyListeners();
  }

  void togglePanel() => setPanelVisible(!rightPanelVisible);

  void setPanelWidth(double width) {
    // Clamp to configured bounds
    final clamped = width.clamp(_minRightPanelWidth, _maxRightPanelWidth);
    if (_rightPanelWidth == clamped) return;
    _rightPanelWidth = clamped;
    notifyListeners();
  }

  void setTab(RightTab t) {
    if (_tab == t) return;
    _tab = t;
    notifyListeners();
  }
}
