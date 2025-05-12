import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lombard/src/core/rest_client/rest_client.dart';

import 'package:lombard/src/feature/auth/data/auth_repository.dart';
import 'package:lombard/src/feature/auth/models/request/user_payload.dart';
import 'package:lombard/src/feature/auth/models/response/auth_error_response.dart';

part 'sign_up_cubit.freezed.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit({
    required IAuthRepository repository,
  })  : _repository = repository,
        super(const SignUpState.initial());
  final IAuthRepository _repository;

  Future<void> getRegisterFormOptions({
    required UserPayload payload,
  }) async {
    try {
      emit(const SignUpState.loading());

      final smsDelay = await _repository.registerSmsSend(
        payload: payload,
      );

      if (isClosed) return;

      emit(SignUpState.loaded(smsDelay: smsDelay));
    } on RestClientException catch (e) {
      _onRestClientException(e, payload);
    } catch (e) {
      emit(
        SignUpState.error(
          message: e.toString(),
          sendedOldValue: payload.phone!,
        ),
      );
    }
  }

  void _onRestClientException(RestClientException e, UserPayload payload) {
    try {
      if (e.statusCode == 429 &&
          e.cause != null &&
          e.cause is Map<String, dynamic> &&
          (e.cause! as Map<String, dynamic>)['sms_delay'] is int) {
        emit(SignUpState.loaded(smsDelay: (e.cause! as Map<String, dynamic>)['sms_delay'] as int));
        return;
      }

      String? phoneFieldError;
      String? passwordFieldError;
      String? passwordConfirmationFieldError;

      final cause = switch (e.cause) {
        final Map<String, Object?> map => map,
        _ => null,
      };

      if (cause case {'phone': final String? phone}) {
        phoneFieldError = phone;
      }
      if (cause case {'password': final String? password}) {
        passwordFieldError = password;
      }
      if (cause case {'password_confirmation': final String? passwordConfirmation}) {
        passwordConfirmationFieldError = passwordConfirmation;
      }

      emit(
        SignUpState.error(
          message: e.message,
          sendedOldValue: payload.phone!,
          authErrorResponse: AuthErrorResponse(
            phone: phoneFieldError,
            password: passwordFieldError,
            passwordConfirmation: passwordConfirmationFieldError,
          ),
        ),
      );
    } catch (e) {
      emit(
        SignUpState.error(
          message: e.toString(),
          sendedOldValue: payload.phone!,
        ),
      );
      rethrow;
    }
  }
}

@freezed
class SignUpState with _$SignUpState {
  const factory SignUpState.initial() = _InitialState;

  const factory SignUpState.loading() = _LoadingState;

  const factory SignUpState.loaded({
    required int smsDelay,
  }) = _LoadedState;

  const factory SignUpState.error({
    required String message,
    required String sendedOldValue,
    AuthErrorResponse? authErrorResponse,
  }) = _ErrorState;
}
