import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';

import 'app/player_ui_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  runApp(const PlayerUiApp());
}
