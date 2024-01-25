import 'package:flutter_bloc_learning/app.dart';
import 'package:flutter_bloc_learning/timer/view/timer_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('App', () {
    testWidgets('renders TimerPage', (widgetTester) async {
      await widgetTester.pumpWidget(const App());
      expect(find.byType(TimerPage), findsOneWidget);
    });
  });
}
