// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc_learning/posts/view/posts_list.dart';
import 'package:flutter_bloc_learning/posts/view/posts_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('renders PostList', () {
    testWidgets('renders PostList', (widgetTester) async {
      await widgetTester.pumpWidget(MaterialApp(home: PostsPage()));
      await widgetTester.pumpAndSettle();
      expect(find.byType(PostsList), findsOneWidget);
    });
  });
}
