import 'package:freezed_annotation/freezed_annotation.dart';

part 'main_page_dto.freezed.dart';
part 'main_page_dto.g.dart';

@freezed
class BannerDTO with _$BannerDTO {
  const factory BannerDTO({
    int? id,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _BannerDTO;

  factory BannerDTO.fromJson(Map<String, dynamic> json) => _$BannerDTOFromJson(json);
}
