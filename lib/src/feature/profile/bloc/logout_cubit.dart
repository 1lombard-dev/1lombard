import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lombard/src/core/rest_client/rest_client.dart';
import 'package:lombard/src/feature/profile/data/profile_repository.dart';

part 'logout_cubit.freezed.dart';

class LogoutCubit extends Cubit<LogoutState> {
  LogoutCubit() : super(const LogoutState.initial());

  Future<void> logout({String? deviceType}) async {
    emit(const LogoutState.loading());

    // Здесь можно вызвать очистку локальных данных, если нужно:
    // await _repository.clearLocalData();

    emit(const LogoutState.loaded());
  }
}

@freezed
class LogoutState with _$LogoutState {
  const factory LogoutState.initial() = _InitialState;

  const factory LogoutState.loading() = _LoadingState;

  const factory LogoutState.loaded() = _LoadedState;

  const factory LogoutState.error({
    required String message,
  }) = _ErrorState;
}
