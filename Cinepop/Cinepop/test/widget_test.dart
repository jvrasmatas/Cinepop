import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cinepop/models/movie.dart';
import 'package:cinepop/widgets/rating_widget.dart';

void main() {
  group('Movie model', () {
    test('parses year from release date', () {
      const movie = Movie(
        id: 1,
        title: 'Test',
        overview: '',
        voteAverage: 7.5,
        releaseDate: '2024-05-01',
      );
      expect(movie.year, '2024');
      expect(movie.formattedRating, '7.5');
    });

    test('falls back to "—" for empty release date', () {
      const movie = Movie(
        id: 1,
        title: 'Test',
        overview: '',
        voteAverage: 0,
        releaseDate: '',
      );
      expect(movie.year, '—');
    });

    test('round-trips through JSON for favorites persistence', () {
      const movie = Movie(
        id: 42,
        title: 'Cinepop',
        overview: 'A movie app',
        voteAverage: 8.2,
        releaseDate: '2023-01-01',
      );
      final restored = Movie.fromJson(movie.toJson());
      expect(restored.id, movie.id);
      expect(restored.title, movie.title);
      expect(restored.voteAverage, movie.voteAverage);
    });
  });

  testWidgets('RatingWidget renders the rating value', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: RatingWidget(rating: 8.3)),
      ),
    );

    expect(find.text('8.3'), findsOneWidget);
    expect(find.byIcon(Icons.star_rounded), findsOneWidget);
  });
}
