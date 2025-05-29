import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:lombard/src/core/rest_client/rest_client.dart';
import 'package:lombard/src/core/utils/talker_logger_util.dart';
import 'package:lombard/src/feature/auth/database/auth_dao.dart';
import 'package:lombard/src/feature/main_feed/model/category_dto.dart';
import 'package:lombard/src/feature/main_feed/model/main_page_dto.dart';
import 'package:lombard/src/feature/main_feed/model/question_dto.dart';
import 'package:lombard/src/feature/settings/data/app_settings_datasource.dart';

abstract interface class IMainRemoteDS {
  Future<List<BannerDTO>> mainPageBanner();

  Future<List<CategoryDTO>> categories();

  Future<List<QuestionDTO>> getFAQ();

  Future<String> getToken();
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
  Future<List<BannerDTO>> mainPageBanner() async {
    try {
      final Map<String, dynamic> response = await restClient.get(
        '/list/app-functions',
        queryParams: {},
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
      TalkerLoggerUtil.talker.error('#getMainPageBanner - $e', e, st);
      rethrow;
    }
  }

  @override
  Future<List<QuestionDTO>> getFAQ() async {
    try {
      final appSettings = await appSettingsDatasource.getAppSettings();
      final token = authDao.token.value;

      final Map<String, dynamic> response = await restClient.post(
        '/webservice/faq/getFaq.php',
        body: {
          'token': token ?? '',
          'lang': appSettings?.locale?.languageCode == 'kk' ? 'kz' : 'ru',
        },
      );

      if (response['data'] == null) {
        throw Exception();
      }
      final list = await compute<List<dynamic>, List<QuestionDTO>>(
        (list) => list
            .map(
              (e) => QuestionDTO.fromJson(e as Map<String, dynamic>),
            )
            .toList(),
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

      log('RESPONSE::::: $response');
      final token = response['token'] as String;
      return token;
    } catch (e, st) {
      TalkerLoggerUtil.talker.error('#getToken - $e', e, st);
      rethrow;
    }
  }
}
