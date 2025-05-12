// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'document_dto.freezed.dart';
part 'document_dto.g.dart';

@freezed
class DocumentDTO with _$DocumentDTO {
  const factory DocumentDTO({
    @JsonKey(defaultValue: -1) int? id,
    String? name,
    String? url,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _DocumentDTO;
  factory DocumentDTO.fromJson(Map<String, dynamic> json) => _$DocumentDTOFromJson(json);
}
