// import 'dart:developer';

// import 'package:auto_route/auto_route.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_html/flutter_html.dart';
// import 'package:gap/gap.dart';
// import 'package:intl/intl.dart';
// import 'package:lombard/src/core/theme/resources.dart';
// import 'package:lombard/src/core/utils/extensions/context_extension.dart';
// import 'package:lombard/src/core/utils/extensions/datetime_extension.dart';
// import 'package:lombard/src/core/utils/extensions/string_extension.dart';
// import 'package:lombard/src/feature/calculation/bloc/read_notification_cubit.dart';
// import 'package:lombard/src/feature/calculation/model/message_dto.dart';
// import 'package:lombard/src/feature/calculation/model/notification_dto.dart';
// import 'package:lombard/src/feature/calculation/presentation/notification_page.dart';
// import 'package:url_launcher/url_launcher.dart';

// @RoutePage()
// class NotificationDetailPage extends StatefulWidget implements AutoRouteWrapper {
//   final String title;
//   final NotificationDTO notificationDTO;
//   const NotificationDetailPage({super.key, required this.title, required this.notificationDTO});

//   @override
//   State<NotificationDetailPage> createState() => _NotificationDetailPageState();

//   @override
//   Widget wrappedRoute(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(
//           create: (context) => ReadNotificationCubit(repository: context.repository.notificationRepository),
//           child: this,
//         ),
//       ],
//       child: this,
//     );
//   }
// }

// class _NotificationDetailPageState extends State<NotificationDetailPage> {
//   List<MessageDTO> messageDTO = [];

//   @override
//   void initState() {
//     BlocProvider.of<ReadNotificationCubit>(context).readNotification(id: widget.notificationDTO.id ?? -1);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           widget.title,
//           style: AppTextStyles.fs18w600,
//         ),
//         shape: const Border(
//           bottom: BorderSide(
//             color: AppColors.dividerGrey,
//             width: 0.5,
//           ),
//         ),
//       ),
//       body: Container(
//         decoration: BoxDecoration(

