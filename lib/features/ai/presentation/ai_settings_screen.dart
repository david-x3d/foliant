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
  final baseUrl = TextEditingController();
  final model = TextEditingController();
  final apiKey = TextEditingController();
  AiEndpoint endpoint = AiEndpoint.openAi;
  bool loading = true;
  bool working = false;
  bool obscure = true;
  String? message;
  bool success = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final config = await ref.read(aiRepositoryProvider).load();
      if (!mounted) return;
      endpoint = config.endpoint;
      baseUrl.text = config.baseUrl;
      model.text = config.model;
    } catch (_) {
      if (!mounted) return;
      message = 'Die KI-Einstellungen konnten nicht geladen werden.';
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  AiProviderConfig get config => AiProviderConfig(
    endpoint: endpoint,
    baseUrl: baseUrl.text.trim(),
    model: model.text.trim(),
  );

  void _selectEndpoint(AiEndpoint next) {
    if (next == endpoint) return;
    setState(() {
      endpoint = next;
      message = null;
      success = false;
      baseUrl.text = next == AiEndpoint.gemini
          ? 'https://generativelanguage.googleapis.com/v1beta'
          : 'https://api.openai.com/v1';
      model.text = next == AiEndpoint.gemini
          ? 'gemini-2.5-flash'
          : 'gpt-4o-mini';
    });
  }

  Future<void> _save({bool test = false}) async {
    final l = AppLocalizations.of(context)!;
    setState(() {
      working = true;
      message = null;
      success = false;
    });
    try {
      await ref
          .read(aiRepositoryProvider)
          .save(
            config,
            apiKey: apiKey.text.trim().isEmpty ? null : apiKey.text.trim(),
          );
      if (!mounted) return;
      apiKey.clear();
      if (test) await ref.read(aiClientProvider).testConnection();
      if (!mounted) return;
      setState(() {
        success = true;
        message = test ? l.aiTestSuccess : l.aiSaved;
      });
    } on AiCallException catch (e) {
      if (mounted) setState(() => message = e.message);
    } catch (_) {
      if (mounted) {
        setState(
          () => message =
              'Die KI-Einstellungen konnten nicht gespeichert oder getestet werden. Bitte erneut versuchen.',
        );
      }
    } finally {
      if (mounted) setState(() => working = false);
    }
  }

  @override
  void dispose() {
    baseUrl.dispose();
    model.dispose();
    apiKey.dispose();
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
                DropdownButtonFormField<AiEndpoint>(
                  initialValue: endpoint,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'API-Endpunkt'),
                  items: const [
                    DropdownMenuItem(
                      value: AiEndpoint.openAi,
                      child: Text('OpenAI-kompatibel'),
                    ),
                    DropdownMenuItem(
                      value: AiEndpoint.gemini,
                      child: Text('Google Gemini'),
                    ),
                  ],
                  onChanged: working
                      ? null
                      : (value) {
                          if (value != null) _selectEndpoint(value);
                        },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: baseUrl,
                  enabled: !working,
                  keyboardType: TextInputType.url,
                  autocorrect: false,
                  enableSuggestions: false,
                  decoration: const InputDecoration(
                    labelText: 'URL',
                    helperText: 'Basis-URL oder vollständige API-Adresse',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: model,
                  enabled: !working,
                  autocorrect: false,
                  enableSuggestions: false,
                  decoration: InputDecoration(labelText: l.aiModel),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: apiKey,
                  enabled: !working,
                  obscureText: obscure,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                    labelText: 'API-Schlüssel',
                    helperText:
                        'Leer lassen, um den gespeicherten Schlüssel zu behalten.',
                    helperMaxLines: 2,
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
                const SizedBox(height: 20),
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
                if (working) const LinearProgressIndicator(),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    OutlinedButton(
                      onPressed: working ? null : () => _save(test: true),
                      child: Text(l.aiTest),
                    ),
                    FilledButton(
                      onPressed: working ? null : _save,
                      child: Text(l.saveLabel),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
