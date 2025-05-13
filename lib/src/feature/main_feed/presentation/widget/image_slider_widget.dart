import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:lombard/src/core/constant/generated/assets.gen.dart';
import 'package:lombard/src/core/theme/resources.dart';

class ImageSliderWidget extends StatefulWidget {
  const ImageSliderWidget({
    super.key,
  });

  @override
  State<ImageSliderWidget> createState() => _ImageSliderWidgetState();
}

class _ImageSliderWidgetState extends State<ImageSliderWidget> {
  PageController controller = PageController();
  bool isFavorite = false;
  List<String> images = [
    Assets.images.slide1.path,
    Assets.images.slide1.path,
    Assets.images.slide1.path,
    Assets.images.slide1.path,
  ];
  int imageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 270,
      width: double.infinity,
      child: Stack(
        children: [
          PageView.builder(
            controller: controller,
            itemCount: images.length,
            onPageChanged: (value) {
              imageIndex = value;
              setState(() {});
            },
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  Assets.images.slide1.path,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              );
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 5,
            child: Center(
              child: DotsIndicator(
                dotsCount: images.length,
                position: imageIndex,
                decorator: const DotsDecorator(activeColor: AppColors.red, activeSize: Size(11, 11)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
