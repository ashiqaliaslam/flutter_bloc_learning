// ignore_for_file: prefer_const_constructors

import 'package:flutter_bloc_learning/app.dart';
import 'package:flutter_bloc_learning/posts/view/posts_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('App', () {
    testWidgets('renders PostsPage', (tester) async {
      await tester.pumpWidget(App());
      await tester.pumpAndSettle();
      expect(find.byType(PostsPage), findsOneWidget);
    });
  });
}
