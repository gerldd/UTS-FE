import 'package:flutter/material.dart';

class Breakpoints {
  static const double compact = 600;
  static const double medium = 900; 
}

extension ScreenInfo on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;
  bool get isCompact => screenWidth < Breakpoints.compact;
  bool get isExpanded => screenWidth >= Breakpoints.medium;
  bool get isLandscape => MediaQuery.orientationOf(this) == Orientation.landscape;
}

class ResponsiveBody extends StatelessWidget {
  const ResponsiveBody({super.key, required this.child, this.maxWidth = 1100});

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
