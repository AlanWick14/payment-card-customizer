import 'package:flutter/material.dart';

class MiniGradientBox extends StatelessWidget {
  const MiniGradientBox({super.key, this.colours});
  final List<Color>? colours;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        gradient: colours == null
            ? null
            : LinearGradient(
                colors: colours!,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
