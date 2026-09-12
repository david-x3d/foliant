# Foliant

**Vocabulary from the page into your head.**

Foliant is an Android app built with Flutter for learning your own vocabulary sets. It combines classic flashcards with active typing practice, a transparent SRS, and book-page import via camera and on-device OCR. AI is optional: without an API key, Foliant remains fully usable offline.

## Features

- Learning languages including English, French, Spanish, Italian, Dutch, Portuguese, Polish, Turkish, Arabic, Japanese, Chinese, Korean, Russian, Latin, and Greek
- Learning direction as a first-class setting: **Foreign language → German** or **German → Foreign language**
- Flashcards with flip, swipe, and SM-2-like SRS
- Multiple-choice quiz
- **Spelling/typing** with autocorrect disabled, live diff, typo/accent scoring, staged hints, and a language-dependent special-character bar
- Mixed sessions with 0 / 50 / 100 % typing share
- Integrated full-screen camera with live preview, grid and flash, followed by cropping and on-device OCR (Google ML Kit)
- Gallery and text import, always with review before saving
- Optional AI pass for structured vocabulary pairs via configurable providers
- AI settings with only four fields: **API endpoint**, **URL**, **model**, and **API key**
- Real connection test: OpenAI-compatible via `POST {baseUrl}/chat/completions`, Google Gemini natively via `generativelanguage.googleapis.com/v1beta`
- Drift/SQLite locally, Riverpod for state, go_router for navigation
- Material 3 with Dynamic Color, surface-container depth, asymmetric shapes, and springy transitions
- Light/Dark/System and Dynamic Color
- Set export and import as JSON
- Demo set **English Basics**, so learning and typing can be tried immediately after launch

## Screenshots

Screenshots are or can be placed under:

`docs/screenshots/`

## Setup

Prerequisites:

- Flutter stable (project state: Flutter 3.47.x / Dart 3.13.x or compatible)
- Android Studio with Android SDK for Android builds

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
flutter analyze
flutter test
flutter run
```

### Camera / OCR

Foliant is Android-only. `CAMERA` and `INTERNET` are set in the Android manifest; gallery selection uses the system picker. The current APK requires Android 7.0 (API 24) or later. The camera stays inside Foliant; it does not launch the phone camera app.

## AI Providers

AI is **optional**. Manual learning, the Drift database, and on-device OCR work without a network connection and without an API key.

API keys are stored exclusively via `flutter_secure_storage`. They belong neither in Shared Preferences nor in logs, `.env`, or Git.

### OpenAI

- Base URL: `https://api.openai.com/v1`
- Model e.g.: `gpt-4o-mini` or `gpt-4.1-mini`
- API key in the app under **More → AI providers**

### OpenRouter

- Base URL: `https://openrouter.ai/api/v1`
- Model: an OpenRouter model ID
- Select **OpenAI-compatible** as the API endpoint.

### Google Gemini

- In **More → AI providers**, select **Google Gemini** in the **API endpoint** field.
- Base URL: `https://generativelanguage.googleapis.com/v1beta`
- Default model: `gemini-2.5-flash` (freely changeable)
- Foliant uses the native `models/{model}:generateContent` endpoint and passes the API key via `x-goog-api-key`.
- JSON import uses `responseMimeType: application/json` with Gemini. Thinking and output budgets are handled automatically; truncated or blocked responses produce a specific error.

### Ollama / local bridge

Foliant expects an OpenAI-compatible `chat/completions` endpoint by default. With an Ollama/LM Studio bridge, a local Base URL can be entered. On a real smartphone the URL must be reachable from the device; `localhost` points to the phone itself.

### Response format for vocabulary import

```json
{
  "source_lang": "en",
  "target_lang": "de",
  "direction": "foreign_to_de",
  "items": [
    {
      "source": "apple",
      "target": "Apfel",
      "example_source": null,
      "example_target": null,
      "notes": null,
      "confidence": 0.98
    }
  ]
}
```

Uncertain results are marked in review. The system prompt explicitly requires not inventing missing pairs.

## Architecture

Feature-first under `lib/features/`:

- `learning/` – session, typing engine, diff, and SRS
- `library/` – sets
- `import/` – camera, crop, OCR, text import, review
- `ai/` – provider configuration, OpenAI-compatible client, and native Google Gemini adapter
- `settings/` – persistent learning/display rules and JSON transfer
- `onboarding/` – language, direction, typing share, optional AI

Shared infrastructure lives under `lib/core/`, Drift under `lib/data/local/`. UI strings are prepared via Flutter ARB/l10n (`lib/l10n/`).

## Privacy / Secrets

- No API key is committed.
- `.env` and typical secret/keystore files are excluded in `.gitignore`.
- `.env.example` contains documentation values only and is not used by the app as a key store.
- OCR runs locally on the device. Only when the user deliberately runs an AI pass is the entered/recognized text sent to the configured provider.

## Release

Download the APK from [GitHub Releases](https://github.com/david-x3d/foliant/releases/latest).

To build and publish an update:

```bash
flutter pub get
flutter analyze
flutter test
flutter build apk --release
git push origin main
git tag -a v0.1.1 -m "Foliant 0.1.1"
git push origin v0.1.1
gh release create v0.1.1 build/app/outputs/flutter-apk/app-release.apk \
  --title "Foliant 0.1.1" --notes-file RELEASE_NOTES.md
```

The current GitHub APK uses the same development signing key as 0.1.0, so it can be installed as an update. It is not a Play Store build.

## Summary

Foliant is a Flutter vocabulary app with flashcards, active typing practice, an SM-2-like SRS, camera/gallery import with on-device OCR, review-before-save, JSON backup/restore, and optional configurable AI through an OpenAI-compatible Base URL. The app remains fully usable offline without an API key.

## License

MIT – see [LICENSE](LICENSE).

**Author:** David-x3d
