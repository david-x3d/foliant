import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/providers.dart';
import '../../../core/widgets/expressive.dart';
import '../../../data/local/app_database.dart';
import '../../../l10n/app_localizations.dart';
import '../../ai/application/ai_providers.dart';
import '../../ai/data/ai_provider_repository.dart';
import '../../settings/application/settings_controller.dart';
import '../data/import_service.dart';
import 'camera_capture_screen.dart';

class ImportScreen extends ConsumerStatefulWidget {
  const ImportScreen({super.key});

  @override
  ConsumerState<ImportScreen> createState() => _ImportScreenState();
}

class _ImportScreenState extends ConsumerState<ImportScreen> {
  final textController = TextEditingController();
  final service = ImportService();
  bool busy = false;
  String? status;

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  Future<void> _gallery() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 94,
      maxWidth: 3000,
    );
    if (picked == null) return;
    await _cropAndRecognize(picked.path);
  }

  Future<void> _camera() async {
    final path = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const CameraCaptureScreen()),
    );
    if (path != null) await _cropAndRecognize(path);
  }

  Future<void> _cropAndRecognize(String path) async {
    setState(() {
      busy = true;
      status = null;
    });
    try {
      final cropped = await ImageCropper().cropImage(
        sourcePath: path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Buchseite zuschneiden',
            lockAspectRatio: false,
          ),
          IOSUiSettings(title: 'Buchseite zuschneiden'),
        ],
      );
      final finalPath = cropped?.path ?? path;
      final recognizer = TextRecognizer(script: TextRecognitionScript.latin);
      try {
        final result = await recognizer.processImage(
          InputImage.fromFile(File(finalPath)),
        );
        textController.text = result.text;
        await _prepareReview(sourceImagePath: finalPath);
      } finally {
        await recognizer.close();
      }
    } catch (_) {
      setState(() => status = AppLocalizations.of(context)!.importOcrFailed);
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> _prepareReview({
    String? sourceImagePath,
    bool preferAi = false,
  }) async {
    final l = AppLocalizations.of(context)!;
    final text = textController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      busy = true;
      status = null;
    });
    try {
      final settings = await ref.read(settingsControllerProvider.future);
      List<ImportPair> pairs;
      if (preferAi) {
        pairs = await ref
            .read(aiClientProvider)
            .extractPairs(
              text: text,
              sourceLang: settings.languageCode,
              targetLang: 'de',
              direction: settings.direction,
            );
      } else {
        pairs = service.parsePlainText(text);
        if (pairs.isEmpty && await ref.read(aiRepositoryProvider).hasApiKey()) {
          pairs = await ref
              .read(aiClientProvider)
              .extractPairs(
                text: text,
                sourceLang: settings.languageCode,
                targetLang: 'de',
                direction: settings.direction,
              );
        }
      }
      if (!mounted) return;
      if (pairs.isEmpty) {
        setState(() => status = l.importNoPairs);
        return;
      }
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ImportReviewScreen(
            pairs: pairs,
            sourceImagePath: sourceImagePath,
            origin: sourceImagePath == null
                ? 'book_import'
                : (preferAi ? 'ai_extract' : 'camera_ocr'),
          ),
        ),
      );
    } on AiCallException catch (e) {
      if (mounted) setState(() => status = '${l.importAiFailed} ${e.message}');
    } catch (e) {
      if (mounted) setState(() => status = '${l.genericError} $e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ExpressiveHero(
            title: l.importHeadline,
            subtitle: 'OCR läuft direkt auf deinem Gerät. KI bleibt optional.',
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: FilledButton.tonalIcon(
                  onPressed: busy ? null : _camera,
                  icon: const Icon(Icons.camera_alt_rounded),
                  label: Text(l.importCamera),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton.tonalIcon(
                  onPressed: busy ? null : _gallery,
                  icon: const Icon(Icons.photo_library_rounded),
                  label: Text(l.importGallery),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          TextField(
            controller: textController,
            minLines: 8,
            maxLines: 16,
            decoration: InputDecoration(
              labelText: l.importText,
              hintText: l.importTextHint,
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: busy ? null : () => _prepareReview(),
                  icon: const Icon(Icons.fact_check_rounded),
                  label: Text(l.importReview),
                ),
              ),
              const SizedBox(width: 10),
              IconButton.filledTonal(
                tooltip: l.importUseAi,
                onPressed: busy ? null : () => _prepareReview(preferAi: true),
                icon: const Icon(Icons.auto_awesome_rounded),
              ),
            ],
          ),
          if (busy) ...[
            const SizedBox(height: 22),
            const Center(child: _MorphingLoader()),
          ],
          if (status != null) ...[
            const SizedBox(height: 16),
            Text(
              status!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
        ],
      ),
    );
  }
}

