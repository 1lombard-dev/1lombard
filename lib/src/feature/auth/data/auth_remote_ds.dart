import 'package:dio/dio.dart';
import 'package:lombard/src/core/rest_client/rest_client.dart';
import 'package:lombard/src/core/utils/talker_logger_util.dart';
import 'package:lombard/src/feature/auth/models/common_dto.dart';
import 'package:lombard/src/feature/auth/models/common_lists_dto.dart';
import 'package:lombard/src/feature/auth/models/request/user_payload.dart';
import 'package:lombard/src/feature/auth/models/user_dto.dart';

abstract interface class IAuthRemoteDS {
  Future<CommonDTO> authenticate({
    required String phone,
  });

  Future<UserDTO> login({
    required String phone,
    required String password,
    String? deviceToken,
    String? deviceType,
  });

  Future<CommonDTO> forgotPasswordSmsSend({
    required String phone,
  });

  // ------

  Future<UserDTO> register({
    required UserPayload user,
    String? deviceToken,
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

  // Forgot password

  Future forgotPasswordSmsCheck({
    required String phone,
    required String code,
  });

  Future forgotPasswordChangePassword({
    required String email,
    required String password,
  });

  //
  Future sendDeviceToken({
    required String deviceToken,
  });
}

class AuthRemoteDSImpl implements IAuthRemoteDS {
  const AuthRemoteDSImpl({
    required this.restClient,
  });
  final IRestClient restClient;

  @override
  Future<CommonDTO> authenticate({
    required String phone,
  }) async {
    try {
      final Map<String, dynamic> response = await restClient.post(
        '/user/authenticate',
        body: {
          'phone': phone,
        },
      );

      // final UserDTO user = UserDTO.fromJson(response['data'] as Map<String, dynamic>);
      return CommonDTO.fromJson(response);
    } catch (e, st) {
      TalkerLoggerUtil.talker.error('#auth - $e', e, st);
      rethrow;
    }
  }

  @override
  Future<UserDTO> login({
    required String phone,
    required String password,
    String? deviceToken,
    String? deviceType,
  }) async {
    try {
      final Map<String, dynamic> response = await restClient.post(
        '/user/login',
        body: {
          'phone': phone,
          'password': password,
          if (deviceToken != null) 'device_token': deviceToken,
          if (deviceType != null) 'device_type': deviceType,
        },
      );

      // final UserDTO user = UserDTO.fromJson(response['data'] as Map<String, dynamic>);
      return UserDTO.fromJson(response);
    } catch (e, st) {
      TalkerLoggerUtil.talker.error('#login - $e', e, st);
      rethrow;
    }
  }

  @override
  Future<UserDTO> register({
    required UserPayload user,
    String? deviceToken,
    String? deviceType,
  }) async {
    try {
      final userPayload = UserPayload(
        name: user.name,
        surname: user.surname,
        phone: user.phone,
        password: user.password,
        deviceToken: deviceToken,
        deviceType: deviceType,
      );

      final FormData formData = FormData.fromMap(userPayload.toJson());

      final Map<String, dynamic> response = await restClient.post(
        '/v1/user/auth/register',
        body: formData,
      );

      // final UserDTO user = UserDTO.fromJson(response['data'] as Map<String, dynamic>);
      return UserDTO.fromJson(response);
    } catch (e, st) {
      TalkerLoggerUtil.talker.error('#login - $e', e, st);
      rethrow;
    }
  }

  @override
  Future<CommonListsDTO> getRegisterFormOptions() async {
    try {
      final Map<String, dynamic> response = await restClient.get('/v1/auth/register');

      return CommonListsDTO.fromJson(response);
    } catch (e, st) {
      TalkerLoggerUtil.talker.error('#getRegisterFormOptions - $e', e, st);
      rethrow;
    }
  }

  @override
  Future sendDeviceToken({
    required String deviceToken,
  }) async {
    try {
      await restClient.get(
        '/v1/user/main/edit_device_token',
        queryParams: {
          'device_token': deviceToken,
        },
      );
    } catch (e, st) {
      TalkerLoggerUtil.talker.error('#sendDeviceToken - $e', e, st);
      rethrow;
    }
  }

  @override
  Future<CommonDTO> forgotPasswordSmsSend({
    required String phone,
  }) async {
    try {
      final Map<String, dynamic> response = await restClient.post(
        '/user/forgot-password',
        body: {
          'phone': phone,
        },
      );

      // final UserDTO user = UserDTO.fromJson(response['data'] as Map<String, dynamic>);
      return CommonDTO.fromJson(response);
    } catch (e, st) {
      TalkerLoggerUtil.talker.error('#forgotPasswordSmsSend - $e', e, st);
      rethrow;
    }
  }

  @override
  Future forgotPasswordSmsCheck({
    required String phone,
    required String code,
  }) async {
    try {
      await restClient.post(
        '/v1/user/auth/check_code',
        body: {
          'email': phone,
          'code': code,
        },
      );
    } catch (e, st) {
      TalkerLoggerUtil.talker.error('#forgotPasswordSmsSend - $e', e, st);
      rethrow;
    }
  }

  @override
  Future forgotPasswordChangePassword({
    required String password,
    required String email,
  }) async {
    try {
      await restClient.post(
        '/v1/user/auth/restore_password',
        body: {
          'email': email,
          'password': password,
        },
      );
    } catch (e, st) {
      TalkerLoggerUtil.talker.error('#forgotPasswordChangePassword - $e', e, st);
      rethrow;
    }
  }

  @override
  Future<int> registerSmsSend({
    required UserPayload payload,
  }) async {
    try {
      final Map<String, dynamic> response = await restClient.post(
        '/v1/auth/register/sms/send',
        body: payload.toJson(),
      );

      final int? smsDelay = response['sms_delay'] as int?;

      if (smsDelay != null) {
        return smsDelay;
      } else {
        throw WrongResponseTypeException(
          message: '''Unexpected response body type: ${response.runtimeType}\n$response''',
        );
      }
    } catch (e, st) {
      TalkerLoggerUtil.talker.error('#registerSmsSend - $e', e, st);
      rethrow;
    }
  }

  @override
  Future<UserDTO> registerSmsCheck({
    required String phone,
    required String code,
  }) async {
    try {
      final Map<String, dynamic> response = await restClient.post(
        '/v1/auth/register/sms/check',
        body: {
          'phone': phone,
          'code': code,
        },
      );

      if (response['user'] == null || response['token'] == null) {
        return throw WrongResponseTypeException(
          message: '''Unexpected response body type: ${response.runtimeType}\n$response''',
        );
      }

      if (response case {'token': final Map<String, Object?> tokenObject}) {
        final accessToken = tokenObject['access_token'] as String?;

        if (accessToken == null) {
          return throw WrongResponseTypeException(
            message: '''Unexpected response body type: ${response.runtimeType}\n$response''',
          );
        }

        final user = UserDTO.fromJson(response['user']! as Map<String, dynamic>).copyWith(
            // accessToken: accessToken,
            );

        return user;
      } else {
        throw WrongResponseTypeException(
          message: '''Unexpected response body type: ${response.runtimeType}\n$response''',
        );
      }
    } catch (e, st) {
      TalkerLoggerUtil.talker.error('#login - $e', e, st);
      rethrow;
    }
  }
}
