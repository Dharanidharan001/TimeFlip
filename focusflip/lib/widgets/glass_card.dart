import 'dart:ui';
import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double blur;
  final bool elevated;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Border? border;

  const GlassCard({
    super.key,
    required this.child,
    this.borderRadius = 16,
    this.blur = 20,
    this.elevated = false,
    this.padding,
    this.color,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: color ??
                (isLight
                    ? (elevated ? const Color(0x12000000) : const Color(0x06000000))
                    : (elevated ? const Color(0x14FFFFFF) : const Color(0x0AFFFFFF))),
            borderRadius: BorderRadius.circular(borderRadius),
            border: border ??
                Border.all(
                  color: isLight ? const Color(0x15000000) : const Color(0x1AFFFFFF),
                  width: 1.0,
                ),
            boxShadow: elevated
                ? [
                    BoxShadow(
                      color: isLight ? const Color(0x10000000) : const Color(0x80000000),
                      offset: const Offset(0, 20),
                      blurRadius: 40,
                    )
                  ]
                : null,
          ),
          child: child,
        ),
      ),
    );
  }
}
