import 'package:dio/dio.dart';
import 'package:lombard/src/core/rest_client/rest_client.dart';
import 'package:lombard/src/core/utils/talker_logger_util.dart';
import 'package:lombard/src/feature/auth/models/request/user_payload.dart';
import 'package:lombard/src/feature/auth/models/user_dto.dart';

abstract interface class IAuthRemoteDS {
  Future<UserDTO> login({
    required String iin,
    required String password,
    String? deviceToken,
    String? deviceType,
  });

  // ------

  Future<UserDTO> register({
    required UserPayload user,
    String? deviceToken,
    String? deviceType,
  });

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
  Future<UserDTO> login({
    required String iin,
    required String password,
    String? deviceToken,
    String? deviceType,
  }) async {
    try {
      final Map<String, dynamic> response = await restClient.post(
        '/webservice/userauth/loginUser.php',
        body: {
          'login': iin,
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
}
