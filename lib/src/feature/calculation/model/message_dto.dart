import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_dto.g.dart';
part 'message_dto.freezed.dart';

@unfreezed
class MessageDTO with _$MessageDTO {
  factory MessageDTO({
    int? id,
    String? text,
    int? to,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'is_read') int? isRead,
    @JsonKey(name: 'is_from_user') bool? isFromUser,
    @JsonKey(name: 'user_type') String? userType,
    @JsonKey(name: 'user_id') int? userId,
    @JsonKey(name: 'chat_id') int? chatId,
    @Freezed(
      fromJson: false,
      toJson: false,
    )
    MessageStatus? messageStatus,
  }) = _MessageDTO;

  factory MessageDTO.fromJson(Map<String, dynamic> json) => _$MessageDTOFromJson(json);
}

enum MessageStatus { loading, error }
