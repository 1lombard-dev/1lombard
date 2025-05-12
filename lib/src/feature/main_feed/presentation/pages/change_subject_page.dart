import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:lombard/src/core/constant/generated/assets.gen.dart';
import 'package:lombard/src/core/theme/resources.dart';
import 'package:lombard/src/feature/main_feed/model/category_dto.dart';
import 'package:lombard/src/feature/main_feed/presentation/widget/subject_item.dart';

@RoutePage()
class ChangeSubjectPage extends StatefulWidget {
  const ChangeSubjectPage({super.key, this.categoryDTO, this.selectedSubject});

  final List<CategoryDTO>? categoryDTO;
  final Function(SubjectDTO subject, String categoryName)? selectedSubject;

  @override
  State<ChangeSubjectPage> createState() => _ChangeSubjectPageState();
}

class _ChangeSubjectPageState extends State<ChangeSubjectPage> {
  @override
  void initState() {
    // log('---${widget.categoryDTO}');
    // log('---${widget.subjectDTO}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kF5F6F8,
      appBar: AppBar(
        title: const Text(
          'Пәнді өзгерту',
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Өз пәніңізді таңдаңыз',
                style: AppTextStyles.fs18w600.copyWith(height: 1.4),
              ),
              const Gap(10),
              ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.categoryDTO?.length,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.categoryDTO![index].subjects!.isNotEmpty &&
                          widget.categoryDTO?[index].subjects != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10, top: 6),
                          child: Text(
                            '${widget.categoryDTO?[index].categoryName}',
                            style: AppTextStyles.fs14w500,
                          ),
                        ),
                      if (widget.categoryDTO![index].subjects!.isNotEmpty &&
                          widget.categoryDTO?[index].subjects != null)
                        ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: widget.categoryDTO?[index].subjects?.length,
                          itemBuilder: (context, indexTwo) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: SubjectItem(
                                testQuantity: '${widget.categoryDTO?[index].subjects?[indexTwo].questionsCount} тест',
                                title: '${widget.categoryDTO?[index].subjects?[indexTwo].name}',
                                onTap: () {
                                  // log('--------${widget.categoryDTO?[index].subjects?[indexTwo].name}');
                                  widget.selectedSubject?.call(
                                    widget.categoryDTO?[index].subjects?[indexTwo] ?? const SubjectDTO(),
                                    widget.categoryDTO?[index].categoryName ?? '',
                                  );
                                  context.router.maybePop();
                                },
                              ),
                            );
                          },
                        ),
                    ],
                  );
                },
              ),
              const Gap(14),

              const Gap(12),
              Center(
                child: Text(
                  'Басқа пәндер жақын арада қосылады',
                  style: AppTextStyles.fs14w600.copyWith(height: 1.7, color: AppColors.green2),
                ),
              ),
              const Gap(4),
              Center(
                child: Text(
                  'Еліміздің үздік тренерлері тесттерді дайындау үстінде...',
                  style: AppTextStyles.fs12w400.copyWith(height: 1.6, color: AppColors.darkBlueText),
                ),
              ),
              const Gap(50),
            ],
          ),
        ),
      ),
    );
  }
}
