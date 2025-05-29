
import 'package:dio/dio.dart';
import 'package:lombard/src/core/utils/talker_logger_util.dart';
import 'package:lombard/src/feature/auth/database/auth_dao.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';

class DioClient {
  factory DioClient({
    required String baseUrl,
    required Interceptor interceptor,
    required IAuthDao authDao,
    required PackageInfo packageInfo,
    // required ISettingsDao settings,
    Dio? initialDio,
    bool useInterceptorWrapper = true,
  }) =>
      DioClient._internal(
        baseUrl: baseUrl,
        initialDio: initialDio,
        interceptor: interceptor,
        authDao: authDao,
        packageInfo: packageInfo,
        // settings: settings,
        useInterceptorWrapper: useInterceptorWrapper,
      );

  DioClient._internal({
    required String baseUrl,
    required Interceptor interceptor,
    required IAuthDao authDao,
    required PackageInfo packageInfo,
    // required ISettingsDao settings,
    required Dio? initialDio,
    required bool useInterceptorWrapper,
  }) : dio = initialDio ?? Dio(BaseOptions(baseUrl: baseUrl)) {
    _initInterceptors(
      dioInterceptor: interceptor,
      authDao: authDao,
      packageInfo: packageInfo,
      // settings: settings,
      useInterceptorWrapper: useInterceptorWrapper,
    );
  }

  final Dio dio;

  void _initInterceptors({
    required Interceptor dioInterceptor,
    required IAuthDao authDao,
    required PackageInfo packageInfo,
    // required ISettingsDao settings,
    required bool useInterceptorWrapper,
  }) {
    if (useInterceptorWrapper) {
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            options.headers['Accept'] = 'application/x-www-form-urlencoded';
            return handler.next(options);
          },
          onError: (e, handler) async => handler.next(e),
        ),
      );
    }

    /// Adds `TalkerDioLogger` to intercept Dio requests and responses and
    /// log them using Talker service.
    dio.interceptors.add(
      TalkerDioLogger(
        talker: TalkerLoggerUtil.talker,
        // settings: const TalkerDioLoggerSettings(
        //   printResponseHeaders: false,
        // ),
      ),
    );

    dio.interceptors.add(dioInterceptor);
  }
}
