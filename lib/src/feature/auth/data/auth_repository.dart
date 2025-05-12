import 'dart:convert';
import 'dart:developer';

import 'package:lombard/src/feature/auth/data/auth_remote_ds.dart';
import 'package:lombard/src/feature/auth/database/auth_dao.dart';
import 'package:lombard/src/feature/auth/models/common_dto.dart';
import 'package:lombard/src/feature/auth/models/common_lists_dto.dart';
import 'package:lombard/src/feature/auth/models/request/user_payload.dart';
import 'package:lombard/src/feature/auth/models/user_dto.dart';

abstract interface class IAuthRepository {
  bool get isAuthenticated;

  // UserDTO? get user;

  UserDTO? cacheUser();

  Future<List<Map<String, dynamic>>> getForceUpdateVersion();

  Future sendDeviceToken();

  Future<void> clearUser();

  Future<CommonDTO> authenticate({
    required String phone,
  });

  Future<CommonDTO> forgotPasswordSmsSend({
    required String phone,
  });

  Future<UserDTO> login({
    required String phone,
    required String password,
    String? deviceType,
  });

  // -----------------

  // Forgot password API's

  Future forgotPasswordSmsCheck({
    required String phone,
    required String code,
  });

  Future forgotPasswordChangePassword({
    required String email,
    required String password,
  });

  /// Auth

  /// Auth
  Future<UserDTO> register({
    required UserPayload userr,
    String? deviceType,
  });

  Future<CommonListsDTO> getRegisterFormOptions();

  Future<int> registerSmsSend({
    required UserPayload payload,
  });

  Future<UserDTO> registerSmsCheck({
    required String phone,
    required String code,
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
  bool get isAuthenticated => _authDao.user.value != null;

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
  Future<List<Map<String, dynamic>>> getForceUpdateVersion() async {
    return [
      {
        'key': 'force_update_version',
        'value': '1.0.0',
      },
      {
        'key': 'store_review_version',
        'value': '1.0.0',
      },
    ];
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
  Future<CommonDTO> authenticate({
    required String phone,
  }) async {
    // final String? dv = _authDao.deviceToken.value;
    try {
      final user = await _remoteDS.authenticate(
        phone: phone,
      );

      // await _authDao.user.setValue(jsonEncode(user.toJson()));

      return user;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserDTO> login({
    required String phone,
    required String password,
    String? deviceType,
  }) async {
    final String? dv = _authDao.deviceToken.value;
    try {
      final user = await _remoteDS.login(
        phone: phone,
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

  @override
  Future<CommonDTO> forgotPasswordSmsSend({
    required String phone,
  }) async {
    try {
      return _remoteDS.forgotPasswordSmsSend(phone: phone);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future forgotPasswordSmsCheck({
    required String phone,
    required String code,
  }) async {
    try {
      return await _remoteDS.forgotPasswordSmsCheck(
        phone: phone,
        code: code,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future forgotPasswordChangePassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _remoteDS.forgotPasswordChangePassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<CommonListsDTO> getRegisterFormOptions() async {
    try {
      return _remoteDS.getRegisterFormOptions();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<int> registerSmsSend({
    required UserPayload payload,
  }) async {
    try {
      return _remoteDS.registerSmsSend(payload: payload);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserDTO> registerSmsCheck({
    required String phone,
    required String code,
  }) async {
    try {
      final user = await _remoteDS.registerSmsCheck(phone: phone, code: code);

      await _authDao.user.setValue(jsonEncode(user.toJson()));

      return user;
    } catch (e) {
      rethrow;
    }
  }
}
