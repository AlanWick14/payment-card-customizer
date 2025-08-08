import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/card_config.dart';

class UploadService {
  Future<http.StreamedResponse> uploadConfig(Uri uri, CardConfig cfg) async {
    final req = http.MultipartRequest('POST', uri)
      ..fields['mode'] = cfg.mode.name
      ..fields['blur'] = cfg.blur.toStringAsFixed(2)
      ..fields['matrix'] = jsonEncode(
        cfg.matrix.map((d) => double.parse(d.toStringAsFixed(5))).toList(),
      );

    if (cfg.mode == CardMode.color && cfg.color != null) {
      req.fields['color'] = cfg.color!
          .toARGB32()
          .toRadixString(16)
          .padLeft(8, '0');
    }
    if (cfg.mode == CardMode.gradient && cfg.gradient != null) {
      req.fields['gradient'] = cfg.gradient!
          .map((c) => c.toARGB32().toRadixString(16).padLeft(8, '0'))
          .join(',');
    }
    if (cfg.mode == CardMode.image && cfg.imageFile != null) {
      req.files.add(
        await http.MultipartFile.fromPath('image', cfg.imageFile!.path),
      );
    }

    return req.send();
  }
}
