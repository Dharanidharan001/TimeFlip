import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/design_system.dart';

class WeeklyBarChart extends StatelessWidget {
  final List<double> weeklyHours; // 7 values for Mon-Sun
  final double maxHours;
  final Color barColor;

  const WeeklyBarChart({
    super.key,
    required this.weeklyHours,
    this.maxHours = 8.0,
    required this.barColor,
  });

  @override
  Widget build(BuildContext context) {
    final weekdays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Container(
      height: 180,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(7, (index) {
          final hours = weeklyHours[index];
          final heightFactor = (hours / maxHours).clamp(0.05, 1.0);

          return Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                       final barHeight = constraints.maxHeight * heightFactor;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: 12,
                            height: barHeight,
                            decoration: BoxDecoration(
                              color: barColor.withValues(alpha: index == 3 ? 1.0 : 0.6), // Highlight one day (e.g. Thu)
                              borderRadius: BorderRadius.circular(99),
                              boxShadow: index == 3
                                  ? [
                                      BoxShadow(
                                        color: barColor.withValues(alpha: 0.4),
                                        blurRadius: 8,
                                        spreadRadius: 1,
                                      )
                                    ]
                                  : null,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  weekdays[index],
                  style: DesignSystem.getLabelSm(
                    context,
                    color: onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class SubjectsDonutChart extends StatelessWidget {
  final double studyPercent; // e.g. 0.40
  final double codingPercent;  // e.g. 0.35
  final double readingPercent; // e.g. 0.25
  final Color accentColor;

  const SubjectsDonutChart({
    super.key,
    required this.studyPercent,
    required this.codingPercent,
    required this.readingPercent,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return SizedBox(
      width: 150,
      height: 150,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(140, 140),
            painter: _DonutPainter(
              studyPercent: studyPercent,
              codingPercent: codingPercent,
              readingPercent: readingPercent,
              accentColor: accentColor,
              onSurfaceColor: onSurface,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '100%',
                style: DesignSystem.getLabelMd(
                  context,
                  color: onSurface,
                  fontSize: 18,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  final double studyPercent;
  final double codingPercent;
  final double readingPercent;
  final Color accentColor;
  final Color onSurfaceColor;

  _DonutPainter({
    required this.studyPercent,
    required this.codingPercent,
    required this.readingPercent,
    required this.accentColor,
    required this.onSurfaceColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 20) / 2; // Offset for strokeWidth
    final rect = Rect.fromCircle(center: center, radius: radius);
    const strokeWidth = 16.0;

    final paintStudy = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = accentColor;

    final paintCoding = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = onSurfaceColor.withValues(alpha: 0.4);

    final paintReading = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = onSurfaceColor.withValues(alpha: 0.15);

    // Starting angle at top: -90 degrees (-pi/2)
    double startAngle = -math.pi / 2;

    // 1. Study Arc
    double sweepAngleStudy = 2 * math.pi * studyPercent;
    canvas.drawArc(rect, startAngle, sweepAngleStudy, false, paintStudy);
    startAngle += sweepAngleStudy;

    // 2. Coding Arc
    double sweepAngleCoding = 2 * math.pi * codingPercent;
    canvas.drawArc(rect, startAngle, sweepAngleCoding, false, paintCoding);
    startAngle += sweepAngleCoding;

    // 3. Reading Arc
    double sweepAngleReading = 2 * math.pi * readingPercent;
    canvas.drawArc(rect, startAngle, sweepAngleReading, false, paintReading);
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) {
    return oldDelegate.studyPercent != studyPercent ||
        oldDelegate.codingPercent != codingPercent ||
        oldDelegate.readingPercent != readingPercent ||
        oldDelegate.accentColor != accentColor ||
        oldDelegate.onSurfaceColor != onSurfaceColor;
  }
}
