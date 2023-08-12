import 'package:rickmorty/layers/data/dto/location_dto.dart';
import 'package:test/test.dart';

void main() {
  group('LocationDto', () {
    late String referenceRawJson;
    late LocationDto referenceDto;

    setUp(() {
      referenceDto = LocationDto(
        name: 'Rick Sanchez',
        url: 'https://example.com/character/1',
      );

      referenceRawJson = referenceDto.toRawJson();
    });

    test('should create LocationDto instance to/from JSON', () {
      final createdDto = LocationDto.fromRawJson(referenceRawJson);
      final json = createdDto.toRawJson();
      expect(createdDto, referenceDto);
      expect(json, referenceRawJson);
    });
  });
}
