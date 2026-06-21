import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:focusflip/main.dart';
import 'package:focusflip/models/app_state.dart';

void main() {
  testWidgets('FocusFlip app load smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => AppState(),
        child: const FocusFlipApp(),
      ),
    );

    // Verify that the greeting "Good Evening" is rendered.
    expect(find.text('Good Evening'), findsOneWidget);
  });
}
