import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:lombard/src/core/constant/generated/assets.gen.dart';
import 'package:lombard/src/core/presentation/widgets/buttons/custom_button.dart';
import 'package:lombard/src/core/theme/resources.dart';
import 'package:lombard/src/feature/main_feed/model/main_page_dto.dart';

//FIXME: add banners api

class BannerBS extends StatefulWidget {
  const BannerBS({super.key, required this.bannerDTO});
  final List<BannerDTO> bannerDTO;

  @override
  _BannerBSState createState() => _BannerBSState();

  static Future<String?> show(
    BuildContext context,
    List<BannerDTO> bannerDTO,
  ) =>
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useRootNavigator: true,
        builder: (context) => BannerBS(bannerDTO: bannerDTO),
      );
}

class _BannerBSState extends State<BannerBS> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => DraggableScrollableSheet(
        expand: false,
        maxChildSize: 0.9,
        initialChildSize: 0.55,
        minChildSize: 0.5,
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
                    'Приложение мүмкіндіктері',
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
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: const BoxDecoration(
                  color: AppColors.muteBlue,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: RichText(
                  text: TextSpan(
                    text: 'Аттестацияға дайындық тесттерін ',
                    style: AppTextStyles.fs14w500.copyWith(
                      color: AppColors.darkBlueText,
                      letterSpacing: -0.32,
                    ),
                    children: [
                      TextSpan(
                        text: 'тегін',
                        style: AppTextStyles.fs14w700.copyWith(
                          color: AppColors.darkBlueText,
                          letterSpacing: -0.32,
                        ),
                      ),
                      TextSpan(
                        text: ' тапсыра аласыз',
                        style: AppTextStyles.fs14w500.copyWith(
                          color: AppColors.darkBlueText,
                          letterSpacing: -0.32,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: const BoxDecoration(
                  color: AppColors.muteBlue,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: RichText(
                  text: TextSpan(
                    text: 'Өткен жылы осы тесттермен дайындалған',
                    style: AppTextStyles.fs14w500.copyWith(
                      color: AppColors.darkBlueText,
                      letterSpacing: -0.32,
                    ),
                    children: [
                      TextSpan(
                        text: ' педагогтар 50/50 жинап рекорд жасады',
                        style: AppTextStyles.fs14w700.copyWith(
                          color: AppColors.darkBlueText,
                          letterSpacing: -0.32,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: const BoxDecoration(
                  color: AppColors.muteBlue,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: RichText(
                  text: TextSpan(
                    text: 'Тест сұрақтары министірлік бекіткен тақырыптар бойынша ',
                    style: AppTextStyles.fs14w500.copyWith(
                      color: AppColors.darkBlueText,
                      letterSpacing: -0.32,
                    ),
                    children: [
                      TextSpan(
                        text: 'үздік тренерлер жасаған',
                        style: AppTextStyles.fs14w700.copyWith(
                          color: AppColors.darkBlueText,
                          letterSpacing: -0.32,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: const BoxDecoration(
                  color: AppColors.muteBlue,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: RichText(
                  text: TextSpan(
                    text: 'Приложениеге тіркелу арқылы ',
                    style: AppTextStyles.fs14w500.copyWith(
                      color: AppColors.darkBlueText,
                      letterSpacing: -0.32,
                    ),
                    children: [
                      TextSpan(
                        text: 'Ustaz tilegi сайтымен байланыс орнатып, ',
                        style: AppTextStyles.fs14w700.copyWith(
                          color: AppColors.darkBlueText,
                          letterSpacing: -0.32,
                        ),
                      ),
                      TextSpan(
                        text: 'сайттағы барлық іс әрекеттерден хабардар бола аласыз',
                        style: AppTextStyles.fs14w500.copyWith(
                          color: AppColors.darkBlueText,
                          letterSpacing: -0.32,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ListView.builder(
              //   itemCount: 4,
              //   shrinkWrap: true,
              //   padding: EdgeInsets.zero,
              //   physics: const NeverScrollableScrollPhysics(),
              //   itemBuilder: (context, index) {
              //     return Container(
              //       width: double.infinity,
              //       margin: const EdgeInsets.only(bottom: 8),
              //       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              //       decoration: const BoxDecoration(
              //         color: AppColors.muteBlue,
              //         borderRadius: BorderRadius.all(Radius.circular(12)),
              //       ),
              //       child: Text(
              //         items[index],
              //         style: AppTextStyles.fs14w500.copyWith(
              //           color: AppColors.darkBlueText,
              //           letterSpacing: -0.32,
              //         ),
              //       ),
              //     );
              //   },
              // ),
              const Gap(8),
              CustomButton(
                onPressed: () {
                  context.router.maybePop();
                },
                style: CustomButtonStyles.mainButtonStyle(context),
                child: const Text(
                  'Түсінікті',
                  style: AppTextStyles.fs16w600,
                ),
              ),
            ],
          ),
        ),
      );
}

class CustomDragHandle extends StatelessWidget {
  const CustomDragHandle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        height: 5,
        width: 36,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: Color(0xffCCCCCC),
        ),
      ),
    );
  }
}
