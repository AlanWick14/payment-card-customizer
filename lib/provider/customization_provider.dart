import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../models/card_config.dart';
import '../services/image_service.dart';
import '../services/upload_service.dart';

class CustomizationProvider extends ChangeNotifier {
  CustomizationProvider({
    required this.imageService,
    required this.uploadService,
    List<String>? predefinedAssets,
  }) : _predefined =
           predefinedAssets ??
           const [
             'assets/images/card_image_city.jpg',
             'assets/images/card_image_mountain.jpg',
             'assets/images/card_image_nature.jpg',
           ];

  final ImageService imageService;
  final UploadService uploadService;
  final List<String> _predefined;

  File? _backgroundImage;
  Color? _backgroundColor;
  List<Color>? _gradientColors;
  double _blur = 0;
  Matrix4 _imageTransform = Matrix4.identity();
  CardMode _mode = CardMode.image;

  File? get backgroundImage => _backgroundImage;
  Color? get backgroundColor => _backgroundColor;
  List<Color>? get gradientColors => _gradientColors;
  double get blur => _blur;
  Matrix4 get imageTransform => _imageTransform;
  CardMode get mode => _mode;
  List<String> get predefined => List.unmodifiable(_predefined);

  bool _initialized = false;
  Future<void> ensureInitialized() async {
    if (_initialized) return;
    _initialized = true;
    final asset = (_predefined.toList()..shuffle()).first;
    final file = await imageService.copyAssetToTemp(asset);
    setImage(file);
  }

  void setImage(File file) {
    _backgroundImage = file;
    _backgroundColor = null;
    _gradientColors = null;
    _mode = CardMode.image;
    notifyListeners();
  }

  void setColor(Color color) {
    _backgroundColor = color;
    _backgroundImage = null;
    _gradientColors = null;
    _mode = CardMode.color;
    notifyListeners();
  }

  void setGradient(List<Color> colors) {
    if (colors.length != 2) return;
    _gradientColors = colors;
    _backgroundImage = null;
    _backgroundColor = null;
    _mode = CardMode.gradient;
    notifyListeners();
  }

  void setBlur(double v) {
    _blur = v.clamp(0.0, 10.0);
    notifyListeners();
  }

  void setImageTransform(Matrix4 m) {
    _imageTransform = m;
    notifyListeners();
  }

  void reset() {
    _backgroundImage = null;
    _backgroundColor = null;
    _gradientColors = null;
    _blur = 0;
    _imageTransform = Matrix4.identity();
    _mode = CardMode.image;
    notifyListeners();
  }

  CardConfig _buildConfigForUpload({File? compressedImage}) {
    final mat = List<double>.from(_imageTransform.storage);
    return CardConfig(
      mode: _mode,
      imageFile: compressedImage ?? _backgroundImage,
      gradient: _gradientColors,
      color: _backgroundColor,
      blur: _blur,
      matrix: mat,
    );
  }

  Future<void> selectPredefined(String assetPath) async {
    final byteData = await rootBundle.load(assetPath);
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/${p.basename(assetPath)}');
    await file.writeAsBytes(byteData.buffer.asUint8List());
    setImage(file);
  }

  Future<int> upload() async {
    File? compressed;
    if (_mode == CardMode.image && _backgroundImage != null) {
      compressed = await imageService.compress(_backgroundImage!);
    }
    final cfg = _buildConfigForUpload(compressedImage: compressed);
    final uri = Uri.parse('https://example.com/api/card/save');
    final res = await uploadService.uploadConfig(uri, cfg);
    return res.statusCode;
  }
}
