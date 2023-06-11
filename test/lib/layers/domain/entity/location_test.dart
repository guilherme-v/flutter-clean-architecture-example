import 'package:rickmorty/layers/domain/entity/location.dart';
import 'package:test/test.dart';

void main() {
  group('Location', () {
    test('Two instances with the same properties should be equal', () {
      final location1 = Location(
        name: 'Earth',
        url: 'https://example.com/earth',
      );

      final location2 = Location(
        name: 'Earth',
        url: 'https://example.com/earth',
      );

      expect(location1, equals(location2));
    });

    test('Two instances with different properties should be different', () {
      final location1 = Location(
        name: 'Earth',
        url: 'https://example.com/earth',
      );

      final location2 = Location(
        name: 'Mars',
        url: 'https://example.com/mars',
      );

      expect(location1, isNot(equals(location2)));
    });
  });
}
