import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lombard/src/core/rest_client/rest_client.dart';

import 'package:lombard/src/feature/auth/data/auth_repository.dart';

part 'new_password_cubit.freezed.dart';

class NewPasswordCubit extends Cubit<NewPasswordState> {
  NewPasswordCubit({
    required IAuthRepository repository,
  })  : _repository = repository,
        super(const NewPasswordState.initial());
  final IAuthRepository _repository;

  Future<void> forgotPasswordChangePassword({
    required String email,
    required String password,
  }) async {
    try {
      emit(const NewPasswordState.loading());

      await _repository.forgotPasswordChangePassword(
        email: email,
        password: password,
      );

      if (isClosed) return;

      emit(const NewPasswordState.loaded());
    } on RestClientException catch (e) {
      emit(
        NewPasswordState.error(
          message: e.message,
        ),
      );
    } catch (e) {
      emit(
        NewPasswordState.error(
          message: e.toString(),
        ),
      );
    }
  }
}

@freezed
class NewPasswordState with _$NewPasswordState {
  const factory NewPasswordState.initial() = _InitialState;

  const factory NewPasswordState.loading() = _LoadingState;

  const factory NewPasswordState.loaded() = _LoadedState;

  const factory NewPasswordState.error({
    required String message,
  }) = _ErrorState;
}
