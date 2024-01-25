import 'package:flutter_bloc_learning/ticker.dart';
import 'package:flutter_bloc_learning/timer/bloc/timer_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';

class _MockTicker extends Mock implements Ticker {}

void main() {
  group('TimerBloc', () {
    late Ticker ticker;

    setUp(() {
      ticker = _MockTicker();
      when(() => ticker.tick(ticks: 5)).thenAnswer(
        (_) => Stream<int>.fromIterable([5, 4, 3, 2, 1]),
      );
    });

    test('initial state is TimerInitial(60)', () {
      expect(
        TimerBloc(ticker: ticker).state,
        const TimerInitial(60),
      );
    });

    blocTest<TimerBloc, TimerState>(
      'emits TickerRunInProgress 5 times after timer started',
      build: () => TimerBloc(ticker: ticker),
      act: (bloc) => bloc.add(const TimerStarted(duration: 5)),
      expect: () => const <TimerState>[
        TimerRunInProgress(5),
        TimerRunInProgress(4),
        TimerRunInProgress(3),
        TimerRunInProgress(2),
        TimerRunInProgress(1),
      ],
      verify: (_) => verify(() => ticker.tick(ticks: 5)).called(1),
    );

    blocTest<TimerBloc, TimerState>(
      'emits [TickerRunPause(2)] when ticker is paused at 2',
      build: () => TimerBloc(ticker: ticker),
      seed: () => const TimerRunInProgress(2),
      act: (bloc) => bloc.add(const TimerPaused()),
      expect: () => const <TimerState>[TimerRunPause(2)],
    );
    blocTest<TimerBloc, TimerState>(
      'emit [TimerRunInProgress(5)] when ticker is resumed at 5',
      build: () => TimerBloc(ticker: ticker),
      seed: () => const TimerRunPause(5),
      act: (bloc) => bloc.add(const TimerResumed()),
      expect: () => const <TimerState>[TimerRunInProgress(5)],
    );
    blocTest<TimerBloc, TimerState>(
      'emit [TickerInitial(60)] when timer is restarted',
      build: () => TimerBloc(ticker: ticker),
      act: (bloc) => bloc.add(const TimerReset()),
      expect: () => const <TimerState>[TimerInitial(60)],
    );
    blocTest<TimerBloc, TimerState>(
      'emits [TimerRunInProgres(3)] when timer ticks to 3',
      setUp: () {
        when(() => ticker.tick(ticks: 3)).thenAnswer(
          (_) => Stream<int>.value(3),
        );
      },
      build: () => TimerBloc(ticker: ticker),
      act: (bloc) => bloc.add(const TimerStarted(duration: 3)),
      expect: () => const <TimerState>[TimerRunInProgress(3)],
    );
    blocTest<TimerBloc, TimerState>(
      'emits [TimerRunInProgress(1), TimerRunComplete()] when timer ticks to 0',
      setUp: () {
        when(() => ticker.tick(ticks: 1)).thenAnswer(
          (_) => Stream<int>.fromIterable([1, 0]),
        );
      },
      build: () => TimerBloc(ticker: ticker),
      act: (bloc) => bloc.add(const TimerStarted(duration: 1)),
      expect: () => const <TimerState>[
        TimerRunInProgress(1),
        TimerRunComplete(),
      ],
    );
  });
}
