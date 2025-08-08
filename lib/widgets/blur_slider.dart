import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/customization_provider.dart';

class BlurSlider extends StatefulWidget {
  const BlurSlider({super.key});
  @override
  State<BlurSlider> createState() => _BlurSliderState();
}

class _BlurSliderState extends State<BlurSlider> {
  bool _showLabel = false;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CustomizationProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Blur', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 14,
            inactiveTrackColor: Colors.grey.shade300,
            activeTrackColor: Color.fromARGB(255, 3, 73, 214),
            trackShape: _GradientTrack(),
            overlayShape: SliderComponentShape.noOverlay,
            thumbShape: _FancyThumb(
              showLabel: _showLabel,
              label: provider.blur.toStringAsFixed(1),
            ),
          ),
          child: Listener(
            onPointerDown: (_) => setState(() => _showLabel = true),
            onPointerUp: (_) => setState(() => _showLabel = false),
            child: Slider(
              value: provider.blur,
              min: 0,
              max: 10,
              divisions: 20,
              onChanged: provider.setBlur,
            ),
          ),
        ),
      ],
    );
  }
}

class _GradientTrack extends SliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final h = sliderTheme.trackHeight ?? 4;
    final y = offset.dy + (parentBox.size.height - h) / 2;
    return Rect.fromLTWH(offset.dx, y, parentBox.size.width, h);
  }

  @override
  void paint(
    PaintingContext ctx,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final rect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
    );
    final Gradient g = const LinearGradient(
      colors: [Colors.transparent, Color.fromARGB(255, 3, 73, 214)],
    );
    final paint = Paint()..shader = g.createShader(rect);
    ctx.canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(7)),
      paint,
    );
  }
}

class _FancyThumb extends SliderComponentShape {
  _FancyThumb({required this.showLabel, required this.label});
  final bool showLabel;
  final String label;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) =>
      const Size.fromRadius(14);

  @override
  void paint(
    PaintingContext ctx,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    double? textScaleFactor,
    Size? sizeWithOverflow,
  }) {
    final canvas = ctx.canvas;

    final thumbPaint = Paint()..color = Colors.white;
    canvas.drawCircle(center, 14, thumbPaint);
    canvas.drawShadow(
      Path()..addOval(Rect.fromCircle(center: center, radius: 14)),
      Colors.black26,
      4,
      true,
    );

    canvas.drawCircle(
      center,
      10,
      Paint()..color = const Color.fromARGB(255, 3, 73, 214),
    );

    if (showLabel) {
      final tp = TextPainter(
        text: TextSpan(
          text: label,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        textDirection: textDirection,
      )..layout();
      final bubbleRect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: center.translate(0, -34),
          width: tp.width + 16,
          height: tp.height + 10,
        ),
        const Radius.circular(8),
      );
      canvas.drawRRect(
        bubbleRect,
        Paint()..color = Color.fromARGB(255, 3, 73, 214),
      );
      tp.paint(
        canvas,
        Offset(
          bubbleRect.left + (bubbleRect.width - tp.width) / 2,
          bubbleRect.top + (bubbleRect.height - tp.height) / 2,
        ),
      );
    }
  }
}
