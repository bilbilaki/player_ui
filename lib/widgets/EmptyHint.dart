part of '../ui/player_home_page.dart';

class _EmptyHint extends StatelessWidget {
  const _EmptyHint({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(title, style: AppTheme.emptyStateTitleStyle),
            const SizedBox(height: 10),
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
