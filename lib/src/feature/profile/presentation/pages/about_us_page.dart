// ignore_for_file: deprecated_member_use

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:lombard/src/core/constant/constants.dart';
import 'package:lombard/src/core/constant/generated/assets.gen.dart';
import 'package:lombard/src/core/presentation/widgets/dialog/toaster.dart';
import 'package:lombard/src/core/presentation/widgets/other/custom_loading_overlay_widget.dart';
import 'package:lombard/src/core/presentation/widgets/shimmer/shimmer_box.dart';
import 'package:lombard/src/core/theme/resources.dart';
import 'package:lombard/src/core/utils/extensions/context_extension.dart';
import 'package:lombard/src/feature/app/bloc/app_bloc.dart';
import 'package:lombard/src/feature/app/router/app_router.dart';
import 'package:lombard/src/feature/initialization/model/environment.dart';
import 'package:lombard/src/feature/profile/bloc/about_us_cubit.dart';
import 'package:lombard/src/feature/profile/bloc/document_cubit.dart';
import 'package:lombard/src/feature/profile/bloc/profile_bloc.dart';
import 'package:lombard/src/feature/profile/bloc/social_media_cubit.dart';
import 'package:lombard/src/feature/profile/bloc/working_hour_cubit.dart';
import 'package:lombard/src/feature/profile/presentation/widget/about_us_under_item.dart';
import 'package:lombard/src/feature/profile/presentation/widget/connection_editorial_bs.dart';
import 'package:url_launcher/url_launcher.dart';

@RoutePage()
class AboutUsPage extends StatefulWidget implements AutoRouteWrapper {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AboutUsCubit(
            repository: context.repository.profileRepository,
          ),
        ),
        BlocProvider(
          create: (context) => DocumentCubit(
            repository: context.repository.profileRepository,
          ),
        ),
      ],
      child: this,
    );
  }
}

