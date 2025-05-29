import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lombard/src/core/rest_client/rest_client.dart';
import 'package:lombard/src/feature/main_feed/data/main_repository.dart';
import 'package:lombard/src/feature/main_feed/model/main_page_dto.dart';

part 'get_token_cubit.freezed.dart';

class GetTokenCubit extends Cubit<GetTokenState> {
  GetTokenCubit({
    required IMainRepository repository,
  })  : _repository = repository,
        super(const GetTokenState.initial());
  final IMainRepository _repository;

  Future<void> getToken() async {
    try {
      emit(const GetTokenState.loading());

      await _repository.getToken();

      emit(const GetTokenState.loaded());
    } on RestClientException catch (e) {
      emit(
        GetTokenState.error(
          message: e.message,
        ),
      );
    } catch (e) {
      emit(
        GetTokenState.error(
          message: e.toString(),
        ),
      );
    }
  }
}

@freezed
class GetTokenState with _$GetTokenState {
  const factory GetTokenState.initial() = _InitialState;

  const factory GetTokenState.loading() = _LoadingState;

  const factory GetTokenState.loaded() = _LoadedState;

  const factory GetTokenState.error({
    required String message,
  }) = _ErrorState;
}
