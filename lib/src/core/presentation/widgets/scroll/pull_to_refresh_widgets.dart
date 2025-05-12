import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RefreshClassicHeader extends StatelessWidget {
  const RefreshClassicHeader({super.key});

  @override
  Widget build(BuildContext context) => const ClassicHeader(
        completeText: 'Сәтті жаңартылды!',
        releaseText: 'Жаңарту!',
        idleText: 'Жаңарту үшін, төмен қарай тартыңыз',
        failedText: 'Белгісіз қате',
        refreshingText: 'Жаңарту...',
        // completeText: '',
        // completeIcon: null,
        // completeDuration: Duration.zero,
      );
}

class RefreshClassicFooter extends StatelessWidget {
  const RefreshClassicFooter({super.key});

  @override
  Widget build(BuildContext context) => const ClassicFooter(
        idleText: '',
        failedText: 'context.localized.unknownError',
        loadingText: 'context.localized.uploadingDotDotDot',
        canLoadingText: 'context.localized.pullUpToLoadTheData',
        noDataText: '',
        idleIcon: null,
      );
}

class TextfieldSearchFooter extends StatelessWidget {
  const TextfieldSearchFooter({super.key});

  @override
  Widget build(BuildContext context) => const ClassicFooter(
        idleText: '',
        failedText: 'context.localized.unknownError',
        loadingText: 'context.localized.uploadingDotDotDot',
        canLoadingText: 'context.localized.pullUpToLoadTheData',
        noDataText: '',
        idleIcon: null,
      );
}
