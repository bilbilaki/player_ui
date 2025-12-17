part of '../ui/player_home_page.dart';

class _RightToolbar extends StatelessWidget {
  const _RightToolbar({
    required this.tab,
    required this.browserDirectory,
    required this.onOpenFiles,
    required this.onOpenFolder,
    required this.onRefreshFolder,
    required this.onTogglePanel,
  });

  final RightTab tab;
  final String? browserDirectory;
  final VoidCallback onOpenFiles;
  final VoidCallback onOpenFolder;
  final VoidCallback onRefreshFolder;
  final VoidCallback onTogglePanel;

  @override
  Widget build(BuildContext context) {
    final label = tab == RightTab.browser
        ? (browserDirectory == null ? 'Default' : browserDirectory!)
        : 'Playlist';

    return Container(
      height: AppTheme.spaceMOf(context) + AppTheme.spaceLOf(context) + 6,
      padding: AppTheme.rightPanePadding,
      decoration: AppTheme.rightTabsToolbarDecoration,
      child: Row(
        children: <Widget>[
          IconButton(
            tooltip: 'Hide Panel',
            onPressed: onTogglePanel,
            icon: Icon(
              Icons.chevron_right_rounded,
              size: AppTheme.iconMediumOf(context),
            ),
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(
              minWidth: AppTheme.controlButtonSizeSmallOf(context),
              minHeight: AppTheme.controlButtonSizeSmallOf(context),
            ),
          ),
          SizedBox(width: AppTheme.spaceXSOf(context)),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTheme.rightPaneToolbarLabelStyle,
            ),
          ),
          IconButton(
            tooltip: 'Open files  (Ctrl+O)',
            onPressed: onOpenFiles,
            icon: Icon(
              Icons.add_box_rounded,
              size: AppTheme.iconMediumOf(context),
            ),
          ),
          if (tab == RightTab.browser)
            IconButton(
              tooltip: 'Open folder  (Ctrl+F)',
              onPressed: onOpenFolder,
              icon: Icon(
                Icons.folder_open_rounded,
                size: AppTheme.iconMediumOf(context),
              ),
            ),
          if (tab == RightTab.browser)
            IconButton(
              tooltip: 'Refresh folder',
              onPressed: onRefreshFolder,
              icon: Icon(
                Icons.refresh_rounded,
                size: AppTheme.iconMediumOf(context),
              ),
            ),
        ],
      ),
    );
  }
}
