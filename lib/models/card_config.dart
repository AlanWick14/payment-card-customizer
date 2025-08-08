import 'dart:io';
import 'package:flutter/material.dart';

enum CardMode { image, color, gradient }

class CardConfig {
  final CardMode mode;
  final File? imageFile;
  final List<Color>? gradient;
  final Color? color;
  final double blur;
  final List<double> matrix;

  const CardConfig({
    required this.mode,
    required this.imageFile,
    required this.gradient,
    required this.color,
    required this.blur,
    required this.matrix,
  });
}
