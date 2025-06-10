import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:lombard/src/core/utils/talker_logger_util.dart';
import 'package:lombard/src/feature/app/logic/not_auth_logic.dart';
import 'package:lombard/src/feature/auth/data/auth_repository.dart';

part 'app_bloc.freezed.dart';
part 'app_event.dart';
part 'app_state.dart';

const _tag = 'AppBloc';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc(this._authRepository) : super(const AppState.loading()) {
    NotAuthLogic().statusSubject.listen((value) async {
      debugPrint('_startListenDio message from stream: $value');

      if (value == 401) {
        await _authRepository.clearUser().whenComplete(() {
          NotAuthLogic().statusSubject.add(-1);
          add(const AppEvent.changeState(state: AppState.notAuthorized()));
          TalkerLoggerUtil.talker.log('$_tag notauthworker is worked');
        });
      }
    });

    on<AppEvent>(
      (event, emit) async => event.map(
        exiting: (_) async => _exit(emit),
        checkAuth: (event) async => _checkAuth(event, emit),
        logining: (_) async => _login(emit),
        toGuest: (event) async => _toGuest(event, emit),
        refreshLocal: (_) async => _refreshLocal(emit),
        sendDeviceToken: (_) async => _sendDeviceToken(),
        changeState: (event) async => _changeState(event, emit),
        // registerSave: (_) async => _registerSave(event, emit),
      ),
    );
  }
  final IAuthRepository _authRepository;

  bool get isAuthenticated => _authRepository.isAuthenticated;




  Future<void> _checkAuth(
    _CheckAuthEvent event,
    Emitter<AppState> emit,
  ) async {
    emit(const AppState.loading());

    try {
      if (_authRepository.isAuthenticated) {
        emit(const AppState.inApp());
      } else {
        emit(const AppState.notAuthorized());
      }
      // final forceUpdateResult = await _authRepository.getForceUpdateVersion();
      // final versionProj = _getExtendedVersionNumber(event.version);
      // final versionFromBack = _versionParser(forceUpdateResult);
      // final versionFromServer = _getExtendedVersionNumber(versionFromBack ?? event.version);

      // if (versionProj >= versionFromServer) {

      // } else {
      //   if (kDebugMode) {
      //     if (_authRepository.isAuthenticated) {
      //       emit(const AppState.inApp());
      //     } else {
      //       emit(const AppState.notAuthorized());
      //     }
      //   } else {
      //     emit(const AppState.notAvailableVersion());
      //   }
      // }
    } catch (e, st) {
      TalkerLoggerUtil.talker.error('$_tag $e', st);
      emit(AppState.error(message: e.toString()));
    }
  }

  Future<void> _login(Emitter<AppState> emit) async {
    debugPrint('$_tag AppBloc _login');
    emit(const AppState.inApp());
  }

  Future<void> _exit(Emitter<AppState> emit) async {
    emit(const AppState.loading());

    await _authRepository.clearUser();
    NotAuthLogic().statusSubject.add(-1);

    emit(const AppState.notAuthorized());
  }

  Future<void> _toGuest(
    _ToGuest event,
    Emitter<AppState> emit,
  ) async {
    emit(const AppState.loading());
    log('AppBloc _toGuest', name: _tag);
    emit(const AppState.guest());
  }

  // Future<void> _registerSave(
  //   _RegisterSave event,
  //   Emitter<AppState> emit,
  // ) async {
  //   _authRepository.setRegistering(registering: true);
  //   emit(const AppState.inApp());
  // }

  Future<void> _refreshLocal(Emitter<AppState> emit) async {
    await state.maybeWhen(
      inApp: () async {
        emit(const AppState.loading());
        await Future<void>.delayed(const Duration(milliseconds: 100));
        emit(const AppState.inApp());
      },
      orElse: () async {
        emit(const AppState.loading());
        await Future<void>.delayed(const Duration(milliseconds: 100));
        emit(const AppState.notAuthorized());
      },
    );
  }

  Future<void> _sendDeviceToken() async {
    try {
      await _authRepository.sendDeviceToken();
    } catch (error, st) {
      TalkerLoggerUtil.talker.handle(error, st);
      TalkerLoggerUtil.talker.error('$_tag $error', st);
    }
  }

  Future<void> _changeState(
    _ChangeStateEvent event,
    Emitter<AppState> emit,
  ) async =>
      emit(event.state);
}
