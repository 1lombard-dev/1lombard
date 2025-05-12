import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lombard/src/core/constant/generated/assets.gen.dart';
import 'package:lombard/src/core/presentation/widgets/shimmer/shimmer_box.dart';
import 'package:lombard/src/core/theme/resources.dart';
import 'package:lombard/src/core/utils/extensions/context_extension.dart';
import 'package:lombard/src/feature/profile/bloc/faq_cubit.dart';

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
          create: (context) => FaqCubit(repository: context.repository.profileRepository),
          child: this,
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
    BlocProvider.of<FaqCubit>(context).getFaqList();
    // log('$faqsVisible', name: 'faqVisible INIT');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Сұрақ-жауап',
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
      body: BlocConsumer<FaqCubit, FaqState>(
        listener: (context, state) {
          state.maybeWhen(
            orElse: () {},
            loaded: (faqList) {
              // if (faqsVisible.length != faqList.length) faqsVisible = List<bool>.filled(faqList.length, false);
            },
          );
        },
        builder: (context, state) {
          return state.maybeWhen(
            orElse: () => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 20),
                itemCount: 4,
                itemBuilder: (BuildContext context, int index) {
                  return const Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: ShimmerBox(
                      height: 50,
                      width: double.infinity,
                    ),
                  );
                },
              ),
            ),
            loaded: (faqList) {
              if (faqsVisible.length != faqList.length) faqsVisible = List<bool>.filled(faqList.length, false);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 20),
                  itemCount: faqList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        faqsVisible[index] = !faqsVisible[index];
                        setState(() {});
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.only(
                          top: 14,
                          right: 14,
                          bottom: 14,
                          left: 16,
                        ),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: faqsVisible[index] ? Border.all(color: AppColors.mainBlueColor, width: 0.5) : null,
                          color: faqsVisible[index] ? AppColors.muteBlue2 : AppColors.greyTextField,
                        ),
                        child: Column(
                          children: [
                            GestureDetector(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      faqList[index].question ?? '',
                                      style: AppTextStyles.fs14w600.copyWith(height: 1.7),
                                    ),
                                  ),
                                  Center(
                                    child: Transform.rotate(
                                      angle: 90 * 3.14159265359 / 180,
                                      child: SvgPicture.asset(
                                        faqsVisible[index] ? Assets.icons.down.path : Assets.icons.down.path,
                                        // ignore: deprecated_member_use
                                        color: faqsVisible[index] == false ? null : AppColors.mainBlueColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                faqsVisible[index] == true ? faqsVisible[index] = false : faqsVisible[index] = true;
                                setState(() {});
                              },
                            ),
                            if (faqsVisible[index])
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 5500),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8, right: 14),
                                  child: Text(
                                    faqList[index].answer ?? '',
                                    style: AppTextStyles.fs14w400.copyWith(height: 1.7),
                                  ),
                                ),
                              ),
                            // AnimatedCrossFade(
                            //   duration: const Duration(milliseconds: 300),
                            //   firstChild: const SizedBox.shrink(),
                            //   secondChild: Padding(
                            //     padding: const EdgeInsets.only(top: 8),
                            //     child: Text(
                            //       faqsAnswer[index],
                            //       style: AppTextStyles.fs14w400.copyWith(height: 1.7),
                            //     ),
                            //   ),
                            //   crossFadeState: faqsVisible[index] ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                            // ),
                          ],
                        ),
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
