import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lombard/src/core/rest_client/rest_client.dart';
import 'package:lombard/src/feature/main_feed/data/main_repository.dart';
import 'package:lombard/src/feature/main_feed/model/question_dto.dart';

part 'get_faq_cubit.freezed.dart';

class GetFaqCubit extends Cubit<GetFaqState> {
  GetFaqCubit({
    required IMainRepository repository,
  })  : _repository = repository,
        super(const GetFaqState.initial());
  final IMainRepository _repository;

  Future<void> getFAQ() async {
    try {
      emit(const GetFaqState.loading());

      final result = await _repository.getFAQ();

      emit(GetFaqState.loaded(faq: result));
    } on RestClientException catch (e) {
      emit(
        GetFaqState.error(
          message: e.message,
        ),
      );
    } catch (e) {
      emit(
        GetFaqState.error(
          message: e.toString(),
        ),
      );
    }
  }
}

@freezed
class GetFaqState with _$GetFaqState {
  const factory GetFaqState.initial() = _InitialState;

  const factory GetFaqState.loading() = _LoadingState;

  const factory GetFaqState.loaded({
    required List<QuestionDTO> faq,
  }) = _LoadedState;

  const factory GetFaqState.error({
    required String message,
  }) = _ErrorState;
}
