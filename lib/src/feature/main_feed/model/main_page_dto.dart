import 'package:freezed_annotation/freezed_annotation.dart';

part 'main_page_dto.freezed.dart';
part 'main_page_dto.g.dart';

@freezed
class LayersDTO with _$LayersDTO {
  const factory LayersDTO({
    List<BannerDTO>? layers,
    String? cityname,
    String? branchname,
    String? coords,
    String? time,
    String? phones,
    String? address,
  }) = _LayersDTO;

  factory LayersDTO.fromJson(Map<String, dynamic> json) => _$LayersDTOFromJson(json);
}

@freezed
class BannerDTO with _$BannerDTO {
  const factory BannerDTO({
    int? id,
    String? type,
    String? title,
    String? introtext,
    String? fulltext,
    String? imagelink,
    String? content,
    String? href,
    @JsonKey(name: 'date_of_creation') DateTime? createdAt,
    @JsonKey(name: 'small_image') String? smallImage,
    @JsonKey(name: 'readmore_link') String? readmoreLink,
    @JsonKey(name: 'full_image') String? fullImage,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _BannerDTO;

  factory BannerDTO.fromJson(Map<String, dynamic> json) => _$BannerDTOFromJson(json);
}
