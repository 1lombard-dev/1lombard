import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lombard/src/core/constant/constants.dart';
import 'package:lombard/src/core/theme/resources.dart';
import 'package:lombard/src/feature/initialization/model/environment.dart';

@RoutePage()
class DetailImagePage extends StatefulWidget {
  final String? image;
  // final bool type;
  const DetailImagePage({
    super.key,
    this.image,
  });

  @override
  State<DetailImagePage> createState() => _DetailImagePageState();
}

class _DetailImagePageState extends State<DetailImagePage> {
  int imageIndex = 0;
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: imageIndex);
    log('${widget.image}');
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
      ),
      backgroundColor: AppColors.muteGrey,
      body: Column(
        children: [
          const Gap(34),
          SizedBox(
            height: 500,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                // setState(() {
                //   imageIndex = index;
                //   log('$imageIndex', name: 'image index');
                // });
              },
              itemCount: 1,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: InteractiveViewer(
                    // panEnabled: false,
                    // boundaryMargin: const EdgeInsets.all(100),
                    // minScale: 0.5,
                    // maxScale: 2,
                    child: CachedNetworkImage(
                      imageUrl: widget.image == null ? NOT_FOUND_IMAGE : '$kBaseUrlImages/${widget.image}',
                      fit: BoxFit.contain,
                      width: double.infinity,
                      height: 430,
                    ),
                  ),
                );
              },
            ),
          ),
          // const Gap(6),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     AnimatedContainer(
          //       duration: const Duration(milliseconds: 300),
          //       margin: const EdgeInsets.symmetric(horizontal: 4),
          //       width: 24,
          //       height: 4,
          //       decoration: BoxDecoration(
          //         color: AppColors.pink,
          //         borderRadius: BorderRadius.circular(4),
          //       ),
          //     ),
          //   ],
          // ),
          // const Gap(16),
          // SizedBox(
          //   height: 60,
          //   child: ListView.builder(
          //     shrinkWrap: true,
          //     itemCount: 1,
          //     scrollDirection: Axis.horizontal,
          //     itemBuilder: (BuildContext context, int index) {
          //       return GestureDetector(
          //         onTap: () {
          //           setState(() {
          //             imageIndex = index;
          //             log('$imageIndex', name: 'image index');
          //           });

          //           _pageController.animateToPage(
          //             index,
          //             duration: const Duration(milliseconds: 300),
          //             curve: Curves.easeInOut,
          //           );
          //         },
          //         child: Padding(
          //           padding: const EdgeInsets.only(right: 8.0),
          //           child: SizedBox(
          //             height: 60,
          //             width: 60,
          //             child: ClipRRect(
          //               borderRadius: BorderRadius.circular(8),
          //               child: CachedNetworkImage(
          //                 imageUrl: widget.image ?? '', // Display the image based on the index
          //                 fit: BoxFit.cover,
          //                 width: double.infinity,
          //                 height: 430,
          //               ),
          //             ),
          //           ),
          //         ),
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}
