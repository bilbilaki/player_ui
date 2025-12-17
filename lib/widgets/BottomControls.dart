part of '../ui/player_home_page.dart';

class _BottomControls extends StatefulWidget {
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
  State<_BottomControls> createState() => _BottomControlsState();
}

enum _MoreAction { openFiles, openFolder, seekBack10, seekForward10 }

class _BottomControlsState extends State<_BottomControls> {
  bool _volumeExpanded = false;

  @override
  Widget build(BuildContext context) {
    final fraction = widget.duration.inMilliseconds <= 0
        ? 0.0
        : (widget.position.inMilliseconds / widget.duration.inMilliseconds)
              .clamp(0.0, 1.0);
    final effective = widget.isDragging ? widget.dragValue : fraction;

    final left = widget.isDragging && widget.duration > Duration.zero
        ? Duration(
            milliseconds: (widget.duration.inMilliseconds * effective).round(),
          )
        : widget.position;

    final sizeClass = context.windowSizeClass;
    final isCompact = sizeClass == WindowSizeClass.compact;
    final showSeekInline = !isCompact;
    final showMoreMenu = isCompact;
    final volumeExpanded = !isCompact || _volumeExpanded;

    return Container(
      height: AppTheme.bottomControlsHeightOf(context),
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
                SizedBox(width: AppTheme.spaceLOf(context)),
                Expanded(
                  child: SliderTheme(
                    data: AppTheme.getSliderThemeData(context),
                    child: Slider(
                      value: effective,
                      onChangeStart: widget.onDragStart,
                      onChanged: widget.onDragUpdate,
                      onChangeEnd: widget.onDragEnd,
                    ),
                  ),
                ),
                SizedBox(width: AppTheme.spaceLOf(context)),
                Text(
                  formatDuration(widget.duration),
                  style: AppTheme.bottomControlsTimeStyle,
                ),
              ],
            ),
          ),
          SizedBox(height: AppTheme.spaceXSOf(context)),
          Expanded(
            child: Padding(
              padding: AppTheme.bottomControlsPadding,
              child: Row(
                children: <Widget>[
                  _CtlButton(
                    icon: Icons.skip_previous_rounded,
                    tooltip: 'Prev (PgUp)',
                    onTap: widget.onPrev,
                  ),
                  SizedBox(width: AppTheme.spaceSOf(context)),
                  _CtlButton(
                    icon: widget.playing
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                    tooltip: 'Play/Pause (Space)',
                    big: true,
                    onTap: widget.onTogglePlayPause,
                  ),
                  SizedBox(width: AppTheme.spaceSOf(context)),
                  _CtlButton(
                    icon: Icons.skip_next_rounded,
                    tooltip: 'Next (PgDn)',
                    onTap: widget.onNext,
                  ),
                  if (showSeekInline) ...[
                    SizedBox(width: AppTheme.spaceLOf(context)),
                    _CtlButton(
                      icon: Icons.replay_10_rounded,
                      tooltip: 'Seek -10s',
                      onTap: () =>
                          widget.onSeekRelative(const Duration(seconds: -10)),
                    ),
                    SizedBox(width: AppTheme.spaceSOf(context)),
                    _CtlButton(
                      icon: Icons.forward_10_rounded,
                      tooltip: 'Seek +10s',
                      onTap: () =>
                          widget.onSeekRelative(const Duration(seconds: 10)),
                    ),
                  ],
                  if (!showSeekInline)
                    SizedBox(width: AppTheme.spaceLOf(context)),
                  if (showMoreMenu)
                    _MoreMenuButton(
                      onSelected: (a) {
                        switch (a) {
                          case _MoreAction.openFiles:
                            widget.onOpenFiles();
                            break;
                          case _MoreAction.openFolder:
                            widget.onOpenFolder();
                            break;
                          case _MoreAction.seekBack10:
                            widget.onSeekRelative(const Duration(seconds: -10));
                            break;
                          case _MoreAction.seekForward10:
                            widget.onSeekRelative(const Duration(seconds: 10));
                            break;
                        }
                      },
                    )
                  else ...[
                    SizedBox(width: AppTheme.spaceMOf(context)),
                    _CtlButton(
                      icon: Icons.add_rounded,
                      tooltip: 'Open files (Ctrl+O)',
                      onTap: widget.onOpenFiles,
                    ),
                    SizedBox(width: AppTheme.spaceSOf(context)),
                    _CtlButton(
                      icon: Icons.folder_open_rounded,
                      tooltip: 'Open folder (Ctrl+F)',
                      onTap: widget.onOpenFolder,
                    ),
                  ],
                  const Spacer(),
                  if (volumeExpanded) ...[
                    _CtlButton(
                      icon: Icons.volume_up_rounded,
                      tooltip: 'Volume',
                      onTap: isCompact
                          ? () => setState(() => _volumeExpanded = false)
                          : () {},
                    ),
                    SizedBox(
                      width: AppTheme.volumeSliderWidthOf(context),
                      child: SliderTheme(
                        data: AppTheme.getSliderThemeData(context),
                        child: Slider(
                          value: widget.volume.clamp(0, 100),
                          min: 0,
                          max: 100,
                          onChanged: widget.onVolumeChanged,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: AppTheme.volumeDisplayWidthOf(context),
                      child: Text(
                        widget.volume.round().toString(),
                        textAlign: TextAlign.right,
                        style: AppTheme.bottomControlsVolumeStyle,
                      ),
                    ),
                  ] else ...[
                    _CtlButton(
                      icon: Icons.volume_up_rounded,
                      tooltip: 'Volume',
                      onTap: () => setState(() => _volumeExpanded = true),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MoreMenuButton extends StatelessWidget {
  const _MoreMenuButton({required this.onSelected});

  final ValueChanged<_MoreAction> onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_MoreAction>(
      onSelected: onSelected,
      itemBuilder: (context) => <PopupMenuEntry<_MoreAction>>[
        const PopupMenuItem<_MoreAction>(
          value: _MoreAction.openFiles,
          child: ListTile(
            leading: Icon(Icons.add_rounded),
            title: Text('Open files'),
          ),
        ),
        const PopupMenuItem<_MoreAction>(
          value: _MoreAction.openFolder,
          child: ListTile(
            leading: Icon(Icons.folder_open_rounded),
            title: Text('Open folder'),
          ),
        ),
        const PopupMenuItem<_MoreAction>(
          value: _MoreAction.seekBack10,
          child: ListTile(
            leading: Icon(Icons.replay_10_rounded),
            title: Text('Seek -10s'),
          ),
        ),
        const PopupMenuItem<_MoreAction>(
          value: _MoreAction.seekForward10,
          child: ListTile(
            leading: Icon(Icons.forward_10_rounded),
            title: Text('Seek +10s'),
          ),
        ),
      ],
      child: Container(
        width: AppTheme.controlButtonSizeSmallOf(context),
        height: AppTheme.controlButtonSizeSmallOf(context),
        decoration: AppTheme.controlButtonDecoration,
        child: Icon(
          Icons.more_horiz_rounded,
          size: AppTheme.controlIconSizeSmallOf(context),
          color: AppTheme.bottomBarControlText,
        ),
      ),
    );
  }
}
