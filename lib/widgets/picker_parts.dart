import 'package:flutter/material.dart';

class SheetScaffold extends StatelessWidget {
  const SheetScaffold({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: child,
      ),
    );
  }
}

class ApplyButton extends StatelessWidget {
  const ApplyButton({super.key, required this.onPressed});
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF0349D6);

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>(
            (states) => states.contains(WidgetState.disabled)
                ? blue.withValues(alpha: 0.3)
                : blue,
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          foregroundColor: WidgetStateProperty.resolveWith<Color>(
            (states) => states.contains(WidgetState.disabled)
                ? Colors.white.withValues(alpha: 0.3)
                : Colors.white,
          ),
          elevation: WidgetStateProperty.all<double>(0),
        ),
        child: const Text('Tasdiqlash'),
      ),
    );
  }
}

class PresetRow extends StatelessWidget {
  const PresetRow({super.key, required this.selected, required this.onTap});
  final Color selected;
  final ValueChanged<Color> onTap;
  @override
  Widget build(BuildContext context) {
    final presets = [
      Colors.blue,
      const Color(0xFF7F5AF0),
      const Color(0xFFF72585),
      const Color(0xFFFFA200),
    ];
    return Row(
      children: presets
          .map(
            (c) => Padding(
              padding: const EdgeInsets.only(right: 12),
              child: SwatchButton(
                color: c,
                selected: selected.toARGB32() == c.toARGB32(),
                onTap: () => onTap(c),
              ),
            ),
          )
          .toList(),
    );
  }
}

class SwatchButton extends StatelessWidget {
  const SwatchButton({
    super.key,
    required this.color,
    required this.selected,
    required this.onTap,
  });
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: 'Rang tanlang',
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? Colors.white : Colors.transparent,
              width: 3,
            ),
            boxShadow: selected
                ? [
                    const BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ]
                : null,
          ),
        ),
      ),
    );
  }
}

class HueSlider extends StatelessWidget {
  const HueSlider({super.key, required this.hue, required this.onChanged});
  final double hue;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 14,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
        overlayShape: SliderComponentShape.noOverlay,
        trackShape: GradientTrackShape(),
      ),
      child: Slider(value: hue, min: 0, max: 360, onChanged: onChanged),
    );
  }
}

class SatSlider extends StatelessWidget {
  const SatSlider({
    super.key,
    required this.value,
    required this.onChanged,
    required this.activeColor,
  });
  final double value;
  final ValueChanged<double> onChanged;
  final Color activeColor;

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 12,
        inactiveTrackColor: Colors.grey.shade300,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
        overlayShape: SliderComponentShape.noOverlay,
      ),
      child: Slider(
        value: value,
        min: 0,
        max: 1,
        activeColor: activeColor,
        onChanged: onChanged,
      ),
    );
  }
}

class GradientHueBar extends StatelessWidget {
  const GradientHueBar({
    super.key,
    required this.startHue,
    required this.endHue,
    required this.onChangeStart,
    required this.onChangeEnd,
  });

  final double startHue;
  final double endHue;
  final ValueChanged<double> onChangeStart;
  final ValueChanged<double> onChangeEnd;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final barWidth = constraints.maxWidth;
          return Stack(
            children: [
              Positioned.fill(
                child: ShaderMask(
                  shaderCallback: (r) {
                    return const LinearGradient(
                      colors: [
                        Color(0xFFFF0000),
                        Color(0xFFFFFF00),
                        Color(0xFF00FF00),
                        Color(0xFF00FFFF),
                        Color(0xFF0000FF),
                        Color(0xFFFF00FF),
                        Color(0xFFFF0000),
                      ],
                    ).createShader(r);
                  },
                  child: Container(color: Colors.white),
                ),
              ),
              HueThumb(
                hue: startHue,
                barWidth: barWidth,
                onChanged: onChangeStart,
              ),
              HueThumb(hue: endHue, barWidth: barWidth, onChanged: onChangeEnd),
            ],
          );
        },
      ),
    );
  }
}

class HueThumb extends StatefulWidget {
  const HueThumb({
    super.key,
    required this.hue,
    required this.onChanged,
    required this.barWidth,
  });

  final double hue;
  final double barWidth;
  final ValueChanged<double> onChanged;

  @override
  State<HueThumb> createState() => _HueThumbState();
}

class _HueThumbState extends State<HueThumb> {
  late double _localHue;

  @override
  void initState() {
    super.initState();
    _localHue = widget.hue.clamp(0, 360);
  }

  @override
  void didUpdateWidget(covariant HueThumb oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.hue != widget.hue) {
      _localHue = widget.hue.clamp(0, 360);
    }
  }

  void _setHueFromDx(double dx) {
    final w = widget.barWidth;
    double h = (dx / w) * 360;
    h = h.clamp(0, 360);
    setState(() => _localHue = h);
    widget.onChanged(h);
  }

  @override
  Widget build(BuildContext context) {
    final left = (_localHue / 360) * widget.barWidth;

    return Positioned(
      left: left.clamp(0.0, widget.barWidth - 28),
      top: (36 - 28) / 2,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onHorizontalDragUpdate: (d) {
          _setHueFromDx((_localHue / 360) * widget.barWidth + d.delta.dx);
        },
        onTapDown: (d) {
          final dx = d.localPosition.dx;
          _setHueFromDx(dx);
        },
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: HSVColor.fromAHSV(1, _localHue, 1, 1).toColor(),
            border: Border.all(color: Colors.white, width: 3),
            shape: BoxShape.circle,
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GradientTrackShape extends SliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = sliderTheme.trackHeight ?? 4;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    return Rect.fromLTWH(
      offset.dx,
      trackTop,
      parentBox.size.width,
      trackHeight,
    );
  }

  @override
  void paint(
    PaintingContext context,
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
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final gradient = const LinearGradient(
      colors: [
        Color(0xFFFF0000),
        Color(0xFFFFFF00),
        Color(0xFF00FF00),
        Color(0xFF00FFFF),
        Color(0xFF0000FF),
        Color(0xFFFF00FF),
        Color(0xFFFF0000),
      ],
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.fill;

    context.canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(6)),
      paint,
    );
  }
}
