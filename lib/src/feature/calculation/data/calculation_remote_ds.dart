import 'package:flutter/foundation.dart';
import 'package:lombard/src/core/rest_client/models/basic_response.dart';
import 'package:lombard/src/core/rest_client/rest_client.dart';
import 'package:lombard/src/core/utils/talker_logger_util.dart';
import 'package:lombard/src/feature/auth/database/auth_dao.dart';
import 'package:lombard/src/feature/calculation/model/gold_dto.dart';

import 'package:lombard/src/feature/settings/data/app_settings_datasource.dart';

abstract interface class ICalculationRemoteDS {
  Future<List<GoldDTO>> getGoldList();

  Future<BasicResponse> readNotification({
    required int id,
  });
}

class CalculationRemoteDSImpl implements ICalculationRemoteDS {
  const CalculationRemoteDSImpl({
    required this.restClient,
    required this.appSettingsDatasource,
    required this.authDao,
  });
  final IRestClient restClient;
  final IAuthDao authDao;
  final AppSettingsDatasource appSettingsDatasource;

  @override
  Future<List<GoldDTO>> getGoldList() async {
    try {
      final appSettings = await appSettingsDatasource.getAppSettings();
      final token = authDao.token.value;

      final Map<String, dynamic> response = await restClient.post(
        '/webservice/gold/getGoldPrice.php',
        body: {
          'token': token ?? '',
          'lang': appSettings?.locale?.languageCode == 'kk' ? 'kz' : 'ru',
        },
      );

      if (response['data'] == null) {
        throw Exception();
      }
      final list = await compute<List<dynamic>, List<GoldDTO>>(
        (list) => list
            .map(
              (e) => GoldDTO.fromJson(e as Map<String, dynamic>),
            )
            .toList(),
        response['data'] as List,
      );
      return list;
    } catch (e, st) {
      TalkerLoggerUtil.talker.error('#getGoldList - $e', e, st);
      rethrow;
    }
  }

  @override
  Future<BasicResponse> readNotification({required int id}) async {
    try {
      final Map<String, dynamic> response = await restClient.get(
        '/notification/$id/read',
        queryParams: {},
      );

      return BasicResponse.fromJson(response);
    } catch (e, st) {
      TalkerLoggerUtil.talker.error('#readNotification - $e', e, st);
      rethrow;
    }
  }
}
