import 'package:freezed_annotation/freezed_annotation.dart';

part 'question_dto.freezed.dart';
part 'question_dto.g.dart';

@freezed
class QuestionDTO with _$QuestionDTO {
  const factory QuestionDTO({
    int? id,
    String? text,
    String? image,
    String? topic,
    String? solution,
    List<AnswerDTO>? answers,
    @JsonKey(name: 'user_answer_id') int? userAnswerId,
  }) = _QuestionDTO;

  factory QuestionDTO.fromJson(Map<String, dynamic> json) => _$QuestionDTOFromJson(json);
}

@freezed
class AnswerDTO with _$AnswerDTO {
  const factory AnswerDTO({
    int? id,
    String? text,
    @JsonKey(name: 'is_correct') int? isCorrect,
    String? image,
  }) = _AnswerDTO;

  factory AnswerDTO.fromJson(Map<String, dynamic> json) => _$AnswerDTOFromJson(json);
}
