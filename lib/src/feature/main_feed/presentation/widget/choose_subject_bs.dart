import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:lombard/src/core/constant/generated/assets.gen.dart';
import 'package:lombard/src/core/extensions/build_context.dart';
import 'package:lombard/src/core/presentation/widgets/dialog/toaster.dart';
import 'package:lombard/src/core/presentation/widgets/other/custom_loading_overlay_widget.dart';
import 'package:lombard/src/core/theme/resources.dart';
import 'package:lombard/src/feature/app/router/app_router.dart';
import 'package:lombard/src/feature/main_feed/bloc/get_question_list_cubit.dart';
import 'package:lombard/src/feature/main_feed/bloc/start_quiz_cubit.dart';
import 'package:lombard/src/feature/main_feed/model/category_dto.dart';
import 'package:lombard/src/feature/main_feed/presentation/widget/banner_bs.dart';

class ChooseSubjectBS extends StatefulWidget {
  const ChooseSubjectBS({
    super.key,
    this.subjects,
    required this.subjectId,
  });
  final List<SectionDTO>? subjects;
  final int subjectId;

  @override
  _ChooseSubjectBSState createState() => _ChooseSubjectBSState();

  static Future<String?> show(
    BuildContext context,
    List<SectionDTO>? subject,
    int? subjectId,
  ) =>
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useRootNavigator: true,
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => StartQuizCubit(
                repository: context.repository.mainRepository,
              ),
            ),
            BlocProvider(
              create: (context) => GetQuestionListCubit(
                repository: context.repository.mainRepository,
              ),
            ),
          ],
          child: ChooseSubjectBS(subjects: subject, subjectId: subjectId ?? -1),
        ),
      );
}

class _ChooseSubjectBSState extends State<ChooseSubjectBS> {
  int subjectId = -1;

  @override
  void initState() {
    // BlocProvider.of<GetQuestionListCubit>(context).getQuestionList(testId: subjectId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => LoaderOverlay(
        overlayColor: AppColors.barrierColor,
        overlayWidgetBuilder: (progress) => const CustomLoadingOverlayWidget(),
        child: DraggableScrollableSheet(
          expand: false,
          maxChildSize: 0.9,
          initialChildSize: 0.4,
          minChildSize: 0.1,
          builder: (context, scrollController) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CustomDragHandle(),
                const Gap(5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Өзіңді тексер',
                      style: AppTextStyles.fs18w600,
                    ),
                    GestureDetector(
                      onTap: () {
                        context.router.maybePop();
                      },
                      child: SvgPicture.asset(Assets.icons.close.path),
                    ),
                  ],
                ),
                const Gap(16),
                BlocListener<StartQuizCubit, StartQuizState>(
                  listener: (context, state) {
                    state.maybeWhen(
                      orElse: () => context.loaderOverlay.hide(),
                      // loading: () => context.loaderOverlay.show(),
                      error: (message) {
                        context.loaderOverlay.hide();
                        Toaster.showErrorTopShortToast(context, message);
                      },
                      loaded: (response) {
                        context.loaderOverlay.hide();
                      },
                    );
                  },
                  child: Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: widget.subjects?.length,
                      itemBuilder: (context, index) {
                        return Container(
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppColors.muteBlue2,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.only(top: 7),
                          child: Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            child: InkWell(
                              onTap: () {
                                // log('${widget.subjects?[index].id}');
                                BlocProvider.of<StartQuizCubit>(context).startQuiz(
                                  sectionId: widget.subjects?[index].id ?? -1,
                                  subjectId: widget.subjectId,
                                );
                                // context.router.push(const TestMainRoute());
                                // Toaster.showTopShortToast(context, message: 'Тест базасы жасалуда');
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 14, top: 24, right: 14, bottom: 24),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${widget.subjects?[index].name}',
                                      style: AppTextStyles.fs18w400.copyWith(
                                        color: AppColors.mainBlueColor,
                                        height: 1.4,
                                        fontStyle: FontStyle.italic,
                                        fontFamily: 'Inter',
                                        letterSpacing: 0.1,
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
