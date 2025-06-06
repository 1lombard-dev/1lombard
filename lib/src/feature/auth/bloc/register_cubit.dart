import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:lombard/src/feature/auth/data/auth_repository.dart';
import 'package:lombard/src/feature/auth/models/request/user_payload.dart';
import 'package:lombard/src/feature/auth/models/user_dto.dart';

part 'register_cubit.freezed.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit({
    required IAuthRepository repository,
  })  : _repository = repository,
        super(const RegisterState.initial());
  final IAuthRepository _repository;

  Future<void> register({
    required UserPayload user,
    String? deviceType,
  }) async {
    try {
      emit(const RegisterState.loading());

      final data = await _repository.register(userr: user, deviceType: deviceType);

      if (isClosed) return;

      emit(RegisterState.loaded(user: data));
    } catch (e) {
      emit(
        RegisterState.error(
          message: e.toString(),
        ),
      );
    }
  }
}

@freezed
class RegisterState with _$RegisterState {
  const factory RegisterState.initial() = _InitialState;

  const factory RegisterState.loading() = _LoadingState;

  const factory RegisterState.loaded({
    required UserDTO user,
  }) = _LoadedState;

  const factory RegisterState.error({
    required String message,
  }) = _ErrorState;
}