class ImportReviewScreen extends ConsumerStatefulWidget {
  const ImportReviewScreen({
    required this.pairs,
    required this.origin,
    this.sourceImagePath,
    super.key,
  });
  final List<ImportPair> pairs;
  final String origin;
  final String? sourceImagePath;

  @override
  ConsumerState<ImportReviewScreen> createState() => _ImportReviewScreenState();
}

class _ImportReviewScreenState extends ConsumerState<ImportReviewScreen> {
  late List<ImportPair> pairs;
  String? setId;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    pairs = List.of(widget.pairs);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final db = ref.watch(databaseProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l.importReview)),
      body: StreamBuilder<List<VocabularySet>>(
        stream: db.watchSets(),
        builder: (context, snapshot) {
          final sets = snapshot.data ?? const [];
          setId ??= sets.isEmpty ? null : sets.first.id;
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
            children: [
              Text(l.importReviewHint),
              const SizedBox(height: 12),
              if (sets.isNotEmpty)
                DropdownButtonFormField<String>(
                  initialValue: setId,
                  decoration: InputDecoration(labelText: l.importSet),
                  items: sets
                      .map(
                        (set) => DropdownMenuItem(
                          value: set.id,
                          child: Text(set.name),
                        ),
                      )
                      .toList(),
                  onChanged: (value) => setState(() => setId = value),
                ),
              const SizedBox(height: 16),
              for (var i = 0; i < pairs.length; i++) ...[
                _ReviewPairCard(
                  pair: pairs[i],
                  onChanged: (next) => setState(() => pairs[i] = next),
                  onDelete: () => setState(() => pairs.removeAt(i)),
                ),
                const SizedBox(height: 10),
              ],
            ],
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: FilledButton.icon(
          onPressed: saving || setId == null || pairs.isEmpty ? null : _save,
          icon: const Icon(Icons.save_rounded),
          label: Text(l.importSet),
        ),
      ),
    );
  }

  Future<void> _save() async {
    setState(() => saving = true);
    final settings = await ref.read(settingsControllerProvider.future);
    await ref
        .read(databaseProvider)
        .upsertImportedItems(
          setId: setId!,
          sourceLang: settings.languageCode,
          targetLang: 'de',
          items: pairs,
          origin: widget.origin,
          sourceImagePath: widget.sourceImagePath,
        );
    if (!mounted) return;
    Navigator.pop(context);
  }
}

class _ReviewPairCard extends StatelessWidget {
  const _ReviewPairCard({
    required this.pair,
    required this.onChanged,
    required this.onDelete,
  });
  final ImportPair pair;
  final ValueChanged<ImportPair> onChanged;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            if (pair.confidence < .7)
              Align(
                alignment: Alignment.centerLeft,
                child: Chip(
                  avatar: const Icon(Icons.warning_amber_rounded, size: 18),
                  label: Text(l.importLowConfidence),
                ),
              ),
            TextFormField(
              initialValue: pair.source,
              decoration: InputDecoration(labelText: l.sourceText),
              onChanged: (v) {
                pair.source = v;
                onChanged(pair);
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              initialValue: pair.target,
              decoration: InputDecoration(labelText: l.targetText),
              onChanged: (v) {
                pair.target = v;
                onChanged(pair);
              },
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline_rounded),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MorphingLoader extends StatefulWidget {
  const _MorphingLoader();
  @override
  State<_MorphingLoader> createState() => _MorphingLoaderState();
}

class _MorphingLoaderState extends State<_MorphingLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);
  @override
  void dispose() {
    c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: c,
    builder: (_, _) => Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8 + 18 * c.value),
          topRight: Radius.circular(26 - 18 * c.value),
          bottomLeft: Radius.circular(26 - 18 * c.value),
          bottomRight: Radius.circular(8 + 18 * c.value),
        ),
      ),
    ),
  );
}
