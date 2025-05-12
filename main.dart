import 'dart:async';

import 'package:lombard/src/core/utils/refined_logger.dart';
import 'package:lombard/src/feature/app/logic/app_runner.dart';

void main() => runZonedGuarded(
      () => const AppRunner().initializeAndRun(),
      logger.logZoneError,
    );
