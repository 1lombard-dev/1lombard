import 'package:freezed_annotation/freezed_annotation.dart';

part 'working_hour_dto.freezed.dart';
part 'working_hour_dto.g.dart';

@freezed
class WorkingHourDTO with _$WorkingHourDTO {
  const factory WorkingHourDTO({
    @JsonKey(defaultValue: -1) int? id,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'day_from') String? dayFrom,
    @JsonKey(name: 'day_to') String? dayTo,
    @JsonKey(name: 'time_from') String? timeFrom,
    @JsonKey(name: 'time_to') String? timeTo,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _WorkingHourDTO;
  factory WorkingHourDTO.fromJson(Map<String, dynamic> json) => _$WorkingHourDTOFromJson(json);
}
