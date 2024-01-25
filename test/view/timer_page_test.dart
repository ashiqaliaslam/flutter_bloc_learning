import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_learning/timer/bloc/timer_bloc.dart';
import 'package:flutter_bloc_learning/timer/view/timer_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockTimerBloc extends MockBloc<TimerEvent, TimerState>
    implements TimerBloc {}

extension on WidgetTester {
  Future<void> pumpTimerView(TimerBloc timerBloc) {
    return pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: timerBloc,
          child: const TimerView(),
        ),
      ),
    );
  }
}

void main() {
  late TimerBloc timerBloc;

  setUpAll(() {
    registerFallbackValue(const TimerStarted(duration: 0));
  });

  setUp(() {
    timerBloc = _MockTimerBloc();
  });

  tearDown(() => reset(timerBloc));

  group('TimerPage', () {
    testWidgets('renders TimerView', (widgetTester) async {
      await widgetTester.pumpWidget(const MaterialApp(home: TimerPage()));
    });
  });

  group('TimerView', () {
    testWidgets('renders initial Timer view', (widgetTester) async {
      when(() => timerBloc.state).thenReturn(const TimerInitial(60));
      await widgetTester.pumpTimerView(timerBloc);
      expect(find.text('01:00'), findsOneWidget);
      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
    });

    testWidgets('renders pause and reset button when timer is in progress',
        (widgetTester) async {
      when(() => timerBloc.state).thenReturn(const TimerRunInProgress(59));
      await widgetTester.pumpTimerView(timerBloc);
      expect(find.text('00:59'), findsOneWidget);
      expect(find.byIcon(Icons.pause), findsOneWidget);
      expect(find.byIcon(Icons.replay), findsOneWidget);
    });

    testWidgets('renders play and reset button when timer is paused',
        (widgetTester) async {
      when(() => timerBloc.state).thenReturn(const TimerRunPause(600));
      await widgetTester.pumpTimerView(timerBloc);
      expect(find.text('10:00'), findsOneWidget);
      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
      expect(find.byIcon(Icons.replay), findsOneWidget);
    });

    testWidgets('renders replay button when timer is finished',
        (widgetTester) async {
      when(() => timerBloc.state).thenReturn(const TimerRunComplete());
      await widgetTester.pumpTimerView(timerBloc);
      expect(find.text('00:00'), findsOneWidget);
      expect(find.byIcon(Icons.replay), findsOneWidget);
    });

    testWidgets('timer started when play arrow button is pressed',
        (widgetTester) async {
      when(() => timerBloc.state).thenReturn(const TimerInitial(60));
      await widgetTester.pumpTimerView(timerBloc);
      await widgetTester.tap(find.byIcon(Icons.play_arrow));
      verify(
        () => timerBloc.add(
          any(
            that: isA<TimerStarted>().having((e) => e.duration, 'duration', 60),
          ),
        ),
      ).called(1);
    });

    testWidgets(
        'timer pauses when pause button is pressed '
        'while time is in progress', (widgetTester) async {
      when(() => timerBloc.state).thenReturn(const TimerRunInProgress(30));
      await widgetTester.pumpTimerView(timerBloc);
      await widgetTester.tap(find.byIcon(Icons.pause));
      verify(() => timerBloc.add(const TimerPaused())).called(1);
    });

    testWidgets(
        'timer resets when replay button is pressed '
        'while timer is in progress', (tester) async {
      when(() => timerBloc.state).thenReturn(const TimerRunInProgress(30));
      await tester.pumpTimerView(timerBloc);
      await tester.tap(find.byIcon(Icons.replay));
      verify(() => timerBloc.add(const TimerReset())).called(1);
    });

    testWidgets(
        'timer resumes when play arrow button is pressed '
        'while timer is paused', (tester) async {
      when(() => timerBloc.state).thenReturn(const TimerRunPause(30));
      await tester.pumpTimerView(timerBloc);
      await tester.tap(find.byIcon(Icons.play_arrow));
      verify(() => timerBloc.add(const TimerResumed())).called(1);
    });

    testWidgets(
        'timer resets when reset button is pressed '
        'while timer is paused', (tester) async {
      when(() => timerBloc.state).thenReturn(const TimerRunPause(30));
      await tester.pumpTimerView(timerBloc);
      await tester.tap(find.byIcon(Icons.replay));
      verify(() => timerBloc.add(const TimerReset())).called(1);
    });

    testWidgets(
        'timer resets when reset button is pressed '
        'when timer is finished', (tester) async {
      when(() => timerBloc.state).thenReturn(const TimerRunComplete());
      await tester.pumpTimerView(timerBloc);
      await tester.tap(find.byIcon(Icons.replay));
      verify(() => timerBloc.add(const TimerReset())).called(1);
    });

    testWidgets('actions are not rebuilt when timer is running',
        (widgetTester) async {
      final controller = StreamController<TimerState>();
      whenListen(
        timerBloc,
        controller.stream,
        initialState: const TimerRunInProgress(10),
      );
      await widgetTester.pumpTimerView(timerBloc);

      FloatingActionButton findPauseButton() {
        return widgetTester.widget<FloatingActionButton>(
          find.byWidgetPredicate(
            (widget) =>
                widget is FloatingActionButton &&
                widget.child is Icon &&
                (widget.child! as Icon).icon == Icons.pause,
          ),
        );
      }

      final pauseButton = findPauseButton();
      controller.add(const TimerRunInProgress(9));
      await widgetTester.pump();
      expect(pauseButton, equals(findPauseButton()));
    });
  });
}
