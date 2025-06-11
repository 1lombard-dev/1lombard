// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_dto.freezed.dart';
part 'user_dto.g.dart';

@freezed
class UserDTO with _$UserDTO {
  const factory UserDTO({
    @JsonKey(defaultValue: -1) int? id,
    @JsonKey(name: 'fullname') String? fullname,
    String? mobilephone,
    String? iin,
    @JsonKey(name: 'device_token') String? deviceToken,
    @JsonKey(name: 'device_type') String? deviceType,
  }) = _UserDTO;
  factory UserDTO.fromJson(Map<String, dynamic> json) => _$UserDTOFromJson(json);
}
