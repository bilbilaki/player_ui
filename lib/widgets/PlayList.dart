part of '../ui/player_home_page.dart';

class _PlaylistList extends StatelessWidget {
  const _PlaylistList({
    required this.items,
    required this.currentIndex,
    required this.onActivateIndex,
    required this.onRemoveIndex,
  });

  final List<MediaEntry> items;
  final int currentIndex;
  final ValueChanged<int> onActivateIndex;
  final ValueChanged<int> onRemoveIndex;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const _EmptyHint(
        title: 'Playlist is empty',
        body: 'Add files with the + button (Ctrl+O).',
      );
    }

    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, __) => Divider(
        height: AppTheme.spaceXSOf(context) / 2,
        thickness: AppTheme.spaceXSOf(context) / 4,
        color: Colors.black.withValues(alpha: 0.18),
      ),
      itemBuilder: (context, i) {
        final entry = items[i];
        final selected = i == currentIndex;
        return _ListRow(
          leading: Icon(
            selected ? Icons.play_arrow_rounded : Icons.play_arrow_outlined,
            size: 18,
            color: selected ? AppTheme.playlistCurrentIndicator : null,
          ),
          title: '${(i + 1).toString().padLeft(3, '0')}.  ${entry.title}',
          subtitle: null,
          selected: selected,
          accent: AppTheme.playlistAccent,
          trailing: const Icon(Icons.close_rounded, size: 16),
          onTap: () => onActivateIndex(i),
          onTrailingTap: () => onRemoveIndex(i),
        );
      },
    );
  }
}
