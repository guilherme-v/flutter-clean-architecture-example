import 'dart:convert';

import 'package:rickmorty/layers/domain/entity/location.dart';

class LocationDto extends Location {
  LocationDto({
    super.name,
    super.url,
  });

  // ---------------------------------------------------------------------------
  // JSON
  // ---------------------------------------------------------------------------
  factory LocationDto.fromRawJson(String str) =>
      LocationDto.fromMap(json.decode(str));

  String toRawJson() => json.encode(toMap());

  // ---------------------------------------------------------------------------
  // Maps
  // ---------------------------------------------------------------------------
  factory LocationDto.fromMap(Map<String, dynamic> json) => LocationDto(
        name: json['name'],
        url: json['url'],
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'url': url,
      };

  // ---------------------------------------------------------------------------
  // Domain
  // ---------------------------------------------------------------------------
  static LocationDto fromLocation(Location location) {
    return LocationDto(
      name: location.name,
      url: location.url,
    );
  }

  Location toLocation() {
    return Location(
      name: name,
      url: url,
    );
  }
}
