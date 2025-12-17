part of '../ui/player_home_page.dart';

class _BottomControls extends StatelessWidget {
  const _BottomControls({
    required this.position,
    required this.duration,
    required this.playing,
    required this.volume,
    required this.isDragging,
    required this.dragValue,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
    required this.onTogglePlayPause,
    required this.onPrev,
    required this.onNext,
    required this.onOpenFiles,
    required this.onOpenFolder,
    required this.onSeekRelative,
    required this.onVolumeChanged,
  });

  final Duration position;
  final Duration duration;
  final bool playing;
  final double volume;

  final bool isDragging;
  final double dragValue;
  final ValueChanged<double> onDragStart;
  final ValueChanged<double> onDragUpdate;
  final ValueChanged<double> onDragEnd;

  final VoidCallback onTogglePlayPause;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  final VoidCallback onOpenFiles;
  final VoidCallback onOpenFolder;

  final ValueChanged<Duration> onSeekRelative;
  final ValueChanged<double> onVolumeChanged;

  @override
  Widget build(BuildContext context) {
    final fraction = duration.inMilliseconds <= 0
        ? 0.0
        : (position.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0);
    final effective = isDragging ? dragValue : fraction;

    final left = isDragging && duration > Duration.zero
        ? Duration(milliseconds: (duration.inMilliseconds * effective).round())
        : position;

    return Container(
      height: AppTheme.bottomControlsHeight,
      decoration: AppTheme.bottomBarDecoration,
      child: Column(
        children: <Widget>[
          Padding(
            padding: AppTheme.bottomControlsPadding,
            child: Row(
              children: <Widget>[
                Text(
                  formatDuration(left),
                  style: AppTheme.bottomControlsTimeStyle,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SliderTheme(
                    data: AppTheme.getSliderThemeData(context),
                    child: Slider(
                      value: effective,
                      onChangeStart: onDragStart,
                      onChanged: onDragUpdate,
                      onChangeEnd: onDragEnd,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  formatDuration(duration),
                  style: AppTheme.bottomControlsTimeStyle,
                ),
              ],
            ),
          ),
          const SizedBox(height: 2),
          Expanded(
            child: Padding(
              padding: AppTheme.bottomControlsPadding,
              child: Row(
                children: <Widget>[
                  _CtlButton(
                    icon: Icons.skip_previous_rounded,
                    tooltip: 'Prev (PgUp)',
                    onTap: onPrev,
                  ),
                  const SizedBox(width: 6),
                  _CtlButton(
                    icon: playing
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                    tooltip: 'Play/Pause (Space)',
                    big: true,
                    onTap: onTogglePlayPause,
                  ),
                  const SizedBox(width: 6),
                  _CtlButton(
                    icon: Icons.skip_next_rounded,
                    tooltip: 'Next (PgDn)',
                    onTap: onNext,
                  ),
                  const SizedBox(width: 10),
                  _CtlButton(
                    icon: Icons.replay_10_rounded,
                    tooltip: 'Seek -10s',
                    onTap: () => onSeekRelative(const Duration(seconds: -10)),
                  ),
                  const SizedBox(width: 6),
                  _CtlButton(
                    icon: Icons.forward_10_rounded,
                    tooltip: 'Seek +10s',
                    onTap: () => onSeekRelative(const Duration(seconds: 10)),
                  ),
                  const SizedBox(width: 12),
                  _CtlButton(
                    icon: Icons.add_rounded,
                    tooltip: 'Open files (Ctrl+O)',
                    onTap: onOpenFiles,
                  ),
                  const SizedBox(width: 6),
                  _CtlButton(
                    icon: Icons.folder_open_rounded,
                    tooltip: 'Open folder (Ctrl+F)',
                    onTap: onOpenFolder,
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.volume_up_rounded,
                    color: AppTheme.bottomBarControlText,
                  ),
                  SizedBox(
                    width: AppTheme.volumeSliderWidth,
                    child: SliderTheme(
                      data: AppTheme.getSliderThemeData(context),
                      child: Slider(
                        value: volume.clamp(0, 100),
                        min: 0,
                        max: 100,
                        onChanged: onVolumeChanged,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: AppTheme.volumeDisplayWidth,
                    child: Text(
                      volume.round().toString(),
                      textAlign: TextAlign.right,
                      style: AppTheme.bottomControlsVolumeStyle,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
