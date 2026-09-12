import '../../../data/local/app_database.dart';

class ImportService {
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
