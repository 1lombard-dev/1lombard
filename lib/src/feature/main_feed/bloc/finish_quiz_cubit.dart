import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lombard/src/core/rest_client/rest_client.dart';
import 'package:lombard/src/feature/main_feed/data/main_repository.dart';
import 'package:lombard/src/feature/main_feed/model/quiz_dto.dart';

part 'finish_quiz_cubit.freezed.dart';

class FinishQuizCubit extends Cubit<FinishQuizState> {
  FinishQuizCubit({
    required IMainRepository repository,
  })  : _repository = repository,
        super(const FinishQuizState.initial());
  final IMainRepository _repository;

  Future<void> finishTest({
    required int testId,
  }) async {
    try {
      emit(const FinishQuizState.loading());

      final result = await _repository.finishTest(testId: testId);

      emit(FinishQuizState.loaded(response: result));
    } on RestClientException catch (e) {
      emit(
        FinishQuizState.error(
          message: e.message,
        ),
      );
    } catch (e) {
      emit(
        FinishQuizState.error(
          message: e.toString(),
        ),
      );
    }
  }
}

@freezed
class FinishQuizState with _$FinishQuizState {
  const factory FinishQuizState.initial() = _InitialState;

  const factory FinishQuizState.loading() = _LoadingState;

  const factory FinishQuizState.loaded({
    required QuizResultDTO response,
  }) = _LoadedState;

  const factory FinishQuizState.error({
    required String message,
  }) = _ErrorState;
}
