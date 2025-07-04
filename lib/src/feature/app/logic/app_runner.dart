import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart' as bloc_concurrency;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lombard/src/core/constant/config.dart';
import 'package:lombard/src/core/utils/app_bloc_observer.dart';
import 'package:lombard/src/core/utils/refined_logger.dart';
import 'package:lombard/src/core/utils/talker_logger_util.dart';
import 'package:lombard/src/feature/app/bloc/app_restart_bloc.dart';
import 'package:lombard/src/feature/app/logic/notification_service.dart';
import 'package:lombard/src/feature/app/presentation/app.dart';
import 'package:lombard/src/feature/initialization/logic/composition_root.dart';
import 'package:lombard/src/feature/initialization/widget/initialization_failed_app.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';

/// {@template app_runner}
/// A class which is responsible for initialization and running the app.
/// {@endtemplate}
final class AppRunner {
  /// {@macro app_runner}
  const AppRunner();

  /// Start the initialization and in case of success run application
  Future<void> initializeAndRun() async {
    final binding = WidgetsFlutterBinding.ensureInitialized();
    // FlutterNativeSplash.preserve(widgetsBinding: binding);

    // Preserve splash screen
    binding.deferFirstFrame();

    // Override logging
    FlutterError.onError = logger.logFlutterError;
    WidgetsBinding.instance.platformDispatcher.onError = logger.logPlatformDispatcherError;

    // Setup bloc observer and transformer
    if (kDebugMode) {
      Bloc.observer = TalkerBlocObserver(
        talker: TalkerLoggerUtil.talker,
        settings: const TalkerBlocLoggerSettings(
          printStateFullData: false,
        ),
      );
    } else {
      Bloc.observer = AppBlocObserver(logger);
    }

    // Added to avoid multiple simultaneous events
    Bloc.transformer = bloc_concurrency.sequential();
    // FlutterNativeSplash.remove();

    // configs
    const config = Config();

    Future<void> initializeAndRun() async {
      try {
        final result = await CompositionRoot(config, logger).compose();

        TalkerLoggerUtil.talker.log('msSpent ${result.msSpent}');
        // Attach this widget to the root of the tree.
        runApp(
          BlocProvider(
            create: (context) => AppRestartBloc(),
            child: App(result: result),
          ),
        );
      } catch (e, stackTrace) {
        TalkerLoggerUtil.talker.error('Initialization failed', e, stackTrace);
        logger.error('Initialization failed', error: e, stackTrace: stackTrace);
        runApp(
          InitializationFailedApp(
            error: e,
            stackTrace: stackTrace,
            retryInitialization: initializeAndRun,
          ),
        );
        rethrow;
      } finally {
        if (!binding.firstFrameRasterized) binding.allowFirstFrame();
      }
    }

    try {
      // await Firebase.initializeApp(
      //   options: DefaultFirebaseOptions.currentPlatform,
      // );
      // await NotificationService().init();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    } finally {
      await initializeAndRun();
    }

    // Run the app
    // await initializeAndRun();
  }
}
