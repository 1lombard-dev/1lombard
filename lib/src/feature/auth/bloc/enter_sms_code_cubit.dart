import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lombard/src/core/rest_client/rest_client.dart';
import 'package:lombard/src/feature/auth/data/auth_repository.dart';
import 'package:lombard/src/feature/auth/models/request/user_payload.dart';
import 'package:lombard/src/feature/auth/models/user_dto.dart';

part 'enter_sms_code_cubit.freezed.dart';

class EnterSmsCodeCubit extends Cubit<EnterSmsCodeState> {
  EnterSmsCodeCubit({
    required IAuthRepository repository,
  })  : _repository = repository,
        super(const EnterSmsCodeState.initial());
  final IAuthRepository _repository;

  Future<void> forgotPasswordSmsCheck({
    required String phone,
    required String code,
  }) async {
    try {
      emit(const EnterSmsCodeState.loading());

      await _repository.forgotPasswordSmsCheck(
        phone: phone,
        code: code,
      );

      if (isClosed) return;

      emit(
        const EnterSmsCodeState.forgotPasswordState(),
      );
    } on RestClientException catch (e) {
      emit(
        EnterSmsCodeState.error(
          message: e.message,
        ),
      );
    } catch (e) {
      emit(
        EnterSmsCodeState.error(
          message: e.toString(),
        ),
      );
    }
  }

  // Future<void> forgotPasswordSmsSend({
  //   required String phone,
  // }) async {
  //   try {
  //     emit(const EnterSmsCodeState.loading());

  //     final smsDelay = await _repository.forgotPasswordSmsSend(
  //       phone: phone,
  //     );

  //     if (isClosed) return;

  //     emit(EnterSmsCodeState.resendForgotPasswordSmsState(smsDelay: smsDelay));
  //   } on RestClientException catch (e) {
  //     emit(
  //       EnterSmsCodeState.error(
  //         message: e.message,
  //       ),
  //     );
  //   } catch (e) {
  //     emit(
  //       EnterSmsCodeState.error(
  //         message: e.toString(),
  //       ),
  //     );
  //   }
  // }

  Future<void> registerSmsCheck({
    required String phone,
    required String code,
  }) async {
    try {
      emit(const EnterSmsCodeState.loading());

      final user = await _repository.registerSmsCheck(
        phone: phone,
        code: code,
      );

      if (isClosed) return;

      emit(EnterSmsCodeState.registerLoaded(user: user));
    } on RestClientException catch (e) {
      emit(
        EnterSmsCodeState.error(
          message: e.message,
        ),
      );
    } catch (e) {
      emit(
        EnterSmsCodeState.error(
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> registerSmsSend({
    required UserPayload payload,
  }) async {
    try {
      emit(const EnterSmsCodeState.loading());

      final smsDelay = await _repository.registerSmsSend(
        payload: payload,
      );

      if (isClosed) return;

      emit(EnterSmsCodeState.resendRegisterSmsState(smsDelay: smsDelay));
    } on RestClientException catch (e) {
      emit(
        EnterSmsCodeState.error(
          message: e.message,
        ),
      );
    } catch (e) {
      emit(
        EnterSmsCodeState.error(
          message: e.toString(),
        ),
      );
    }
  }
}

@freezed
class EnterSmsCodeState with _$EnterSmsCodeState {
  const factory EnterSmsCodeState.initial() = _InitialState;

  const factory EnterSmsCodeState.loading() = _LoadingState;

  const factory EnterSmsCodeState.forgotPasswordState() = _ForgotPasswordState;

  const factory EnterSmsCodeState.resendForgotPasswordSmsState({
    required int smsDelay,
  }) = _ResendForgotPasswordSmsState;

  const factory EnterSmsCodeState.resendRegisterSmsState({
    required int smsDelay,
  }) = _ResendRegisterSmsState;

  const factory EnterSmsCodeState.registerLoaded({
    required UserDTO user,
  }) = _RegisterLoadedState;

  const factory EnterSmsCodeState.error({
    required String message,
  }) = _ErrorState;
}
