part of '../ui/player_home_page.dart';

class _ListRow extends StatelessWidget {
  const _ListRow({
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.accent,
    required this.trailing,
    required this.onTap,
    this.onTrailingTap,
  });

  final Widget leading;
  final String title;
  final String? subtitle;
  final bool selected;
  final Color accent;
  final Widget trailing;
  final VoidCallback onTap;
  final VoidCallback? onTrailingTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: AppTheme.listRowHeightOf(context),
        padding: EdgeInsets.symmetric(horizontal: AppTheme.spaceLOf(context)),
        decoration: selected
            ? AppTheme.listItemSelectedDecoration(accent)
            : const BoxDecoration(),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: AppTheme.iconSmallOf(context),
              child: Center(child: leading),
            ),
            SizedBox(width: AppTheme.spaceMOf(context)),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: selected
                        ? AppTheme.listItemTitleSelectedStyle
                        : AppTheme.listItemTitleStyle,
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTheme.listItemSubtitleStyle,
                    ),
                ],
              ),
            ),
            InkWell(
              onTap: onTrailingTap ?? onTap,
              child: Padding(
                padding: EdgeInsets.all(AppTheme.spaceSOf(context)),
                child: IconTheme(
                  data: IconThemeData(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                  child: trailing,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
