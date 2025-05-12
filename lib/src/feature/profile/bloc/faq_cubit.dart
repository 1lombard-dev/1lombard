import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:lombard/src/core/rest_client/rest_client.dart';
import 'package:lombard/src/feature/profile/data/profile_repository.dart';
import 'package:lombard/src/feature/profile/models/response/faq_dto.dart';

part 'faq_cubit.freezed.dart';

class FaqCubit extends Cubit<FaqState> {
  FaqCubit({
    required IProfileRepository repository,
  })  : _repository = repository,
        super(const FaqState.initial());
  final IProfileRepository _repository;

  // final List<FaqDTO> _faqList = [];

  Future<void> getFaqList() async {
    try {
      emit(const FaqState.loading());

      final result = await _repository.faqList();

      emit(FaqState.loaded(faqList: result));
    } on RestClientException catch (e) {
      emit(
        FaqState.error(
          message: e.message,
        ),
      );
    } catch (e) {
      emit(
        FaqState.error(
          message: e.toString(),
        ),
      );
    }
  }

  // It's for caching a first data from api and show to the UI.
  // Future<void> getFaqList() async {
  //   try {
  //     emit(const FaqState.loading());

  //     if (_faqList.isEmpty) {
  //       final result = await _repository.faqList();
  //       _faqList = result;

  //       emit(FaqState.loaded(faqList: _faqList));
  //     } else {
  //       // log('=========$_faqList');
  //       emit(FaqState.loaded(faqList: _faqList));
  //     }
  //   } on RestClientException catch (e) {
  //     emit(
  //       FaqState.error(
  //         message: e.message,
  //       ),
  //     );
  //   } catch (e) {
  //     emit(
  //       FaqState.error(
  //         message: e.toString(),
  //       ),
  //     );
  //   }
  // }
}

@freezed
class FaqState with _$FaqState {
  const factory FaqState.initial() = _InitialState;

  const factory FaqState.loading() = _LoadingState;

  const factory FaqState.loaded({
    required List<FaqDTO> faqList,
  }) = _LoadedState;

  const factory FaqState.error({
    required String message,
  }) = _ErrorState;
}
