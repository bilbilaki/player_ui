part of '../ui/player_home_page.dart';

class _TitleBarPill extends StatelessWidget {
  const _TitleBarPill({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: AppTheme.titleBarPillDecoration,
      child: Text(text, style: AppTheme.titleBarPillStyle),
    );
  }
}
