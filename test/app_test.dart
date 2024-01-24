// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc_learning/app.dart';
import 'package:flutter_bloc_learning/counter/counter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CounterApp', () {
    testWidgets('is a MaterialApp', (widgetTester) async {
      expect(CounterApp(), isA<MaterialApp>());
    });

    testWidgets('home is CounterPage', (widgetTester) async {
      expect(CounterApp().home, isA<CounterPage>());
    });

    testWidgets('renders CounterPage', (widgetTester) async {
      await widgetTester.pumpWidget(CounterApp());
      expect(find.byType(CounterPage), findsOneWidget);
    });
  });
}
