import 'package:freezed_annotation/freezed_annotation.dart';

part 'about_us_dto.freezed.dart';
part 'about_us_dto.g.dart';

@freezed
class AboutUsDTO with _$AboutUsDTO {
  const factory AboutUsDTO({
    @JsonKey(defaultValue: -1) int? id,
    String? author,
    @JsonKey(name: 'author_position') String? authorPosition,
    @JsonKey(name: 'author_image') String? authorimage,
    @JsonKey(name: 'text') String? text,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _AboutUsDTO;
  factory AboutUsDTO.fromJson(Map<String, dynamic> json) => _$AboutUsDTOFromJson(json);
}
