part of '../ui/player_home_page.dart';

class _CtlButton extends StatelessWidget {
  const _CtlButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.big = false,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final bool big;

  @override
  Widget build(BuildContext context) {
    final size = big
        ? AppTheme.controlButtonSizeLarge
        : AppTheme.controlButtonSizeSmall;
    final iconSize = big
        ? AppTheme.controlIconSizeLarge
        : AppTheme.controlIconSizeSmall;
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: size,
          height: size,
          decoration: AppTheme.controlButtonDecoration,
          child: Icon(
            icon,
            size: iconSize,
            color: AppTheme.bottomBarControlText,
          ),
        ),
      ),
    );
  }
}
