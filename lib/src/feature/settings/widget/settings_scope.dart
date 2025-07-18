import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lombard/src/core/utils/extensions/context_extension.dart';

import 'package:lombard/src/feature/app/bloc/app_bloc.dart';

import 'package:lombard/src/feature/initialization/widget/dependencies_scope.dart';
import 'package:lombard/src/feature/main_feed/bloc/check_token_cubit.dart';
import 'package:lombard/src/feature/main_feed/bloc/get_token_cubit.dart';
import 'package:lombard/src/feature/profile/bloc/profile_bloc.dart';

import 'package:lombard/src/feature/settings/bloc/app_settings_bloc.dart';
import 'package:lombard/src/feature/settings/model/app_settings.dart';

/// {@template settings_scope}
/// SettingsScope widget.
/// {@endtemplate}
class SettingsScope extends StatefulWidget {
  /// {@macro settings_scope}
  const SettingsScope({
    required this.child,
    super.key,
  });

  /// The child widget.
  final Widget child;

  /// Get the [AppSettingsBloc] instance.
  static AppSettingsBloc of(
    BuildContext context, {
    bool listen = true,
  }) {
    final settingsScope = listen
        ? context.dependOnInheritedWidgetOfExactType<_InheritedSettings>()
        : context.getInheritedWidgetOfExactType<_InheritedSettings>();
    return settingsScope!.state._appSettingsBloc;
  }

  /// Get the [AppSettings] instance.
  static AppSettings settingsOf(
    BuildContext context, {
    bool listen = true,
  }) {
    final settingsScope = listen
        ? context.dependOnInheritedWidgetOfExactType<_InheritedSettings>()
        : context.getInheritedWidgetOfExactType<_InheritedSettings>();
    return settingsScope!.settings ?? const AppSettings();
  }

  @override
  State<SettingsScope> createState() => _SettingsScopeState();
}

/// State for widget SettingsScope.
class _SettingsScopeState extends State<SettingsScope> {
  late final AppSettingsBloc _appSettingsBloc;

  @override
  void initState() {
    _appSettingsBloc = DependenciesScope.of(context).appSettingsBloc;
    super.initState();
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<AppSettingsBloc, AppSettingsState>(
        bloc: _appSettingsBloc,
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => AppBloc(context.repository.authRepository),
            ),
            BlocProvider(
              create: (context) => GetTokenCubit(repository: context.repository.mainRepository),
            ),
            BlocProvider(
              create: (context) => CheckTokenCubit(repository: context.repository.mainRepository),
            ),
            BlocProvider(
              create: (context) => ProfileBLoC(
                authRepository: context.repository.authRepository,
                profileRepository: context.repository.profileRepository,
              ),
            ),
            // BlocProvider(
            //   create: (context) => FaqCubit(repository: context.repository.profileRepository),
            // ),
          ],
          child: _InheritedSettings(
            settings: state.appSettings,
            state: this,
            child: widget.child,
          ),
        ),
      );
}

/// {@template inherited_settings}
/// _InheritedSettings widget.
/// {@endtemplate}
class _InheritedSettings extends InheritedWidget {
  /// {@macro inherited_settings}
  const _InheritedSettings({
    required super.child,
    required this.state,
    required this.settings,
    super.key, // ignore: unused_element
  });

  /// _SettingsScopeState instance.
  final _SettingsScopeState state;
  final AppSettings? settings;

  @override
  bool updateShouldNotify(covariant _InheritedSettings oldWidget) => settings != oldWidget.settings;
}
