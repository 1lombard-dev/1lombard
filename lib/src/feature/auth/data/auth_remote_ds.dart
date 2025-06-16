import 'package:dio/dio.dart';
import 'package:lombard/src/core/rest_client/rest_client.dart';
import 'package:lombard/src/core/utils/talker_logger_util.dart';
import 'package:lombard/src/feature/auth/database/auth_dao.dart';
import 'package:lombard/src/feature/auth/models/request/user_payload.dart';
import 'package:lombard/src/feature/auth/models/user_dto.dart';
import 'package:lombard/src/feature/settings/data/app_settings_datasource.dart';

abstract interface class IAuthRemoteDS {
  Future<String> login({
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
    required this.authDao,
    required this.appSettingsDatasource,
  });
  final IRestClient restClient;
  final IAuthDao authDao;
  final AppSettingsDatasource appSettingsDatasource; // ✅ Declare this

  @override
  Future<String> login({
    required String iin,
    required String password,
    String? deviceToken,
    String? deviceType,
  }) async {
    try {
      final appSettings = await appSettingsDatasource.getAppSettings();
      final token = authDao.token.value;

      final dynamic rawResponse = await restClient.post(
        '/webservice/userauth/loginUser.php',
        body: {
          'token': token ?? '',
          'lang': appSettings?.locale?.languageCode == 'kk' ? 'kz' : 'ru',
          'login': iin,
          'password': password,
          if (deviceToken != null) 'device_token': deviceToken,
          if (deviceType != null) 'device_type': deviceType,
        },
      );



      // ignore: avoid_dynamic_calls
      final data = rawResponse['data'];
      if (data is List && data.isNotEmpty) {
        final Map<String, dynamic> response = data.first as Map<String, dynamic>;

        final status = response['status'];
        if (status == 'error') {
          final errorText = response['errortext'] ?? 'Неизвестная ошибка';
          throw Exception(errorText);
        }

        final userId = response['userid'];
        if (userId is String) {
          return userId;
        } else {
          throw Exception('Некорректный формат userId');
        }
      } else {
        throw Exception('Некорректный формат ответа от сервера');
      }
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
