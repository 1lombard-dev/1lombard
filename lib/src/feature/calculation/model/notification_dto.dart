import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_dto.g.dart';
part 'notification_dto.freezed.dart';

@unfreezed
class NotificationDTO with _$NotificationDTO {
  factory NotificationDTO({
    int? id,
    String? title,
    String? message,
    String? photo,
    @JsonKey(name: 'has_button') bool? hasButton,
    @JsonKey(name: 'is_read') int? isRead,
    @JsonKey(name: 'button_text') String? buttonText,
    @JsonKey(name: 'button_url') String? buttonUrl,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _NotificationDTO;

  factory NotificationDTO.fromJson(Map<String, dynamic> json) => _$NotificationDTOFromJson(json);
}
