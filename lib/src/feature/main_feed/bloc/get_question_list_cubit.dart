import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lombard/src/core/rest_client/rest_client.dart';
import 'package:lombard/src/feature/main_feed/data/main_repository.dart';
import 'package:lombard/src/feature/main_feed/model/question_dto.dart';

part 'get_question_list_cubit.freezed.dart';

class GetQuestionListCubit extends Cubit<GetQuestionListState> {
  GetQuestionListCubit({
    required IMainRepository repository,
  })  : _repository = repository,
        super(const GetQuestionListState.initial());
  final IMainRepository _repository;

  Future<void> getQuestionList({
    required int testId,
  }) async {
    try {
      emit(const GetQuestionListState.loading());

      final result = await _repository.getQuestionList(testId: testId);

      emit(GetQuestionListState.loaded(list: result));
    } on RestClientException catch (e) {
      emit(
        GetQuestionListState.error(
          message: e.message,
        ),
      );
    } catch (e) {
      emit(
        GetQuestionListState.error(
          message: e.toString(),
        ),
      );
    }
  }
}

@freezed
class GetQuestionListState with _$GetQuestionListState {
  const factory GetQuestionListState.initial() = _InitialState;

  const factory GetQuestionListState.loading() = _LoadingState;

  const factory GetQuestionListState.loaded({
    required List<QuestionDTO> list,
  }) = _LoadedState;

  const factory GetQuestionListState.error({
    required String message,
  }) = _ErrorState;
}
