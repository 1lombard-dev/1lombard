// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_dto.freezed.dart';
part 'user_dto.g.dart';

@freezed
class UserDTO with _$UserDTO {
  const factory UserDTO({
    @JsonKey(defaultValue: -1) int? id,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'surname') String? surname,
    String? patronymic,
    String? phone,
    String? email,
    String? password,
    @JsonKey(name: 'id_number') String? idNumber,
    String? balance,
    String? bonus,
    String? avatar,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'device_token') String? deviceToken,
    @JsonKey(name: 'device_type') String? deviceType,
    @JsonKey(name: 'access_token') String? accessToken,
    String? role,
  }) = _UserDTO;
  factory UserDTO.fromJson(Map<String, dynamic> json) => _$UserDTOFromJson(json);
}
