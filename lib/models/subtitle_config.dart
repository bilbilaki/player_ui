import 'package:flutter/material.dart';

/// Configuration for subtitle appearance and positioning
class SubtitleConfig {
  final double fontSize;
  final Color textColor;
  final Color backgroundColor;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final EdgeInsets padding;
  final double height; // Line height multiplier
  final double letterSpacing;
  final double wordSpacing;

  const SubtitleConfig({
    this.fontSize = 24.0,
    this.textColor = const Color(0xFFFFFFFF),
    this.backgroundColor = const Color(0xAA000000),
    this.fontWeight = FontWeight.normal,
    this.textAlign = TextAlign.center,
    this.padding = const EdgeInsets.all(24.0),
    this.height = 1.4,
    this.letterSpacing = 0.0,
    this.wordSpacing = 0.0,
  });

  /// Create a copy with modified values
  SubtitleConfig copyWith({
    double? fontSize,
    Color? textColor,
    Color? backgroundColor,
    FontWeight? fontWeight,
    TextAlign? textAlign,
    EdgeInsets? padding,
    double? height,
    double? letterSpacing,
    double? wordSpacing,
  }) {
    return SubtitleConfig(
      fontSize: fontSize ?? this.fontSize,
      textColor: textColor ?? this.textColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      fontWeight: fontWeight ?? this.fontWeight,
      textAlign: textAlign ?? this.textAlign,
      padding: padding ?? this.padding,
      height: height ?? this.height,
      letterSpacing: letterSpacing ?? this.letterSpacing,
      wordSpacing: wordSpacing ?? this.wordSpacing,
    );
  }

  /// Convert to TextStyle for media_kit
  TextStyle toTextStyle() {
    return TextStyle(
      fontSize: fontSize,
      color: textColor,
      backgroundColor: backgroundColor,
      fontWeight: fontWeight,
      height: height,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
    );
  }

  /// Default configuration
  static const SubtitleConfig defaultConfig = SubtitleConfig();
}
