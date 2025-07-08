import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lombard/src/core/presentation/widgets/other/custom_loading_widget.dart';
import 'package:lombard/src/core/utils/extensions/context_extension.dart';
import 'package:lombard/src/feature/app/bloc/app_bloc.dart';

import 'package:lombard/src/feature/app/presentation/pages/base_student.dart';
import 'package:lombard/src/feature/app/presentation/pages/force_update_page.dart';
import 'package:lombard/src/feature/auth/bloc/login_cubit.dart';
import 'package:lombard/src/feature/auth/presentation/pages/pin_code_create_page.dart';
import 'package:lombard/src/feature/auth/presentation/pages/pin_code_enter_page.dart';
import 'package:lombard/src/feature/main_feed/bloc/check_token_cubit.dart';

import 'package:lombard/src/feature/main_feed/bloc/get_token_cubit.dart';
import 'package:lombard/src/feature/profile/bloc/profile_bloc.dart';

@RoutePage(name: 'LauncherRoute')
class Launcher extends StatefulWidget {
  const Launcher({super.key});

  @override
  _LauncherState createState() => _LauncherState();
}

class _LauncherState extends State<Launcher> {
  String? tokenExpired;
  @override
  void initState() {
    super.initState();
    FToast().init(context);

    final authDao = context.repository.authDao;
    final token = authDao.token.value;

    if (token == null || token.isEmpty) {
      // Токена нет — сразу получаем
      context.read<GetTokenCubit>().getToken();
    } else {
      // Токен есть — проверим его валидность
      context.read<CheckTokenCubit>().checkToken();
    }

    // Остальная инициализация
    // NotificationService().getDeviceToken(authDao: authDao);
    context.read<AppBloc>().add(
          AppEvent.checkAuth(
            version: context.dependencies.packageInfo.version,
          ),
        );
  }

  @override
  Widget build(BuildContext context) => BlocConsumer<AppBloc, AppState>(
        listener: (context, state) {
          log(state.toString());
          state.whenOrNull(
            inApp: () {
              // BlocProvider.of<AppBloc>(context).add(const AppEvent.sendDeviceToken());
              BlocProvider.of<ProfileBLoC>(context).add(const ProfileEvent.getProfile());
            },
          );
        },
        builder: (context, state) => state.maybeWhen(
          notAvailableVersion: () => ForceUpdatePage.forceUpdate(
            onTap: () async {},
          ),
          error: (message) => ForceUpdatePage.noAvailable(
            onTap: () async {},
          ),
          inApp: () => const BaseStudent(),
          guest: () => const BaseStudent(),
          notAuthorized: () => BlocProvider(
            create: (context) => LoginCubit(
              repository: context.repository.authRepository,
            ),
            child: const BaseStudent(),
          ),
          createPin: () => const PinCodeCreatePage(),
          enterPin: () => const PinCodeEnterPage(),
          loading: () => const _Scaffold(
            child: CustomLoadingWidget(),
          ),
          orElse: () => const BaseStudent(),
        ),
      );
}

class _Scaffold extends StatelessWidget {
  const _Scaffold({
    required this.child,
  });
  final Widget child;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(child: child),
      );
}
