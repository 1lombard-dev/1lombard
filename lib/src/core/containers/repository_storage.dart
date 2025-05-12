import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:lombard/src/core/rest_client/rest_client.dart';
import 'package:lombard/src/core/rest_client/src/dio_rest_client/src/dio_client.dart';
import 'package:lombard/src/core/rest_client/src/dio_rest_client/src/interceptor/dio_interceptor.dart';
import 'package:lombard/src/core/rest_client/src/dio_rest_client/src/rest_client_dio.dart';
import 'package:lombard/src/feature/auth/data/auth_remote_ds.dart';
import 'package:lombard/src/feature/auth/data/auth_repository.dart';
import 'package:lombard/src/feature/auth/database/auth_dao.dart';
import 'package:lombard/src/feature/main_feed/data/main_remote_ds.dart';
import 'package:lombard/src/feature/main_feed/data/main_repository.dart';
import 'package:lombard/src/feature/calculation/data/notification_remote_ds.dart';
import 'package:lombard/src/feature/calculation/data/notification_repository.dart';
import 'package:lombard/src/feature/profile/data/profile_remote_ds.dart';
import 'package:lombard/src/feature/profile/data/profile_repository.dart';

abstract class IRepositoryStorage {
  // dao's
  IAuthDao get authDao;
  // ISettingsDao get settingsDao;
  // ITipsDao get tipsDao;

  /// Network
  IRestClient get restClient;

  // Repositories
  // ISettingsRepository get settings;
  IAuthRepository get authRepository;
  IProfileRepository get profileRepository;
  IMainRepository get mainRepository;
  INotificationRepository get notificationRepository;

  // Data sources
  IAuthRemoteDS get authRemoteDS;
  IProfileRemoteDS get profileRemoteDS;
  IMainRemoteDS get mainRemoteDS;
  INotificationRemoteDS get notificationRemoteDS;

  void close();
}

class RepositoryStorage implements IRepositoryStorage {
  RepositoryStorage({
    required SharedPreferencesWithCache sharedPreferences,
    required PackageInfo packageInfo,
  })  : _sharedPreferences = sharedPreferences,
        _packageInfo = packageInfo;
  final SharedPreferencesWithCache _sharedPreferences;
  final PackageInfo _packageInfo;
  IRestClient? _restClient;

  @override
  Future<void> close() async {
    _restClient = null;
    // _portalRestClient = null;
    // _marketplaceRestClient = null;
    // _gamificationRestClient = null;
  }

  ///
  /// Network
  ///
  @override
  IRestClient get restClient => _restClient ??= RestClientDio(
        baseUrl: 'http://194.32.140.48/api',
        dioClient: DioClient(
          baseUrl: 'http://194.32.140.48/api',
          interceptor: const DioInterceptor(),
          authDao: authDao,
          packageInfo: _packageInfo,
          // settings: SettingsDao(sharedPreferences: sharedPreferences),
        ),
      );

  ///
  /// Repositories
  ///
  @override
  IAuthRepository get authRepository => AuthRepositoryImpl(
        remoteDS: authRemoteDS,
        authDao: authDao,
      );

  @override
  IProfileRepository get profileRepository => ProfileRepositoryImpl(
        remoteDS: profileRemoteDS,
      );

  @override
  IMainRepository get mainRepository => MainRepositoryImpl(
        remoteDS: mainRemoteDS,
      );

  @override
  INotificationRepository get notificationRepository => NotificationRepositoryImpl(
        remoteDS: notificationRemoteDS,
      );

  ///
  /// Remote datasources
  ///
  @override
  IAuthRemoteDS get authRemoteDS => AuthRemoteDSImpl(
        restClient: restClient,
      );

  @override
  IProfileRemoteDS get profileRemoteDS => ProfileRemoteDSImpl(
        restClient: restClient,
      );

  @override
  IMainRemoteDS get mainRemoteDS => MainRemoteDSImpl(
        restClient: restClient,
      );

  @override
  INotificationRemoteDS get notificationRemoteDS => NotificationRemoteDSImpl(
        restClient: restClient,
      );

  ///
  /// Data Access Object
  ///
  @override
  IAuthDao get authDao => AuthDao(sharedPreferences: _sharedPreferences);
}
