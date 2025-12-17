part of '../ui/player_home_page.dart';

class _TopTitleBar extends StatelessWidget {
  const _TopTitleBar({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppTheme.titleBarHeight,
      decoration: AppTheme.titleBarDecoration,
      padding: AppTheme.titleBarPadding,
      child: Row(
        children: <Widget>[
          Container(
            width: 18,
            height: 18,
            decoration: AppTheme.titleBarIconBoxDecoration,
            child: const Icon(Icons.play_arrow_rounded, size: 14),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTheme.titleBarTitleStyle,
            ),
          ),
          const SizedBox(width: 8),
          _TitleBarPill(text: 'SW'),
          const SizedBox(width: 6),
          _TitleBarPill(text: 'AVC1'),
          const SizedBox(width: 6),
          _TitleBarPill(text: 'AAC'),
        ],
      ),
    );
  }
}
