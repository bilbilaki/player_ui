part of '../ui/player_home_page.dart';

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
  double _startVolume = 0.0;
  double _startBrightness = 0.0;
  bool _isVolumeControl = false;
  Duration _seekStartPosition = Duration.zero;

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
                behavior: HitTestBehavior.translucent,
                onVerticalDragStart: (details) async {
                  final double screenWidth = MediaQuery.of(context).size.width;
                  if (details.globalPosition.dx < screenWidth / 2) {
                    // Left side: Brightness
                    _isVolumeControl = false;
                    _startBrightness = await ScreenBrightness().current;
                  } else {
                    // Right side: Volume
                    _isVolumeControl = true;
                    _startVolume = widget.videoController.player.state.volume;
                  }
                },
                onVerticalDragUpdate: (details) {
                  final double delta = details.primaryDelta ?? 0;
                  const double sensitivity = 1.0;

                  if (!_isVolumeControl) {
                    // Brightness control (left side)
                    double newBrightness =
                        (_startBrightness - (delta / 300) * sensitivity).clamp(
                          0.0,
                          1.0,
                        );
                    ScreenBrightness().setApplicationScreenBrightness(
                      newBrightness,
                    );
                    _startBrightness = newBrightness;
                  } else {
                    // Volume control (right side)
                    double newVol = (_startVolume - (delta * sensitivity))
                        .clamp(0.0, 100.0);
                    widget.videoController.player.setVolume(newVol);
                    _startVolume = newVol;
                  }
                },
                onHorizontalDragStart: (details) {
                  _seekStartPosition =
                      widget.videoController.player.state.position;
                },
                onHorizontalDragUpdate: (details) {
                  final Duration totalDur =
                      widget.videoController.player.state.duration;
                  final double seekSeconds = (details.primaryDelta ?? 0) / 5;

                  final Duration newPos =
                      _seekStartPosition +
                      Duration(seconds: seekSeconds.toInt());

                  if (newPos >= Duration.zero && newPos <= totalDur) {
                    widget.videoController.player.seek(newPos);
                    _seekStartPosition = newPos;
                  }
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
            Positioned(
              left: 12,
              bottom: 10,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppTheme.spaceSOf(context),
                  vertical: AppTheme.spaceXSOf(context),
                ),
                decoration: AppTheme.videoPaneOverlayDecoration,
                child: const Text('', style: AppTheme.videoPaneWatermarkStyle),
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
}
