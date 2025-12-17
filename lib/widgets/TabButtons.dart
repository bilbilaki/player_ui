part of '../ui/player_home_page.dart';

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.text,
    required this.selected,
    required this.selectedColor,
    required this.onTap,
  });

  final String text;
  final bool selected;
  final Color selectedColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: selected
            ? AppTheme.tabButtonSelectedDecoration(selectedColor)
            : AppTheme.tabButtonUnselectedDecoration,
        child: Text(
          text,
          style: selected
              ? AppTheme.tabButtonSelectedStyle
              : AppTheme.tabButtonUnselectedStyle,
        ),
      ),
    );
  }
}
