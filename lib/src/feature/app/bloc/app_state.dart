part of 'app_bloc.dart';

@freezed
sealed class AppState with _$AppState {
  const factory AppState.loading() = _LoadingAppState;

  const factory AppState.notAuthorized() = _NotAuthorizedState;

  const factory AppState.inApp() = _InAppState;

  const factory AppState.guest() = _GuestState;

  const factory AppState.notAvailableVersion() = _NotAvailableVersion;

    const factory AppState.createPin() = _CreatePin;
  const factory AppState.enterPin() = _EnterPin;

  const factory AppState.error({
    required String message,
  }) = _ErrorAppState;
}
