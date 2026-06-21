import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum AppThemeType { amoled, cyberBlue, retroFlip, terminal }

class AppThemeData {
  final AppThemeType type;
  final String name;
  final Color background;
  final Color surface;
  final Color surfaceContainer;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color outline;
  final Color defaultAccent;
  final Color error;

  const AppThemeData({
    required this.type,
    required this.name,
    required this.background,
    required this.surface,
    required this.surfaceContainer,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.outline,
    required this.defaultAccent,
    required this.error,
  });

  static AppThemeData getTheme(AppThemeType type, [Color? customAccent]) {
    final accent = customAccent ?? const Color(0xFFADC6FF);

    switch (type) {
      case AppThemeType.amoled:
        return AppThemeData(
          type: AppThemeType.amoled,
          name: 'AMOLED',
          background: const Color(0xFF000000),
          surface: const Color(0xFF131313),
          surfaceContainer: const Color(0xFF1F1F1F),
          onSurface: const Color(0xFFE2E2E2),
          onSurfaceMuted: const Color(0xFFC2C6D6),
          outline: const Color(0xFF8C909F),
          defaultAccent: accent,
          error: const Color(0xFFFFB4AB),
        );
      case AppThemeType.cyberBlue:
        return AppThemeData(
          type: AppThemeType.cyberBlue,
          name: 'Cyber Blue',
          background: const Color(0xFF0A192F),
          surface: const Color(0xFF172A45),
          surfaceContainer: const Color(0xFF303C55),
          onSurface: const Color(0xFFF2F4F8),
          onSurfaceMuted: const Color(0xFF8892B0),
          outline: const Color(0xFF4C566A),
          defaultAccent: accent == const Color(0xFFADC6FF) ? const Color(0xFF64FFDA) : accent,
          error: const Color(0xFFFF6B6B),
        );
      case AppThemeType.retroFlip:
        return AppThemeData(
          type: AppThemeType.retroFlip,
          name: 'Retro Flip',
          background: const Color(0xFF1B1B1B),
          surface: const Color(0xFF2A2A2A),
          surfaceContainer: const Color(0xFF333333),
          onSurface: const Color(0xFFE5E5E5),
          onSurfaceMuted: const Color(0xFFA3A3A3),
          outline: const Color(0xFF525252),
          defaultAccent: const Color(0xFFF97316), // Orange
          error: const Color(0xFFEF4444),
        );
      case AppThemeType.terminal:
        return AppThemeData(
          type: AppThemeType.terminal,
          name: 'Terminal',
          background: const Color(0xFF0D1117),
          surface: const Color(0xFF161B22),
          surfaceContainer: const Color(0xFF21262D),
          onSurface: const Color(0xFFC9D1D9),
          onSurfaceMuted: const Color(0xFF8B949E),
          outline: const Color(0xFF30363D),
          defaultAccent: const Color(0xFF238636), // Green
          error: const Color(0xFFF85149),
        );
    }
  }
}

class DesignSystem {
  static TextStyle getDisplay(BuildContext context, {Color? color}) {
    return GoogleFonts.inter(
      fontSize: 48,
      fontWeight: FontWeight.bold,
      color: color ?? Theme.of(context).colorScheme.onSurface,
      letterSpacing: -0.04 * 48,
      height: 1.1,
    );
  }

  static TextStyle getHeadlineLg(BuildContext context, {Color? color}) {
    return GoogleFonts.inter(
      fontSize: 32,
      fontWeight: FontWeight.w600,
      color: color ?? Theme.of(context).colorScheme.onSurface,
      letterSpacing: -0.02 * 32,
      height: 1.2,
    );
  }

  static TextStyle getHeadlineMd(BuildContext context, {Color? color}) {
    return GoogleFonts.inter(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: color ?? Theme.of(context).colorScheme.onSurface,
      height: 1.3,
    );
  }

  static TextStyle getBodyLg(BuildContext context, {Color? color}) {
    return GoogleFonts.inter(
      fontSize: 18,
      fontWeight: FontWeight.normal,
      color: color ?? Theme.of(context).colorScheme.onSurface,
      height: 1.6,
    );
  }

  static TextStyle getBodyMd(BuildContext context, {Color? color, FontWeight? fontWeight}) {
    return GoogleFonts.inter(
      fontSize: 16,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color ?? Theme.of(context).colorScheme.onSurface,
      height: 1.6,
    );
  }

  // Mono fonts for labels, timers, data points (using spaceMono/geistMono look)
  static TextStyle getLabelMd(BuildContext context, {Color? color, double? fontSize}) {
    return GoogleFonts.spaceMono(
      fontSize: fontSize ?? 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.02 * (fontSize ?? 14),
      height: 1.4,
      color: color ?? Theme.of(context).colorScheme.onSurface,
    );
  }

  static TextStyle getLabelSm(BuildContext context, {Color? color, double? fontSize}) {
    return GoogleFonts.spaceMono(
      fontSize: fontSize ?? 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.05 * (fontSize ?? 12),
      height: 1.2,
      color: color ?? Theme.of(context).colorScheme.onSurface,
    );
  }

  static BoxDecoration getGlassDecoration({
    Color? borderGradientStart,
    Color? borderGradientEnd,
    bool elevated = false,
  }) {
    return BoxDecoration(
      color: elevated
          ? const Color(0x14FFFFFF) // 8% opacity white
          : const Color(0x0AFFFFFF), // 4% opacity white
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: const Color(0x1AFFFFFF), // 10% opacity white border
        width: 1.0,
      ),
      boxShadow: elevated
          ? [
              const BoxShadow(
                color: Color(0x80000000), // 50% opacity black glow
                offset: Offset(0, 20),
                blurRadius: 40,
              )
            ]
          : null,
    );
  }
}
