import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lombard/src/core/rest_client/models/basic_response.dart';
import 'package:lombard/src/core/rest_client/rest_client.dart';
import 'package:lombard/src/core/utils/talker_logger_util.dart';
import 'package:lombard/src/feature/auth/database/auth_dao.dart';
import 'package:lombard/src/feature/auth/models/user_dto.dart';
import 'package:lombard/src/feature/auth/presentation/auth.dart';
import 'package:lombard/src/feature/profile/models/response/about_us_dto.dart';
import 'package:lombard/src/feature/profile/models/response/document_dto.dart';
import 'package:lombard/src/feature/profile/models/response/faq_dto.dart';
import 'package:lombard/src/feature/profile/models/response/social_media_dto.dart';
import 'package:lombard/src/feature/profile/models/response/working_hour_dto.dart';
import 'package:lombard/src/feature/settings/data/app_settings_datasource.dart';

abstract interface class IProfileRemoteDS {
  Future<UserDTO> profileData();

  Future<List<FaqDTO>> faqList();

  Future<List<SocialMediaDTO>> socialMediaList();

  Future<List<WorkingHourDTO>> workingHourList();

  Future<List<AboutUsDTO>> aboutUsList();

  Future<List<DocumentDTO>> documents();

  Future<BasicResponse> deleteAccount();

  Future<BasicResponse> logout();

  Future<BasicResponse> editAccount({
    required UserPayload userPayload,
    XFile? avatar,
  });
}

class ProfileRemoteDSImpl implements IProfileRemoteDS {
  const ProfileRemoteDSImpl({
    required this.restClient,
    required this.authDao,
    required this.appSettingsDatasource,
  });
  final IRestClient restClient;
  final IAuthDao authDao;
  final AppSettingsDatasource appSettingsDatasource; // ✅ Declare this
  @override
  Future<UserDTO> profileData() async {
    try {
      final token = authDao.token.value;
      final iin = authDao.iin.value;

      final Map<String, dynamic> response = await restClient.post(
        '/webservice/userauth/getUserInfo.php',
        body: {
          'token': token ?? '',
          'login': iin ?? '',
        },
      );

      final dynamic data = response['data'];

      if (data is List && data.isNotEmpty && data.first is Map<String, dynamic>) {
        return UserDTO.fromJson(data.first as Map<String, dynamic>);
      } else {
        throw Exception('Некорректный формат данных пользователя');
      }
    } catch (e, st) {
      TalkerLoggerUtil.talker.error('#getUserData - $e', e, st);
      rethrow;
    }
  }

  @override
  Future<BasicResponse> deleteAccount() async {
    try {
      final Map<String, dynamic> response = await restClient.get(
        '/user/delete',
      );

      return BasicResponse.fromJson(response);
    } catch (e, st) {
      TalkerLoggerUtil.talker.error('#deleteAccount - $e', e, st);
      rethrow;
    }
  }

  @override
  Future<BasicResponse> editAccount({
    required UserPayload userPayload,
    XFile? avatar,
  }) async {
    try {
      final FormData formData = FormData.fromMap(userPayload.toJson());
      if (avatar != null) {
        formData.files.add(MapEntry('avatar', await MultipartFile.fromFile(avatar.path)));
      }

      final Map<String, dynamic> response = await restClient.post(
        '/user/edit',
        body: formData,
      );

      return BasicResponse.fromJson(response);
    } catch (e, st) {
      TalkerLoggerUtil.talker.error('#editAccount - $e', e, st);
      rethrow;
    }
  }

  @override
  Future<List<FaqDTO>> faqList() async {
    try {
      final Map<String, dynamic> response = await restClient.get(
        '/main/faq',
        queryParams: {},
      );

      if (response['data'] == null) {
        throw Exception();
      }
      final list = await compute<List<dynamic>, List<FaqDTO>>(
        (list) => list
            .map(
              (e) => FaqDTO.fromJson(e as Map<String, dynamic>),
            )
            .toList(),
        response['data'] as List,
      );
      return list;
    } catch (e, st) {
      TalkerLoggerUtil.talker.error('#getFaqList - $e', e, st);
      rethrow;
    }
  }

  @override
  Future<List<SocialMediaDTO>> socialMediaList() async {
    try {
      final Map<String, dynamic> response = await restClient.get(
        '/main/social-media',
        queryParams: {},
      );

      if (response['data'] == null) {
        throw Exception();
      }
      final list = await compute<List<dynamic>, List<SocialMediaDTO>>(
        (list) => list
            .map(
              (e) => SocialMediaDTO.fromJson(e as Map<String, dynamic>),
            )
            .toList(),
        response['data'] as List,
      );
      return list;
    } catch (e, st) {
      TalkerLoggerUtil.talker.error('#getSocialMedia - $e', e, st);
      rethrow;
    }
  }

  @override
  Future<List<DocumentDTO>> documents() async {
    try {
      final Map<String, dynamic> response = await restClient.get(
        '/main/documents',
        queryParams: {},
      );

      if (response['data'] == null) {
        throw Exception();
      }
      final list = await compute<List<dynamic>, List<DocumentDTO>>(
        (list) => list
            .map(
              (e) => DocumentDTO.fromJson(e as Map<String, dynamic>),
            )
            .toList(),
        response['data'] as List,
      );
      return list;
    } catch (e, st) {
      TalkerLoggerUtil.talker.error('#getDocuments - $e', e, st);
      rethrow;
    }
  }

  @override
  Future<List<AboutUsDTO>> aboutUsList() async {
    try {
      final Map<String, dynamic> response = await restClient.get(
        '/main/about-us',
        queryParams: {},
      );

      if (response['data'] == null) {
        throw Exception();
      }
      final list = await compute<List<dynamic>, List<AboutUsDTO>>(
        (list) => list
            .map(
              (e) => AboutUsDTO.fromJson(e as Map<String, dynamic>),
            )
            .toList(),
        response['data'] as List,
      );
      return list;
    } catch (e, st) {
      TalkerLoggerUtil.talker.error('#getAboutUs - $e', e, st);
      rethrow;
    }
  }

  @override
  Future<List<WorkingHourDTO>> workingHourList() async {
    try {
      final Map<String, dynamic> response = await restClient.get(
        '/main/working-hours',
        queryParams: {},
      );

      if (response['data'] == null) {
        throw Exception();
      }
      final list = await compute<List<dynamic>, List<WorkingHourDTO>>(
        (list) => list
            .map(
              (e) => WorkingHourDTO.fromJson(e as Map<String, dynamic>),
            )
            .toList(),
        response['data'] as List,
      );
      return list;
    } catch (e, st) {
      TalkerLoggerUtil.talker.error('#getWorkingHour - $e', e, st);
      rethrow;
    }
  }

  @override
  Future<BasicResponse> logout() async {
    try {
      final Map<String, dynamic> response = await restClient.get(
        '/user/logout',
      );

      return BasicResponse.fromJson(response);
    } catch (e, st) {
      TalkerLoggerUtil.talker.error('#logoutAccount - $e', e, st);
      rethrow;
    }
  }
}
