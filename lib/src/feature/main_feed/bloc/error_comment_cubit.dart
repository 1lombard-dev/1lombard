import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lombard/src/core/rest_client/models/basic_response.dart';
import 'package:lombard/src/core/rest_client/rest_client.dart';
import 'package:lombard/src/feature/main_feed/data/main_repository.dart';

part 'error_comment_cubit.freezed.dart';

class ErrorCommentCubit extends Cubit<ErrorCommentState> {
  ErrorCommentCubit({
    required IMainRepository repository,
  })  : _repository = repository,
        super(const ErrorCommentState.initial());
  final IMainRepository _repository;

  Future<void> uploadErrorComment({
    required int questionId,
    required String comment,
  }) async {
    try {
      emit(const ErrorCommentState.loading());

      final result = await _repository.errorComment(questionId: questionId, comment: comment);

      emit(ErrorCommentState.loaded(response: result));
    } on RestClientException catch (e) {
      emit(
        ErrorCommentState.error(
          message: e.message,
        ),
      );
    } catch (e) {
      emit(
        ErrorCommentState.error(
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> answerUpload({
    required int testId,
    required int questionId,
    required int answerId,
  }) async {
    try {
      emit(const ErrorCommentState.loading());

      final result = await _repository.answerUpload(questionId: questionId, answerId: answerId, testId: testId);

      emit(ErrorCommentState.loaded(response: result));
    } on RestClientException catch (e) {
      emit(
        ErrorCommentState.error(
          message: e.message,
        ),
      );
    } catch (e) {
      emit(
        ErrorCommentState.error(
          message: e.toString(),
        ),
      );
    }
  }
}

@freezed
class ErrorCommentState with _$ErrorCommentState {
  const factory ErrorCommentState.initial() = _InitialState;

  const factory ErrorCommentState.loading() = _LoadingState;

  const factory ErrorCommentState.loaded({
    required BasicResponse response,
  }) = _LoadedState;

  const factory ErrorCommentState.error({
    required String message,
  }) = _ErrorState;
}
