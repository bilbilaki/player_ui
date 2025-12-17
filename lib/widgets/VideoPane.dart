part of '../ui/player_home_page.dart';

class _VideoPane extends StatelessWidget {
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
    required this.vidKey
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
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.videoPaneBackground,
      child: _ContextMenu(
        subWidget: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Video(
                key: vidKey,
                controller: videoController,
                controls: NoVideoControls,
                subtitleViewConfiguration: SubtitleViewConfiguration(
                  style: subtitleConfig.toTextStyle(),
                  textAlign: subtitleConfig.textAlign,
                  padding: subtitleConfig.padding,
                ),
              ),
            ),
            Positioned.fill(
      child: GestureDetector(
        onVerticalDragUpdate: (details) async {
          final double screenWidth = MediaQuery.of(context).size.width;
          final double tapPosition = details.globalPosition.dx;
          final double delta = details.primaryDelta ?? 0;

          const double sensitivity = 1.0; 

          if (tapPosition < screenWidth / 2) {
            double currentBrightness = await ScreenBrightness().current;
            double newBrightness = (currentBrightness - (delta / 300) * sensitivity).clamp(0.0, 1.0);
            await ScreenBrightness().setApplicationScreenBrightness(newBrightness);
          } else {
            double currentVol = videoController.player.state.volume;
            double newVol = (currentVol - (delta * sensitivity)).clamp(0.0, 100.0);
            await videoController.player.setVolume(newVol);
          }
        },
        onHorizontalDragUpdate: (details) {
          final Duration currentPos = videoController.player.state.position;
          final Duration totalDur = videoController.player.state.duration;
          
          final double seekSeconds = (details.primaryDelta ?? 0) / 5; 
          
          final Duration newPos = currentPos + Duration(seconds: seekSeconds.toInt());
          
          if (newPos >= Duration.zero && newPos <= totalDur) {
             videoController.player.seek(newPos);
          }
        },
        onDoubleTapDown: (details) {
             final double screenWidth = MediaQuery.of(context).size.width;
             if (details.globalPosition.dx < screenWidth / 2) {
                 final pos = videoController.player.state.position - const Duration(seconds: 10);
                 videoController.player.seek(pos);
             } else {
                 final pos = videoController.player.state.position + const Duration(seconds: 10);
                 videoController.player.seek(pos);
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
                child: 
                IconButton(onPressed: () => toggleFullScreen(), icon: Icon(
                  Icons.fullscreen,
                  color: AppTheme.videoPaneWatermarkColor,
                  size: 16,
                )),
              //  const Text('', style: AppTheme.videoPaneWatermarkStyle),
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
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
          ],
        ),
        onOpenFile: onOpenFile,
        onOpenFolder: onOpenFolder,
        onOpenSubtitle: onOpenSubtitle,
        onOpenAudio: onOpenAudio,
        onTakeScreenshot: onTakeScreenshot,
        onCustomizeSubtitle: onCustomizeSubtitle,
        getSubtitleTracks: getSubtitleTracks,
        getAudioTracks: getAudioTracks,
        onSelectSubtitleTrack: onSelectSubtitleTrack,
        onSelectAudioTrack: onSelectAudioTrack,
      ),
    );
  }
}
