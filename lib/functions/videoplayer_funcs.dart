part of '../ui/player_home_page.dart';

Future<void> toggleFullScreen(BuildContext context) async {
  // For mobile platforms (Android/iOS), use SystemChrome for fullscreen
  if (Platform.isAndroid || Platform.isIOS) {
    // Get current orientation modes to detect if we're in fullscreen
    final currentOrientation = MediaQuery.of(context).orientation;

    if (currentOrientation == Orientation.landscape) {
      // Exit fullscreen
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      // Enter fullscreen
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
  } else {
    // For desktop platforms, use video widget's fullscreen
    final isFullScreen = videoKey.currentState?.isFullscreen() ?? false;

    if (isFullScreen) {
      await videoKey.currentState?.exitFullscreen();
    } else {
      await videoKey.currentState?.enterFullscreen();
    }
  }
}
