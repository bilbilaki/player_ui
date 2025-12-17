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
    this.overlayMode = false,
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
  final bool overlayMode;

  @override
  Widget build(BuildContext context) {
    final BoxDecoration contentDecoration = overlayMode
        ? BoxDecoration(
            color: AppTheme.rightTabsBackground.withValues(alpha: 0.96),
            border: Border(
              left: BorderSide(
                width: AppTheme.spaceXSOf(context) / 2,
                color: AppTheme.rightPaneBorderLeftAccent,
              ),
              right: BorderSide(
                width: AppTheme.spaceXSOf(context) / 2,
                color: AppTheme.rightPaneBorderLeftAccent,
              ),
              bottom: BorderSide(
                width: AppTheme.spaceXSOf(context) / 2,
                color: AppTheme.rightPaneBorderBottomAccent,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.45),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          )
        : AppTheme.rightPaneContentDecoration;

    return Container(
      color: overlayMode
          ? AppTheme.rightPaneBackground.withValues(alpha: 0.88)
          : AppTheme.rightPaneBackground,
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
          SizedBox(height: AppTheme.spaceSOf(context)),
          Expanded(
            child: Container(
              decoration: contentDecoration,
              child: tab == RightTab.browser
                  ? _BrowserList(
                      directory: browserDirectory,
                      items: browserItems,
                      onActivate: (entry) {
                        onPlayFromBrowser(entry);
                        if (overlayMode) {
                          onTogglePanel();
                        }
                      },
                    )
                  : _PlaylistList(
                      items: playlist,
                      currentIndex: currentIndex,
                      onActivateIndex: (i) {
                        onPlayIndex(i);
                        if (overlayMode) {
                          onTogglePanel();
                        }
                      },
                      onRemoveIndex: onRemoveAt,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
