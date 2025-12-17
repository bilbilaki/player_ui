import 'package:flutter/material.dart';

import '../ui/player_home_page.dart';

class PlayerUiApp extends StatelessWidget {
  const PlayerUiApp({super.key});

  @override
  Widget build(BuildContext context) {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorSchemeSeed: const Color(0xFFFF6A00),
      scaffoldBackgroundColor: const Color(0xFF0C0C10),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: base.copyWith(
        sliderTheme: base.sliderTheme.copyWith(
          trackHeight: 2,
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
          overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
        ),
      ),
      home: const PlayerHomePage(),
    );
  }
}
