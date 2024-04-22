import 'package:rickmorty/layers/data/dto/character_dto.dart';
import 'package:rickmorty/layers/data/dto/location_dto.dart';
import 'package:test/test.dart';

void main() {
  group('CharacterDto', () {
    late String referenceRawJson;
    late CharacterDto referenceDto;

    setUp(() {
      referenceDto = CharacterDto(
        id: 1,
        name: 'Rick Sanchez',
        status: 'Alive',
        species: 'Human',
        type: 'Super genius',
        gender: 'Male',
        origin: LocationDto(name: 'Earth', url: 'https://example.com/earth'),
        location: LocationDto(name: 'Earth', url: 'https://example.com/earth'),
        image: 'https://example.com/rick.png',
        episode: [
          'https://example.com/episode1',
          'https://example.com/episode2',
        ],
        url: 'https://example.com/character/1',
        created: DateTime.parse('2022-01-01T12:00:00Z'),
      );

      referenceRawJson = referenceDto.toRawJson();
    });

    test('should create CharacterDto instance to/from JSON', () {
      final createdDto = CharacterDto.fromRawJson(referenceRawJson);
      final json = createdDto.toRawJson();
      expect(createdDto, referenceDto);
      expect(json, referenceRawJson);
    });
  });
}
