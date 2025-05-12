import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:lombard/src/core/rest_client/rest_client.dart';
import 'package:lombard/src/feature/auth/data/auth_repository.dart';

part 'password_recovery_cubit.freezed.dart';

class PasswordRecoveryCubit extends Cubit<PasswordRecoveryState> {
  PasswordRecoveryCubit({
    required IAuthRepository repository,
  })  : _repository = repository,
        super(const PasswordRecoveryState.initial());
  final IAuthRepository _repository;

  Future<void> forgotPasswordSmsSend({
    required String phone,
  }) async {
    try {
      emit(const PasswordRecoveryState.loading());

      await _repository.forgotPasswordSmsSend(
        phone: phone,
      );

      if (isClosed) return;

      emit(const PasswordRecoveryState.loaded());
    } on RestClientException catch (e) {
      _onRestClientException(e);
    } catch (e) {
      emit(
        PasswordRecoveryState.error(
          message: e.toString(),
        ),
      );
    }
  }

  void _onRestClientException(RestClientException e) {
    try {
      if (e.statusCode == 429 &&
          e.cause != null &&
          e.cause is Map<String, dynamic> &&
          (e.cause! as Map<String, dynamic>)['sms_delay'] is int) {
        emit(const PasswordRecoveryState.loaded());
        return;
      }

      emit(
        PasswordRecoveryState.error(
          message: e.message,
        ),
      );
    } catch (e) {
      emit(
        PasswordRecoveryState.error(
          message: e.toString(),
        ),
      );
      rethrow;
    }
  }
}

@freezed
class PasswordRecoveryState with _$PasswordRecoveryState {
  const factory PasswordRecoveryState.initial() = _InitialState;

  const factory PasswordRecoveryState.loading() = _LoadingState;

  const factory PasswordRecoveryState.loaded() = _LoadedState;

  const factory PasswordRecoveryState.error({
    required String message,
  }) = _ErrorState;
}
