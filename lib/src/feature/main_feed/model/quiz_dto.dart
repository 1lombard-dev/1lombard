import 'package:freezed_annotation/freezed_annotation.dart';

part 'quiz_dto.freezed.dart';
part 'quiz_dto.g.dart';

@freezed
class QuizDTO with _$QuizDTO {
  const factory QuizDTO({
    @JsonKey(name: 'test_id') int? testId,
    @JsonKey(name: 'subject_id') int? subjectId,
    @JsonKey(name: 'section_id') int? sectionId,
    @JsonKey(name: 'user_id') int? userId,
  }) = _QuizDTO;

  factory QuizDTO.fromJson(Map<String, dynamic> json) => _$QuizDTOFromJson(json);
}

@freezed
class QuizResultDTO with _$QuizResultDTO {
  const factory QuizResultDTO({
    @JsonKey(name: 'correct_answers') int? correctAnswers,
    @JsonKey(name: 'total_questions') int? totalQuestions,
    @JsonKey(name: 'time_taken') TimeTakenDTO? timeTaken,
    @JsonKey(name: 'incorrect_topics') List<String>? incorrectTopics,
  }) = _QuizResultDTO;

  factory QuizResultDTO.fromJson(Map<String, dynamic> json) => _$QuizResultDTOFromJson(json);
}

@freezed
class TimeTakenDTO with _$TimeTakenDTO {
  const factory TimeTakenDTO({
    int? hours,
    int? minutes,
    int? seconds,
  }) = _TimeTakenDTO;

  factory TimeTakenDTO.fromJson(Map<String, dynamic> json) => _$TimeTakenDTOFromJson(json);
}
