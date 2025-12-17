part of '../ui/player_home_page.dart';

class _RightPane extends StatelessWidget {
  const _RightPane({
    required this.tab,
    required this.onTabChanged,
    required this.browserDirectory,
    required this.browserItems,
    required this.playlist,
    required this.currentIndex,
    required this.onOpenFiles,
    required this.onOpenFolder,
    required this.onRefreshFolder,
    required this.onPlayFromBrowser,
    required this.onPlayIndex,
    required this.onRemoveAt,
    required this.onTogglePanel,
  });

  final RightTab tab;
  final ValueChanged<RightTab> onTabChanged;

  final String? browserDirectory;
  final List<MediaEntry> browserItems;

  final List<MediaEntry> playlist;
  final int currentIndex;

  final VoidCallback onOpenFiles;
  final VoidCallback onOpenFolder;
  final VoidCallback onRefreshFolder;

  final ValueChanged<MediaEntry> onPlayFromBrowser;
  final ValueChanged<int> onPlayIndex;
  final ValueChanged<int> onRemoveAt;
  final VoidCallback onTogglePanel;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.rightPaneBackground,
      child: Column(
        children: <Widget>[
          RightTabs(tab: tab, onChanged: onTabChanged),
          _RightToolbar(
            tab: tab,
            browserDirectory: browserDirectory,
            onOpenFiles: onOpenFiles,
            onOpenFolder: onOpenFolder,
            onRefreshFolder: onRefreshFolder,
            onTogglePanel: onTogglePanel,
          ),
          const SizedBox(height: 4),
          Expanded(
            child: Container(
              decoration: AppTheme.rightPaneContentDecoration,
              child: tab == RightTab.browser
                  ? _BrowserList(
                      directory: browserDirectory,
                      items: browserItems,
                      onActivate: onPlayFromBrowser,
                    )
                  : _PlaylistList(
                      items: playlist,
                      currentIndex: currentIndex,
                      onActivateIndex: onPlayIndex,
                      onRemoveIndex: onRemoveAt,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
