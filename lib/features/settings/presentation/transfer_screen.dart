import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/providers.dart';
import '../../../l10n/app_localizations.dart';

class TransferScreen extends ConsumerStatefulWidget {
  const TransferScreen({super.key});

  @override
  ConsumerState<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends ConsumerState<TransferScreen> {
  bool busy = false;
  String? message;

  Future<void> _export() async {
    final l = AppLocalizations.of(context)!;
    setState(() => busy = true);
    try {
      final json = await ref.read(databaseProvider).exportAllAsJson();
      final dir = await getTemporaryDirectory();
      final file = File(
        p.join(
          dir.path,
          'foliant-export-${DateTime.now().millisecondsSinceEpoch}.json',
        ),
      );
      await file.writeAsString(json, flush: true);
      await SharePlus.instance.share(
        ShareParams(files: [XFile(file.path)], text: 'Foliant Set-Export'),
      );
      if (mounted) setState(() => message = l.exportDone);
    } catch (e) {
      if (mounted) setState(() => message = '${l.genericError} $e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> _import() async {
    final l = AppLocalizations.of(context)!;
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    final path = result?.files.single.path;
    if (path == null) return;
    setState(() => busy = true);
    try {
      final json = await File(path).readAsString();
      await ref.read(databaseProvider).importFromJson(json);
      if (mounted) setState(() => message = l.importDone);
    } catch (e) {
      if (mounted) setState(() => message = '${l.genericError} $e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l.settingsExport)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: ListTile(
              contentPadding: const EdgeInsets.all(20),
              leading: const Icon(Icons.upload_file_rounded),
              title: Text(l.exportJson),
              subtitle: const Text(
                'Sets, Vokabeln und Lernfortschritt werden in einer JSON-Datei gespeichert.',
              ),
              trailing: const Icon(Icons.arrow_forward_rounded),
              onTap: busy ? null : _export,
            ),
          ),
          Card(
            child: ListTile(
              contentPadding: const EdgeInsets.all(20),
              leading: const Icon(Icons.download_rounded),
              title: Text(l.importJson),
              subtitle: const Text(
                'Vorhandene IDs werden aktualisiert, neue Sets und Karten ergänzt.',
              ),
              trailing: const Icon(Icons.arrow_forward_rounded),
              onTap: busy ? null : _import,
            ),
          ),
          if (busy)
            const Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: CircularProgressIndicator()),
            ),
          if (message != null)
            Padding(padding: const EdgeInsets.all(8), child: Text(message!)),
        ],
      ),
    );
  }
}
