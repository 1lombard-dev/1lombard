// ignore_for_file: comment_references

import 'package:flutter/material.dart';
import 'package:lombard/src/core/presentation/widgets/shimmer/animator.dart';

/// Creates simple yet beautiful shimmer animations
///
/// Shimmer is very widely used as the default animation for skeleton loaders or placeholder widgets throughout the development community.
/// Therefore, having an easy to use, yet customizable widget ready to use for Android, iOS and Web, gives developers an advantage to focus on their actual functionality, let shimmer make the loading experience smoother.
///
/// By default, the widget will select the preset config but it can be easily customized as shown below:
///
/// - @required [child] : accepts a child [Widget] over which the animation is to be displayed
/// - [color] : accepts a [Color] and sets the color of the animation overlay. Default value is [Colors.white]
/// - [colorOpacity] : accepts a [double] and sets the Opacity of the color of the animation overlay. Default value is [0.3]
/// - [enabled] : accepts a [bool] which toggles the animation on/off. Default value is [true]
/// - [duration] : accepts a [Duration] that would be the time period of animation. Default value is [Duration(seconds: 3)]
/// - [interval] : accepts a [Duration] that would be the interval between the repeating animation. Default value is [Duration(seconds: 0)]
/// - [direction] : accepts a [ShimmerDirection] and aligns the animation accordingly. Default value is [ShimmerDirection.fromLBRT()]
class Shimmer extends StatelessWidget {
  const Shimmer({
    required this.child,
    this.enabled = true,
    this.color = Colors.white,
    this.colorOpacity = 0.3,
    this.duration = const Duration(milliseconds: 1500),
    this.direction = const ShimmerDirection.fromLTRB(),
    this.cornerRadius = 12,
  });

  /// Accepts a child [Widget] over which the animation is to be displayed
  final Widget child;

  /// Accepts a [bool] which toggles the animation on/off. Default value is [true]
  final bool enabled;

  /// Accepts a parameter of type [Color] and sets the color of the animation overlay. Default value is [Colors.white]
  final Color color;

  /// Accepts a parameter of type [double] and sets the Opacity of the color of the animation overlay. Default value is [0.3]
  final double colorOpacity;

  /// Accepts a [Duration] that would be the time period of animation. Default value is [Duration(seconds: 3)]
  final Duration duration;

  /// Accepts a [ShimmerDirection] and aligns the animation accordingly. Default value is [ShimmerDirection.fromLBRT()]
  final ShimmerDirection direction;

  /// Accepts a [double] and sets the corner radius of the animation overlay. Default value is [12]
  final double cornerRadius;

  @override
  Widget build(BuildContext context) {
    if (enabled) {
      return ShimmerAnimator(
        color: color,
        opacity: colorOpacity,
        duration: duration,
        direction: direction,
        cornerRadius: cornerRadius,
        child: child,
      );
    } else {
      return child;
    }
  }
}

/// A direction along which the shimmer animation will travel
///
///
/// Shimmer animation can travel in 6 possible directions:
///
/// Diagonal Directions:
/// - [ShimmerDirection.fromLTRB] : animation starts from Left Top and moves towards the Right Bottom. This is also the default behaviour if no direction is specified.
/// - [ShimmerDirection.fromRTLB] : animation starts from Right Top and moves towards the Left Bottom
/// - [ShimmerDirection.fromLBRT] : animation starts from Left Bottom and moves towards the Right Top
/// - [ShimmerDirection.fromRBLT] : animation starts from Right Bottom and moves towards the Left Top
///
/// Directions along the axes:
/// - [ShimmerDirection.fromLeftToRight] : animation starts from Left Center and moves towards the Right Center
/// - [ShimmerDirection.fromRightToLeft] : animation starts from Right Center and moves towards the Left Center
class ShimmerDirection {
  factory ShimmerDirection() => const ShimmerDirection._fromLTRB();
  const ShimmerDirection._fromLTRB({
    this.begin = Alignment.topLeft,
    this.end = Alignment.centerRight,
  });

  const ShimmerDirection._fromRTLB({
    this.begin = Alignment.centerRight,
    this.end = Alignment.topLeft,
  });

  const ShimmerDirection._fromLBRT({
    this.begin = Alignment.bottomLeft,
    this.end = Alignment.centerRight,
  });

  const ShimmerDirection._fromRBLT({
    this.begin = Alignment.topRight,
    this.end = Alignment.centerLeft,
  });

  const ShimmerDirection._fromLeftToRight({
    this.begin = Alignment.centerLeft,
    this.end = Alignment.centerRight,
  });

  const ShimmerDirection._fromRightToLeft({
    this.begin = Alignment.centerLeft,
    this.end = Alignment.centerRight,
  });

  /// Animation starts from Left Top and moves towards the Right Bottom
  const factory ShimmerDirection.fromLTRB() = ShimmerDirection._fromLTRB;

  /// Animation starts from Right Top and moves towards the Left Bottom
  const factory ShimmerDirection.fromRTLB() = ShimmerDirection._fromRTLB;

  /// Animation starts from Left Bottom and moves towards the Right Top
  const factory ShimmerDirection.fromLBRT() = ShimmerDirection._fromLBRT;

  /// Animation starts from Right Bottom and moves towards the Left Top
  const factory ShimmerDirection.fromRBLT() = ShimmerDirection._fromRBLT;

  /// Animation starts from Left Center and moves towards the Right Center
  const factory ShimmerDirection.fromLeftToRight() = ShimmerDirection._fromLeftToRight;

  /// Animation starts from Right Center and moves towards the Left Center
  const factory ShimmerDirection.fromRightToLeft() = ShimmerDirection._fromRightToLeft;
  final Alignment begin;
  final Alignment end;
}
