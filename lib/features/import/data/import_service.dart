import 'dart:io';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/local/app_database.dart';

class ImportCapture {
  const ImportCapture({required this.text, this.imagePath});
  final String text;
  final String? imagePath;
}

class ImportService {
  final _picker = ImagePicker();

  Future<ImportCapture?> pickAndRecognize(ImageSource source) async {
    final file = await _picker.pickImage(
      source: source,
      imageQuality: 92,
      maxWidth: 2600,
    );
    if (file == null) return null;
    final recognizer = TextRecognizer(script: TextRecognitionScript.latin);
    try {
      final input = InputImage.fromFile(File(file.path));
      final recognized = await recognizer.processImage(input);
      return ImportCapture(text: recognized.text, imagePath: file.path);
    } finally {
      await recognizer.close();
    }
  }

  List<ImportPair> parsePlainText(String text) {
    final pairs = <ImportPair>[];
    for (final rawLine in text.split(RegExp(r'\r?\n'))) {
      final line = rawLine.trim().replaceFirst(RegExp(r'^[-*•]\s*'), '');
      if (line.isEmpty) continue;
      final match = RegExp(
        r'^(.+?)\s*(?:\s[-–—=:;]\s|\t+)\s*(.+)$',
      ).firstMatch(line);
      if (match == null) continue;
      final source = match.group(1)?.trim() ?? '';
      final target = match.group(2)?.trim() ?? '';
      if (source.isNotEmpty && target.isNotEmpty) {
        pairs.add(ImportPair(source: source, target: target, confidence: .82));
      }
    }
    return pairs;
  }
}
