import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:focusflip/main.dart';
import 'package:focusflip/models/app_state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseCoreMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  testWidgets('FocusFlip app load smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => AppState(),
        child: const FocusFlipApp(),
      ),
    );

    // Verify that the Welcome Screen message is rendered.
    expect(find.text('Master your time, shape your focus.'), findsOneWidget);
  });
}
