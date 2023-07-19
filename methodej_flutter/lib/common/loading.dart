import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:math' as math;

class Loading extends StatefulWidget {
  Loading({required this.size});
  final double size;
  @override
  State<Loading> createState() => _LoadingState(size: this.size);
}

class _LoadingState extends State<Loading> with SingleTickerProviderStateMixin {
  _LoadingState({required this.size});

  final double size;
  late AnimationController controller;
  @override
  void initState() {
    controller = AnimationController(
        duration: Duration(seconds: 2),
        vsync: this,
        lowerBound: 0,
        upperBound: 180)
      ..forward()
      ..addListener(() {
        if (controller.isCompleted) {
          controller.repeat();
        }
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return /*Container(
      width: size as double,
      height: size as double,
      child: AnimatedBuilder(
          animation: controller,
          builder: (context, child) => Transform.rotate(
                angle: controller.value < 45
                    ? controller.value * (math.pi / 180)
                    : controller.value < 90
                        ? (45 + (45 - controller.value)) * (math.pi / 180)
                        : controller.value < 135
                            ? (-controller.value + 90) * (math.pi / 180)
                            : (controller.value - 180) * (math.pi / 180),
                child: child,
              ),
          child: Image.asset('images/loader.png')),
    );*/
        Image.asset(
      "images/loader.gif",
      height: size,
      width: size,
    );
  }
}
