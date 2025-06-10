import 'package:lombard/src/core/rest_client/rest_client.dart';
import 'package:lombard/src/core/rest_client/src/dio_rest_client/src/dio_client.dart';
import 'package:lombard/src/core/rest_client/src/dio_rest_client/src/interceptor/dio_interceptor.dart';
import 'package:lombard/src/core/rest_client/src/dio_rest_client/src/rest_client_dio.dart';
import 'package:lombard/src/feature/auth/data/auth_remote_ds.dart';
import 'package:lombard/src/feature/auth/data/auth_repository.dart';
import 'package:lombard/src/feature/auth/database/auth_dao.dart';
import 'package:lombard/src/feature/calculation/data/calculation_remote_ds.dart';
import 'package:lombard/src/feature/calculation/data/calculation_repository.dart';
import 'package:lombard/src/feature/main_feed/data/main_remote_ds.dart';
import 'package:lombard/src/feature/main_feed/data/main_repository.dart';
import 'package:lombard/src/feature/map/data/map_remote_ds.dart';
import 'package:lombard/src/feature/map/data/map_repository.dart';
import 'package:lombard/src/feature/profile/data/profile_remote_ds.dart';
import 'package:lombard/src/feature/profile/data/profile_repository.dart';
import 'package:lombard/src/feature/settings/data/app_settings_datasource.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  IMapRepository get mapRepository;
  ICalculationRepository get calculacationRepository;

  // Data sources
  IAuthRemoteDS get authRemoteDS;
  IProfileRemoteDS get profileRemoteDS;
  IMainRemoteDS get mainRemoteDS;
  IMapRemoteDS get mapRemoteDS;
  ICalculationRemoteDS get calculationRemoteDS;

  void close();
}

class RepositoryStorage implements IRepositoryStorage {
  RepositoryStorage({
    required SharedPreferencesWithCache sharedPreferences,
    required PackageInfo packageInfo,
    required AppSettingsDatasource appSettingsDatasource,
  })  : _sharedPreferences = sharedPreferences,
        _packageInfo = packageInfo,
        _appSettingsDatasource = appSettingsDatasource;
  final SharedPreferencesWithCache _sharedPreferences;
  final PackageInfo _packageInfo;
  final AppSettingsDatasource _appSettingsDatasource;
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
        baseUrl: 'https://1lombard.kz',
        dioClient: DioClient(
          baseUrl: 'https://1lombard.kz',
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
        authDao: authDao,
      );

  @override
  IMapRepository get mapRepository => MapRepositoryImpl(
        remoteDS: mapRemoteDS,
      );

  @override
  ICalculationRepository get calculacationRepository => CalculationRepositoryImpl(
        remoteDS: calculationRemoteDS,
      );

  ///
  /// Remote datasources
  ///
  @override
  IAuthRemoteDS get authRemoteDS => AuthRemoteDSImpl(
        restClient: restClient,
      );

  @override
  IMapRemoteDS get mapRemoteDS => MapRemoteDSImpl(
        restClient: restClient,
        authDao: authDao,
        appSettingsDatasource: _appSettingsDatasource,
      );

  @override
  IProfileRemoteDS get profileRemoteDS => ProfileRemoteDSImpl(
        restClient: restClient,
      );

  @override
  IMainRemoteDS get mainRemoteDS => MainRemoteDSImpl(
        restClient: restClient,
        authDao: authDao,
        appSettingsDatasource: _appSettingsDatasource, // ✅ Inject here
      );

  @override
  ICalculationRemoteDS get calculationRemoteDS => CalculationRemoteDSImpl(
        restClient: restClient,
        authDao: authDao,
        appSettingsDatasource: _appSettingsDatasource, // ✅ Inject here
      );

  ///
  /// Data Access Object
  ///
  @override
  IAuthDao get authDao => AuthDao(sharedPreferences: _sharedPreferences);
}