class _AboutUsPageState extends State<AboutUsPage> {
  @override
  void initState() {
    BlocProvider.of<AboutUsCubit>(context).getAboutUsData();
    BlocProvider.of<SocialMediaCubit>(context).getSocialMediaList();
    BlocProvider.of<WorkingHourCubit>(context).getWorkingHour();
    BlocProvider.of<DocumentCubit>(context).getDocument();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      overlayWidgetBuilder: (progress) => const CustomLoadingOverlayWidget(),
      overlayColor: AppColors.barrierColor,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          title: const Text(
            'Орталық жайлы',
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
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///
                /// avatar, organization, info to client
                ///
                BlocBuilder<AboutUsCubit, AboutUsState>(
                  builder: (context, state) {
                    return state.maybeWhen(
                      orElse: () => const Column(
                        children: [
                          Gap(18),
                          ShimmerBox(
                            height: 112,
                            width: double.infinity,
                          ),
                          Gap(16),
                          ShimmerBox(
                            height: 328,
                            width: double.infinity,
                          ),
                          Gap(59),
                        ],
                      ),
                      loaded: (aboutUsDTO) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Gap(18),
                            Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 80, top: 6),
                                  child: Container(
                                    // width: 263,
                                    height: 106,
                                    decoration: const BoxDecoration(
                                      color: AppColors.mutePurple,
                                      borderRadius: BorderRadius.all(Radius.circular(16)),
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top: 10, left: 20, right: 42),
                                          child: Text(
                                            aboutUsDTO[0].author ?? '',
                                            style: AppTextStyles.fs14w600.copyWith(height: 1.7),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 10, left: 20),
                                          child: Text(
                                            aboutUsDTO[0].authorPosition ?? '',
                                            style: AppTextStyles.fs12w400.copyWith(
                                              color: AppColors.darkBlueText,
                                              letterSpacing: 0.01,
                                              height: 1.5,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    // border: Border.all(color: AppColors.mutePurple2, width: 6),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 5.6,
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(Radius.circular(100)),
                                    child: Image.network(
                                      // 'http://194.32.140.48/storage/users/4/avatar/kvoU6qsF7lB26YtNRz521cus42VgNugYt5csaRrL.jpg',
                                      aboutUsDTO[0].authorimage != null
                                          ? '$kBaseUrlImages/${aboutUsDTO[0].authorimage}'
                                          : NOT_FOUND_IMAGE,
                                      fit: BoxFit.cover,
                                      height: 100,
                                      width: 100,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // TODO: тут должна быть кривая фигура
                            // ClipPath(
                            //   clipper: MyCustomClipper(),
                            //   child: Container(
                            //     alignment: Alignment.center,
                            //     color: AppColors.mutePurple,
                            //     width: 263,
                            //     height: 106,
                            //     child: const Text("Dummy Text"),
                            //   ),
                            // ),
                            // Image.asset(
                            //   Assets.images.aboutUsImage.path,
                            //   // height: 112,
                            //   // fit: BoxFit.cover,
                            // ),
                            const Gap(16),
                            Container(
                              padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20, right: 17),
                              decoration: BoxDecoration(
                                color: AppColors.greyTextField,
                                border: Border.all(color: AppColors.lineGray),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Gap(12),
                                  Expanded(
                                    child: Text(
                                      """
      Құрметті әріптестер! Еліміздің болашағы өскелең ұрпағымыздың еншісінде. Болашағымыз жарқын болуы үшін елімізді көркейтетін, туымызды көкке көтеретін жас ұрпақтың бойына қазақи құндылығымызды дарыта отырып, заман талабына сай білім беру сіз бен біздің қолымызда. 
      Дарынды, талапты және еңбекқор  педагогтер – заманауи Қазақстанның жарқын келбеті. Олай болса сіздерді дамушы ортамен тәжірибе алмасу алаңына шақырамын.""",
                                      style: AppTextStyles.fs14w400.copyWith(height: 1.7, letterSpacing: 0.5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Gap(59),
                          ],
                        );
                      },
                    );
                  },
                ),

                ///
                /// social media, contact
                ///
                BlocBuilder<SocialMediaCubit, SocialMediaState>(
                  builder: (context, state) {
                    return state.maybeWhen(
                      orElse: () => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Редакциямен байланыс',
                            style: AppTextStyles.fs18w600,
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
                          const Gap(14),
                        ],
                      ),
                      loaded: (socialMediaList) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Редакциямен байланыс',
                              style: AppTextStyles.fs18w600,
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
                                    //   // icon: socialMediaList[index].platform == 'instagram'
                                    //   //     ? Assets.icons.backButton
                                    //   //     : socialMediaList[index].platform == 'whatsapp'
                                    //   //         ? Assets.icons.circle
                                    //   //         : Assets.icons.closeCircle,
                                    //   subtitle: socialMediaList[index].url ?? '',
                                    //   onTap: () {
                                    //     socialMediaList[index].platform == 'instagram'
                                    //         ? UrlUtil.openInstagram('@ustaz.tilegi')
                                    //         : socialMediaList[index].platform == 'whatsapp'
                                    //             ? UrlUtil.launchWhatsappUrl(context, phone: '+77712355599')
                                    //             : UrlUtil.launchPhoneUrl(
                                    //                 context,
                                    //                 phone: '+77478904540',
                                    //               );
                                    //   },
                                    // ),
                                  );
                                },
                              ),
                            ),
                            const Gap(14),
                          ],
                        );
                      },
                    );
                  },
                ),

                ///
                /// working day and hour
                ///
                BlocBuilder<WorkingHourCubit, WorkingHourState>(
                  builder: (context, state) {
                    return state.maybeWhen(
                      orElse: () => Column(
                        children: [
                          Center(
                            child: Text(
                              'Жұмыс кестесі:',
                              style: AppTextStyles.fs14w500.copyWith(height: 1.7),
                            ),
                          ),
                          const Center(
                            child: ShimmerBox(
                              height: 22,
                              width: 200,
                            ),
                          ),
                          const Gap(20),
                        ],
                      ),
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
                            const Gap(20),
                          ],
                        );
                      },
                    );
                  },
                ),

                ///
                /// documents
                ///
                BlocBuilder<DocumentCubit, DocumentState>(
                  builder: (context, state) {
                    return state.maybeWhen(
                      orElse: () => const Column(
                        children: [
                          ShimmerBox(
                            height: 50,
                            width: double.infinity,
                          ),
                          Gap(10),
                          ShimmerBox(
                            height: 50,
                            width: double.infinity,
                          ),
                          Gap(10),
                          ShimmerBox(
                            height: 50,
                            width: double.infinity,
                          ),
                          Gap(30),
                        ],
                      ),
                      loaded: (documentList) {
                        return Column(
                          children: [
                            AboutUsUnderItem(
                              title: documentList[0].name ?? '',
                              onTap: () {
                                launch('$kBaseUrlImages/${documentList[0].url}');
                                // launchUrl(Uri(path: '$kBaseUrlImages/${documentList[0].url}'));
                              },
                            ),
                            const Gap(10),
                            AboutUsUnderItem(
                              title: documentList[1].name ?? '',
                              onTap: () {
                                launch('$kBaseUrlImages/${documentList[1].url}');
                              },
                            ),
                            const Gap(10),
                          ],
                        );
                      },
                    );
                  },
                ),

                ///
                /// documents
                ///
                BlocConsumer<ProfileBLoC, ProfileState>(
                  listener: (context, state) {
                    state.maybeWhen(
                      error: (message) {
                        context.loaderOverlay.hide();
                        Toaster.showErrorTopShortToast(context, message);
                      },
                      loading: () {
                        context.loaderOverlay.show();
                        Future<void>.delayed(
                          const Duration(milliseconds: 300),
                        );
                      },
                      exited: (message) {
                        Toaster.showTopShortToast(context, message: message);
                        context.router.popUntil((route) => route.settings.name == LauncherRoute.name);
                        BlocProvider.of<AppBloc>(context).add(const AppEvent.exiting());
                      },
                      orElse: () {
                        context.loaderOverlay.hide();
                      },
                    );
                  },
                  builder: (context, state) {
                    return state.maybeWhen(
                      orElse: () => const Column(
                        children: [
                          ShimmerBox(
                            height: 50,
                            width: double.infinity,
                          ),
                          Gap(30),
                        ],
                      ),
                      loaded: (documentList) {
                        return Column(
                          children: [
                            AboutUsUnderItem(
                              title: 'Кабинетті жою',
                              onTap: () {
                                _deleteAccountAlertDialog(
                                  context,
                                  onYesTap: () {
                                    BlocProvider.of<ProfileBLoC>(context).add(
                                      const ProfileEvent.deleteAccount(),
                                    );
                                    // BlocProvider.of<AppBloc>(context).add(const AppEvent.exiting());
                                    context.router.maybePop();
                                  },
                                );
                              },
                            ),
                            const Gap(30),
                          ],
                        );
                      },
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

// class MyCustomClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     const double radius = 50;
//     final path = Path()
//       ..lineTo(0, 0)
//       ..lineTo(size.width * 0.9, size.height - radius)
//       ..lineTo(size.width, size.height * 0.9)
//       ..lineTo(size.width * 0.2, size.height * 0.9)
//       ..close();
//     return path;
//   }
//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) {
//     return false;
//   }
// }

void _deleteAccountAlertDialog(
  BuildContext context, {
  Function()? onYesTap,
}) {
  showCupertinoDialog<void>(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      content: Column(
        children: [
          Text(
            'Жеке кабинетті жоюға сенімдісіз бе?',
            style: AppTextStyles.fs16w500.copyWith(height: 1.5),
          ),
          const Gap(2),
          Text(
            'Кабинетті жою арқылы сіздің Ustaz tilegi сайтындағы және приложениедегі барлық ақпараттарыңыз өшіп кетеді',
            style: AppTextStyles.fs12w400.copyWith(height: 1.5),
          ),
        ],
      ),
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
          onPressed: onYesTap,
          child: Text(
            'Өшіру',
            style: AppTextStyles.fs17w400.copyWith(color: AppColors.red),
            textAlign: TextAlign.center,
          ),
        ),
        CupertinoDialogAction(
          onPressed: () {
            context.router.maybePop();
          },
          child: Text(
            'Сақтау',
            style: AppTextStyles.fs16w500.copyWith(color: AppColors.mainBlueColor),
          ),
        ),
      ],
    ),
  );
}
