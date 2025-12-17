import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ui/player_home_page.dart';
import '../adaptive/adaptive_theme_tokens.dart';
import '../state/player_ui_layout_state.dart';

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

    return ChangeNotifierProvider<PlayerUiLayoutState>(
      create: (_) => PlayerUiLayoutState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: base.copyWith(
          sliderTheme: base.sliderTheme.copyWith(
            trackHeight: 2,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
          ),
          // Attach adaptive theme tokens as a ThemeExtension so widgets can read
          // context-aware dimensions.
          extensions: [
            AdaptiveThemeTokens.forContext(context),
            ...base.extensions.values,
          ],
        ),
        home: const PlayerHomePage(),
      ),
    );
  }
}
