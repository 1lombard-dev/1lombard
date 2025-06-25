import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:lombard/src/core/theme/resources.dart';
import 'package:lombard/src/feature/initialization/model/environment.dart';
import 'package:lombard/src/feature/main_feed/model/main_page_dto.dart';

class ImageSliderWidget extends StatefulWidget {
  final List<LayersDTO> banners;

  const ImageSliderWidget({
    super.key,
    required this.banners,
  });

  @override
  State<ImageSliderWidget> createState() => _ImageSliderWidgetState();
}

class _ImageSliderWidgetState extends State<ImageSliderWidget> {
  final PageController controller = PageController();
  int imageIndex = 0;

  String cleanHtml(String html) {
    final String withoutStyle = html.replaceAll(RegExp('style="[^"]*"'), '');
    return withoutStyle.replaceAllMapped(
      RegExp('<span[^>]*>(.*?)</span>', dotAll: true),
      (match) {
        final content = match.group(1)!;
        if (content.contains("Скачайте") || content.contains("оцените")) {
          return '<b>$content</b>';
        }
        return '<span>$content</span>';
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      width: double.infinity,
      child: Stack(
        children: [
          PageView.builder(
            controller: controller,
            itemCount: widget.banners.length,
            onPageChanged: (value) {
              setState(() {
                imageIndex = value;
              });
            },
            itemBuilder: (context, index) {
              final banner = widget.banners[index];

              return Stack(
                children: [
                  // Background image
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(
                        '$kBaseUrlImages${banner.layers?[0].imagelink?.replaceFirst('\$', '')}',
                        fit: BoxFit.contain,
                        width: double.infinity,
                      ),
                    ),
                  ),

                  // Gradient overlay for readability
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.4),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),

                  // HTML text
                  Padding(
                    padding: index == 3
                        ? const EdgeInsets.only(top: 70, left: 16, right: 16, bottom: 16)
                        : const EdgeInsets.all(16),
                    child: Html(
                      data: cleanHtml(banner.layers![1].content ?? ''),
                      style: {
                        "span": Style(
                          fontSize: FontSize(20),
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                        "b": Style(
                          fontSize: FontSize(20),
                          fontWeight: FontWeight.w800,
                          color: AppColors.red,
                        ),
                      },
                    ),
                  ),
                ],
              );
            },
          ),

          // Dots indicator
          Positioned(
            left: 0,
            right: 0,
            bottom: 5,
            child: Center(
              child: DotsIndicator(
                dotsCount: widget.banners.length,
                position: imageIndex,
                decorator: const DotsDecorator(
                  activeColor: AppColors.red,
                  activeSize: Size(11, 11),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
