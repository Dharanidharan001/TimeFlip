import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../theme/design_system.dart';
import '../widgets/glass_card.dart';
import '../widgets/custom_charts.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final theme = appState.theme;

    // Calculate progress towards 7-hour daily goal
    final double dailyGoalHours = 7.0;
    final double todayHours = appState.todayTotalFocus.inMinutes / 60.0;
    final int goalPercent = ((todayHours / dailyGoalHours) * 100).clamp(0, 100).round();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 120), // Bottom padding for navigation dock
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo/Header row
              Row(
                children: [
                  Icon(
                    Icons.blur_on,
                    color: theme.defaultAccent,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'FocusFlip',
                    style: DesignSystem.getHeadlineMd(
                      context,
                      color: theme.onSurface,
                    ).copyWith(letterSpacing: -1.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Title Header
              Text(
                "TODAY'S FOCUS",
                style: DesignSystem.getLabelSm(
                  context,
                  color: theme.onSurfaceMuted,
                ).copyWith(letterSpacing: 1.0),
              ),
              const SizedBox(height: 8),
              Text(
                _formatDuration(appState.todayTotalFocus),
                style: DesignSystem.getHeadlineLg(
                  context,
                  color: theme.onSurface,
                ).copyWith(fontSize: 48, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // Badges Row
              Row(
                children: [
                  _buildHeaderBadge(
                    context: context,
                    icon: Icons.trending_up,
                    label: '+18% vs Yesterday',
                    color: theme.defaultAccent,
                  ),
                  const SizedBox(width: 8),
                  _buildHeaderBadge(
                    context: context,
                    icon: Icons.local_fire_department,
                    label: '${appState.streak} Days Streak',
                    color: const Color(0xFFFF8A65),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Keep the chain alive.',
                style: DesignSystem.getBodyMd(
                  context,
                  color: theme.onSurfaceMuted.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 24),

              // Goal progress bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Daily Goal: ${dailyGoalHours.round()}h',
                    style: DesignSystem.getLabelMd(context, color: theme.onSurfaceMuted),
                  ),
                  Text(
                    '$goalPercent%',
                    style: DesignSystem.getLabelMd(context, color: theme.onSurface),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: LinearProgressIndicator(
                  value: (todayHours / dailyGoalHours).clamp(0.0, 1.0),
                  minHeight: 8,
                  backgroundColor: theme.onSurface.withValues(alpha: 0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(theme.defaultAccent),
                ),
              ),
              const SizedBox(height: 32),

              // 2x2 stats grid
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.5,
                children: [
                  _buildStatCard(context, 'This Week', _formatDuration(appState.thisWeekFocus), theme),
                  _buildStatCard(context, 'This Month', _formatDuration(appState.thisMonthFocus), theme),
                  _buildStatCard(context, 'Sessions', '${appState.totalSessionsCount}', theme),
                  _buildStatCard(context, 'Avg. Session', _formatDuration(appState.averageSessionDuration), theme),
                ],
              ),
              const SizedBox(height: 24),

              // Weekly Overview Card
              GlassCard(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Weekly Overview',
                              style: DesignSystem.getBodyLg(
                                context,
                                color: theme.onSurface,
                              ).copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Avg ${_formatDuration(Duration(minutes: (appState.averageDailyFocusHoursThisWeek * 60).round()))} / day',
                              style: DesignSystem.getLabelSm(
                                context,
                                color: theme.onSurfaceMuted,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: theme.defaultAccent.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: Text(
                            appState.weeklyTrendPercent,
                            style: DesignSystem.getLabelSm(
                              context,
                              color: theme.defaultAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    WeeklyBarChart(
                      weeklyHours: appState.weeklyOverviewHours,
                      maxHours: appState.weeklyOverviewHours.fold(8.0, (max, h) => h > max ? h : max),
                      barColor: theme.defaultAccent,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Subjects Card
              GlassCard(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Subjects',
                      style: DesignSystem.getBodyLg(
                        context,
                        color: theme.onSurface,
                      ).copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        SubjectsDonutChart(
                          studyPercent: appState.studyPercentage,
                          codingPercent: appState.codingPercentage,
                          readingPercent: appState.readingPercentage,
                          accentColor: theme.defaultAccent,
                        ),
                        const SizedBox(width: 32),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLegendItem(context, 'Study', '${(appState.studyPercentage * 100).round()}%', theme.defaultAccent, theme),
                              const SizedBox(height: 12),
                              _buildLegendItem(context, 'Coding', '${(appState.codingPercentage * 100).round()}%', theme.onSurface.withValues(alpha: 0.4), theme),
                              const SizedBox(height: 12),
                              _buildLegendItem(context, 'Reading', '${(appState.readingPercentage * 100).round()}%', theme.onSurface.withValues(alpha: 0.15), theme),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Streak Card
              GlassCard(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.onSurface.withValues(alpha: 0.04),
                        shape: BoxShape.circle,
                        border: Border.all(color: theme.outline.withValues(alpha: 0.2)),
                      ),
                      child: Icon(
                        Icons.local_fire_department,
                        color: Colors.orange[400],
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${appState.streak} Day Streak',
                            style: DesignSystem.getBodyLg(
                              context,
                              color: theme.onSurface,
                            ).copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                'Best: ${appState.bestStreak} Days',
                                style: DesignSystem.getLabelSm(context, color: theme.onSurfaceMuted),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Rate: ${appState.weeklyConsistencyRate}%',
                                style: DesignSystem.getLabelSm(context, color: theme.onSurfaceMuted),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Weekday check list row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildStreakDayBox(context, 'M', appState.weeklyChecklist[0], theme.defaultAccent),
                              _buildStreakDayBox(context, 'T', appState.weeklyChecklist[1], theme.defaultAccent),
                              _buildStreakDayBox(context, 'W', appState.weeklyChecklist[2], theme.defaultAccent),
                              _buildStreakDayBox(context, 'T', appState.weeklyChecklist[3], theme.defaultAccent),
                              _buildStreakDayBox(context, 'F', appState.weeklyChecklist[4], theme.defaultAccent),
                              _buildStreakDayBox(context, 'S', appState.weeklyChecklist[5], theme.defaultAccent),
                              _buildStreakDayBox(context, 'S', appState.weeklyChecklist[6], theme.defaultAccent),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '2 Freeze Tokens available',
                            style: DesignSystem.getLabelSm(
                              context,
                              color: theme.onSurfaceMuted.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Insights Card
              GlassCard(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Insights',
                      style: DesignSystem.getBodyLg(
                        context,
                        color: theme.onSurface,
                      ).copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 20),
                    _buildInsightRow(
                      context: context,
                      icon: Icons.schedule,
                      title: 'Peak Focus Time',
                      detail: appState.peakFocusTime,
                      accentColor: theme.defaultAccent,
                      theme: theme,
                    ),
                    Divider(color: theme.outline.withValues(alpha: 0.15), height: 32),
                    _buildInsightRow(
                      context: context,
                      icon: Icons.trending_up,
                      title: 'Productivity Trend',
                      detail: appState.productivityTrend,
                      accentColor: theme.defaultAccent,
                      theme: theme,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Today's Timeline Card
              GlassCard(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Today's Timeline",
                      style: DesignSystem.getBodyLg(
                        context,
                        color: theme.onSurface,
                      ).copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 24),
                    ...List.generate(appState.timelineSessions.length, (index) {
                      final session = appState.timelineSessions[index];
                      return _buildTimelineItem(
                        context: context,
                        session: session,
                        accentColor: theme.defaultAccent,
                        isLast: index == appState.timelineSessions.length - 1,
                        theme: theme,
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Achievements Section
              Text(
                'ACHIEVEMENTS',
                style: DesignSystem.getLabelSm(
                  context,
                  color: theme.onSurfaceMuted,
                ).copyWith(letterSpacing: 1.5),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildAchievementCard(
                      context: context,
                      icon: Icons.emoji_events,
                      iconColor: Colors.amber,
                      title: 'First 10 Hours',
                      subtitle: appState.totalFocusHours >= 10
                          ? 'Completed'
                          : '${appState.totalFocusHours.toStringAsFixed(1)}h / 10h',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildAchievementCard(
                      context: context,
                      icon: Icons.local_fire_department,
                      iconColor: Colors.orange,
                      title: '7 Day Streak',
                      subtitle: appState.bestStreak >= 7
                          ? 'Completed'
                          : '${appState.bestStreak}d / 7d',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  Widget _buildHeaderBadge({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 4),
          Text(
            label,
            style: DesignSystem.getLabelSm(context, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    AppThemeData theme,
  ) {
    return GlassCard(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: DesignSystem.getLabelSm(
              context,
              color: theme.onSurfaceMuted,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: DesignSystem.getBodyLg(
              context,
              color: theme.onSurface,
            ).copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(BuildContext context, String label, String value, Color color, AppThemeData theme) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: DesignSystem.getBodyMd(
            context,
            color: theme.onSurface.withValues(alpha: 0.8),
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: DesignSystem.getLabelMd(
            context,
            color: theme.onSurface,
          ).copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildStreakDayBox(BuildContext context, String day, bool checked, Color activeColor) {
    final theme = Provider.of<AppState>(context, listen: false).theme;
    if (checked) {
      return Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: activeColor,
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Icon(
          Icons.check,
          color: Colors.black,
          size: 14,
        ),
      );
    } else {
      return SizedBox(
        width: 24,
        height: 24,
        child: Center(
          child: Text(
            day,
            style: DesignSystem.getLabelSm(
              context,
              color: theme.onSurface.withValues(alpha: 0.3),
            ),
          ),
        ),
      );
    }
  }

  Widget _buildInsightRow({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String detail,
    required Color accentColor,
    required AppThemeData theme,
  }) {
    return Row(
      children: [
        Icon(icon, color: accentColor, size: 20),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: DesignSystem.getBodyMd(
                context,
                color: theme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              detail,
              style: DesignSystem.getBodyMd(
                context,
                color: theme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimelineItem({
    required BuildContext context,
    required FocusSession session,
    required Color accentColor,
    required bool isLast,
    required AppThemeData theme,
  }) {
    Color getDotColor() {
      if (session.timeDisplay == 'Now') return accentColor;
      if (session.category == 'Physics' || session.category == 'Study') return theme.onSurface;
      return theme.onSurface.withValues(alpha: 0.3);
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left timeline axis
          Column(
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: getDotColor(), width: 2.0),
                ),
                child: session.timeDisplay == 'Now'
                    ? Center(
                        child: Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: accentColor,
                          ),
                        ),
                      )
                    : null,
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: theme.outline.withValues(alpha: 0.3),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),

          // Timeline node content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.timeDisplay,
                    style: DesignSystem.getLabelSm(
                      context,
                      color: theme.onSurfaceMuted,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GlassCard(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              session.title,
                              style: DesignSystem.getBodyMd(
                                context,
                                color: theme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              session.targetDuration != null
                                  ? '${_formatDuration(session.duration)} / ${_formatDuration(session.targetDuration!)}'
                                  : _formatDuration(session.duration),
                              style: DesignSystem.getLabelSm(
                                context,
                                color: theme.onSurfaceMuted,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    final theme = Provider.of<AppState>(context, listen: false).theme;
    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 40),
          const SizedBox(height: 12),
          Text(
            title,
            style: DesignSystem.getBodyMd(
              context,
              color: theme.onSurface,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: DesignSystem.getLabelSm(
              context,
              color: theme.onSurface.withValues(alpha: 0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
