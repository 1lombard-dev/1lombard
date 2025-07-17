import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lombard/src/core/constant/generated/assets.gen.dart';
import 'package:lombard/src/core/presentation/widgets/other/custom_loading_overlay_widget.dart';
import 'package:lombard/src/core/theme/resources.dart';
import 'package:lombard/src/core/utils/extensions/context_extension.dart';
import 'package:lombard/src/feature/main_feed/bloc/main_cubit.dart';
import 'package:lombard/src/feature/main_feed/presentation/widget/main_list_container_widget.dart';

@RoutePage()
class FaqPage extends StatefulWidget implements AutoRouteWrapper {
  const FaqPage({super.key});

  @override
  State<FaqPage> createState() => _FaqPageState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MainCubit(
            repository: context.repository.mainRepository,
            calRepository: context.repository.calculacationRepository,
          ),
        ),
      ],
      child: this,
    );
  }
}

class _FaqPageState extends State<FaqPage> {
  List<bool> faqsVisible = [];

  @override
  void initState() {
    BlocProvider.of<MainCubit>(context).getFAQ();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.localized.answersToYourQuestions,
          style: AppTextStyles.fs18w600,
        ),
        leading: IconButton(
          onPressed: () {
            context.router.maybePop();
          },
          icon: SvgPicture.asset(Assets.icons.backButton.path),
        ),
        shape: const Border(
          bottom: BorderSide(
            color: AppColors.dividerGrey,
            width: 0.5,
          ),
        ),
      ),
      body: BlocBuilder<MainCubit, MainState>(
        builder: (context, state) {
          return state.maybeWhen(
            orElse: () {
              return const CustomLoadingOverlayWidget();
            },
            loaded: (doc, faq, gold) {
              return SingleChildScrollView(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: faq.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: index == faq.length - 1 ? 0 : 15),
                      child: MainListContainerWidget(
                        title: faq[index].title ?? 'ERROR',
                        introtext: faq[index].introtext ?? 'ERROR',
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
