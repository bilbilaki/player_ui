part of '../ui/player_home_page.dart';

class RightTabs extends StatelessWidget {
  const RightTabs({super.key, required this.tab, required this.onChanged});

  final RightTab tab;
  final ValueChanged<RightTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: Row(
        children: <Widget>[
          Expanded(
            child: _TabButton(
              text: 'Browser',
              selected: tab == RightTab.browser,
              selectedColor: AppTheme.tabBrowserActive,
              onTap: () => onChanged(RightTab.browser),
            ),
          ),
          Expanded(
            child: _TabButton(
              text: 'Playlist',
              selected: tab == RightTab.playlist,
              selectedColor: AppTheme.tabPlaylistActive,
              onTap: () => onChanged(RightTab.playlist),
            ),
          ),
        ],
      ),
    );
  }
}
