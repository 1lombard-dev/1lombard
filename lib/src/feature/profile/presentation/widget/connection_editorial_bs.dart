import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:lombard/src/core/constant/generated/assets.gen.dart';
import 'package:lombard/src/core/presentation/widgets/shimmer/shimmer_box.dart';
import 'package:lombard/src/core/theme/resources.dart';
import 'package:lombard/src/core/utils/layout/url_util.dart';
import 'package:lombard/src/feature/profile/bloc/social_media_cubit.dart';
import 'package:lombard/src/feature/profile/bloc/working_hour_cubit.dart';
import 'package:lombard/src/feature/profile/presentation/widget/about_us_item.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ConnectionEditorialBS extends StatefulWidget {
  const ConnectionEditorialBS({super.key});

  @override
  _ConnectionEditorialBSState createState() => _ConnectionEditorialBSState();

  static Future<String?> show(
    BuildContext context,
  ) =>
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useRootNavigator: true,
        builder: (context) => const ConnectionEditorialBS(),
      );
}

class _ConnectionEditorialBSState extends State<ConnectionEditorialBS> {
  MaskTextInputFormatter maskPhoneFormatter = MaskTextInputFormatter(
    mask: '+###########',
    filter: {"#": RegExp('[0-9]')},
  );

  @override
  void initState() {
    BlocProvider.of<SocialMediaCubit>(context).getSocialMediaList();
    BlocProvider.of<WorkingHourCubit>(context).getWorkingHour();

    super.initState();
  }

  @override
  Widget build(BuildContext context) => DraggableScrollableSheet(
        expand: false,
        maxChildSize: 0.5,
        initialChildSize: 0.45,
        minChildSize: 0.4,
        builder: (context, scrollController) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BlocConsumer<SocialMediaCubit, SocialMediaState>(
                listener: (context, state) {
                  state.maybeWhen(
                    orElse: () {},
                    loaded: (socialMediaList) {},
                  );
                },
                builder: (context, state) {
                  return state.maybeWhen(
                    orElse: () {
                      return Column(
                        children: [
                          const CustomDragHandle(),
                          const Gap(5),
                          Row(
                            children: [
                              const Gap(26),
                              const Expanded(
                                child: Center(
                                  child: Text(
                                    'Редакциямен байланыс',
                                    style: AppTextStyles.fs16w700,
                                  ),
                                ),
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
                          SizedBox(
                            height: 224,
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 3,
                              itemBuilder: (context, index) {
                                return const Padding(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: ShimmerBox(
                                    height: 68,
                                    width: double.infinity,
                                  ),
                                );
                              },
                            ),
                          ),
                          const Gap(12),
                        ],
                      );
                    },
                    loaded: (socialMediaList) {
                      return Column(
                        children: [
                          const CustomDragHandle(),
                          const Gap(5),
                          Row(
                            children: [
                              const Gap(26),
                              const Expanded(
                                child: Center(
                                  child: Text(
                                    'Редакциямен байланыс',
                                    style: AppTextStyles.fs16w700,
                                  ),
                                ),
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
                          SizedBox(
                            height: 224,
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: socialMediaList.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  // child: AboutUsItem(
                                  //   title: socialMediaList[index].platform == 'instagram'
                                  //       ? 'Instagram-ға жазу'
                                  //       : socialMediaList[index].platform == 'whatsapp'
                                  //           ? 'WhatsApp-қа жазу'
                                  //           : 'Қоңырау шалу',
                                  //   icon: socialMediaList[index].platform == 'instagram'
                                  //       ? Assets.icons.skillIconsInstagram.path
                                  //       : socialMediaList[index].platform == 'whatsapp'
                                  //           ? Assets.icons.whatsapp.path
                                  //           : Assets.icons.fluentCall28Filled.path,
                                  //   subtitle: socialMediaList[index].url ?? '',
                                  //   onTap: () {
                                  //     maskPhoneFormatter = MaskTextInputFormatter(
                                  //       mask: '+###########',
                                  //       filter: {"#": RegExp('[0-9]')},
                                  //       initialText: socialMediaList[index].url,
                                  //     );
                                  //     // log('${socialMediaList[index].url}');
                                  //     // log(maskPhoneFormatter.getMaskedText());
                                  //     socialMediaList[index].platform == 'instagram'
                                  //         ? UrlUtil.openInstagram('@ustaz.tilegi')
                                  //         : socialMediaList[index].platform == 'whatsapp'
                                  //             ? UrlUtil.launchWhatsappUrl(
                                  //                 context,
                                  //                 phone: maskPhoneFormatter.getMaskedText(),
                                  //                 // phone: '+77712345599',
                                  //               )
                                  //             : UrlUtil.launchPhoneUrl(
                                  //                 context,
                                  //                 phone: '${socialMediaList[index].url}',
                                  //               );
                                  //   },
                                  // ),
                                );
                              },
                            ),
                          ),
                          const Gap(12),
                        ],
                      );
                    },
                  );
                },
              ),
              BlocBuilder<WorkingHourCubit, WorkingHourState>(
                builder: (context, state) {
                  return state.maybeWhen(
                    orElse: () {
                      return Column(
                        children: [
                          Center(
                            child: Text(
                              'Жұмыс кестесі:',
                              style: AppTextStyles.fs14w500.copyWith(height: 1.7),
                            ),
                          ),
                          const ShimmerBox(
                            height: 22,
                            width: 200,
                          ),
                          const Gap(20),
                        ],
                      );
                    },
                    loaded: (workingHourList) {
                      return Column(
                        children: [
                          Center(
                            child: Text(
                              'Жұмыс кестесі:',
                              style: AppTextStyles.fs14w500.copyWith(height: 1.7),
                            ),
                          ),
                          Center(
                            child: Text(
                              '${workingHourList[0].dayFrom} - ${workingHourList[0].dayTo}, ${formatTime('${workingHourList[0].timeFrom}')}-${formatTime('${workingHourList[0].timeTo}')}',
                              // 'Дүйсенбі - Жұма, 10:00-18:00',
                              style: AppTextStyles.fs14w400.copyWith(height: 1.7),
                            ),
                          ),
                          // const Gap(20),
                        ],
                      );
                    },
                  );
                },
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

String formatTime(String time) {
  // Split the time string by ":"
  final List<String> parts = time.split(':');

  // Check if the input is in the expected format
  if (parts.length < 2) {
    throw ArgumentError('Invalid time format. Expected "HH:mm:ss".');
  }

  // Return the first two parts (hours and minutes) joined by ":"
  return '${parts[0]}:${parts[1]}';
}
