import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_dto.freezed.dart';
part 'category_dto.g.dart';

@freezed
class CategoryDTO with _$CategoryDTO {
  const factory CategoryDTO({
    int? id,
    @JsonKey(name: 'category_name') String? categoryName,
    List<SubjectDTO>? subjects,
  }) = _CategoryDTO;

  factory CategoryDTO.fromJson(Map<String, dynamic> json) => _$CategoryDTOFromJson(json);
}

@freezed
class SubjectDTO with _$SubjectDTO {
  const factory SubjectDTO({
    int? id,
    String? name,
    @JsonKey(name: 'questions_count') int? questionsCount,
    @JsonKey(name: 'has_sections') bool? hasSections,
    List<SectionDTO>? sections,
  }) = _SubjectDTO;

  factory SubjectDTO.fromJson(Map<String, dynamic> json) => _$SubjectDTOFromJson(json);
}

@freezed
class SectionDTO with _$SectionDTO {
  const factory SectionDTO({
    int? id,
    String? name,
    @JsonKey(name: 'questions_count') int? questionsCount,
  }) = _SectionDTO;

  factory SectionDTO.fromJson(Map<String, dynamic> json) => _$SectionDTOFromJson(json);
}
