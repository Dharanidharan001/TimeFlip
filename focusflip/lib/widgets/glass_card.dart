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
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: color ??
                (elevated
                    ? const Color(0x14FFFFFF) // 8% opacity white
                    : const Color(0x0AFFFFFF)), // 4% opacity white
            borderRadius: BorderRadius.circular(borderRadius),
            border: border ??
                Border.all(
                  color: const Color(0x1AFFFFFF), // 10% opacity white
                  width: 1.0,
                ),
            boxShadow: elevated
                ? const [
                    BoxShadow(
                      color: Color(0x80000000), // 50% opacity black
                      offset: Offset(0, 20),
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