//         ),
//         width: double.infinity,
//         child: Padding(
//           padding: const EdgeInsets.only(left: 16, right: 16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               Center(
//                 child: Text(
//                   DateFormat('dd.MM.yyyy')
//                       .format(widget.notificationDTO.createdAt ?? DateTime.now())
//                       .monthToUpperCase(),
//                   style: AppTextStyles.fs14w400.copyWith(height: 1.7, color: AppColors.grayText),
//                 ),
//               ),
//               const Gap(26),
//               // Padding(
//               //   padding: const EdgeInsets.only(right: 58),
//               //   child: Stack(
//               //     children: [
//               //       Container(
//               //         padding: const EdgeInsets.all(14),
//               //         decoration: const BoxDecoration(
//               //           color: AppColors.chatMessageBox,
//               //           borderRadius: BorderRadius.only(
//               //             topLeft: Radius.circular(12),
//               //             topRight: Radius.circular(12),
//               //             bottomRight: Radius.circular(12),
//               //           ),
//               //         ),
//               //         child: Column(
//               //           crossAxisAlignment: CrossAxisAlignment.start,
//               //           children: [
//               //             Text(
//               //               'Сәуір айының Республикалық олимпиадасы басталады.',
//               //               style: AppTextStyles.fs14w400.copyWith(letterSpacing: -0.1, height: 1.7),
//               //             ),
//               //           ],
//               //         ),
//               //       ),
//               //       Positioned(
//               //         bottom: 8,
//               //         right: 8,
//               //         child: Text('11:25', style: AppTextStyles.fs12w400.copyWith(letterSpacing: 0.1)),
//               //       ),
//               //     ],
//               //   ),
//               // ),
//               // const Gap(16),
//               // Padding(
//               //   padding: const EdgeInsets.only(right: 58),
//               //   child: Stack(
//               //     children: [
//               //       Container(
//               //         padding: const EdgeInsets.all(14),
//               //         decoration: const BoxDecoration(
//               //           color: AppColors.chatMessageBox,
//               //           borderRadius: BorderRadius.only(
//               //             topLeft: Radius.circular(12),
//               //             topRight: Radius.circular(12),
//               //             bottomRight: Radius.circular(12),
//               //           ),
//               //         ),
//               //         child: Column(
//               //           crossAxisAlignment: CrossAxisAlignment.start,
//               //           children: [
//               //             Text(
//               //               'Олимпиада басталмас бұрын, дайындық тесттерін тапсыру сенбі күні болады.',
//               //               style: AppTextStyles.fs14w400.copyWith(letterSpacing: -0.1, height: 1.7),
//               //             ),
//               //           ],
//               //         ),
//               //       ),
//               //       Positioned(
//               //         bottom: 8,
//               //         right: 8,
//               //         child: Text('11:25', style: AppTextStyles.fs12w400.copyWith(letterSpacing: 0.1)),
//               //       ),
//               //     ],
//               //   ),
//               // ),
//               // const Gap(30),
//               // Text(
//               //   'Бүгін',
//               //   style: AppTextStyles.fs14w400.copyWith(height: 1.7, color: AppColors.grayText),
//               // ),
//               // const Gap(26),
//               // Padding(
//               //   padding: const EdgeInsets.only(right: 58),
//               //   child: Stack(
//               //     children: [
//               //       Container(
//               //         padding: const EdgeInsets.all(14),
//               //         decoration: const BoxDecoration(
//               //           color: AppColors.chatMessageBox,
//               //           borderRadius: BorderRadius.only(
//               //             topLeft: Radius.circular(12),
//               //             topRight: Radius.circular(12),
//               //             bottomRight: Radius.circular(12),
//               //           ),
//               //         ),
//               //         child: Column(
//               //           crossAxisAlignment: CrossAxisAlignment.start,
//               //           children: [
//               //             Text(
//               //               'Сәуір айының Республикалық олимпиадасы басталады.',
//               //               style: AppTextStyles.fs14w400.copyWith(letterSpacing: -0.1, height: 1.7),
//               //             ),
//               //           ],
//               //         ),
//               //       ),
//               //       Positioned(
//               //         bottom: 8,
//               //         right: 8,
//               //         child: Text('11:25', style: AppTextStyles.fs12w400.copyWith(letterSpacing: 0.1)),
//               //       ),
//               //     ],
//               //   ),
//               // ),
//               // const Gap(16),
//               Padding(
//                 padding: const EdgeInsets.only(right: 58),
//                 child: Stack(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(14),
//                       decoration: const BoxDecoration(
//                         color: AppColors.chatMessageBox,
//                         borderRadius: BorderRadius.only(
//                           topLeft: Radius.circular(12),
//                           topRight: Radius.circular(12),
//                           bottomRight: Radius.circular(12),
//                         ),
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           if (widget.notificationDTO.photo != null && widget.notificationDTO.photo != '')
//                             Container(
//                               decoration: BoxDecoration(
//                                 border: Border.all(color: AppColors.darkBlueText),
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: ClipRRect(
//                                 borderRadius: const BorderRadius.all(Radius.circular(12)),
//                                 child: CachedNetworkImage(
//                                   imageUrl: '${widget.notificationDTO.photo}',
//                                 ),
//                               ),
//                             ),
//                           Html(
//                             data: widget.notificationDTO.message,
//                             style: {
//                               "h2": Style(fontSize: FontSize(14), fontWeight: FontWeight.w600),
//                               "h3": Style(fontSize: FontSize(14.0), fontWeight: FontWeight.w400),
//                               "strong": Style(fontWeight: FontWeight.w600),
//                               "p": Style(fontSize: FontSize(14.0), fontWeight: FontWeight.w400),
//                               "i": Style(
//                                 // fontFamily: 'Inter',
//                                 fontWeight: FontWeight.w300,
//                                 fontSize: FontSize(14.0),
//                                 // letterSpacing: 0.01,
//                               ),
//                             },
//                           ),
//                           // Text(
//                           //   '${widget.notificationDTO.message}',
//                           //   style: AppTextStyles.fs14w400.copyWith(height: 1.7, letterSpacing: -0.1),
//                           // ),
//                           const Gap(10),
//                           if (widget.notificationDTO.hasButton == true)
//                             Container(
//                               width: 88,
//                               height: 30,
//                               decoration: const BoxDecoration(
//                                 color: AppColors.mainBlueColor,
//                                 borderRadius: BorderRadius.all(Radius.circular(12)),
//                               ),
//                               child: Material(
//                                 borderRadius: BorderRadius.circular(
//                                   12,
//                                 ),
//                                 color: Colors.transparent,
//                                 child: InkWell(
//                                   borderRadius: BorderRadius.circular(12),
//                                   onTap: () {
//                                     log('${widget.notificationDTO.buttonUrl}');
//                                     launchUrl(Uri.parse('${widget.notificationDTO.buttonUrl}'));
//                                   },
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Center(
//                                       child: Text(
//                                         '${widget.notificationDTO.buttonText}',
//                                         style: AppTextStyles.fs12w400.copyWith(color: AppColors.white),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           const Gap(10),
//                         ],
//                       ),
//                     ),
//                     Positioned(
//                       bottom: 8,
//                       right: 8,
//                       child: Text(
//                         formatTime('${widget.notificationDTO.createdAt}'),
//                         style: AppTextStyles.fs12w400.copyWith(letterSpacing: 0.1),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const Gap(32),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class MessageBox extends StatelessWidget {
//   const MessageBox({
//     super.key,
//   });
//   @override
//   Widget build(BuildContext context) {
//     final boxWidth = MediaQuery.sizeOf(context).width * 0.76;
//     // ignore: unused_local_variable
//     final minBoxWidth = MediaQuery.sizeOf(context).width * 0.25;

//     return Row(
//       children: [
//         Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 ConstrainedBox(
//                   constraints: BoxConstraints(
//                     maxWidth: boxWidth,
//                   ),
//                   child: Align(
//                     alignment: Alignment.centerLeft,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//                       decoration: const BoxDecoration(
//                         color: AppColors.muteGrey,
//                         borderRadius: BorderRadius.only(
//                           topLeft: Radius.circular(32),
//                           topRight: Radius.circular(32),
//                           bottomLeft: Radius.circular(4),
//                           bottomRight: Radius.circular(32),
//                         ),
//                       ),
//                       margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//                       child: Column(
//                         children: [
//                           TextMessageBodyWidget(
//                             key: UniqueKey(),
//                             text: '',
//                             style: AppTextStyles.fs16w400,
//                             sentAtStyle: const TextStyle(
//                               fontSize: 11,
//                             ),
//                             linkStyle: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

// class GroupHeaderDate extends StatelessWidget {
//   final DateTime date;

//   const GroupHeaderDate({required this.date, super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Container(
//         decoration: const BoxDecoration(
//           color: AppColors.buttonGrey,
//           borderRadius: BorderRadius.all(Radius.circular(16)),
//         ),
//         padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
//         child: Text(
//           // 'date',
//           date.chatDetailTimeHeader(context),
//           style: AppTextStyles.fs12w400.copyWith(color: const Color.fromRGBO(0, 0, 0, 0.5)),
//         ),
//       ),
//     );
//   }
// }
