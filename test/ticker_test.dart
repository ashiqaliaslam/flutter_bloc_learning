import 'package:flutter_bloc_learning/ticker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Ticker', () {
    const ticker = Ticker();
    test('ticker emits 3 ticks from 2-1 every second', () {
      expectLater(ticker.tick(ticks: 3), emitsInOrder(<int>[2, 1, 0]));
    });
  });
}
