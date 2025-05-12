import 'package:freezed_annotation/freezed_annotation.dart';

part 'city_dto.freezed.dart';
part 'city_dto.g.dart';

@freezed
class CityDTO with _$CityDTO {
  const factory CityDTO({
    int? id,
    String? name,
  }) = _CityDTO;

  factory CityDTO.fromJson(Map<String, dynamic> json) => _$CityDTOFromJson(json);
}
