import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

import '../models/MediaEntry.dart';
import '../models/enums.dart';
import 'format.dart';
import 'theme.dart';
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

class PlayerHomePage extends StatefulWidget {
  const PlayerHomePage({super.key});

  @override
  State<PlayerHomePage> createState() => _PlayerHomePageState();
}

class _PlayerHomePageState extends State<PlayerHomePage> {
  late final Player _player;
  late final VideoController _videoController;

  final List<MediaEntry> _playlist = <MediaEntry>[];
  int _currentIndex = -1;

  RightTab _tab = RightTab.playlist;

  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _playing = false;
  double _volume = 80;

  bool _isDragging = false;
  double _dragValue = 0;

  // Right panel state
  bool _rightPanelVisible = true;
  double _rightPanelWidth = 360;
  bool _isResizingPanel = false;

  String? _browserDirectory;
  List<MediaEntry> _browserItems = const <MediaEntry>[];

  StreamSubscription<Duration>? _posSub;
  StreamSubscription<Duration>? _durSub;
  StreamSubscription<bool>? _playingSub;

  @override
  void initState() {
    super.initState();
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
  }

  @override
  void dispose() {
    _posSub?.cancel();
    _durSub?.cancel();
    _playingSub?.cancel();
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
      _tab = RightTab.playlist;
    });

    if (_currentIndex < 0 && _playlist.isNotEmpty) {
      await _playIndex(0);
    }
  }

  Future<void> _openFolder() async {
    final dir = await FilePicker.platform.getDirectoryPath();
    if (dir == null || dir.isEmpty) return;

    setState(() {
      _browserDirectory = dir;
      _tab = RightTab.browser;
    });

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
      _tab = RightTab.playlist;
      _currentIndex = _playlist.length - 1;
    });

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

  String get _windowTitle {
    if (_currentIndex >= 0 && _currentIndex < _playlist.length) {
      return '${_currentIndex + 1}/${_playlist.length}  ${_playlist[_currentIndex].title}';
    }
    return 'PotPlayer UI (Flutter)';
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

    return Shortcuts(
      shortcuts: shortcuts,
      child: Actions(
        actions: actions,
        child: Focus(
          autofocus: true,
          child: Scaffold(
            body: Column(
              children: <Widget>[
                _TopTitleBar(title: _windowTitle),
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: _VideoPane(
                          videoController: _videoController,
                          title: _windowTitle,
                        ),
                      ),
                      if (_rightPanelVisible)
                        GestureDetector(
                          onHorizontalDragStart: (details) {
                            setState(() => _isResizingPanel = true);
                          },
                          onHorizontalDragUpdate: (details) {
                            setState(() {
                              _rightPanelWidth =
                                  (_rightPanelWidth - details.delta.dx).clamp(
                                    280.0,
                                    600.0,
                                  );
                            });
                          },
                          onHorizontalDragEnd: (details) {
                            setState(() => _isResizingPanel = false);
                          },
                          child: Container(
                            width: 4,
                            color: Colors.transparent,
                            child: MouseRegion(
                              cursor: SystemMouseCursors.resizeColumn,
                              child: Container(
                                width: 2,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 1,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.1),
                                  boxShadow: _isResizingPanel
                                      ? [
                                          BoxShadow(
                                            color: AppTheme
                                                .rightPaneBorderLeftAccent
                                                .withValues(alpha: 0.5),
                                            blurRadius: 4,
                                          ),
                                        ]
                                      : null,
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (_rightPanelVisible)
                        SizedBox(
                          width: _rightPanelWidth,
                          child: _RightPane(
                            tab: _tab,
                            onTabChanged: (t) => setState(() => _tab = t),
                            browserDirectory: _browserDirectory,
                            browserItems: _browserItems,
                            playlist: _playlist,
                            currentIndex: _currentIndex,
                            onOpenFiles: _openFiles,
                            onOpenFolder: _openFolder,
                            onRefreshFolder: _refreshBrowserListing,
                            onPlayFromBrowser: _playFromBrowser,
                            onPlayIndex: _playIndex,
                            onRemoveAt: (i) {
                              setState(() {
                                if (i < 0 || i >= _playlist.length) return;
                                _playlist.removeAt(i);
                                if (_playlist.isEmpty) {
                                  _currentIndex = -1;
                                } else if (_currentIndex >= _playlist.length) {
                                  _currentIndex = _playlist.length - 1;
                                } else if (i == _currentIndex) {
                                  _currentIndex = _currentIndex.clamp(
                                    0,
                                    _playlist.length - 1,
                                  );
                                }
                              });
                            },
                            onTogglePanel: () {
                              setState(
                                () => _rightPanelVisible = !_rightPanelVisible,
                              );
                            },
                          ),
                        ),
                      if (!_rightPanelVisible)
                        Container(
                          width: 40,
                          decoration: BoxDecoration(
                            color: AppTheme.rightPaneBackground,
                            border: Border(
                              left: BorderSide(
                                color: AppTheme.rightPaneBorderLeftAccent
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
                                    setState(() => _rightPanelVisible = true);
                                  },
                                  child: Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: AppTheme.tabPlaylistActive
                                          .withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: AppTheme.tabPlaylistActive
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
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            bottomNavigationBar: _BottomControls(
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
              onSeekRelative: _seekRelative,
              onVolumeChanged: (v) {
                setState(() => _volume = v);
                _player.setVolume(v);
              },
            ),
          ),
        ),
      ),
    );
  }
}
