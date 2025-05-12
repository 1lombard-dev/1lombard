import 'package:freezed_annotation/freezed_annotation.dart';

part 'faq_dto.freezed.dart';
part 'faq_dto.g.dart';

@freezed
class FaqDTO with _$FaqDTO {
  const factory FaqDTO({
    @JsonKey(defaultValue: -1) int? id,
    String? question,
    String? answer,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  }) = _FaqDTO;
  factory FaqDTO.fromJson(Map<String, dynamic> json) => _$FaqDTOFromJson(json);
}
