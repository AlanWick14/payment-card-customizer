import 'dart:math' as math;
import 'package:card_customizer/widgets/components/action_row_button.dart';
import 'package:card_customizer/widgets/components/mini_color_box.dart';
import 'package:card_customizer/widgets/components/mini_gradient_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/customization_provider.dart';
import '../widgets/custom_card.dart';
import '../widgets/image_picker_modal.dart';
import '../widgets/blur_slider.dart';
import '../widgets/fancy_color_picker_sheet.dart';
import '../widgets/fancy_gradient_picker_sheet.dart';

class CardCustomizationPage extends StatefulWidget {
  const CardCustomizationPage({super.key});

  @override
  State<CardCustomizationPage> createState() => _CardCustomizationPageState();
}

class _CardCustomizationPageState extends State<CardCustomizationPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<CustomizationProvider>().ensureInitialized();
    });
  }

  Future<void> _onSave() async {
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(const SnackBar(content: Text('Yuklanmoqda…')));
    try {
      final code = await context.read<CustomizationProvider>().upload();
      messenger.showSnackBar(
        SnackBar(
          content: Text(code == 200 ? 'Muvaffaqiyatli!' : 'Xatolik: $code'),
        ),
      );
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Xatolik: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final customization = context.watch<CustomizationProvider>();

    final size = MediaQuery.sizeOf(context);
    final pad = MediaQuery.paddingOf(context);
    const maxContentW = 520.0;
    const cardAspect = 1.586;
    const desiredGap = 24.0;

    final contentW = math.min(size.width, maxContentW).toDouble();
    final cardW = (contentW - 48).toDouble();
    final cardH = (cardW / cardAspect).toDouble();

    const appBarH = kToolbarHeight;
    final cardTopMin = pad.top + appBarH + 16;

    final proposedSheetH = size.height * 0.58;
    final maxSheetHThatStillLeavesRoom =
        size.height - (cardTopMin + cardH + desiredGap);
    final sheetH = proposedSheetH
        .clamp(320.0, math.max(300.0, maxSheetHThatStillLeavesRoom))
        .toDouble();

    final sheetTop = size.height - sheetH;
    final computedCardTop = math
        .max(cardTopMin, sheetTop - cardH - desiredGap)
        .toDouble();

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Sizning Kartangiz',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 75, 92, 240),
                  Color.fromARGB(255, 3, 73, 214),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: maxContentW,
                minHeight: sheetH,
              ),
              child: Container(
                padding: const EdgeInsets.fromLTRB(24, 50, 24, 24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ActionButton(
                        icon: Icons.image_outlined,
                        label: 'Surat tanlang',
                        onTap: () => showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(24),
                            ),
                          ),
                          builder: (_) => const ImagePickerModal(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ActionButton(
                        icon: Icons.color_lens_outlined,
                        label: 'Oddiy rang',
                        trailing: MiniColourBox(
                          colour: customization.backgroundColor,
                        ),
                        onTap: () => showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.black.withValues(alpha: 0.7),
                          builder: (_) => const FancyColorPickerSheet(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ActionButton(
                        icon: Icons.gradient,
                        label: 'Gradient rang',
                        trailing: MiniGradientBox(
                          colours: customization.gradientColors,
                        ),
                        onTap: () => showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.black.withValues(alpha: 0.7),
                          builder: (_) => const FancyGradientPickerSheet(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const BlurSlider(),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _onSave,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 4,
                          ),
                          child: Ink(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 75, 92, 240),
                                  Color.fromARGB(255, 3, 73, 214),
                                ],
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(14),
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                'Saqlash',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: computedCardTop,
            left: 0,
            right: 0,
            child: Center(
              child: Material(
                elevation: 12,
                borderRadius: BorderRadius.circular(20),
                clipBehavior: Clip.antiAlias,
                child: SizedBox(
                  width: cardW,
                  height: cardH,
                  child: const CustomCard(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
