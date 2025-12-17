part of '../ui/player_home_page.dart';

class _VideoPane extends StatelessWidget {
  const _VideoPane({required this.videoController, required this.title});

  final VideoController videoController;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.videoPaneBackground,
      child: Stack(
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
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: AppTheme.videoPaneOverlayDecoration,
              child: const Text('', style: AppTheme.videoPaneWatermarkStyle),
            ),
          ),
          Positioned(
            left: 12,
            top: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
    );
  }
}
