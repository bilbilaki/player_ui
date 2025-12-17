part of '../ui/player_home_page.dart';

class _SubtitleCustomizerDialog extends StatefulWidget {
  final SubtitleConfig initialConfig;
  final Function(SubtitleConfig) onConfigChanged;

  const _SubtitleCustomizerDialog({
    required this.initialConfig,
    required this.onConfigChanged,
  });

  @override
  State<_SubtitleCustomizerDialog> createState() =>
      _SubtitleCustomizerDialogState();
}

class _SubtitleCustomizerDialogState extends State<_SubtitleCustomizerDialog> {
  late SubtitleConfig _config;

  @override
  void initState() {
    super.initState();
    _config = widget.initialConfig;
  }

  void _updateConfig(SubtitleConfig newConfig) {
    setState(() {
      _config = newConfig;
    });
    widget.onConfigChanged(newConfig);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = AdaptiveThemeTokens.forContext(context);

    return Dialog(
      backgroundColor: AppTheme.rightPaneBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: AppTheme.rightPaneBorderLeftAccent.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(tokens.spaceL),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    AppTheme.titleBarGradientStart,
                    AppTheme.titleBarGradientEnd,
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.subtitles_outlined,
                    color: AppTheme.textPrimary,
                    size: tokens.iconMedium,
                  ),
                  SizedBox(width: tokens.spaceM),
                  Text(
                    'Customize Subtitles',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: tokens.textLarge,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      size: tokens.iconMedium,
                      color: AppTheme.textPrimary,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(tokens.spaceL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Preview
                    _buildPreviewSection(tokens),
                    SizedBox(height: tokens.spaceXL),

                    // Font Size
                    _buildFontSizeSection(tokens),
                    SizedBox(height: tokens.spaceL),

                    // Text Color
                    _buildTextColorSection(tokens),
                    SizedBox(height: tokens.spaceL),

                    // Background Color
                    _buildBackgroundColorSection(tokens),
                    SizedBox(height: tokens.spaceL),

                    // Font Weight
                    _buildFontWeightSection(tokens),
                    SizedBox(height: tokens.spaceL),

                    // Text Alignment
                    _buildTextAlignmentSection(tokens),
                    SizedBox(height: tokens.spaceL),

                    // Advanced Settings
                    _buildAdvancedSection(tokens),
                  ],
                ),
              ),
            ),

            // Footer
            Container(
              padding: EdgeInsets.all(tokens.spaceL),
              decoration: BoxDecoration(
                color: AppTheme.rightTabsBackground,
                border: Border(
                  top: BorderSide(color: AppTheme.dividerLight, width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      _updateConfig(SubtitleConfig.defaultConfig);
                    },
                    child: Text(
                      'Reset to Default',
                      style: TextStyle(
                        color: AppTheme.tabBrowserActive,
                        fontSize: tokens.textMedium,
                      ),
                    ),
                  ),
                  SizedBox(width: tokens.spaceM),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.tabPlaylistActive,
                      foregroundColor: AppTheme.textSecondary,
                    ),
                    child: Text(
                      'Done',
                      style: TextStyle(fontSize: tokens.textMedium),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewSection(AdaptiveThemeTokens tokens) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Preview',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: tokens.textLarge,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: tokens.spaceM),
        Container(
          width: double.infinity,
          padding: _config.padding,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.rightPaneBorderLeftAccent.withValues(alpha: 0.3),
            ),
          ),
          child: Text(
            'Sample subtitle text',
            style: _config.toTextStyle(),
            textAlign: _config.textAlign,
          ),
        ),
      ],
    );
  }

  Widget _buildFontSizeSection(AdaptiveThemeTokens tokens) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Font Size',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: tokens.textMedium,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${_config.fontSize.toStringAsFixed(0)} px',
              style: TextStyle(
                color: AppTheme.tabPlaylistActive,
                fontSize: tokens.textMedium,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: tokens.spaceS),
        Slider(
          value: _config.fontSize,
          min: 12.0,
          max: 64.0,
          divisions: 52,
          activeColor: AppTheme.tabPlaylistActive,
          inactiveColor: AppTheme.bottomBarTrackActive,
          onChanged: (value) {
            _updateConfig(_config.copyWith(fontSize: value));
          },
        ),
      ],
    );
  }

  Widget _buildTextColorSection(AdaptiveThemeTokens tokens) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Text Color',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: tokens.textMedium,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: tokens.spaceM),
        Wrap(
          spacing: tokens.spaceM,
          runSpacing: tokens.spaceM,
          children: [
            _buildColorOption(const Color(0xFFFFFFFF), 'White', tokens),
            _buildColorOption(const Color(0xFFFFFF00), 'Yellow', tokens),
            _buildColorOption(const Color(0xFF00FF00), 'Green', tokens),
            _buildColorOption(const Color(0xFF00FFFF), 'Cyan', tokens),
            _buildColorOption(const Color(0xFFFF00FF), 'Magenta', tokens),
            _buildColorOption(const Color(0xFFFF0000), 'Red', tokens),
          ],
        ),
      ],
    );
  }

  Widget _buildColorOption(
    Color color,
    String label,
    AdaptiveThemeTokens tokens,
  ) {
    final isSelected = _config.textColor == color;
    return InkWell(
      onTap: () {
        _updateConfig(_config.copyWith(textColor: color));
      },
      child: Container(
        width: 80,
        padding: EdgeInsets.all(tokens.spaceS),
        decoration: BoxDecoration(
          color: AppTheme.rightTabsBackground,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected
                ? AppTheme.tabPlaylistActive
                : AppTheme.dividerLight,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: AppTheme.dividerLight),
              ),
            ),
            SizedBox(height: tokens.spaceXS),
            Text(
              label,
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: tokens.textSmall,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundColorSection(AdaptiveThemeTokens tokens) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Background Color & Opacity',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: tokens.textMedium,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: tokens.spaceM),
        Wrap(
          spacing: tokens.spaceM,
          runSpacing: tokens.spaceM,
          children: [
            _buildBgColorOption(const Color(0xAA000000), 'Black', tokens),
            _buildBgColorOption(const Color(0xAA1A1A1A), 'Dark Gray', tokens),
            _buildBgColorOption(const Color(0xAA404040), 'Gray', tokens),
            _buildBgColorOption(const Color(0x00000000), 'Transparent', tokens),
          ],
        ),
        SizedBox(height: tokens.spaceM),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Opacity',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: tokens.textSmall,
              ),
            ),
            Text(
              '${(_config.backgroundColor.a / 255 * 100).toStringAsFixed(0)}%',
              style: TextStyle(
                color: AppTheme.tabBrowserActive,
                fontSize: tokens.textSmall,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        Slider(
          value: _config.backgroundColor.a / 255,
          min: 0.0,
          max: 1.0,
          divisions: 20,
          activeColor: AppTheme.tabBrowserActive,
          inactiveColor: AppTheme.bottomBarTrackActive,
          onChanged: (value) {
            _updateConfig(
              _config.copyWith(
                backgroundColor: _config.backgroundColor.withValues(
                  alpha: value,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildBgColorOption(
    Color color,
    String label,
    AdaptiveThemeTokens tokens,
  ) {
    final isSelected =
        _config.backgroundColor.withValues(alpha: 1.0) ==
        color.withValues(alpha: 1.0);
    return InkWell(
      onTap: () {
        _updateConfig(
          _config.copyWith(
            backgroundColor: color.withValues(
              alpha: _config.backgroundColor.a / 255,
            ),
          ),
        );
      },
      child: Container(
        width: 80,
        padding: EdgeInsets.all(tokens.spaceS),
        decoration: BoxDecoration(
          color: AppTheme.rightTabsBackground,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected
                ? AppTheme.tabBrowserActive
                : AppTheme.dividerLight,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: AppTheme.dividerLight),
              ),
              child: color.a == 0
                  ? const Center(
                      child: Icon(Icons.block, color: Colors.red, size: 20),
                    )
                  : null,
            ),
            SizedBox(height: tokens.spaceXS),
            Text(
              label,
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: tokens.textSmall,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFontWeightSection(AdaptiveThemeTokens tokens) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Font Weight',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: tokens.textMedium,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: tokens.spaceM),
        Wrap(
          spacing: tokens.spaceM,
          runSpacing: tokens.spaceM,
          children: [
            _buildFontWeightOption(FontWeight.w300, 'Light', tokens),
            _buildFontWeightOption(FontWeight.normal, 'Normal', tokens),
            _buildFontWeightOption(FontWeight.w600, 'Semi-Bold', tokens),
            _buildFontWeightOption(FontWeight.bold, 'Bold', tokens),
          ],
        ),
      ],
    );
  }

  Widget _buildFontWeightOption(
    FontWeight weight,
    String label,
    AdaptiveThemeTokens tokens,
  ) {
    final isSelected = _config.fontWeight == weight;
    return InkWell(
      onTap: () {
        _updateConfig(_config.copyWith(fontWeight: weight));
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: tokens.spaceL,
          vertical: tokens.spaceM,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.tabPlaylistActive.withValues(alpha: 0.2)
              : AppTheme.rightTabsBackground,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected
                ? AppTheme.tabPlaylistActive
                : AppTheme.dividerLight,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: tokens.textMedium,
            fontWeight: weight,
          ),
        ),
      ),
    );
  }

  Widget _buildTextAlignmentSection(AdaptiveThemeTokens tokens) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Text Alignment',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: tokens.textMedium,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: tokens.spaceM),
        Row(
          children: [
            _buildAlignmentOption(
              TextAlign.left,
              Icons.format_align_left,
              tokens,
            ),
            SizedBox(width: tokens.spaceM),
            _buildAlignmentOption(
              TextAlign.center,
              Icons.format_align_center,
              tokens,
            ),
            SizedBox(width: tokens.spaceM),
            _buildAlignmentOption(
              TextAlign.right,
              Icons.format_align_right,
              tokens,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAlignmentOption(
    TextAlign align,
    IconData icon,
    AdaptiveThemeTokens tokens,
  ) {
    final isSelected = _config.textAlign == align;
    return InkWell(
      onTap: () {
        _updateConfig(_config.copyWith(textAlign: align));
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.tabBrowserActive.withValues(alpha: 0.2)
              : AppTheme.rightTabsBackground,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected
                ? AppTheme.tabBrowserActive
                : AppTheme.dividerLight,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Icon(
          icon,
          color: isSelected ? AppTheme.tabBrowserActive : AppTheme.textPrimary,
          size: tokens.iconMedium,
        ),
      ),
    );
  }

  Widget _buildAdvancedSection(AdaptiveThemeTokens tokens) {
    return ExpansionTile(
      title: Text(
        'Advanced Settings',
        style: TextStyle(
          color: AppTheme.textPrimary,
          fontSize: tokens.textMedium,
          fontWeight: FontWeight.w500,
        ),
      ),
      iconColor: AppTheme.textPrimary,
      collapsedIconColor: AppTheme.textPrimary,
      children: [
        Padding(
          padding: EdgeInsets.all(tokens.spaceM),
          child: Column(
            children: [
              // Line Height
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Line Height',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: tokens.textSmall,
                    ),
                  ),
                  Text(
                    _config.height.toStringAsFixed(1),
                    style: TextStyle(
                      color: AppTheme.tabPlaylistActive,
                      fontSize: tokens.textSmall,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Slider(
                value: _config.height,
                min: 1.0,
                max: 2.5,
                divisions: 15,
                activeColor: AppTheme.tabPlaylistActive,
                inactiveColor: AppTheme.bottomBarTrackActive,
                onChanged: (value) {
                  _updateConfig(_config.copyWith(height: value));
                },
              ),
              SizedBox(height: tokens.spaceM),

              // Letter Spacing
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Letter Spacing',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: tokens.textSmall,
                    ),
                  ),
                  Text(
                    _config.letterSpacing.toStringAsFixed(1),
                    style: TextStyle(
                      color: AppTheme.tabBrowserActive,
                      fontSize: tokens.textSmall,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Slider(
                value: _config.letterSpacing,
                min: -2.0,
                max: 5.0,
                divisions: 35,
                activeColor: AppTheme.tabBrowserActive,
                inactiveColor: AppTheme.bottomBarTrackActive,
                onChanged: (value) {
                  _updateConfig(_config.copyWith(letterSpacing: value));
                },
              ),
              SizedBox(height: tokens.spaceM),

              // Padding
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Padding',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: tokens.textSmall,
                    ),
                  ),
                  Text(
                    '${_config.padding.top.toStringAsFixed(0)} px',
                    style: TextStyle(
                      color: AppTheme.tabPlaylistActive,
                      fontSize: tokens.textSmall,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Slider(
                value: _config.padding.top,
                min: 0.0,
                max: 64.0,
                divisions: 16,
                activeColor: AppTheme.tabPlaylistActive,
                inactiveColor: AppTheme.bottomBarTrackActive,
                onChanged: (value) {
                  _updateConfig(
                    _config.copyWith(padding: EdgeInsets.all(value)),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
