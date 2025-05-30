import 'package:lombard/src/feature/app/logic/tracking_manager.dart';
import 'package:lombard/src/feature/settings/bloc/app_settings_bloc.dart';
import 'package:lombard/src/feature/settings/data/app_settings_datasource.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';


/// Composed dependencies from the [CompositionRoot].
///
/// This class contains all the dependencies that are required for the application
/// to work.
///

base class DependenciesContainer {
  const DependenciesContainer({
    required this.appSettingsBloc,
    required this.errorTrackingManager,
    required this.packageInfo,
    required this.sharedPreferences,
    required this.appSettingsDatasource,
  });

  /// [AppSettingsBloc] instance, used to manage theme and locale.
  final AppSettingsBloc appSettingsBloc;

  /// [ErrorTrackingManager] instance, used to report errors.
  final ErrorTrackingManager errorTrackingManager;

  final PackageInfo packageInfo;

  final SharedPreferencesWithCache sharedPreferences;

  final AppSettingsDatasource appSettingsDatasource;
}

/// A special version of [DependenciesContainer] that is used in tests.
///
/// In order to use [DependenciesContainer] in tests, it is needed to
/// extend this class and provide the dependencies that are needed for the test.
base class TestDependenciesContainer implements DependenciesContainer {
  @override
  Object? noSuchMethod(Invocation invocation) {
    throw UnimplementedError(
      'The test tries to access ${invocation.memberName} dependency, but '
      'it was not provided. Please provide the dependency in the test. '
      'You can do it by extending this class and providing the dependency.',
    );
  }
}
