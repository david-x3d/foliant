import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../application/ai_providers.dart';
import '../data/ai_provider_repository.dart';

class AiSettingsScreen extends ConsumerStatefulWidget {
  const AiSettingsScreen({super.key});

  @override
  ConsumerState<AiSettingsScreen> createState() => _AiSettingsScreenState();
}

class _AiSettingsScreenState extends ConsumerState<AiSettingsScreen> {
  final displayName = TextEditingController();
  final baseUrl = TextEditingController();
  final model = TextEditingController();
  final apiVersion = TextEditingController();
  final extraHeaders = TextEditingController();
  final orgId = TextEditingController();
  final projectId = TextEditingController();
  final apiKey = TextEditingController();
  bool loading = true;
  bool testing = false;
  bool obscure = true;
  String? message;
  bool success = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(_load);
  }

  Future<void> _load() async {
    final config = await ref.read(aiRepositoryProvider).load();
    displayName.text = config.displayName;
    baseUrl.text = config.baseUrl;
    model.text = config.model;
    apiVersion.text = config.apiVersion;
    extraHeaders.text = config.extraHeaders;
    orgId.text = config.orgId;
    projectId.text = config.projectId;
    if (mounted) setState(() => loading = false);
  }

  AiProviderConfig get config => AiProviderConfig(
    displayName: displayName.text.trim(),
    baseUrl: baseUrl.text.trim(),
    model: model.text.trim(),
    apiVersion: apiVersion.text.trim(),
    extraHeaders: extraHeaders.text.trim(),
    orgId: orgId.text.trim(),
    projectId: projectId.text.trim(),
  );

  void _applyPreset(String preset) {
    setState(() {
      message = null;
      success = false;
      if (preset == 'google') {
        displayName.text = 'Google Gemini';
        baseUrl.text = 'https://generativelanguage.googleapis.com/v1beta';
        model.text = 'gemini-2.5-flash';
        apiVersion.text = 'v1beta';
        extraHeaders.text = '{}';
        orgId.clear();
        projectId.clear();
      } else {
        displayName.text = 'OpenAI-kompatibel';
        baseUrl.text = 'https://api.openai.com/v1';
        model.text = 'gpt-4o-mini';
        apiVersion.clear();
        extraHeaders.text = '{}';
        orgId.clear();
        projectId.clear();
      }
    });
  }
  Future<void> _save() async {
    final l = AppLocalizations.of(context)!;
    await ref
        .read(aiRepositoryProvider)
        .save(config, apiKey: apiKey.text.isEmpty ? null : apiKey.text);
    if (!mounted) return;
    apiKey.clear();
    setState(() {
      success = true;
      message = l.aiSaved;
    });
  }

  Future<void> _test() async {
    final l = AppLocalizations.of(context)!;
    setState(() {
      testing = true;
      message = null;
    });
    try {
      await ref
          .read(aiRepositoryProvider)
          .save(config, apiKey: apiKey.text.isEmpty ? null : apiKey.text);
      await ref.read(aiClientProvider).testConnection();
      if (!mounted) return;
      setState(() {
        success = true;
        message = l.aiTestSuccess;
      });
    } on AiCallException catch (e) {
      if (!mounted) return;
      setState(() {
        success = false;
        message = switch (e.kind) {
          AiErrorKind.noKey => l.aiTestNoKey,
          AiErrorKind.invalidKey => l.aiTestInvalidKey,
          AiErrorKind.rateLimit => l.aiTestRateLimit,
          AiErrorKind.network => l.aiTestNetwork,
          _ => e.message,
        };
      });
    } finally {
      if (mounted) setState(() => testing = false);
    }
  }

  @override
  void dispose() {
    for (final c in [
      displayName,
      baseUrl,
      model,
      apiVersion,
      extraHeaders,
      orgId,
      projectId,
      apiKey,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l.aiHeadline)),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  'Voreinstellungen',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    ActionChip(
                      avatar: const Icon(Icons.auto_awesome_rounded, size: 18),
                      label: const Text('Google Gemini'),
                      onPressed: () => _applyPreset('google'),
                    ),
                    ActionChip(
                      avatar: const Icon(Icons.hub_rounded, size: 18),
                      label: const Text('OpenAI-kompatibel'),
                      onPressed: () => _applyPreset('openai'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: displayName,
                  decoration: InputDecoration(labelText: l.aiProviderName),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: baseUrl,
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(labelText: l.aiBaseUrl),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: apiKey,
                  obscureText: obscure,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                    labelText: l.aiApiKey,
                    hintText: 'Leer lassen, um gespeicherten Key zu behalten',
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => obscure = !obscure),
                      icon: Icon(
                        obscure
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: model,
                  decoration: InputDecoration(
                    labelText: l.aiModel,
                    hintText:
                        'gpt-4o-mini, gpt-4.1-mini, claude-sonnet, gemini-flash, grok-*, lokal',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: apiVersion,
                  decoration: InputDecoration(labelText: l.aiApiVersion),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: extraHeaders,
                  minLines: 2,
                  maxLines: 5,
                  decoration: InputDecoration(labelText: l.aiExtraHeader),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: orgId,
                        decoration: InputDecoration(labelText: l.aiOrg),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: projectId,
                        decoration: InputDecoration(labelText: l.aiProject),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                if (message != null)
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: success
                          ? Theme.of(context).colorScheme.primaryContainer
                          : Theme.of(context).colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(message!),
                  ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: testing ? null : _test,
                        child: Text(l.aiTest),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FilledButton(
                        onPressed: testing ? null : _save,
                        child: Text(l.saveLabel),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const Text(
                  'Hinweis: Standard ist OpenAI-kompatibel Ã¼ber /chat/completions. OpenRouter, Groq, LM Studio, Ollama-Bridges und xAI funktionieren Ã¼ber Base URL + Modell, sofern sie diesen Endpunkt anbieten.',
                ),
              ],
            ),
    );
  }
}

