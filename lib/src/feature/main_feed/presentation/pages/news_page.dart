import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import 'package:lombard/src/core/constant/generated/assets.gen.dart';
import 'package:lombard/src/core/extensions/build_context.dart';
import 'package:lombard/src/core/presentation/widgets/scroll/pull_to_refresh_widgets.dart';
import 'package:lombard/src/core/theme/resources.dart';
import 'package:lombard/src/feature/main_feed/bloc/news_cubit.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

@RoutePage()
class NewsPage extends StatefulWidget implements AutoRouteWrapper {
  const NewsPage({super.key});

  @override
  _NewsPageState createState() => _NewsPageState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NewsCubit(repository: context.repository.mainRepository),
        ),
      ],
      child: this,
    );
  }
}

class _NewsPageState extends State<NewsPage> {
  final TextEditingController priceController = TextEditingController();
  final RefreshController _refreshController = RefreshController();
  @override
  void initState() {
    super.initState();
    BlocProvider.of<NewsCubit>(context).getNews();
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
                    'Уведомления',
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
                                Text('Ертанова Лаура', style: AppTextStyles.fs16w400),
                                Text('16:34', style: AppTextStyles.fs16w400),
                              ],
                            ),
                            const Gap(18),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Добрый день,хочу напомнить о ', style: AppTextStyles.fs16w400),
                                Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(6),
                                  child: Text(
                                    '2',
                                    style: AppTextStyles.fs12w600.copyWith(color: AppColors.white),
                                  ),
                                ),
                              ],
                            ),
                            const Gap(9),
                          ],
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
