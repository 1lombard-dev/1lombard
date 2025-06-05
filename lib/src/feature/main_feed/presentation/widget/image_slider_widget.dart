import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:lombard/src/core/theme/resources.dart';
import 'package:lombard/src/feature/initialization/model/environment.dart';
import 'package:lombard/src/feature/main_feed/model/main_page_dto.dart';
import 'package:url_launcher/url_launcher.dart';

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
  PageController controller = PageController();

  int imageIndex = 0;
  String cleanHtml(String html) {
    // Удаляем inline style
    String withoutStyle = html.replaceAll(RegExp(r'style="[^"]*"'), '');

    // Распознаём вложенные <span> и превращаем в <b>
    return withoutStyle.replaceAllMapped(
      RegExp(r'<span[^>]*>(.*?)</span>', dotAll: true),
      (match) {
        final content = match.group(1)!;
        // Если внутри были признаки жирного текста (раньше был font-weight:800), делаем <b>
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
              imageIndex = value;
              setState(() {});
            },
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(
                        '$kBaseUrlImages${widget.banners[index].layers?[0].imagelink?.replaceFirst('\$', '')}',
                        fit: BoxFit.contain,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  Html(
                    data: cleanHtml(widget.banners[index].layers![1].content!),
                    style: {
                      "span": Style(
                        fontSize: FontSize(20),
                        fontWeight: FontWeight.w600,
                        color: AppColors.red,
                      ),
                      "b": Style(
                        fontSize: FontSize(20),
                        fontWeight: FontWeight.w800,
                        color: AppColors.white,
                      ),
                    },
                  ),
                  if (widget.banners[index].layers?[2].href != null)
                    Positioned(
                      right: 0,
                      bottom: 20,
                      child: Container(
                        decoration: BoxDecoration(color: AppColors.red, borderRadius: BorderRadius.circular(20)),
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          child: InkWell(
                            onTap: () async {
                              final href = widget.banners[index].layers?[2].href;
                              if (href != null) {
                                final uri = Uri.tryParse(href);
                                if (uri != null && await canLaunchUrl(uri)) {
                                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                                } else {
                                  debugPrint('Could not launch $href');
                                }
                              }
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                'ПОДРОБНЕЕ',
                                style: AppTextStyles.fs15w400.copyWith(color: AppColors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 5,
            child: Center(
              child: DotsIndicator(
                dotsCount: widget.banners.length,
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
