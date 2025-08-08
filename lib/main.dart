import 'package:card_customizer/services/image_service.dart';
import 'package:card_customizer/services/upload_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/card_customization_page.dart';
import 'provider/customization_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CustomizationProvider(
        imageService: ImageService(),
        uploadService: UploadService(),
      ),
      child: MaterialApp(
        title: 'Karta sozlovchi',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Color(0xFF1557C9),
            selectionColor: Color(0xFF7EA8FF),
            selectionHandleColor: Color(0xFF1557C9),
          ),
        ),
        home: const CardCustomizationPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
