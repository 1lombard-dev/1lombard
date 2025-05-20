import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:gap/gap.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:lombard/src/core/constant/generated/assets.gen.dart';
import 'package:lombard/src/core/presentation/widgets/buttons/custom_material_button.dart';
import 'package:lombard/src/core/presentation/widgets/other/custom_radio.dart';
import 'package:lombard/src/core/theme/resources.dart';
import 'package:lombard/src/feature/app/bloc/app_restart_bloc.dart';
import 'package:lombard/src/feature/settings/bloc/app_settings_bloc.dart';
import 'package:lombard/src/feature/settings/widget/settings_scope.dart';

@RoutePage()
class ChooseLanguagePage extends StatefulWidget {
  const ChooseLanguagePage({super.key});

  @override
  _ChooseLanguagePageState createState() => _ChooseLanguagePageState();
}

class _ChooseLanguagePageState extends State<ChooseLanguagePage> {
// State to manage the switch

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        backgroundColor: AppColors.backgroundInput,
        appBar: AppBar(
          title: Container(
            decoration: const BoxDecoration(
              color: AppColors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Кабинет',
                    style: AppTextStyles.fs18w600.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Image.asset(
                    Assets.images.logoHeader.path,
                    height: 34,
                  ),
                ],
              ),
            ),
          ),
          shape: const Border(
            bottom: BorderSide(
              color: AppColors.dividerGrey,
              width: 0.5,
            ),
          ),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Gap(12),
            Semantics(
              excludeSemantics: true,
              explicitChildNodes: true,
              label: 'select_change_language_en_button',
              child: CustomMaterialButton(
                borderRadiusGeometry: BorderRadius.zero,
                onTap: () async {
                  SettingsScope.of(context).add(
                    AppSettingsEvent.updateAppSettings(
                      appSettings: SettingsScope.settingsOf(context).copyWith(
                        locale: const Locale('en'),
                      ),
                    ),
                  );
                  context.router.maybePop();

                  BlocProvider.of<AppRestartBloc>(context).add(const AppRestartEvent.restartApp());
                },
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'English',
                      style: AppTextStyles.fs16w500,
                    ),
                    CustomRadio(
                      value: const Locale('en'),
                      groupValue: SettingsScope.settingsOf(context).locale,
                      onChanged: (Locale index) {},
                    ),
                  ],
                ),
              ),
            ),
            const Divider(
              height: 1, // Adjust height to remove extra space
              thickness: 1, // Adjust thickness if needed
            ),
            Semantics(
              excludeSemantics: true,
              explicitChildNodes: true,
              label: 'select_change_language_kz_button',
              child: CustomMaterialButton(
                borderRadiusGeometry: BorderRadius.zero,
                onTap: () async {
                  SettingsScope.of(context).add(
                    AppSettingsEvent.updateAppSettings(
                      appSettings: SettingsScope.settingsOf(context).copyWith(
                        locale: const Locale('kk'),
                      ),
                    ),
                  );
                  context.router.maybePop();

                  BlocProvider.of<AppRestartBloc>(context).add(const AppRestartEvent.restartApp());
                },
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Казахский',
                      style: AppTextStyles.fs16w500,
                    ),
                    CustomRadio(
                      value: const Locale('kk'),
                      groupValue: SettingsScope.settingsOf(context).locale,
                      onChanged: (Locale index) {},
                    ),
                  ],
                ),
              ),
            ),
            const Divider(
              height: 1, // Adjust height to remove extra space
              thickness: 1, // Adjust thickness if needed
            ),
            Semantics(
              excludeSemantics: true,
              explicitChildNodes: true,
              label: 'select_change_language_ru_button',
              child: CustomMaterialButton(
                borderRadiusGeometry: BorderRadius.zero,
                onTap: () async {
                  SettingsScope.of(context).add(
                    AppSettingsEvent.updateAppSettings(
                      appSettings: SettingsScope.settingsOf(context).copyWith(
                        locale: const Locale('ru'),
                      ),
                    ),
                  );
                  context.router.maybePop();

                  BlocProvider.of<AppRestartBloc>(context).add(const AppRestartEvent.restartApp());
                },
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Русский',
                      style: AppTextStyles.fs16w500,
                    ),
                    CustomRadio(
                      value: const Locale('ru'),
                      groupValue: SettingsScope.settingsOf(context).locale,
                      onChanged: (Locale index) {},
                    ),
                  ],
                ),
              ),
            ),
            const Divider(
              height: 1, // Adjust height to remove extra space
              thickness: 1, // Adjust thickness if needed
            ),
            const Gap(20),
          ],
        ),
      ),
    );
  }
}
