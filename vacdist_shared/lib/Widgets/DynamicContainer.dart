import 'package:flutter/material.dart';

class DynamicContainer extends StatelessWidget {
  DynamicContainer(
      {Key? key,
      required this.heightPct,
      required this.widthPct,
      required this.child,
      this.padding})
      : super(key: key);

  final double heightPct;
  final double widthPct;
  final EdgeInsetsGeometry? padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * heightPct,
      width: MediaQuery.of(context).size.width * widthPct,
      padding: padding,
      child: child,
    );
  }
}
