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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.videoPaneBackground,
      child: _ContextMenu(
        subWidget: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Video(
                controller: videoController,
                controls: NoVideoControls,
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
