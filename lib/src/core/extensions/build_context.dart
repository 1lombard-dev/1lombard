import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lombard/src/core/containers/dependencies_storage.dart';
import 'package:lombard/src/core/containers/repository_storage.dart';
import 'package:lombard/src/core/presentation/scopes/dependencies_scope.dart';
import 'package:lombard/src/core/presentation/scopes/repository_scope.dart';
import 'package:lombard/src/core/utils/screen_util.dart';
import 'package:lombard/src/feature/app/bloc/app_bloc.dart';
import 'package:lombard/src/feature/auth/models/user_dto.dart';
import 'package:lombard/src/feature/main_feed/bloc/check_token_cubit.dart';
import 'package:lombard/src/feature/main_feed/bloc/get_token_cubit.dart';
import 'package:package_info_plus/package_info_plus.dart';

extension BuildContextX on BuildContext {
  // IEnvironmentStorage get environment => EnvironmentScope.of(this);
  IDependenciesStorage get dependencies => DependenciesScope.of(this);
  // Dio get dio => dependencies.dio;
  // AppDatabase get database => dependencies.database;
  // SharedPreferencesWithCache get sharedPreferences => dependencies.sharedPreferences;
  PackageInfo get packageInfo => dependencies.packageInfo;

  IRepositoryStorage get repository => RepositoryScope.of(this);

  // ignore: avoid-non-null-assertion
  /// Перевести через контекст
  // AppLocalizations get localized => AppLocalizations.of(this);

  /// Выбранный язык
  // AppLanguage get currentLocale => SettingsScope.appLanguageOf(this);

  UserDTO? get cacheUser => repository.authRepository.cacheUser();

  /// Поддерживаемые языки
  // List<Locale> get supportedLocales => AppLocalizations.supportedLocales;

  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get screenSize => MediaQuery.sizeOf(this);
  EdgeInsets get viewPadding => MediaQuery.viewPaddingOf(this);

  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;

  AppBloc get appBloc => BlocProvider.of<AppBloc>(this);

  GetTokenCubit get getToken => BlocProvider.of<GetTokenCubit>(this);

  CheckTokenCubit get checkToken => BlocProvider.of<CheckTokenCubit>(this);
  // ProfileBloc get profileBloc => BlocProvider.of<ProfileBloc>(this);
  ScreenSize get deviceSize => ScreenUtil.screenSizeOf(this);
  // ScreenSize get deviceSizeOf => ScreenUtil.screenSizeOf(this);
  Orientation get orientation => ScreenUtil.orientation();
  // Scale height with design size
  double get scaleHeight => mediaQuery.size.height / 844;
  // Scale width with design size
  double get scaleWidth => mediaQuery.size.width / 390;
}

extension OrientationX on Orientation {
  T whenByValue<T extends Object?>({
    required T portrait,
    required T landscape,
  }) {
    switch (this) {
      case Orientation.portrait:
        return portrait;
      case Orientation.landscape:
        return landscape;
    }
  }

  T maybeWhenByValue<T extends Object?>({
    required T orElse,
    T? portrait,
    T? landscape,
  }) =>
      whenByValue<T>(
        portrait: portrait ?? orElse,
        landscape: landscape ?? orElse,
      );
}
