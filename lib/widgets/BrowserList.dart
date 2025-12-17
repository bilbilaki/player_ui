part of '../ui/player_home_page.dart';

class _BrowserList extends StatelessWidget {
  const _BrowserList({
    required this.directory,
    required this.items,
    required this.onActivate,
  });

  final String? directory;
  final List<MediaEntry> items;
  final ValueChanged<MediaEntry> onActivate;

  @override
  Widget build(BuildContext context) {
    if (directory == null) {
      return _EmptyHint(
        title: 'Browser',
        body:
            'Pick a folder to browse local media files.\nUse the folder button above (Ctrl+F).',
      );
    }

    if (items.isEmpty) {
      return const _EmptyHint(
        title: 'No media found',
        body:
            'This folder has no supported files (mkv/mp4/webm/avi/mov + common audio).',
      );
    }

    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, __) => Divider(
        height: 1,
        thickness: 1,
        color: Colors.black.withValues(alpha: 0.18),
      ),
      itemBuilder: (context, i) {
        final entry = items[i];
        return _ListRow(
          leading: const Icon(Icons.play_arrow_rounded, size: 18),
          title: entry.title,
          subtitle: null,
          selected: false,
          accent: AppTheme.browserListAccent,
          trailing: const Icon(Icons.add_rounded, size: 18),
          onTap: () => onActivate(entry),
        );
      },
    );
  }
}
