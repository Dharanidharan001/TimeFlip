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
      if (userDoc.exists) {
        final data = userDoc.data()!;
        _streak = data['streak'] ?? 0;
        _todayTotalFocus = Duration(seconds: data['todayTotalFocusSeconds'] ?? 0);
      } else {
        _streak = 0;
        _todayTotalFocus = Duration.zero;
      }

      final sessionsQuery = await _db
          .collection('users')
          .doc(uid)
          .collection('sessions')
          .orderBy('timestamp', descending: true)
          .limit(20)
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

          _streak = _streak == 0 ? 1 : _streak; // Set streak to 1 if first session
          _db.collection('users').doc(user.uid).set({
            'streak': _streak,
            'todayTotalFocusSeconds': _todayTotalFocus.inSeconds,
            'lastFocusDate': DateTime.now().toIso8601String().substring(0, 10),
          }, SetOptions(merge: true));
        }
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
