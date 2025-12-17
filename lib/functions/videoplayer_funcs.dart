part of '../ui/player_home_page.dart';

Future<void> toggleFullScreen() async {
    final isFullScreen = videoKey.currentState?.isFullscreen() ?? false; 
    
    if (isFullScreen) {
      await videoKey.currentState?.exitFullscreen();
    } else {
      await videoKey.currentState?.enterFullscreen();
    }
  }