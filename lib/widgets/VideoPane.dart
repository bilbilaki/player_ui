part of '../ui/player_home_page.dart';

enum _DragType { none, brightness, volume, seek }

class _VideoPane extends StatefulWidget {
  const _VideoPane({
    required this.videoController,
    required this.title,
    required this.onOpenFile,
    required this.onOpenFolder,
    required this.onOpenSubtitle,
    required this.onOpenAudio,
    required this.onTakeScreenshot,
    required this.onCustomizeSubtitle,
    required this.getSubtitleTracks,
    required this.getAudioTracks,
    required this.onSelectSubtitleTrack,
    required this.onSelectAudioTrack,
    required this.subtitleConfig,
    required this.vidKey,
  });

  final VideoController videoController;
  final String title;
  final VoidCallback onOpenFile;
  final VoidCallback onOpenFolder;
  final VoidCallback onOpenSubtitle;
  final VoidCallback onOpenAudio;
  final VoidCallback onTakeScreenshot;
  final VoidCallback onCustomizeSubtitle;
  final List<SubtitleTrack> Function() getSubtitleTracks;
  final List<AudioTrack> Function() getAudioTracks;
  final Function(SubtitleTrack) onSelectSubtitleTrack;
  final Function(AudioTrack) onSelectAudioTrack;
  final SubtitleConfig subtitleConfig;
  final Key vidKey;

  @override
  State<_VideoPane> createState() => _VideoPaneState();
}

class _VideoPaneState extends State<_VideoPane> {
  _DragType _currentDragType = _DragType.none;
  double _dragValue = 0.0;
  Duration? _seekPreviewPosition;
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.videoPaneBackground,
      child: _ContextMenu(
        subWidget: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Video(
                key: widget.vidKey,
                controller: widget.videoController,
                controls: NoVideoControls,
                subtitleViewConfiguration: SubtitleViewConfiguration(
                  style: widget.subtitleConfig.toTextStyle(),
                  textAlign: widget.subtitleConfig.textAlign,
                  padding: widget.subtitleConfig.padding,
                ),
              ),
            ),
            Positioned.fill(
              child: GestureDetector(
                onVerticalDragStart: (details) {
                  final double screenWidth = MediaQuery.of(context).size.width;
                  final double tapPosition = details.globalPosition.dx;

                  setState(() {
                    _isDragging = true;
                    if (tapPosition < screenWidth / 2) {
                      _currentDragType = _DragType.brightness;
                    } else {
                      _currentDragType = _DragType.volume;
                    }
                  });
                },
                onVerticalDragUpdate: (details) async {
                  final double delta = details.primaryDelta ?? 0;

                  if (_currentDragType == _DragType.brightness) {
                    double currentBrightness = await ScreenBrightness().current;
                    double newBrightness = (currentBrightness - (delta / 300))
                        .clamp(0.0, 1.0);
                    await ScreenBrightness().setApplicationScreenBrightness(
                      newBrightness,
                    );
                    setState(() {
                      _dragValue = newBrightness * 100;
                    });
                  } else if (_currentDragType == _DragType.volume) {
                    double currentVol =
                        widget.videoController.player.state.volume;
                    double newVol = (currentVol - delta).clamp(0.0, 100.0);
                    await widget.videoController.player.setVolume(newVol);
                    setState(() {
                      _dragValue = newVol;
                    });
                  }
                },
                onVerticalDragEnd: (details) {
                  setState(() {
                    _isDragging = false;
                    _currentDragType = _DragType.none;
                  });
                },
                onHorizontalDragStart: (details) {
                  setState(() {
                    _isDragging = true;
                    _currentDragType = _DragType.seek;
                    _seekPreviewPosition =
                        widget.videoController.player.state.position;
                  });
                },
                onHorizontalDragUpdate: (details) {
                  final double delta = details.primaryDelta ?? 0;
                  final Duration totalDur =
                      widget.videoController.player.state.duration;

                  // More sensitive seeking: 1 pixel = 0.5 seconds
                  final double seekSeconds = delta * 0.5;

                  setState(() {
                    if (_seekPreviewPosition != null) {
                      final newPos =
                          _seekPreviewPosition! +
                          Duration(milliseconds: (seekSeconds * 1000).toInt());
                      // Clamp duration manually
                      if (newPos < Duration.zero) {
                        _seekPreviewPosition = Duration.zero;
                      } else if (newPos > totalDur) {
                        _seekPreviewPosition = totalDur;
                      } else {
                        _seekPreviewPosition = newPos;
                      }
                      _dragValue = _seekPreviewPosition!.inSeconds.toDouble();
                    }
                  });
                },
                onHorizontalDragEnd: (details) {
                  if (_seekPreviewPosition != null) {
                    widget.videoController.player.seek(_seekPreviewPosition!);
                  }
                  setState(() {
                    _isDragging = false;
                    _currentDragType = _DragType.none;
                    _seekPreviewPosition = null;
                  });
                },
                onDoubleTapDown: (details) {
                  final double screenWidth = MediaQuery.of(context).size.width;
                  if (details.globalPosition.dx < screenWidth / 2) {
                    final pos =
                        widget.videoController.player.state.position -
                        const Duration(seconds: 10);
                    widget.videoController.player.seek(pos);
                  } else {
                    final pos =
                        widget.videoController.player.state.position +
                        const Duration(seconds: 10);
                    widget.videoController.player.seek(pos);
                  }
                },
              ),
            ),
            // Visual feedback overlay
            if (_isDragging)
              Positioned.fill(
                child: Center(
                  child: AnimatedOpacity(
                    opacity: _isDragging ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.75),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: _buildDragIndicator(),
                    ),
                  ),
                ),
              ),
            Positioned(
              right: 12,
              bottom: 12,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => toggleFullScreen(context),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: EdgeInsets.all(AppTheme.spaceSOf(context)),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.fullscreen,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 12,
              top: 10,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppTheme.spaceLOf(context),
                  vertical: AppTheme.spaceSOf(context),
                ),
                decoration: AppTheme.videoPaneTitleDecoration,
                child: Text(
                  widget.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
          ],
        ),
        onOpenFile: widget.onOpenFile,
        onOpenFolder: widget.onOpenFolder,
        onOpenSubtitle: widget.onOpenSubtitle,
        onOpenAudio: widget.onOpenAudio,
        onTakeScreenshot: widget.onTakeScreenshot,
        onCustomizeSubtitle: widget.onCustomizeSubtitle,
        getSubtitleTracks: widget.getSubtitleTracks,
        getAudioTracks: widget.getAudioTracks,
        onSelectSubtitleTrack: widget.onSelectSubtitleTrack,
        onSelectAudioTrack: widget.onSelectAudioTrack,
      ),
    );
  }

  Widget _buildDragIndicator() {
    IconData icon;
    String text;

    switch (_currentDragType) {
      case _DragType.brightness:
        icon = Icons.brightness_6;
        text = '${_dragValue.toInt()}%';
        break;
      case _DragType.volume:
        icon = _dragValue > 0 ? Icons.volume_up : Icons.volume_off;
        text = '${_dragValue.toInt()}%';
        break;
      case _DragType.seek:
        icon = Icons.fast_forward;
        final duration = Duration(seconds: _dragValue.toInt());
        text = _formatDuration(duration);
        break;
      case _DragType.none:
        icon = Icons.help;
        text = '';
        break;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 48),
        const SizedBox(height: 8),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }
}
