// ignore_for_file: prefer_const_constructors

import 'package:flutter_bloc_learning/posts/models/post.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('supports value comparison', () {
    expect(
      Post(id: 1, title: 'post title', body: 'post body'),
      Post(id: 1, title: 'post title', body: 'post body'),
    );
  });
}
