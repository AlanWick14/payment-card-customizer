import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ImageService {
  Future<File> copyAssetToTemp(String assetPath) async {
    final bytes = await rootBundle.load(assetPath);
    final tmp = await getTemporaryDirectory();
    final file = File(p.join(tmp.path, p.basename(assetPath)));
    return file.writeAsBytes(bytes.buffer.asUint8List());
  }

  Future<File> compress(File original, {int maxEdge = 1200}) async {
    final bytes = await original.readAsBytes();
    final codec = await ui.instantiateImageCodec(
      bytes,
      targetWidth: null,
      targetHeight: null,
    );
    final frame = await codec.getNextFrame();
    final src = frame.image;

    final w = src.width;
    final h = src.height;

    final scale = (w >= h ? maxEdge / w : maxEdge / h);
    final targetW = (scale < 1.0) ? (w * scale).round() : w;
    final targetH = (scale < 1.0) ? (h * scale).round() : h;

    ui.Image finalImage;
    if (targetW != w || targetH != h) {
      final codec2 = await ui.instantiateImageCodec(
        bytes,
        targetWidth: targetW,
        targetHeight: targetH,
      );
      final frame2 = await codec2.getNextFrame();
      finalImage = frame2.image;
    } else {
      finalImage = src;
    }

    final byteData = await finalImage.toByteData(
      format: ui.ImageByteFormat.png,
    );
    if (byteData == null) {
      throw Exception('Failed to encode image');
    }

    final tmp = await getTemporaryDirectory();
    final base = p.basenameWithoutExtension(original.path);
    final outPath = p.join(tmp.path, 'compressed_$base.png');
    final out = File(outPath);
    await out.writeAsBytes(byteData.buffer.asUint8List(), flush: true);

    return out;
  }
}
