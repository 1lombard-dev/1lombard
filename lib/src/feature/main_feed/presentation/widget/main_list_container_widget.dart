import 'package:flutter/material.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:lombard/src/core/theme/resources.dart';

class MainListContainerWidget extends StatefulWidget {
  final String title;
  final String introtext;

  const MainListContainerWidget({
    super.key,
    required this.title,
    required this.introtext,
  });

  @override
  State<MainListContainerWidget> createState() => _MainListContainerWidgetState();
}

class _MainListContainerWidgetState extends State<MainListContainerWidget> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  String stripHtmlTags(String htmlString) {
    final document = html_parser.parse(htmlString);
    return document.body?.text.trim() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 19.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: _toggleExpand,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 21),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.title,
                          style: AppTextStyles.fs16w600.copyWith(color: AppColors.black),
                        ),
                      ),
                      RotationTransition(
                        turns: Tween(begin: 0.0, end: 0.5).animate(_animation),
                        child: const Icon(Icons.keyboard_arrow_down),
                      ),
                    ],
                  ),
                  SizeTransition(
                    sizeFactor: _animation,
                    axisAlignment: -1.0,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        stripHtmlTags(widget.introtext),
                        style: AppTextStyles.fs14w400.copyWith(color: AppColors.grayText),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
