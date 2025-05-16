import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import 'package:lombard/src/core/extensions/build_context.dart';
import 'package:lombard/src/core/presentation/widgets/textfields/custom_textfield.dart';
import 'package:lombard/src/core/theme/resources.dart';
import 'package:lombard/src/feature/app/router/app_router.dart';
import 'package:lombard/src/feature/main_feed/bloc/banner_cubit.dart';
import 'package:lombard/src/feature/main_feed/bloc/category_cubit.dart';

@RoutePage()
class AllBranchesPage extends StatefulWidget implements AutoRouteWrapper {
  const AllBranchesPage({super.key});

  @override
  _AllBranchesPageState createState() => _AllBranchesPageState();

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

class _AllBranchesPageState extends State<AllBranchesPage> {
  final TextEditingController priceController = TextEditingController();
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
          title: Text(
            'Все отделения ',
            style: AppTextStyles.fs18w600.copyWith(fontWeight: FontWeight.bold),
          ),
          shape: const Border(
            bottom: BorderSide(
              color: AppColors.dividerGrey,
              width: 0.5,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(15),
              const CustomTextField(
                suffixIcon: Icon(Icons.search),
                hintText: 'Например: город Алматы',
              ),
              const Gap(30),
              Text(
                'Выберите город',
                style: AppTextStyles.fs20w600.copyWith(color: AppColors.red),
              ),
              const Gap(20),
              Column(
                children: List.generate(10, (index) {
                  return Padding(
                    padding: EdgeInsets.zero.copyWith(bottom: 12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: Semantics(
                          excludeSemantics: true,
                          explicitChildNodes: true,
                          label: 'open_certificate_button',
                          child: InkWell(
                            onTap: () {
                              context.router.push(const BranchesDetailRoute());
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      'Алматы',
                                      style: AppTextStyles.fs16w500.copyWith(color: Colors.black),
                                    ),
                                  ),
                                  const Icon(Icons.arrow_forward_ios_outlined),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      );
}
