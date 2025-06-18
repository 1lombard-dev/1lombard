import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lombard/src/core/presentation/widgets/other/custom_loading_widget.dart';
import 'package:lombard/src/core/utils/extensions/context_extension.dart';
import 'package:lombard/src/feature/app/bloc/app_bloc.dart';
import 'package:lombard/src/feature/app/logic/notification_service.dart';
import 'package:lombard/src/feature/app/presentation/pages/force_update_page.dart';
import 'package:lombard/src/feature/auth/bloc/login_cubit.dart';
import 'package:lombard/src/feature/auth/presentation/pages/pin_code_create_page.dart';
import 'package:lombard/src/feature/auth/presentation/pages/pin_code_enter_page.dart';

import 'package:lombard/src/feature/main_feed/bloc/get_token_cubit.dart';
import 'package:lombard/src/feature/profile/bloc/profile_bloc.dart';

@RoutePage(name: 'LauncherRoute')
class Launcher extends StatefulWidget {
  const Launcher({super.key});

  @override
  _LauncherState createState() => _LauncherState();
}

class _LauncherState extends State<Launcher> {
  @override
  void initState() {
    FToast().init(context);
    BlocProvider.of<GetTokenCubit>(context).getToken();
    // log('------${context.repository.authDao}');
    NotificationService().getDeviceToken(authDao: context.repository.authDao);
    BlocProvider.of<AppBloc>(context).add(
      AppEvent.checkAuth(
        version: context.dependencies.packageInfo.version,
      ),
    );
    super.initState();
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
          inApp: () => const PinCodeEnterPage(),
          guest: () => const PinCodeEnterPage(),
          notAuthorized: () => BlocProvider(
            create: (context) => LoginCubit(
              repository: context.repository.authRepository,
            ),
            child: const PinCodeCreatePage(),
          ),
          loading: () => const _Scaffold(
            child: CustomLoadingWidget(),
          ),
          orElse: () => const PinCodeCreatePage(),
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
