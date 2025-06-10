import 'dart:convert';
import 'dart:developer';

import 'package:lombard/src/feature/auth/data/auth_remote_ds.dart';
import 'package:lombard/src/feature/auth/database/auth_dao.dart';
import 'package:lombard/src/feature/auth/models/request/user_payload.dart';
import 'package:lombard/src/feature/auth/models/user_dto.dart';

abstract interface class IAuthRepository {
  bool get isAuthenticated;

  // UserDTO? get user;

  UserDTO? cacheUser();

  Future sendDeviceToken();

  Future<void> clearUser();

  Future<UserDTO> login({
    required String iin,
    required String password,
    String? deviceType,
  });

  // -----------------

  /// Auth

  /// Auth
  Future<UserDTO> register({
    required UserPayload userr,
    String? deviceType,
  });
}

class AuthRepositoryImpl implements IAuthRepository {
  const AuthRepositoryImpl({
    required IAuthRemoteDS remoteDS,
    required IAuthDao authDao,
  })  : _remoteDS = remoteDS,
        _authDao = authDao;
  final IAuthRemoteDS _remoteDS;
  final IAuthDao _authDao;

  @override
  bool get isAuthenticated => _authDao.userId.value != null;

  @override
  UserDTO? cacheUser() {
    try {
      if (_authDao.user.value != null) {
        final UserDTO user = UserDTO.fromJson(
          jsonDecode(_authDao.user.value!) as Map<String, dynamic>,
        );
        return user;
      }
    } on Exception catch (e) {
      log(e.toString(), name: 'getUserFromCache()');
    }
    return null;
  }

  @override
  Future<void> clearUser() async {
    try {
      await _authDao.user.remove();
      log(name: 'User', _authDao.user.value ?? '');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future sendDeviceToken() async {
    try {
      final deviceToken =
          _authDao.deviceToken.value ?? 'device_token'; // await NotificationService.getUserId(_authDao);

      await _remoteDS.sendDeviceToken(deviceToken: deviceToken);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserDTO> login({
    required String iin,
    required String password,
    String? deviceType,
  }) async {
    final String? dv = _authDao.deviceToken.value;
    try {
      final user = await _remoteDS.login(
        iin: iin,
        password: password,
        deviceToken: dv,
        deviceType: deviceType,
      );

      await _authDao.user.setValue(jsonEncode(user.toJson()));

      return user;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserDTO> register({
    required UserPayload userr,
    String? deviceType,
  }) async {
    final String? dv = _authDao.deviceToken.value;
    try {
      final user = await _remoteDS.register(
        user: userr,
        deviceToken: dv,
        deviceType: deviceType,
      );

      await _authDao.user.setValue(jsonEncode(user.toJson()));

      return user;
    } catch (e) {
      rethrow;
    }
  }
}
