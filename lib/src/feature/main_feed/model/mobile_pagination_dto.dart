import 'package:freezed_annotation/freezed_annotation.dart';

part 'mobile_pagination_dto.freezed.dart';
part 'mobile_pagination_dto.g.dart';

@freezed
class MobilePaginationDTO with _$MobilePaginationDTO {
  const factory MobilePaginationDTO({
    @JsonKey(name: 'current_page') int? currentPage,
    @JsonKey(name: 'has_more_pages') bool? hasMorePages,
    @JsonKey(name: 'last_page') int? lastPage,
    @JsonKey(name: 'per_page') int? perPage,
    int? total,
  }) = _MobilePaginationDTO;

  factory MobilePaginationDTO.fromJson(Map<String, dynamic> json) => _$MobilePaginationDTOFromJson(json);
}
