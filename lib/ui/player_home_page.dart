import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:provider/provider.dart';
import 'package:screen_brightness/screen_brightness.dart';
import '../adaptive/adaptive_layout_policy.dart';
import '../adaptive/adaptive_theme_tokens.dart';
import '../adaptive/breakpoints.dart';

import '../models/MediaEntry.dart';
import '../models/enums.dart';
import '../models/subtitle_config.dart';
import 'format.dart';
import 'theme.dart';
import '../state/player_ui_layout_state.dart';
import '../state/fullscreen_state.dart';
import '../services/screenshot_service.dart';
import '../services/permission_service.dart';
part '../widgets/TopTitleBar.dart';
part '../widgets/TitleBarPill.dart';
part '../widgets/VideoPane.dart';
part '../widgets/RightPane.dart';
part '../widgets/RightPaneTabs.dart';
part '../widgets/TabButtons.dart';
part '../widgets/RightToolBars.dart';
part '../widgets/BrowserList.dart';
part '../widgets/PlayList.dart';
part '../widgets/ListsRow.dart';
part '../widgets/EmptyHint.dart';
part '../widgets/BottomControls.dart';
part '../widgets/CtlButtons.dart';
part '../intents/Intents.dart';
part '../widgets/ContextMenu.dart';
part '../widgets/SubtitleCustomizerDialog.dart';
part '../widgets/FullscreenWrapper.dart';
part '../functions/videoplayer_funcs.dart';

final GlobalKey<VideoState> videoKey = GlobalKey<VideoState>();

class PlayerHomePage extends StatefulWidget {
  const PlayerHomePage({super.key});

  @override
  State<PlayerHomePage> createState() => _PlayerHomePageState();
}

class _PlayerHomePageState extends State<PlayerHomePage> {
  late final Player _player;
  late final VideoController _videoController;
  late final FullscreenState _fullscreenState;

  final List<MediaEntry> _playlist = <MediaEntry>[];
  int _currentIndex = -1;

  // Tab state moved to PlayerUiLayoutState

  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _playing = false;
  double _volume = 80;

  bool _isDragging = false;
  double _dragValue = 0;

  // Right panel state
  // Moved to PlayerUiLayoutState provider
  bool _isResizingPanel = false;
  bool _layoutDefaultsApplied = false;

  String? _browserDirectory;
  List<MediaEntry> _browserItems = const <MediaEntry>[];

  SubtitleConfig _subtitleConfig = SubtitleConfig.defaultConfig;

  StreamSubscription<Duration>? _posSub;
  StreamSubscription<Duration>? _durSub;
  StreamSubscription<bool>? _playingSub;

  @override
  void initState() {
    super.initState();
    _fullscreenState = FullscreenState();
    _player = Player();
    _videoController = VideoController(_player);

    _posSub = _player.stream.position.listen((d) {
      if (!_isDragging && mounted) {
        setState(() => _position = d);
      }
    });

    _durSub = _player.stream.duration.listen((d) {
      if (mounted) setState(() => _duration = d);
    });

    _playingSub = _player.stream.playing.listen((v) {
      if (mounted) setState(() => _playing = v);
    });

    // Set initial volume
    _player.setVolume(_volume);

    // Request Android permissions for media file access
    _requestAndroidPermissions();
  }

  /// Request necessary Android permissions for reading media files
  Future<void> _requestAndroidPermissions() async {
    if (!Platform.isAndroid) {
      return; // No permissions needed on non-Android platforms
    }

    final permissionsGranted =
        await PermissionService.requestAllStoragePermissions();

    if (!permissionsGranted && mounted) {
      _showPermissionDeniedSnackBar();
    }
  }

