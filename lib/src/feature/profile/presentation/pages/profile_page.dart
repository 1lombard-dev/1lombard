import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

import 'package:lombard/src/core/constant/generated/assets.gen.dart';

import 'package:lombard/src/core/presentation/widgets/scroll/pull_to_refresh_widgets.dart';
import 'package:lombard/src/core/theme/resources.dart';
import 'package:lombard/src/core/utils/extensions/context_extension.dart';
import 'package:lombard/src/feature/app/router/app_router.dart';
import 'package:lombard/src/feature/main_feed/bloc/banner_cubit.dart';
import 'package:lombard/src/feature/main_feed/bloc/category_cubit.dart';
import 'package:lombard/src/feature/profile/presentation/widget/logout_bottom_sheet.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

@RoutePage()
class ProfilePage extends StatefulWidget implements AutoRouteWrapper {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => BannerCubit(repository: context.repository.mainRepository),
        ),
        BlocProvider(
          create: (context) => CategoryCubit(repository: context.repository.mainRepository),
        ),
      ],
      child: this,
    );
  }
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController priceController = TextEditingController();
  final RefreshController _refreshController = RefreshController();
  @override
  void initState() {
    super.initState();
    BlocProvider.of<BannerCubit>(context).getMainPageBanner();
    BlocProvider.of<CategoryCubit>(context).getCategory();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
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
                    context.localized.office,
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
        body: SafeArea(
          child: SmartRefresher(
            controller: _refreshController,
            header: const RefreshClassicHeader(),
            onRefresh: () {
              // BlocProvider.of<BannerCubit>(context).getMainPageBanner();
              // BlocProvider.of<CategoryCubit>(context).getCategory();
              _refreshController.refreshCompleted();
            },
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Gap(9),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('ФИО', style: AppTextStyles.fs16w400),
                                Text('Нугуманов Арман', style: AppTextStyles.fs16w400),
                              ],
                            ),
                            const Gap(18),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(context.localized.phoneNumber, style: AppTextStyles.fs16w400),
                                const Text('+7 (777) 999  77-99', style: AppTextStyles.fs16w400),
                              ],
                            ),
                            const Gap(18),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('ИИН', style: AppTextStyles.fs16w400),
                                Text('030907551155', style: AppTextStyles.fs16w400),
                              ],
                            ),
                            const Gap(9),
                          ],
                        ),
                      ),
                    ),
                    const Gap(41),
                    Text(
                      context.localized.settings,
                      style: AppTextStyles.fs16w700.copyWith(color: AppColors.black),
                    ),
                    const Gap(12),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                context.localized.changePassword,
                                style: AppTextStyles.fs16w400.copyWith(color: AppColors.black),
                              ),
                              SvgPicture.asset(
                                Assets.icons.arrowRight.path,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Divider(),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          context.router.push(const ChooseLanguageRoute());
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Язык / Language / Тіл',
                                style: AppTextStyles.fs16w400.copyWith(color: AppColors.black),
                              ),
                              SvgPicture.asset(
                                Assets.icons.arrowRight.path,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Divider(),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          context.router.push(const NotificationRoute());
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                context.localized.notifications,
                                style: AppTextStyles.fs16w400.copyWith(color: AppColors.black),
                              ),
                              SvgPicture.asset(
                                Assets.icons.arrowRight.path,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Divider(),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          context.router.push(const ContactsRoute());
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                context.localized.contacts,
                                style: AppTextStyles.fs16w400.copyWith(color: AppColors.black),
                              ),
                              SvgPicture.asset(
                                Assets.icons.arrowRight.path,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Divider(),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                context.localized.help,
                                style: AppTextStyles.fs16w400.copyWith(color: AppColors.black),
                              ),
                              SvgPicture.asset(
                                Assets.icons.arrowRight.path,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Divider(),
                    const Gap(40),
                    Center(
                      child: InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            useRootNavigator: false,
                            // barrierDismissible: true,
                            builder: (BuildContext context) {
                              return LogoutBottomSheet(
                                parentContext: context,
                              );
                            },
                          );
                        },
                        child: Text(
                          context.localized.exit,
                          style: AppTextStyles.fs20w600.copyWith(color: AppColors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
