import 'package:flutter/material.dart';
import 'picker_parts.dart';
import 'package:provider/provider.dart';
import '../provider/customization_provider.dart';

class FancyColorPickerSheet extends StatefulWidget {
  const FancyColorPickerSheet({super.key});

  @override
  State<FancyColorPickerSheet> createState() => _FancyColorPickerSheetState();
}

class _FancyColorPickerSheetState extends State<FancyColorPickerSheet> {
  late HSVColor _hsv;
  bool _touched = false;

  @override
  void initState() {
    super.initState();
    final c =
        context.read<CustomizationProvider>().backgroundColor ?? Colors.blue;
    _hsv = HSVColor.fromColor(c);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<CustomizationProvider>();
    final current = _hsv.toColor();

    return SheetScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PresetRow(
            selected: current,
            onTap: (c) {
              setState(() {
                _hsv = HSVColor.fromColor(c);
                _touched = true;
              });
              provider.setColor(c);
            },
          ),
          const SizedBox(height: 24),

          const Text('Hue'),
          HueSlider(
            hue: _hsv.hue,
            onChanged: (h) {
              setState(() {
                _hsv = _hsv.withHue(h);
                _touched = true;
              });
              provider.setColor(_hsv.toColor());
            },
          ),
          const SizedBox(height: 24),

          const Text("To'qlik"),
          SatSlider(
            value: _hsv.saturation,
            activeColor: _hsv.toColor(),
            onChanged: (s) {
              setState(() {
                _hsv = _hsv.withSaturation(s);
                _touched = true;
              });
              provider.setColor(_hsv.toColor());
            },
          ),
          const SizedBox(height: 24),

          ApplyButton(
            onPressed: _touched ? () => Navigator.pop(context) : null,
          ),
        ],
      ),
    );
  }
}
