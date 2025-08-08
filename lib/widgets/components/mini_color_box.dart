import 'package:flutter/material.dart';

class MiniColourBox extends StatelessWidget {
  const MiniColourBox({super.key, this.colour});
  final Color? colour;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        color: colour ?? Colors.transparent,
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
