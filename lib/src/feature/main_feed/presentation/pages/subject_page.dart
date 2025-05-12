import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:lombard/src/core/constant/generated/assets.gen.dart';
import 'package:lombard/src/core/extensions/build_context.dart';
import 'package:lombard/src/core/presentation/widgets/buttons/custom_button.dart';
import 'package:lombard/src/core/presentation/widgets/dialog/toaster.dart';
import 'package:lombard/src/core/presentation/widgets/other/custom_loading_overlay_widget.dart';
import 'package:lombard/src/core/theme/resources.dart';
import 'package:lombard/src/feature/app/router/app_router.dart';
import 'package:lombard/src/feature/main_feed/bloc/get_question_list_cubit.dart';
import 'package:lombard/src/feature/main_feed/bloc/start_quiz_cubit.dart';
import 'package:lombard/src/feature/main_feed/model/category_dto.dart';
import 'package:lombard/src/feature/main_feed/presentation/widget/choose_subject_bs.dart';

@RoutePage()
class SubjectPage extends StatefulWidget implements AutoRouteWrapper {
  final SubjectDTO? subjectDTO;
  final List<CategoryDTO>? categoryDTO;
  final int categoryIndex;
  const SubjectPage({super.key, this.subjectDTO, this.categoryDTO, required this.categoryIndex});

  @override
  State<SubjectPage> createState() => _SubjectPageState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
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
      child: this,
    );
  }
}

class _SubjectPageState extends State<SubjectPage> {
  String? categoryName;
  SubjectDTO? subject;
  @override
  void initState() {
    categoryName = widget.categoryDTO?[widget.categoryIndex].categoryName;
    subject = widget.subjectDTO;
    // log('---${widget.categoryDTO}');
    // log('---${widget.subjectDTO}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      overlayColor: AppColors.barrierColor,
      overlayWidgetBuilder: (progress) => const CustomLoadingOverlayWidget(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundInput,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [

                    Gap(16),
                    Text(
                      'Аттестацияға (ПББ) дайындық',
                      style: AppTextStyles.fs18w600,
                    ),
                  ],
                ),
                const Gap(22),
                Text(
                  'Таңдау пәніңіз',
                  style: AppTextStyles.fs20w700.copyWith(height: 1.3),
                ),
                const Gap(16),
                Container(
                  height: 0.5,
                  width: double.infinity,
                  color: AppColors.dividerGrey,
                ),
                const Gap(16),
                Row(
                  children: [

                    const Gap(10),
                    const Text(
                      'Тілі:',
                      style: AppTextStyles.fs14w500,
                    ),
                    const Gap(8),
                    const Text(
                      'Қазақша',
                      style: AppTextStyles.fs14w500,
                    ),
                  ],
                ),
                const Gap(10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Gap(10),
                    const Text(
                      'Тестілеу түрі:',
                      style: AppTextStyles.fs14w500,
                    ),
                    const Gap(8),
                    Expanded(
                      child: Text(
                        '$categoryName',
                        // '${widget.categoryDTO?[widget.categoryIndex].categoryName}',
                        // 'Колледждер (Техникалық мекемелер)',
                        style: AppTextStyles.fs14w500,
                      ),
                    ),
                  ],
                ),
                const Gap(10),
                Row(
                  children: [

                    const Gap(10),
                    const Text(
                      'Пән:',
                      style: AppTextStyles.fs14w500,
                    ),
                    const Gap(8),
                    Expanded(
                      child: Text(
                        '${subject?.name}',
                        // 'Математика',
                        style: AppTextStyles.fs14w500,
                      ),
                    ),
                  ],
                ),
                const Gap(16),
                CustomButton(
                  height: 42,
                  onPressed: () {
                    context.router.push(
                      ChangeSubjectRoute(
                        categoryDTO: widget.categoryDTO,
                        selectedSubject: (subjectDTO, title) {
                          // log('$subjectDTO ------ $title');
                          categoryName = title;
                          subject = subjectDTO;
                          setState(() {});
                        },
                      ),
                    );
                  },
                  style: CustomButtonStyles.muteBlueButtonStyle(context, padding: const EdgeInsets.all(1), radius: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      const Text('Өзгерту'),
                    ],
                  ),
                ),
                const Gap(20),
                Text(
                  'Тест бөлімі',
                  style: AppTextStyles.fs20w700.copyWith(height: 1.3),
                ),
                const Gap(11),
                BlocConsumer<StartQuizCubit, StartQuizState>(
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
                  builder: (context, state) {
                    return Stack(
                      children: [
                        Container(
                          height: 98,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.dividerGrey),
                          ),
                          margin: const EdgeInsets.only(top: 7),
                          child: Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            child: InkWell(
                              onTap: () {
                                log('$subject');
                                if (subject?.hasSections == true) {
                                  ChooseSubjectBS.show(context, subject?.sections, subject?.id);
                                } else {
                                  if (subject?.questionsCount != 0) {
                                    BlocProvider.of<StartQuizCubit>(context).startQuiz(subjectId: subject?.id ?? -1);
                                  } else {
                                    Toaster.showTopShortToast(context, message: 'Тест базасы жасалуда');
                                  }
                                }
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 14, top: 24, right: 14, bottom: 24),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Өзіңді тексер',
                                          style: AppTextStyles.fs18w600
                                              .copyWith(color: AppColors.mainBlueColor, height: 1.4),
                                        ),
                                        const Text(
                                          'Пән бойынша тесттер',
                                          style: AppTextStyles.fs14w500,
                                          // style: AppTextStyles.fs14w500.copyWith(height: 1.7),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 16,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: AppColors.green,
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 20),
                            child: Text(
                              'Тегін',
                              style: AppTextStyles.fs14w600.copyWith(
                                fontFamily: 'Inter',
                                height: 1.3,
                                color: AppColors.white,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
