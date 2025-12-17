part of '../ui/player_home_page.dart';

class _TitleBarPill extends StatelessWidget {
  const _TitleBarPill({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppTheme.spaceSOf(context),
        vertical: AppTheme.spaceXSOf(context),
      ),
      decoration: AppTheme.titleBarPillDecoration,
      child: Text(text, style: AppTheme.titleBarPillStyle),
    );
  }
}
