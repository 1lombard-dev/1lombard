import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import 'package:lombard/src/core/constant/generated/assets.gen.dart';
import 'package:lombard/src/core/extensions/build_context.dart';
import 'package:lombard/src/core/presentation/widgets/scroll/pull_to_refresh_widgets.dart';
import 'package:lombard/src/core/theme/resources.dart';
import 'package:lombard/src/feature/main_feed/bloc/banner_cubit.dart';
import 'package:lombard/src/feature/main_feed/bloc/category_cubit.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

@RoutePage()
class ContactsPage extends StatefulWidget implements AutoRouteWrapper {
  const ContactsPage({super.key});

  @override
  _ContactsPageState createState() => _ContactsPageState();

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

class _ContactsPageState extends State<ContactsPage> {
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
                    'Профиль',
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
                    const Gap(1),
                    Text(
                      'Головной офис',
                      style: AppTextStyles.fs18w600.copyWith(color: AppColors.red),
                    ),
                    const Gap(19),
                    Text(
                      'Телефон',
                      style: AppTextStyles.fs16w600.copyWith(color: AppColors.black, fontWeight: FontWeight.bold),
                    ),
                    const Gap(9),
                    InkWell(
                      onTap: () async {
                        final Uri uri = Uri(scheme: 'tel', path: '+77087087084');
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri);
                        }
                      },
                      child: Text(
                        '+7 708 708 70 84',
                        style: AppTextStyles.fs14w600.copyWith(color: AppColors.black),
                      ),
                    ),
                    const Gap(9),
                    InkWell(
                      onTap: () async {
                        final Uri uri = Uri(scheme: 'tel', path: '+77089730422');
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri);
                        }
                      },
                      child: Text(
                        '+7 708 973 04 22',
                        style: AppTextStyles.fs14w600.copyWith(color: AppColors.black),
                      ),
                    ),
                    const Gap(8),
                    Text(
                      'Почта',
                      style: AppTextStyles.fs16w600.copyWith(color: AppColors.black, fontWeight: FontWeight.bold),
                    ),
                    const Gap(8),
                    InkWell(
                      onTap: () async {
                        final Uri uri = Uri(
                          scheme: 'mailto',
                          path: 'marketing@1lombard.kz',
                        );
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri);
                        }
                      },
                      child: Text(
                        'marketing@1lombard.kz',
                        style: AppTextStyles.fs14w600.copyWith(
                          color: AppColors.black,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const Gap(9),
                    Text(
                      'Адресс',
                      style: AppTextStyles.fs16w600.copyWith(color: AppColors.black, fontWeight: FontWeight.bold),
                    ),
                    const Gap(8),
                    Text(
                      'Казахстан, г. Алматы, ул. Розыбакиева, д. 37',
                      style: AppTextStyles.fs14w600.copyWith(
                        color: AppColors.black,
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
