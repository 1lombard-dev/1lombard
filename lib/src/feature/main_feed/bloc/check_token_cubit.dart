import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lombard/src/core/rest_client/rest_client.dart';
import 'package:lombard/src/feature/main_feed/data/main_repository.dart';

part 'check_token_cubit.freezed.dart';

class CheckTokenCubit extends Cubit<CheckTokenState> {
  CheckTokenCubit({
    required IMainRepository repository,
  })  : _repository = repository,
        super(const CheckTokenState.initial());
  final IMainRepository _repository;

  Future<void> checkToken() async {
    try {
      emit(const CheckTokenState.loading());

      final status = await _repository.checkToken();

      emit(CheckTokenState.loaded(status: status));
    } on RestClientException catch (e) {
      emit(
        CheckTokenState.error(
          message: e.message,
        ),
      );
    } catch (e) {
      emit(
        CheckTokenState.error(
          message: e.toString(),
        ),
      );
    }
  }
}

@freezed
class CheckTokenState with _$CheckTokenState {
  const factory CheckTokenState.initial() = _InitialState;

  const factory CheckTokenState.loading() = _LoadingState;

  const factory CheckTokenState.loaded({required String status}) = _LoadedState;

  const factory CheckTokenState.error({
    required String message,
  }) = _ErrorState;
}
