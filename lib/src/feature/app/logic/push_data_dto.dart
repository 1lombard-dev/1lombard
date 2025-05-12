import 'package:freezed_annotation/freezed_annotation.dart';

part 'push_data_dto.freezed.dart';
part 'push_data_dto.g.dart';

@freezed
class PushDataDTO with _$PushDataDTO {
  const factory PushDataDTO({
    String? id,
    String? type,
    String? title,
    PushDataInfoDTO? info,
    // String? body,
    // String? title,
  }) = _PushDataDTO;

  factory PushDataDTO.fromJson(Map<String, dynamic> json) => _$PushDataDTOFromJson(json);
}

@freezed
class PushDataInfoDTO with _$PushDataInfoDTO {
  const factory PushDataInfoDTO({
    String? action,
    @JsonKey(name: 'order_id') String? orderId,
  }) = _PushDataInfoDTO;

  factory PushDataInfoDTO.fromJson(Map<String, dynamic> json) => _$PushDataInfoDTOFromJson(json);
}
