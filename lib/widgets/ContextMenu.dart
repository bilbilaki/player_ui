part of '../ui/player_home_page.dart';

class _ContextMenu extends StatelessWidget {
  const _ContextMenu({
    required this.subWidget,
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

  final Widget subWidget;
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

  List<ContextMenuEntry> _buildMenuEntries() {
    final subtitleTracks = getSubtitleTracks();
    final audioTracks = getAudioTracks();

    // Build subtitle track menu items
    final subtitleTrackItems = <MenuItem>[
      MenuItem(
        label: const Text('No Subtitle'),
        value: 'subtitle_no',
        icon: const Icon(Icons.subtitles_off, size: 18),
        onSelected: (value) {
          onSelectSubtitleTrack(SubtitleTrack.no());
        },
      ),
      MenuItem(
        label: const Text('Auto'),
        value: 'subtitle_auto',
        icon: const Icon(Icons.auto_fix_high, size: 18),
        onSelected: (value) {
          onSelectSubtitleTrack(SubtitleTrack.auto());
        },
      ),
    ];

    // Add embedded subtitle tracks
    for (int i = 0; i < subtitleTracks.length; i++) {
      final track = subtitleTracks[i];
      final title = track.title?.isNotEmpty == true
          ? track.title!
          : 'Track ${i + 1}';
      final lang = track.language?.isNotEmpty == true
          ? ' (${track.language})'
          : '';

      subtitleTrackItems.add(
        MenuItem(
          label: Text('$title$lang'),
          value: 'subtitle_$i',
          icon: const Icon(Icons.subtitles, size: 18),
          onSelected: (value) {
            onSelectSubtitleTrack(track);
          },
        ),
      );
    }

    // Build audio track menu items
    final audioTrackItems = <MenuItem>[
      MenuItem(
        label: const Text('No Audio'),
        value: 'audio_no',
        icon: const Icon(Icons.volume_off, size: 18),
        onSelected: (value) {
          onSelectAudioTrack(AudioTrack.no());
        },
      ),
      MenuItem(
        label: const Text('Auto'),
        value: 'audio_auto',
        icon: const Icon(Icons.auto_fix_high, size: 18),
        onSelected: (value) {
          onSelectAudioTrack(AudioTrack.auto());
        },
      ),
    ];

    // Add embedded audio tracks
    for (int i = 0; i < audioTracks.length; i++) {
      final track = audioTracks[i];
      final title = track.title?.isNotEmpty == true
          ? track.title!
          : 'Track ${i + 1}';
      final lang = track.language?.isNotEmpty == true
          ? ' (${track.language})'
          : '';

      audioTrackItems.add(
        MenuItem(
          label: Text('$title$lang'),
          value: 'audio_$i',
          icon: const Icon(Icons.audiotrack, size: 18),
          onSelected: (value) {
            onSelectAudioTrack(track);
          },
        ),
      );
    }

    return <ContextMenuEntry>[
      const MenuHeader(text: "Media Player"),
      MenuItem(
        label: const Text('Open File'),
        icon: const Icon(Icons.insert_drive_file, size: 18),
        onSelected: (value) {
          onOpenFile();
        },
      ),
      MenuItem(
        label: const Text('Open Folder'),
        icon: const Icon(Icons.folder_open, size: 18),
        onSelected: (value) {
          onOpenFolder();
        },
      ),
      const MenuDivider(),
      MenuItem.submenu(
        label: const Text('Subtitle'),
        icon: const Icon(Icons.closed_caption, size: 18),
        items: [
          MenuItem(
            label: const Text('Open Subtitle File'),
            value: 'open_subtitle',
            icon: const Icon(Icons.file_open, size: 18),
            onSelected: (value) {
              onOpenSubtitle();
            },
          ),
          if (subtitleTrackItems.isNotEmpty) const MenuDivider(),
          if (subtitleTrackItems.isNotEmpty)
            MenuItem.submenu(
              label: const Text('Choose Subtitle Track'),
              icon: const Icon(Icons.list, size: 18),
              items: subtitleTrackItems,
            ),
          const MenuDivider(),
          MenuItem(
            label: const Text('Customize Subtitle'),
            value: 'customize_subtitle',
            icon: const Icon(Icons.settings, size: 18),
            onSelected: (value) {
              onCustomizeSubtitle();
            },
          ),
        ],
      ),
      MenuItem.submenu(
        label: const Text('Audio'),
        icon: const Icon(Icons.audiotrack, size: 18),
        items: [
          MenuItem(
            label: const Text('Open Audio File'),
            value: 'open_audio',
            icon: const Icon(Icons.file_open, size: 18),
            onSelected: (value) {
              onOpenAudio();
            },
          ),
          if (audioTrackItems.isNotEmpty) const MenuDivider(),
          if (audioTrackItems.isNotEmpty)
            MenuItem.submenu(
              label: const Text('Choose Audio Track'),
              icon: const Icon(Icons.list, size: 18),
              items: audioTrackItems,
            ),
        ],
      ),
      const MenuDivider(),
      MenuItem(
        label: const Text('Take Screenshot'),
        icon: const Icon(Icons.camera_alt, size: 18),
        onSelected: (value) {
          onTakeScreenshot();
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ContextMenuRegion(
      contextMenu: ContextMenu(
        entries: _buildMenuEntries(),
        padding: const EdgeInsets.all(8.0),
      ),
      onItemSelected: (value) {
        debugPrint('Context menu item selected: $value');
      },
      child: subWidget,
    );
  }
}
