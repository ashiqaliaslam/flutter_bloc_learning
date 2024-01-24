// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc_learning/counter/counter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CounterPage', () {
    testWidgets('renders CounterView', (widgetTester) async {
      await widgetTester.pumpWidget(
        MaterialApp(
          home: CounterPage(),
        ),
      );
      expect(find.byType(CounterView), findsOneWidget);
    });
  });
}
