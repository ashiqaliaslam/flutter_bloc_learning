import 'package:flutter_bloc_learning/timer/bloc/timer_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TimerState', () {
    group('TimerInitial', () {
      test('supports value comparison', () {
        expect(
          const TimerInitial(60),
          const TimerInitial(60),
        );
      });
    });
    group('TimerRunPause', () {
      test('supports value comparison', () {
        expect(
          const TimerRunPause(60),
          const TimerRunPause(60),
        );
      });
    });
    group('TimerRunInProgress', () {
      test('supports value comparison', () {
        expect(
          const TimerRunInProgress(60),
          const TimerRunInProgress(60),
        );
      });
    });
    group('TimerRunComplete', () {
      test('supports value comparison', () {
        expect(
          const TimerRunComplete(),
          const TimerRunComplete(),
        );
      });
    });
  });
}
