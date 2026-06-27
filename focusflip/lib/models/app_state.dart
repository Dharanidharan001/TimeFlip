import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/design_system.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
  bool _isLoggedIn;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  AppState({bool isLoggedIn = false}) : _isLoggedIn = isLoggedIn {
    _isLoggedIn = isLoggedIn || FirebaseAuth.instance.currentUser != null;
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      _isLoggedIn = user != null;
      if (user != null) {
        _loadUserData(user.uid);
      } else {
        _clearUserData();
      }
      notifyListeners();
    });
  }

  bool get isLoggedIn => _isLoggedIn;

  Future<void> login() async {
    _isLoggedIn = true;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', true);
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', false);
    await FirebaseAuth.instance.signOut();
    try {
      final googleSignIn = GoogleSignIn(
        clientId: '933796135635-h78ct5652e784u5md4124pu6oe97slvm.apps.googleusercontent.com',
      );
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }
    } catch (e) {
      debugPrint("Error signing out Google client: $e");
    }
  }

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
  int _streak = 0;
  int get streak => _streak;

  int _bestStreak = 0;
  int get bestStreak => _bestStreak;

  String _lastFocusDate = '';
  String get lastFocusDate => _lastFocusDate;

  Duration _todayTotalFocus = Duration.zero;
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
  List<FocusSession> _recentSessions = [];
  List<FocusSession> get recentSessions => List.unmodifiable(_recentSessions);

  List<FocusSession> _timelineSessions = [];
  List<FocusSession> get timelineSessions => List.unmodifiable(_timelineSessions);

  void setInitialTimerDuration(Duration duration) {
    _initialTimerDuration = duration;
    _currentTimerDuration = duration;
    notifyListeners();
  }

  String _formatTimeDisplay(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    if (difference.inMinutes < 60) {
      if (difference.inMinutes <= 0) return 'Just now';
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      final day = timestamp.day.toString().padLeft(2, '0');
      final month = timestamp.month.toString().padLeft(2, '0');
      return '$day/$month';
    }
  }

  Future<void> _loadUserData(String uid) async {
    try {
      final userDoc = await _db.collection('users').doc(uid).get();
      final todayStr = DateTime.now().toIso8601String().substring(0, 10);
      if (userDoc.exists) {
        final data = userDoc.data()!;
        _streak = data['streak'] ?? 0;
        _bestStreak = data['bestStreak'] ?? _streak;
        _lastFocusDate = data['lastFocusDate'] ?? '';
        
        if (_lastFocusDate == todayStr) {
          _todayTotalFocus = Duration(seconds: data['todayTotalFocusSeconds'] ?? 0);
        } else {
          _todayTotalFocus = Duration.zero;
          final yesterdayStr = DateTime.now().subtract(const Duration(days: 1)).toIso8601String().substring(0, 10);
          final updates = <String, dynamic>{
            'todayTotalFocusSeconds': 0,
          };
          if (_lastFocusDate != yesterdayStr && _lastFocusDate.isNotEmpty) {
            _streak = 0;
            updates['streak'] = 0;
          }
          _db.collection('users').doc(uid).update(updates);
        }
      } else {
        _streak = 0;
        _bestStreak = 0;
        _lastFocusDate = '';
        _todayTotalFocus = Duration.zero;
        
        // Initialize in Firestore database if missing
        final currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser != null) {
          await _db.collection('users').doc(uid).set({
            'uid': uid,
            'name': currentUser.displayName ?? currentUser.email?.split('@')[0] ?? 'User',
            'email': currentUser.email ?? '',
            'createdAt': FieldValue.serverTimestamp(),
            'streak': 0,
            'bestStreak': 0,
            'todayTotalFocusSeconds': 0,
            'lastFocusDate': '',
          }, SetOptions(merge: true));
        }
      }

      final sessionsQuery = await _db
          .collection('users')
          .doc(uid)
          .collection('sessions')
          .orderBy('timestamp', descending: true)
          .limit(100)
          .get();

      _recentSessions = sessionsQuery.docs.map((doc) {
        final data = doc.data();
        final timestamp = (data['timestamp'] as Timestamp).toDate();
        return FocusSession(
          category: data['category'] ?? 'Coding',
          title: data['title'] ?? '',
          duration: Duration(seconds: data['durationSeconds'] ?? 0),
          timeDisplay: _formatTimeDisplay(timestamp),
          timestamp: timestamp,
        );
      }).toList();

      _timelineSessions = List.from(_recentSessions);
      notifyListeners();
    } catch (e) {
      debugPrint("Error loading user data: $e");
    }
  }

  void _clearUserData() {
    _streak = 0;
    _bestStreak = 0;
    _lastFocusDate = '';
    _todayTotalFocus = Duration.zero;
    _recentSessions = [];
    _timelineSessions = [];
    notifyListeners();
  }

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
        
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          _db.collection('users').doc(user.uid).collection('sessions').add({
            'category': newSession.category,
            'title': newSession.title,
            'durationSeconds': newSession.duration.inSeconds,
            'timestamp': Timestamp.fromDate(newSession.timestamp),
          });

          final todayStr = DateTime.now().toIso8601String().substring(0, 10);
          final yesterdayStr = DateTime.now().subtract(const Duration(days: 1)).toIso8601String().substring(0, 10);
          
          if (_lastFocusDate == yesterdayStr) {
            _streak += 1;
          } else if (_lastFocusDate != todayStr) {
            _streak = 1;
          }
          _lastFocusDate = todayStr;
          
          if (_streak > _bestStreak) {
            _bestStreak = _streak;
          }

          _db.collection('users').doc(user.uid).set({
            'streak': _streak,
            'bestStreak': _bestStreak,
            'todayTotalFocusSeconds': _todayTotalFocus.inSeconds,
            'lastFocusDate': _lastFocusDate,
          }, SetOptions(merge: true));
        }
      }
    }
    _isTimerRunning = false;
    _isTimerPaused = false;
    _currentTimerDuration = Duration.zero;
    notifyListeners();
  }

  // Dynamic statistics getters
  Duration get thisWeekFocus {
    final now = DateTime.now();
    final startOfWeek = DateTime(now.year, now.month, now.day).subtract(Duration(days: now.weekday - 1));
    return _recentSessions
        .where((s) => s.timestamp.isAfter(startOfWeek))
        .fold(Duration.zero, (prev, s) => prev + s.duration);
  }

  Duration get thisMonthFocus {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    return _recentSessions
        .where((s) => s.timestamp.isAfter(startOfMonth))
        .fold(Duration.zero, (prev, s) => prev + s.duration);
  }

  int get totalSessionsCount => _recentSessions.length;

  Duration get averageSessionDuration {
    if (_recentSessions.isEmpty) return Duration.zero;
    final totalDuration = _recentSessions.fold(Duration.zero, (prev, s) => prev + s.duration);
    return Duration(seconds: totalDuration.inSeconds ~/ _recentSessions.length);
  }

  List<double> get weeklyOverviewHours {
    final now = DateTime.now();
    final startOfWeek = DateTime(now.year, now.month, now.day).subtract(Duration(days: now.weekday - 1));
    final hours = List<double>.filled(7, 0.0);
    for (int i = 0; i < 7; i++) {
      final day = startOfWeek.add(Duration(days: i));
      final dayStart = DateTime(day.year, day.month, day.day);
      final dayEnd = dayStart.add(const Duration(days: 1));
      final daySessions = _recentSessions.where((s) => s.timestamp.isAfter(dayStart) && s.timestamp.isBefore(dayEnd));
      final totalSecs = daySessions.fold(0, (prev, s) => prev + s.duration.inSeconds);
      hours[i] = totalSecs / 3600.0;
    }
    return hours;
  }

  double get averageDailyFocusHoursThisWeek {
    final hours = weeklyOverviewHours;
    final activeDays = hours.where((h) => h > 0).length;
    if (activeDays == 0) return 0.0;
    final total = hours.fold(0.0, (prev, h) => prev + h);
    return total / activeDays;
  }

  List<bool> get weeklyChecklist {
    final now = DateTime.now();
    final startOfWeek = DateTime(now.year, now.month, now.day).subtract(Duration(days: now.weekday - 1));
    final checked = List<bool>.filled(7, false);
    for (int i = 0; i < 7; i++) {
      final day = startOfWeek.add(Duration(days: i));
      final dayStart = DateTime(day.year, day.month, day.day);
      final dayEnd = dayStart.add(const Duration(days: 1));
      checked[i] = _recentSessions.any((s) => s.timestamp.isAfter(dayStart) && s.timestamp.isBefore(dayEnd));
    }
    return checked;
  }

  int get weeklyActiveDaysCount => weeklyChecklist.where((c) => c).length;

  int get weeklyConsistencyRate {
    final active = weeklyActiveDaysCount;
    return ((active / 7) * 100).round();
  }

  double get studyPercentage {
    if (_recentSessions.isEmpty) return 0.0;
    final totalSecs = _recentSessions.fold(0, (prev, s) => prev + s.duration.inSeconds);
    if (totalSecs == 0) return 0.0;
    final studySecs = _recentSessions.where((s) => s.category == 'Study').fold(0, (prev, s) => prev + s.duration.inSeconds);
    return studySecs / totalSecs;
  }

  double get codingPercentage {
    if (_recentSessions.isEmpty) return 0.0;
    final totalSecs = _recentSessions.fold(0, (prev, s) => prev + s.duration.inSeconds);
    if (totalSecs == 0) return 0.0;
    final codingSecs = _recentSessions.where((s) => s.category == 'Coding').fold(0, (prev, s) => prev + s.duration.inSeconds);
    return codingSecs / totalSecs;
  }

  double get readingPercentage {
    if (_recentSessions.isEmpty) return 0.0;
    final totalSecs = _recentSessions.fold(0, (prev, s) => prev + s.duration.inSeconds);
    if (totalSecs == 0) return 0.0;
    final readingSecs = _recentSessions.where((s) => s.category == 'Reading').fold(0, (prev, s) => prev + s.duration.inSeconds);
    return readingSecs / totalSecs;
  }

  String get peakFocusTime {
    if (_recentSessions.isEmpty) return 'No sessions';
    final blocks = List<int>.filled(6, 0);
    for (final s in _recentSessions) {
      final hour = s.timestamp.hour;
      blocks[hour ~/ 4]++;
    }
    int maxIdx = 0;
    for (int i = 1; i < 6; i++) {
      if (blocks[i] > blocks[maxIdx]) {
        maxIdx = i;
      }
    }
    switch (maxIdx) {
      case 0: return '12 AM – 4 AM';
      case 1: return '4 AM – 8 AM';
      case 2: return '8 AM – 12 PM';
      case 3: return '12 PM – 4 PM';
      case 4: return '4 PM – 8 PM';
      case 5: return '8 PM – 12 AM';
      default: return 'No sessions';
    }
  }

  String get productivityTrend {
    final now = DateTime.now();
    final startOfWeek = DateTime(now.year, now.month, now.day).subtract(Duration(days: now.weekday - 1));
    final startOfLastWeek = startOfWeek.subtract(const Duration(days: 7));
    
    final thisWeekSecs = _recentSessions
        .where((s) => s.timestamp.isAfter(startOfWeek))
        .fold(0, (prev, s) => prev + s.duration.inSeconds);
    final lastWeekSecs = _recentSessions
        .where((s) => s.timestamp.isAfter(startOfLastWeek) && s.timestamp.isBefore(startOfWeek))
        .fold(0, (prev, s) => prev + s.duration.inSeconds);
        
    if (lastWeekSecs == 0) {
      if (thisWeekSecs == 0) {
        return 'Steady (0h this week)';
      }
      return 'Increasing (+100%)';
    }
    final change = ((thisWeekSecs - lastWeekSecs) / lastWeekSecs * 100).round();
    if (change >= 0) {
      return 'Increasing (+$change% vs last week)';
    } else {
      return 'Decreasing ($change% vs last week)';
    }
  }

  String get weeklyTrendPercent {
    final now = DateTime.now();
    final startOfWeek = DateTime(now.year, now.month, now.day).subtract(Duration(days: now.weekday - 1));
    final startOfLastWeek = startOfWeek.subtract(const Duration(days: 7));
    
    final thisWeekSecs = _recentSessions
        .where((s) => s.timestamp.isAfter(startOfWeek))
        .fold(0, (prev, s) => prev + s.duration.inSeconds);
    final lastWeekSecs = _recentSessions
        .where((s) => s.timestamp.isAfter(startOfLastWeek) && s.timestamp.isBefore(startOfWeek))
        .fold(0, (prev, s) => prev + s.duration.inSeconds);
        
    if (lastWeekSecs == 0) return thisWeekSecs > 0 ? '+100%' : '0%';
    final change = ((thisWeekSecs - lastWeekSecs) / lastWeekSecs * 100).round();
    return change >= 0 ? '+$change%' : '$change%';
  }

  double get totalFocusHours {
    final totalSecs = _recentSessions.fold(0, (prev, s) => prev + s.duration.inSeconds);
    return totalSecs / 3600.0;
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
