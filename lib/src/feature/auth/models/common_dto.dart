import 'package:freezed_annotation/freezed_annotation.dart';

part 'common_dto.freezed.dart';
part 'common_dto.g.dart';

/// This [CommonDTO] class will be used for objects such as the city, the student's class, etc
@freezed
class CommonDTO with _$CommonDTO {
  const factory CommonDTO({
    int? id,
    String? name,

    // authenticate
    String? message,
    bool? exists,
  }) = _CommonDTO;

  factory CommonDTO.fromJson(Map<String, dynamic> json) => _$CommonDTOFromJson(json);
}
