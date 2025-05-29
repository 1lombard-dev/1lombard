import 'package:freezed_annotation/freezed_annotation.dart';

part 'question_dto.freezed.dart';
part 'question_dto.g.dart';

@freezed
class QuestionDTO with _$QuestionDTO {
  const factory QuestionDTO({
    String? title,
    String? introtext,
  }) = _QuestionDTO;

  factory QuestionDTO.fromJson(Map<String, dynamic> json) => _$QuestionDTOFromJson(json);
}
