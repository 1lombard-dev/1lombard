import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lombard/src/feature/auth/data/auth_repository.dart';
import 'package:lombard/src/feature/auth/models/common_dto.dart';

part 'auth_cubit.freezed.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required IAuthRepository repository,
  })  : _repository = repository,
        super(const AuthState.initial());
  final IAuthRepository _repository;

  Future<void> authenticate({
    required String phone,
  }) async {
    try {
      emit(const AuthState.loading());

      final response = await _repository.authenticate(
        phone: phone,
      );

      if (isClosed) return;

      emit(AuthState.loaded(message: response));
    } catch (e) {
      emit(
        AuthState.error(
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> sendForgetPassword({
    required String phone,
  }) async {
    try {
      emit(const AuthState.loading());

      final response = await _repository.forgotPasswordSmsSend(
        phone: phone,
      );

      if (isClosed) return;

      emit(AuthState.loaded(message: response));
    } catch (e) {
      emit(
        AuthState.error(
          message: e.toString(),
        ),
      );
    }
  }
}

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _InitialState;

  const factory AuthState.loading() = _LoadingState;

  const factory AuthState.loaded({
    required CommonDTO message,
  }) = _LoadedState;

  const factory AuthState.error({
    required String message,
  }) = _ErrorState;
}
