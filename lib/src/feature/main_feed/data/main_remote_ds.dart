import 'package:flutter/foundation.dart';
import 'package:lombard/src/core/rest_client/rest_client.dart';
import 'package:lombard/src/core/utils/talker_logger_util.dart';
import 'package:lombard/src/feature/auth/database/auth_dao.dart';
import 'package:lombard/src/feature/main_feed/model/category_dto.dart';
import 'package:lombard/src/feature/main_feed/model/main_page_dto.dart';
import 'package:lombard/src/feature/main_feed/model/question_dto.dart';
import 'package:lombard/src/feature/settings/data/app_settings_datasource.dart';

abstract interface class IMainRemoteDS {
  Future<List<LayersDTO>> mainPageBanner();
  Future<List<BannerDTO>> getNews();

  Future<List<CategoryDTO>> categories();

  Future<List<QuestionDTO>> getFAQ();

  Future<String> getToken();

  Future<String> checkToken();
}

class MainRemoteDSImpl implements IMainRemoteDS {
  const MainRemoteDSImpl({
    required this.restClient,
    required this.authDao,
    required this.appSettingsDatasource, // ✅ Add this
  });
  final IRestClient restClient;
  final IAuthDao authDao;
  final AppSettingsDatasource appSettingsDatasource; // ✅ Declare this

  @override
  Future<List<BannerDTO>> getNews() async {
    try {
      final appSettings = await appSettingsDatasource.getAppSettings();
      final token = await ensureValidToken();

      final Map<String, dynamic> response = await restClient.post(
        '/webservice/news/getNews.php',
        body: {
          'token': token,
          'lang': appSettings?.locale?.languageCode == 'kk' ? 'kz' : 'ru',
        },
      );

      if (response['data'] == null) {
        throw Exception();
      }
      final list = await compute<List<dynamic>, List<BannerDTO>>(
        (list) => list
            .map(
              (e) => BannerDTO.fromJson(e as Map<String, dynamic>),
            )
            .toList(),
        response['data'] as List,
      );
      return list;
    } catch (e, st) {
      TalkerLoggerUtil.talker.error('#getNews - $e', e, st);
      rethrow;
    }
  }

  @override
  Future<List<LayersDTO>> mainPageBanner() async {
    try {
      final appSettings = await appSettingsDatasource.getAppSettings();
      final token = await ensureValidToken();

      final Map<String, dynamic> response = await restClient.post(
        '/webservice/slider/getActiveSlides.php',
        body: {
          'token': token,
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
  Future<List<QuestionDTO>> getFAQ() async {
    try {
      final appSettings = await appSettingsDatasource.getAppSettings();
      final token = await ensureValidToken();

      final Map<String, dynamic> response = await restClient.post(
        '/webservice/faq/getFaq.php',
        body: {
          'token': token,
          'lang': appSettings?.locale?.languageCode == 'kk' ? 'kz' : 'ru',
        },
      );

      if (response['data'] == null) {
        throw Exception();
      }

      final list = await compute<List<dynamic>, List<QuestionDTO>>(
        (list) => list.map((e) => QuestionDTO.fromJson(e as Map<String, dynamic>)).toList(),
        response['data'] as List,
      );

      return list;
    } catch (e, st) {
      TalkerLoggerUtil.talker.error('#getFAQ - $e', e, st);
      rethrow;
    }
  }

  @override
  Future<List<CategoryDTO>> categories() async {
    try {
      final Map<String, dynamic> response = await restClient.get(
        '/list/categories',
        queryParams: {},
      );

      if (response['data'] == null) {
        throw Exception();
      }
      final list = await compute<List<dynamic>, List<CategoryDTO>>(
        (list) => list
            .map(
              (e) => CategoryDTO.fromJson(e as Map<String, dynamic>),
            )
            .toList(),
        response['data'] as List,
      );
      return list;
    } catch (e, st) {
      TalkerLoggerUtil.talker.error('#getCategories - $e', e, st);
      rethrow;
    }
  }

  @override
  Future<String> getToken() async {
    try {
      final Map<String, dynamic> response = await restClient.post(
        '/webservice/auth/getToken.php',
        body: {
          'secret': 'djdmctndbnnf3wzq8yjgmbm9wo561201',
        },
      );

      final token = response['token'] as String?;
      final expire = response['expire_date_time'] as String?;

      if (token == null || token.isEmpty) {
        throw Exception('Empty token');
      }
      // ✅ Сохраняем токен и дату окончания
      await authDao.token.setValue(token);
      if (expire != null) {
        await authDao.tokenExpire.setValue(expire);
      }

      return token;
    } catch (e, st) {
      TalkerLoggerUtil.talker.error('#getToken - $e', e, st);
      rethrow;
    }
  }

  Future<String> ensureValidToken() async {
    final String? token = authDao.token.value;

    if (token == null || token.isEmpty) {
      return await getToken();
    }

    try {
      final status = await checkToken();

      if (status.toLowerCase() == 'valid') {
        return token;
      } else {
        return await getToken(); // expired или invalid
      }
    } catch (e) {
      // На всякий случай — если checkToken упал
      TalkerLoggerUtil.talker.warning('#ensureValidToken fallback to getToken - $e');
      return await getToken();
    }
  }

  @override
  Future<String> checkToken() async {
    try {
      final String? token = authDao.token.value;
      final Map<String, dynamic> response = await restClient.post(
        '/webservice/auth/checkToken.php',
        body: {
          'token': token,
        },
      );

      final status = response['status'] as String?;
      final expire = response['expire_date_time'] as String?;

      if (expire != null) {
        await authDao.tokenExpire.setValue(expire);
      }

      return status!;
    } catch (e, st) {
      TalkerLoggerUtil.talker.error('#getToken - $e', e, st);
      rethrow;
    }
  }
}
