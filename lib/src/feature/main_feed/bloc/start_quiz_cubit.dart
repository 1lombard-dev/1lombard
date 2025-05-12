import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lombard/src/core/rest_client/rest_client.dart';
import 'package:lombard/src/feature/main_feed/data/main_repository.dart';
import 'package:lombard/src/feature/main_feed/model/quiz_dto.dart';

part 'start_quiz_cubit.freezed.dart';

class StartQuizCubit extends Cubit<StartQuizState> {
  StartQuizCubit({
    required IMainRepository repository,
  })  : _repository = repository,
        super(const StartQuizState.initial());
  final IMainRepository _repository;

  Future<void> startQuiz({
    required int subjectId,
    int? sectionId,
  }) async {
    try {
      emit(const StartQuizState.loading());

      final result = await _repository.startQuiz(subjectId: subjectId, sectionId: sectionId);

      emit(StartQuizState.loaded(response: result));
    } on RestClientException catch (e) {
      emit(
        StartQuizState.error(
          message: e.message,
        ),
      );
    } catch (e) {
      emit(
        StartQuizState.error(
          message: e.toString(),
        ),
      );
    }
  }
}

@freezed
class StartQuizState with _$StartQuizState {
  const factory StartQuizState.initial() = _InitialState;

  const factory StartQuizState.loading() = _LoadingState;

  const factory StartQuizState.loaded({
    required QuizDTO response,
  }) = _LoadedState;

  const factory StartQuizState.error({
    required String message,
  }) = _ErrorState;
}
