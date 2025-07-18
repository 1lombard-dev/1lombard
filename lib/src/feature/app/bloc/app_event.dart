part of 'app_bloc.dart';

@freezed
sealed class AppEvent with _$AppEvent {
  const factory AppEvent.checkAuth({
    required String version,
  }) = _CheckAuthEvent;

  const factory AppEvent.logining() = _LoginingEvent;

  const factory AppEvent.exiting() = _ExitingEvent;

  const factory AppEvent.toGuest() = _ToGuest;

  const factory AppEvent.refreshLocal() = _RefreshLocalEvent;

  const factory AppEvent.sendDeviceToken() = _SendDeviceTokenEvent;


   const factory AppEvent.createPin() = _CreatePinEvent;
  const factory AppEvent.enterPin() = _EnterPinEvent;

  const factory AppEvent.changeState({
    required AppState state,
  }) = _ChangeStateEvent;
}