  /// Show a snackbar when permissions are denied
  void _showPermissionDeniedSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Storage permissions are required to access media files',
        ),
        action: SnackBarAction(
          label: 'Settings',
          onPressed: () async {
            // Open app settings
            await PermissionService.openAppSettings();
          },
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  @override
  void dispose() {
    _posSub?.cancel();
    _durSub?.cancel();
    _playingSub?.cancel();
    _fullscreenState.dispose();
    _player.dispose();
    super.dispose();
  }

  Future<void> _openFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: const <String>[
        'mkv',
        'mp4',
        'webm',
        'avi',
        'mov',
        'm4v',
        'mp3',
        'flac',
        'wav',
        'aac',
        'm4a',
      ],
    );

    if (result == null) return;

    final picked = result.paths.whereType<String>().where((p) => p.isNotEmpty);
    if (picked.isEmpty) return;

    setState(() {
      _playlist.addAll(picked.map((p) => MediaEntry(path: p)));
    });
    if (!mounted) return;
    context.read<PlayerUiLayoutState>().setTab(RightTab.playlist);

    if (_currentIndex < 0 && _playlist.isNotEmpty) {
      await _playIndex(0);
    }
  }

  Future<void> _openFolder() async {
    final dir = await FilePicker.platform.getDirectoryPath();
    if (dir == null || dir.isEmpty) return;

    setState(() {
      _browserDirectory = dir;
    });
    if (!mounted) return;
    context.read<PlayerUiLayoutState>().setTab(RightTab.browser);

    await _refreshBrowserListing();
  }

  Future<void> _refreshBrowserListing() async {
    final dir = _browserDirectory;
    if (dir == null || dir.isEmpty) {
      if (mounted) setState(() => _browserItems = const <MediaEntry>[]);
      return;
    }

    final directory = Directory(dir);
    if (!await directory.exists()) {
      if (mounted) setState(() => _browserItems = const <MediaEntry>[]);
      return;
    }

    final allowed = <String>{
      '.mkv',
      '.mp4',
      '.webm',
      '.avi',
      '.mov',
      '.m4v',
      '.mp3',
      '.flac',
      '.wav',
      '.aac',
      '.m4a',
    };

    final entries =
        directory
            .listSync(followLinks: false)
            .whereType<File>()
            .where((f) => allowed.contains(_extLower(f.path)))
            .map((f) => MediaEntry(path: f.path))
            .toList()
          ..sort(
            (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
          );

    if (mounted) setState(() => _browserItems = entries);
  }

  String _extLower(String path) {
    final normalized = path.replaceAll('\\', '/');
    final idx = normalized.lastIndexOf('.');
    if (idx < 0) return '';
    return normalized.substring(idx).toLowerCase();
  }

  Future<void> _playIndex(int index) async {
    if (index < 0 || index >= _playlist.length) return;

    final entry = _playlist[index];
    setState(() => _currentIndex = index);

    await _player.open(Media(entry.path), play: true);
  }

  Future<void> _playFromBrowser(MediaEntry entry) async {
    setState(() {
      _playlist.add(entry);
      _currentIndex = _playlist.length - 1;
    });
    context.read<PlayerUiLayoutState>().setTab(RightTab.playlist);

    await _player.open(Media(entry.path), play: true);
  }

  Future<void> _togglePlayPause() async {
    if (_playing) {
      await _player.pause();
    } else {
      await _player.play();
    }
  }

  Future<void> _prev() async {
    if (_playlist.isEmpty) return;
    final next = (_currentIndex <= 0) ? 0 : _currentIndex - 1;
    await _playIndex(next);
  }

  Future<void> _next() async {
    if (_playlist.isEmpty) return;
    final next = (_currentIndex < 0)
        ? 0
        : (_currentIndex + 1).clamp(0, _playlist.length - 1);
    await _playIndex(next);
  }

  Future<void> _seekRelative(Duration delta) async {
    final target = _position + delta;
    final clamped = target < Duration.zero
        ? Duration.zero
        : (_duration > Duration.zero && target > _duration)
        ? _duration
        : target;
    await _player.seek(clamped);
  }

  Future<void> _seekToFraction(double fraction) async {
    if (_duration <= Duration.zero) return;
    final target = Duration(
      milliseconds: (_duration.inMilliseconds * fraction).round(),
    );
    await _player.seek(target);
  }

  // Context menu handlers
  Future<void> _openSubtitleFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const <String>['srt', 'vtt', 'ass', 'ssa', 'sub'],
    );

    if (result == null || result.files.isEmpty) return;
    final path = result.files.first.path;
    if (path == null || path.isEmpty) return;

    // Only load subtitle if a video is currently playing
    if (_currentIndex >= 0) {
      await _player.setSubtitleTrack(
        SubtitleTrack.uri(path, title: result.files.first.name),
      );
    }
  }

  Future<void> _openAudioFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const <String>[
        'mp3',
        'flac',
        'wav',
        'aac',
        'm4a',
        'ogg',
        'opus',
      ],
    );

    if (result == null || result.files.isEmpty) return;
    final path = result.files.first.path;
    if (path == null || path.isEmpty) return;

    // Only load audio if a video is currently playing
    if (_currentIndex >= 0) {
      await _player.setAudioTrack(
        AudioTrack.uri(path, title: result.files.first.name),
      );
    }
  }

  Future<void> _takeScreenshot() async {
    try {
      final screenshot = await _player.screenshot();
      if (screenshot == null) return;

      // Use screenshot service to handle platform-specific logic
      final service = const ScreenshotService();
      final savedPath = await service.saveScreenshot(screenshot);

      if (mounted) {
        if (savedPath != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Screenshot saved to: $savedPath'),
              duration: const Duration(seconds: 3),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Screenshot save not supported on this platform'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save screenshot: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _customizeSubtitle() async {
    // Show subtitle customization dialog
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => _SubtitleCustomizerDialog(
        initialConfig: _subtitleConfig,
        onConfigChanged: (config) {
          setState(() {
            _subtitleConfig = config;
          });
        },
      ),
    );
  }

  List<SubtitleTrack> _getSubtitleTracks() {
    return _player.state.tracks.subtitle;
  }

  List<AudioTrack> _getAudioTracks() {
    return _player.state.tracks.audio;
  }

  Future<void> _selectSubtitleTrack(SubtitleTrack track) async {
    await _player.setSubtitleTrack(track);
  }

  Future<void> _selectAudioTrack(AudioTrack track) async {
    await _player.setAudioTrack(track);
  }

  Future<void> _toggleFullscreen() async {
    await _fullscreenState.toggleFullscreen();
  }

  String get _windowTitle {
    if (_currentIndex >= 0 && _currentIndex < _playlist.length) {
      return '${_currentIndex + 1}/${_playlist.length}  ${_playlist[_currentIndex].title}';
    }
    return 'Media Player';
  }

  @override
  Widget build(BuildContext context) {
    final shortcuts = <ShortcutActivator, Intent>{
      const SingleActivator(LogicalKeyboardKey.space): const _ToggleIntent(),
      const SingleActivator(LogicalKeyboardKey.arrowLeft): const _SeekIntent(
        Duration(seconds: -5),
      ),
      const SingleActivator(LogicalKeyboardKey.arrowRight): const _SeekIntent(
        Duration(seconds: 5),
      ),
      const SingleActivator(LogicalKeyboardKey.keyO, control: true):
          const _OpenFilesIntent(),
      const SingleActivator(LogicalKeyboardKey.keyF, control: true):
          const _OpenFolderIntent(),
      const SingleActivator(LogicalKeyboardKey.pageUp): const _PrevIntent(),
      const SingleActivator(LogicalKeyboardKey.pageDown): const _NextIntent(),
    };

    final actions = <Type, Action<Intent>>{
      _ToggleIntent: CallbackAction<_ToggleIntent>(
        onInvoke: (_) {
          _togglePlayPause();
          return null;
        },
      ),
      _SeekIntent: CallbackAction<_SeekIntent>(
        onInvoke: (i) {
          _seekRelative(i.delta);
          return null;
        },
      ),
      _OpenFilesIntent: CallbackAction<_OpenFilesIntent>(
        onInvoke: (_) {
          _openFiles();
          return null;
        },
      ),
      _OpenFolderIntent: CallbackAction<_OpenFolderIntent>(
        onInvoke: (_) {
          _openFolder();
          return null;
        },
      ),
      _PrevIntent: CallbackAction<_PrevIntent>(
        onInvoke: (_) {
          _prev();
          return null;
        },
      ),
      _NextIntent: CallbackAction<_NextIntent>(
        onInvoke: (_) {
          _next();
          return null;
        },
      ),
    };

    final layout = context.watch<PlayerUiLayoutState>();
    final policy = context.layoutPolicy;

    // Apply default right panel width from policy once on first build.
    if (!_layoutDefaultsApplied) {
      layout.setRightPanelWidthBounds(
        policy.minRightPaneWidth,
        policy.maxRightPaneWidth,
      );
      layout.setPanelWidth(policy.defaultRightPaneWidth);
      _layoutDefaultsApplied = true;
    }

    return Shortcuts(
      shortcuts: shortcuts,
      child: Actions(
        actions: actions,
        child: Focus(
          autofocus: true,
          child: ListenableBuilder(
            listenable: _fullscreenState,
            builder: (context, _) {
              final isFullscreen = _fullscreenState.isFullscreen;
              final showControls = _fullscreenState.controlsVisible;

              return Scaffold(
                body: Column(
                  children: <Widget>[
                    // Hide title bar in fullscreen
                    if (!isFullscreen || showControls)
                      AnimatedOpacity(
                        opacity: !isFullscreen || showControls ? 1.0 : 0.0,
                        duration: FullscreenState.controlsHideAnimationDuration,
                        child: _TopTitleBar(title: _windowTitle),
                      ),
                    Expanded(
                      child: GestureDetector(
                        onTap: isFullscreen
                            ? () => _fullscreenState.onUserInteraction()
                            : null,
                        child: MouseRegion(
                          onHover: isFullscreen
                              ? (_) => _fullscreenState.onUserInteraction()
                              : null,
                          child: policy.panelMode == RightPanelMode.docked
                              ? Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: _VideoPane(
                                        vidKey: videoKey,
                                        videoController: _videoController,
                                        title: _windowTitle,
                                        onOpenFile: _openFiles,
                                        onOpenFolder: _openFolder,
                                        onOpenSubtitle: _openSubtitleFile,
                                        onOpenAudio: _openAudioFile,
                                        onTakeScreenshot: _takeScreenshot,
                                        onCustomizeSubtitle: _customizeSubtitle,
                                        getSubtitleTracks: _getSubtitleTracks,
                                        getAudioTracks: _getAudioTracks,
                                        onSelectSubtitleTrack:
                                            _selectSubtitleTrack,
                                        onSelectAudioTrack: _selectAudioTrack,
                                        subtitleConfig: _subtitleConfig,
                                      ),
                                    ),
                                    if (layout.rightPanelVisible &&
                                        !isFullscreen &&
                                        policy.enablePanelResize)
                                      GestureDetector(
                                        onHorizontalDragStart: (details) {
                                          setState(
                                            () => _isResizingPanel = true,
                                          );
                                        },
                                        onHorizontalDragUpdate: (details) {
                                          layout.setPanelWidth(
                                            (layout.rightPanelWidth -
                                                details.delta.dx),
                                          );
                                        },
                                        onHorizontalDragEnd: (details) {
                                          setState(
                                            () => _isResizingPanel = false,
                                          );
                                        },
                                        child: Container(
                                          width: 4,
                                          color: Colors.transparent,
                                          child: MouseRegion(
                                            cursor:
                                                SystemMouseCursors.resizeColumn,
                                            child: Container(
                                              width: 2,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 1,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withValues(
                                                  alpha: 0.1,
                                                ),
                                                boxShadow: _isResizingPanel
                                                    ? [
                                                        BoxShadow(
                                                          color: AppTheme
                                                              .rightPaneBorderLeftAccent
                                                              .withValues(
                                                                alpha: 0.5,
                                                              ),
                                                          blurRadius: 4,
                                                        ),
                                                      ]
                                                    : null,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    if (layout.rightPanelVisible &&
                                        !isFullscreen)
                                      SizedBox(
                                        width: layout.rightPanelWidth,
                                        child: _RightPane(
                                          tab: layout.tab,
                                          onTabChanged: (t) => layout.setTab(t),
                                          browserDirectory: _browserDirectory,
                                          browserItems: _browserItems,
                                          playlist: _playlist,
                                          currentIndex: _currentIndex,
                                          onOpenFiles: _openFiles,
                                          onOpenFolder: _openFolder,
                                          onRefreshFolder:
                                              _refreshBrowserListing,
                                          onPlayFromBrowser: _playFromBrowser,
                                          onPlayIndex: _playIndex,
                                          onRemoveAt: (i) {
                                            setState(() {
                                              if (i < 0 ||
                                                  i >= _playlist.length)
                                                return;
                                              _playlist.removeAt(i);
                                              if (_playlist.isEmpty) {
                                                _currentIndex = -1;
                                              } else if (_currentIndex >=
                                                  _playlist.length) {
                                                _currentIndex =
                                                    _playlist.length - 1;
                                              } else if (i == _currentIndex) {
                                                _currentIndex = _currentIndex
                                                    .clamp(
                                                      0,
                                                      _playlist.length - 1,
                                                    );
                                              }
                                            });
                                          },
                                          onTogglePanel: () =>
                                              layout.togglePanel(),
                                          overlayMode: false,
                                        ),
                                      ),
                                    if (!layout.rightPanelVisible &&
                                        !isFullscreen)
                                      Container(
                                        width: 40,
                                        decoration: BoxDecoration(
                                          color: AppTheme.rightPaneBackground,
                                          border: Border(
                                            left: BorderSide(
                                              color: AppTheme
                                                  .rightPaneBorderLeftAccent
                                                  .withValues(alpha: 0.5),
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            const SizedBox(height: 8),
                                            Tooltip(
                                              message: 'Show Panel',
                                              child: InkWell(
                                                onTap: () {
                                                  layout.setPanelVisible(true);
                                                },
                                                child: Container(
                                                  width: 32,
                                                  height: 32,
                                                  decoration: BoxDecoration(
                                                    color: AppTheme
                                                        .tabPlaylistActive
                                                        .withValues(alpha: 0.2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          6,
                                                        ),
                                                    border: Border.all(
                                                      color: AppTheme
                                                          .tabPlaylistActive
                                                          .withValues(
                                                            alpha: 0.4,
                                                          ),
                                                    ),
                                                  ),
                                                  child: const Icon(
                                                    Icons.chevron_left_rounded,
                                                    size: 20,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                )
                              : Stack(
                                  children: <Widget>[
                                    Positioned.fill(
                                      child: _VideoPane(
                                        vidKey: videoKey,
                                        videoController: _videoController,
                                        title: _windowTitle,
                                        onOpenFile: _openFiles,
                                        onOpenFolder: _openFolder,
                                        onOpenSubtitle: _openSubtitleFile,
                                        onOpenAudio: _openAudioFile,
                                        onTakeScreenshot: _takeScreenshot,
                                        onCustomizeSubtitle: _customizeSubtitle,
                                        getSubtitleTracks: _getSubtitleTracks,
                                        getAudioTracks: _getAudioTracks,
                                        onSelectSubtitleTrack:
                                            _selectSubtitleTrack,
                                        onSelectAudioTrack: _selectAudioTrack,
                                        subtitleConfig: _subtitleConfig,
                                      ),
                                    ),
                                    if (layout.rightPanelVisible &&
                                        !isFullscreen)
                                      Positioned.fill(
                                        child: GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () =>
                                              layout.setPanelVisible(false),
                                          child: Container(
                                            color: Colors.black.withValues(
                                              alpha: 0.35,
                                            ),
                                          ),
                                        ),
                                      ),
                                    if (layout.rightPanelVisible &&
                                        !isFullscreen)
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        bottom: 0,
                                        child: SizedBox(
                                          width: layout.rightPanelWidth,
                                          child: _RightPane(
                                            tab: layout.tab,
                                            onTabChanged: (t) =>
                                                layout.setTab(t),
                                            browserDirectory: _browserDirectory,
                                            browserItems: _browserItems,
                                            playlist: _playlist,
                                            currentIndex: _currentIndex,
                                            onOpenFiles: _openFiles,
                                            onOpenFolder: _openFolder,
                                            onRefreshFolder:
                                                _refreshBrowserListing,
                                            onPlayFromBrowser: _playFromBrowser,
                                            onPlayIndex: _playIndex,
                                            onRemoveAt: (i) {
                                              setState(() {
                                                if (i < 0 ||
                                                    i >= _playlist.length)
                                                  return;
                                                _playlist.removeAt(i);
                                                if (_playlist.isEmpty) {
                                                  _currentIndex = -1;
                                                } else if (_currentIndex >=
                                                    _playlist.length) {
                                                  _currentIndex =
                                                      _playlist.length - 1;
                                                } else if (i == _currentIndex) {
                                                  _currentIndex = _currentIndex
                                                      .clamp(
                                                        0,
                                                        _playlist.length - 1,
                                                      );
                                                }
                                              });
                                            },
                                            onTogglePanel: () =>
                                                layout.togglePanel(),
                                            overlayMode: true,
                                          ),
                                        ),
                                      ),
                                    if (!layout.rightPanelVisible &&
                                        !isFullscreen)
                                      Positioned(
                                        top: 8,
                                        right: 4,
                                        child: Tooltip(
                                          message: 'Show Panel',
                                          child: InkWell(
                                            onTap: () =>
                                                layout.setPanelVisible(true),
                                            child: Container(
                                              width: 32,
                                              height: 32,
                                              decoration: BoxDecoration(
                                                color: AppTheme
                                                    .tabPlaylistActive
                                                    .withValues(alpha: 0.2),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                border: Border.all(
                                                  color: AppTheme
                                                      .tabPlaylistActive
                                                      .withValues(alpha: 0.4),
                                                ),
                                              ),
                                              child: const Icon(
                                                Icons.chevron_left_rounded,
                                                size: 20,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    if (policy.controlsLocation ==
                                        ControlsLocation.overlayOnVideo)
                                      AnimatedPositioned(
                                        duration: FullscreenState
                                            .controlsHideAnimationDuration,
                                        left: 0,
                                        right: 0,
                                        bottom: (!isFullscreen || showControls)
                                            ? 0
                                            : -120,
                                        child: AnimatedOpacity(
                                          opacity:
                                              (!isFullscreen || showControls)
                                              ? 1.0
                                              : 0.0,
                                          duration: FullscreenState
                                              .controlsHideAnimationDuration,
                                          child: _BottomControls(
                                            position: _position,
                                            duration: _duration,
                                            playing: _playing,
                                            volume: _volume,
                                            isDragging: _isDragging,
                                            dragValue: _dragValue,
                                            onDragStart: (v) => setState(() {
                                              _isDragging = true;
                                              _dragValue = v;
                                            }),
                                            onDragUpdate: (v) =>
                                                setState(() => _dragValue = v),
                                            onDragEnd: (v) async {
                                              setState(() {
                                                _isDragging = false;
                                                _dragValue = v;
                                              });
                                              await _seekToFraction(v);
                                            },
                                            onTogglePlayPause: _togglePlayPause,
                                            onPrev: _prev,
                                            onNext: _next,
                                            onOpenFiles: _openFiles,
                                            onOpenFolder: _openFolder,
                                            onToggleFullscreen:
                                                _toggleFullscreen,
                                            onSeekRelative: _seekRelative,
                                            onVolumeChanged: (v) {
                                              setState(() => _volume = v);
                                              _player.setVolume(v);
                                            },
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
                bottomNavigationBar:
                    (!isFullscreen &&
                        policy.controlsLocation == ControlsLocation.bottomBar)
                    ? _BottomControls(
                        position: _position,
                        duration: _duration,
                        playing: _playing,
                        volume: _volume,
                        isDragging: _isDragging,
                        dragValue: _dragValue,
                        onDragStart: (v) => setState(() {
                          _isDragging = true;
                          _dragValue = v;
                        }),
                        onDragUpdate: (v) => setState(() => _dragValue = v),
                        onDragEnd: (v) async {
                          setState(() {
                            _isDragging = false;
                            _dragValue = v;
                          });
                          await _seekToFraction(v);
                        },
                        onTogglePlayPause: _togglePlayPause,
                        onPrev: _prev,
                        onNext: _next,
                        onOpenFiles: _openFiles,
                        onOpenFolder: _openFolder,
                        onToggleFullscreen: _toggleFullscreen,
                        onSeekRelative: _seekRelative,
                        onVolumeChanged: (v) {
                          setState(() => _volume = v);
                          _player.setVolume(v);
                        },
                      )
                    : null,
              );
            },
          ),
        ),
      ),
    );
  }
}
