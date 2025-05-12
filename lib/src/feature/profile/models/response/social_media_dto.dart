import 'package:freezed_annotation/freezed_annotation.dart';

part 'social_media_dto.freezed.dart';
part 'social_media_dto.g.dart';

@freezed
class SocialMediaDTO with _$SocialMediaDTO {
  const factory SocialMediaDTO({
    @JsonKey(defaultValue: -1) int? id,
    String? platform,
    String? url,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _SocialMediaDTO;
  factory SocialMediaDTO.fromJson(Map<String, dynamic> json) => _$SocialMediaDTOFromJson(json);
}
