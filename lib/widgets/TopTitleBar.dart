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
            width: AppTheme.iconMediumOf(context),
            height: AppTheme.iconMediumOf(context),
            decoration: AppTheme.titleBarIconBoxDecoration,
            child: Icon(
              Icons.play_arrow_rounded,
              size: AppTheme.iconSmallOf(context),
            ),
          ),
          SizedBox(width: AppTheme.spaceLOf(context)),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTheme.titleBarTitleStyle,
            ),
          ),
          SizedBox(width: AppTheme.spaceLOf(context)),
          _TitleBarPill(text: 'SW'),
          SizedBox(width: AppTheme.spaceSOf(context)),
          _TitleBarPill(text: 'AVC1'),
          SizedBox(width: AppTheme.spaceSOf(context)),
          _TitleBarPill(text: 'AAC'),
        ],
      ),
    );
  }
}
