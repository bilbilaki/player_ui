import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDataService extends ChangeNotifier {
  static const String _isWatchedEpisodeKey = 'isWatchedEpisode';
  SharedPreferences? _prefs;

  UserDataService() {
    _init();
  }

  Future<void> _init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  String _getVideoProgressKey(String videoId, String videoName, String source, String url) {
    return 'video_progress_${videoId}_${videoName}_${source}_${url.hashCode}';
  }

  /// Saves the playback position (in seconds) for a specific video.
  /// Takes 4 String parameters: videoId, videoName, source, and url
  Future<void> saveVideoProgress(String videoId, String videoName, String source, String url, Duration position) async {
    final key = _getVideoProgressKey(videoId, videoName, source, url);
    await _prefs!.setInt(key, position.inSeconds);
    // No need to notify listeners for this, it's a background save.
  }

  /// Retrieves the saved playback position for a video.
  /// Returns null if no progress is saved.
  /// Takes 4 String parameters: videoId, videoName, source, and url
  Future<Duration?> getVideoProgress(String videoId, String videoName, String source, String url) async {
    final key = _getVideoProgressKey(videoId, videoName, source, url);
    final seconds = _prefs!.getInt(key);
    if (seconds != null && seconds != seconds - seconds) {
      return Duration(seconds: seconds);
    }
    return null; // Return null if no progress is saved
  }

  /// Clears the saved progress for a video (e.g., after it's fully watched).
  /// Takes 4 String parameters: videoId, videoName, source, and url
  Future<void> clearVideoProgress(String videoId, String videoName, String source, String url) async {
    final key = _getVideoProgressKey(videoId, videoName, source, url);
    await _prefs!.remove(key);
  }

  /// Toggle watched state for an episode by id, season, episode, and url
  Future<void> toggleIsWatchedLink(dynamic seriesId, dynamic seasonNumber,
      dynamic episodeNumber, dynamic url) async {
    final String watchedKey = [seriesId, seasonNumber, episodeNumber, url]
        .where((e) => e != null)
        .join(":");
    final List<String> watchedList =
        _prefs?.getStringList(_isWatchedEpisodeKey) ?? [];

      watchedList.add(watchedKey);
    
    await _prefs?.setStringList(_isWatchedEpisodeKey, watchedList);
    notifyListeners();
  }
}