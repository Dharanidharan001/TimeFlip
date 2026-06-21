import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/design_system.dart';

class FocusSession {
  final String category;
  final String title;
  final Duration duration;
  final Duration? targetDuration;
  final String timeDisplay;
  final DateTime timestamp;

  FocusSession({
    required this.category,
    required this.title,
    required this.duration,
    this.targetDuration,
    required this.timeDisplay,
    required this.timestamp,
  });
}

class AppState extends ChangeNotifier {
  // Navigation & UI state
  int _activeTab = 0;
  int get activeTab => _activeTab;
  set activeTab(int tab) {
    _activeTab = tab;
    notifyListeners();
  }

  // Customization & Theme settings
  AppThemeType _activeThemeType = AppThemeType.amoled;
  AppThemeType get activeThemeType => _activeThemeType;
  void setTheme(AppThemeType type) {
    _activeThemeType = type;
    notifyListeners();
  }

  AppThemeData get theme => AppThemeData.getTheme(_activeThemeType, _accentColor);

  Color _accentColor = const Color(0xFFADC6FF);
  Color get accentColor => _accentColor;
  void setAccentColor(Color color) {
    _accentColor = color;
    notifyListeners();
  }

  double _timerDisplayStyle = 75.0; // 0 to 100
  double get timerDisplayStyle => _timerDisplayStyle;
  void setTimerDisplayStyle(double val) {
    _timerDisplayStyle = val;
    notifyListeners();
  }

  String get timerDisplayStyleLabel {
    if (_timerDisplayStyle < 33) return 'Minimal';
    if (_timerDisplayStyle < 66) return 'Standard';
    return 'Monospace Digital';
  }

  double _animationSpeed = 40.0; // 0 to 100
  double get animationSpeed => _animationSpeed;
  void setAnimationSpeed(double val) {
    _animationSpeed = val;
    notifyListeners();
  }

  String get animationSpeedLabel {
    if (_animationSpeed < 33) return 'Static';
    if (_animationSpeed < 66) return 'Responsive';
    return '0.4s (Default)';
  }

  // Timer State
  bool _isTimerRunning = false;
  bool get isTimerRunning => _isTimerRunning;

  bool _isTimerPaused = false;
  bool get isTimerPaused => _isTimerPaused;

  Duration _currentTimerDuration = Duration.zero;
  Duration get currentTimerDuration => _currentTimerDuration;

  Duration _initialTimerDuration = const Duration(minutes: 25);
  Duration get initialTimerDuration => _initialTimerDuration;

  Timer? _timer;

  // Streak & Metrics
  final int _streak = 12;
  int get streak => _streak;

  Duration _todayTotalFocus = const Duration(hours: 2, minutes: 45);
  Duration get todayTotalFocus => _todayTotalFocus;

  String _activeCategory = 'Coding';
  String get activeCategory => _activeCategory;
  void setActiveCategory(String cat) {
    _activeCategory = cat;
    notifyListeners();
  }

  final List<String> _categories = ['Study', 'Coding', 'Reading'];
  List<String> get categories => List.unmodifiable(_categories);

  void addCustomCategory(String name) {
    if (name.isNotEmpty && !_categories.contains(name)) {
      _categories.add(name);
      notifyListeners();
    }
  }

  // Sessions log
  final List<FocusSession> _recentSessions = [
    FocusSession(
      category: 'Coding',
      title: 'Coding - App Setup & UI',
      duration: const Duration(minutes: 50),
      timeDisplay: '2h ago',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
  ];
  List<FocusSession> get recentSessions => List.unmodifiable(_recentSessions);

  final List<FocusSession> _timelineSessions = [
    FocusSession(
      category: 'Physics',
      title: 'Physics - Quantum Mechanics',
      duration: const Duration(hours: 2, minutes: 15),
      timeDisplay: '08:00',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    FocusSession(
      category: 'Coding',
      title: 'Coding - Algorithms',
      duration: const Duration(hours: 1, minutes: 45),
      timeDisplay: '10:30',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    FocusSession(
      category: 'Reading',
      title: 'Reading - Literature Review',
      duration: const Duration(minutes: 42),
      targetDuration: const Duration(hours: 1),
      timeDisplay: 'Now',
      timestamp: DateTime.now(),
    ),
  ];
  List<FocusSession> get timelineSessions => List.unmodifiable(_timelineSessions);

  // Focus progress (relative progress of currently running timer)
  double get focusProgressPercent {
    if (_initialTimerDuration.inSeconds == 0) return 0.0;
    final elapsed = _initialTimerDuration.inSeconds - _currentTimerDuration.inSeconds;
    return (elapsed / _initialTimerDuration.inSeconds) * 100;
  }

  void startTimer(Duration duration) {
    _initialTimerDuration = duration;
    _currentTimerDuration = duration;
    _isTimerRunning = true;
    _isTimerPaused = false;
    _startTicker();
    notifyListeners();
  }

  void pauseTimer() {
    if (_isTimerRunning && !_isTimerPaused) {
      _isTimerPaused = true;
      _timer?.cancel();
      notifyListeners();
    }
  }

  void resumeTimer() {
    if (_isTimerRunning && _isTimerPaused) {
      _isTimerPaused = false;
      _startTicker();
      notifyListeners();
    }
  }

  void stopTimer(bool saveCompleted) {
    _timer?.cancel();
    if (saveCompleted) {
      final elapsed = _initialTimerDuration - _currentTimerDuration;
      if (elapsed.inSeconds > 1) {
        // Update today's total
        _todayTotalFocus += elapsed;
        
        final newSession = FocusSession(
          category: _activeCategory,
          title: '$_activeCategory Session',
          duration: elapsed,
          timeDisplay: 'Just now',
          timestamp: DateTime.now(),
        );
        _recentSessions.insert(0, newSession);
        _timelineSessions.insert(0, newSession);
      }
    }
    _isTimerRunning = false;
    _isTimerPaused = false;
    _currentTimerDuration = Duration.zero;
    notifyListeners();
  }

  void _startTicker() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentTimerDuration.inSeconds > 0) {
        _currentTimerDuration = _currentTimerDuration - const Duration(seconds: 1);
        notifyListeners();
      } else {
        // Timer completed!
        stopTimer(true);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
