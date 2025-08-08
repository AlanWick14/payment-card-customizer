import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/customization_provider.dart';
import '../models/card_config.dart';

class CustomCard extends StatefulWidget {
  const CustomCard({super.key});

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  late final TransformationController _controller;

  @override
  void initState() {
    super.initState();
    final provider = context.read<CustomizationProvider>();
    _controller = TransformationController(provider.imageTransform);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final matrix = context.read<CustomizationProvider>().imageTransform;
    if (!_matrixEquals(_controller.value, matrix)) {
      _controller.value = matrix.clone();
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.watch<CustomizationProvider>();

    return AspectRatio(
      aspectRatio: 1.586,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            if (c.mode == CardMode.image && c.backgroundImage != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: InteractiveViewer(
                  boundaryMargin: EdgeInsets.zero,
                  clipBehavior: Clip.hardEdge,
                  transformationController: _controller,
                  minScale: 1,
                  maxScale: 3,
                  panEnabled: true,
                  onInteractionEnd: (_) => context
                      .read<CustomizationProvider>()
                      .setImageTransform(_controller.value.clone()),
                  child: Image.file(
                    c.backgroundImage!,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            if (c.mode == CardMode.color && c.backgroundColor != null)
              Container(color: c.backgroundColor),
            if (c.mode == CardMode.gradient && c.gradientColors != null)
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: c.gradientColors!,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            if (c.blur > 0)
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: c.blur, sigmaY: c.blur),
                child: const SizedBox.expand(),
              ),
            Padding(padding: const EdgeInsets.all(18), child: _Face()),
          ],
        ),
      ),
    );
  }

  bool _matrixEquals(Matrix4 a, Matrix4 b) {
    for (var i = 0; i < 16; i++) {
      if ((a.storage[i] - b.storage[i]).abs() > 0.0001) return false;
    }
    return true;
  }
}

class _Face extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, cts) {
        final h = cts.maxHeight;
        final gapS = h * 0.015;
        final gapM = h * 0.025;
        final chipH = h * 0.18;
        final logoH = h * 0.18;
        final contactlessSize = h * 0.12;

        return Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: h * 0.18,
                  child: Image.asset(
                    'assets/images/nbu_logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(width: h * 0.05),
                Expanded(
                  child: FittedBox(
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'NATIONAL BANK OF\nUZBEKISTAN',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: h * 0.075,
                        fontWeight: FontWeight.w700,
                        height: 1.1,
                        letterSpacing: 0.5,
                        shadows: const [
                          Shadow(blurRadius: 1.5, color: Colors.black45),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: gapS),
            Row(
              children: [
                Chip(height: chipH),
                SizedBox(width: h * 0.04),
                Icon(
                  Icons.contactless,
                  color: Colors.white,
                  size: contactlessSize,
                ),
              ],
            ),

            const Spacer(),
            FittedBox(
              alignment: Alignment.centerLeft,
              fit: BoxFit.scaleDown,
              child: Text(
                '1234  5678  9101  1121',
                style: TextStyle(
                  fontSize: h * 0.16,
                  color: Colors.white,
                  letterSpacing: 2,
                  fontFamily: 'RobotoMono',
                  fontWeight: FontWeight.w700,
                  shadows: const [Shadow(blurRadius: 2, color: Colors.black45)],
                ),
              ),
            ),

            SizedBox(height: gapS),
            Row(
              children: [
                Text(
                  '561468',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: h * 0.06,
                    letterSpacing: 0.6,
                  ),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'VALID',
                      style: TextStyle(color: Colors.white, fontSize: h * 0.05),
                    ),
                    Text(
                      'THRU 03/28',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: h * 0.075,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: gapM),
            Row(
              children: [
                Expanded(
                  child: FittedBox(
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'ANVAR FAYZULLAEV',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.1,
                        fontSize: h * 0.09,
                        shadows: const [
                          Shadow(blurRadius: 1.5, color: Colors.black38),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: h * 0.04),
                SizedBox(
                  height: logoH,
                  child: Image.asset(
                    'assets/images/uzcard_logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class Chip extends StatelessWidget {
  const Chip({super.key, required this.height});
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: AspectRatio(
        aspectRatio: 46 / 34,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(height * 0.18),
          child: Image.asset(
            'assets/images/chip_card_logo.webp',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
