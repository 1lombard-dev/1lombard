import 'package:flutter/foundation.dart';
import 'package:lombard/src/core/rest_client/rest_client.dart';
import 'package:lombard/src/core/utils/talker_logger_util.dart';
import 'package:lombard/src/feature/auth/database/auth_dao.dart';
import 'package:lombard/src/feature/main_feed/model/main_page_dto.dart';
import 'package:lombard/src/feature/settings/data/app_settings_datasource.dart';

abstract interface class IMapRemoteDS {
  Future<List<LayersDTO>> getCity();

  Future<List<LayersDTO>> getCityDetail({required String name});
}

class MapRemoteDSImpl implements IMapRemoteDS {
  const MapRemoteDSImpl({
    required this.restClient,
    required this.authDao,
    required this.appSettingsDatasource, // ✅ Add this
  });
  final IRestClient restClient;
  final IAuthDao authDao;
  final AppSettingsDatasource appSettingsDatasource; // ✅ Declare this

  @override
  Future<List<LayersDTO>> getCity() async {
    try {
      final appSettings = await appSettingsDatasource.getAppSettings();
      final token = authDao.token.value;

      final Map<String, dynamic> response = await restClient.post(
        '/webservice/branches/getCityList.php',
        body: {
          'token': token ?? '',
          'lang': appSettings?.locale?.languageCode == 'kk' ? 'kz' : 'ru',
        },
      );

      if (response['data'] == null) {
        throw Exception();
      }
      final list = await compute<List<dynamic>, List<LayersDTO>>(
        (list) => list
            .map(
              (e) => LayersDTO.fromJson(e as Map<String, dynamic>),
            )
            .toList(),
        response['data'] as List,
      );
      return list;
    } catch (e, st) {
      TalkerLoggerUtil.talker.error('#mainPageBanner - $e', e, st);
      rethrow;
    }
  }

  @override
  Future<List<LayersDTO>> getCityDetail({
    required String name,
  }) async {
    try {
      final appSettings = await appSettingsDatasource.getAppSettings();
      final token = authDao.token.value;

      final Map<String, dynamic> response = await restClient.post(
        '/webservice/branches/getBranchesByCity.php',
        body: {'token': token ?? '', 'lang': appSettings?.locale?.languageCode == 'kk' ? 'kz' : 'ru', 'cityname': name},
      );

      if (response['data'] == null) {
        throw Exception();
      }
      final list = await compute<List<dynamic>, List<LayersDTO>>(
        (list) => list
            .map(
              (e) => LayersDTO.fromJson(e as Map<String, dynamic>),
            )
            .toList(),
        response['data'] as List,
      );
      return list;
    } catch (e, st) {
      TalkerLoggerUtil.talker.error('#mainPageBanner - $e', e, st);
      rethrow;
    }
  }
}
