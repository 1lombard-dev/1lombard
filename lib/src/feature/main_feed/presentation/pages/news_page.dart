import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:lombard/src/core/constant/generated/assets.gen.dart';
import 'package:lombard/src/core/presentation/widgets/other/custom_loading_overlay_widget.dart';
import 'package:lombard/src/core/presentation/widgets/scroll/pull_to_refresh_widgets.dart';
import 'package:lombard/src/core/theme/resources.dart';
import 'package:lombard/src/core/utils/extensions/context_extension.dart';
import 'package:lombard/src/core/utils/layout/url_util.dart';
import 'package:lombard/src/feature/initialization/model/environment.dart';
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
  final RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    context.read<NewsCubit>().getNews();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.backgroundInput,
        appBar: AppBar(
          title: Container(
            decoration: const BoxDecoration(color: AppColors.white),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.localized.news,
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
            bottom: BorderSide(color: AppColors.dividerGrey, width: 0.5),
          ),
        ),
        body: SafeArea(
          child: SmartRefresher(
            controller: _refreshController,
            header: const RefreshClassicHeader(),
            onRefresh: () {
              context.read<NewsCubit>().getNews();
              _refreshController.refreshCompleted();
            },
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: BlocBuilder<NewsCubit, NewsState>(
                  builder: (context, state) {
                    return state.maybeWhen(
                      orElse: () => const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 200.0),
                          child: CustomLoadingOverlayWidget(),
                        ),
                      ),
                      loaded: (news) {
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(bottom: 20),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.65,
                          ),
                          itemCount: news.length,
                          itemBuilder: (context, index) {
                            final item = news[index];
                            return Container(
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.network(
                                      '$kBaseUrlImages/${item.smallImage}',
                                      height: 130,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const Gap(10),
                                  Text(
                                    item.title ?? 'Без текста',
                                    style: AppTextStyles.fs18w600,
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const Spacer(),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.red,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    width: double.infinity,
                                    child: Material(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(20),
                                      child: InkWell(
                                        onTap: () async {
                                          UrlUtil.launch(context, url: 'https://1lombard.kz${item.readmoreLink ?? ''}');
                                        },
                                        borderRadius: BorderRadius.circular(20),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Text(
                                            context.localized.moreDetailed,
                                            textAlign: TextAlign.center,
                                            style: AppTextStyles.fs15w400.copyWith(color: AppColors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );
}
