import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_payload.freezed.dart';
part 'user_payload.g.dart';

@freezed
class UserPayload with _$UserPayload {
  const factory UserPayload({
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'surname') String? surname,
    String? patronymic,
    String? password,
    String? phone,
    @JsonKey(includeIfNull: false, name: 'device_token') String? deviceToken,
    @JsonKey(includeIfNull: false, name: 'device_type') String? deviceType,
    // @JsonKey(name: 'password_confirmation') String? passwordConfirmation,
  }) = _UserPayload;

  factory UserPayload.fromJson(Map<String, dynamic> json) => _$UserPayloadFromJson(json);
}
