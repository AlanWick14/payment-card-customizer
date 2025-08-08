import 'package:flutter/material.dart';
import 'picker_parts.dart';
import 'package:provider/provider.dart';
import '../provider/customization_provider.dart';

class FancyGradientPickerSheet extends StatefulWidget {
  const FancyGradientPickerSheet({super.key});
  @override
  State<FancyGradientPickerSheet> createState() =>
      _FancyGradientPickerSheetState();
}

class _FancyGradientPickerSheetState extends State<FancyGradientPickerSheet> {
  late HSVColor _hsv1;
  late HSVColor _hsv2;
  bool _touched = false;

  @override
  void initState() {
    super.initState();
    final provider = context.read<CustomizationProvider>();
    final list =
        provider.gradientColors ?? [Colors.blue, const Color(0xFFB400FF)];
    _hsv1 = HSVColor.fromColor(list[0]);
    _hsv2 = HSVColor.fromColor(list[1]);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<CustomizationProvider>();

    return SheetScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SwatchButton(
                color: _hsv1.toColor(),
                selected: true,
                onTap: () {
                  setState(() => _touched = true);
                },
              ),
              SwatchButton(
                color: _hsv2.toColor(),
                selected: true,
                onTap: () {
                  setState(() => _touched = true);
                },
              ),
            ],
          ),
          const SizedBox(height: 24),

          const Text('Gradient'),
          GradientHueBar(
            startHue: _hsv1.hue,
            endHue: _hsv2.hue,
            onChangeStart: (h) {
              setState(() {
                _hsv1 = _hsv1.withHue(h);
                _touched = true;
              });
              provider.setGradient([_hsv1.toColor(), _hsv2.toColor()]);
            },
            onChangeEnd: (h) {
              setState(() {
                _hsv2 = _hsv2.withHue(h);
                _touched = true;
              });
              provider.setGradient([_hsv1.toColor(), _hsv2.toColor()]);
            },
          ),
          const SizedBox(height: 24),
          const Text("To'qlik", style: TextStyle(color: Colors.white)),
          SatSlider(
            value: (_hsv1.saturation + _hsv2.saturation) / 2,
            activeColor: _hsv1.toColor(),
            onChanged: (s) {
              setState(() {
                _hsv1 = _hsv1.withSaturation(s);
                _hsv2 = _hsv2.withSaturation(s);
                _touched = true;
              });
              provider.setGradient([_hsv1.toColor(), _hsv2.toColor()]);
            },
          ),
          const SizedBox(height: 32),
          ApplyButton(
            onPressed: _touched ? () => Navigator.pop(context) : null,
          ),
        ],
      ),
    );
  }
}
