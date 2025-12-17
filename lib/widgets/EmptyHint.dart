part of '../ui/player_home_page.dart';

class _EmptyHint extends StatelessWidget {
  const _EmptyHint({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppTheme.spaceLOf(context) + 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(title, style: AppTheme.emptyStateTitleStyle),
            SizedBox(height: AppTheme.spaceLOf(context)),
            Text(
              body,
              textAlign: TextAlign.center,
              style: AppTheme.emptyStateBodyStyle,
            ),
          ],
        ),
      ),
    );
  }
}
