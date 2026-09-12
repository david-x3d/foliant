# Foliant

**Vokabeln von der Seite in den Kopf.**

Foliant ist eine Android-App auf Flutter-Basis zum Lernen eigener Vokabelsets. Sie verbindet klassische Karteikarten mit aktivem Schreibtraining, einem nachvollziehbaren SRS und dem Import von Buchseiten per Kamera und On-Device-OCR. KI ist optional: Ohne API-Key bleibt Foliant vollstÃ¤ndig offline nutzbar.

## Features

- Lernsprachen u. a. Englisch, FranzÃ¶sisch, Spanisch, Italienisch, NiederlÃ¤ndisch, Portugiesisch, Polnisch, TÃ¼rkisch, Arabisch, Japanisch, Chinesisch, Koreanisch, Russisch, Latein und Griechisch
- Lernrichtung als First-Class-Einstellung: **Fremdsprache â†’ Deutsch** oder **Deutsch â†’ Fremdsprache**
- Karteikarten mit Flip, Swipe und SM-2-artigem SRS
- Multiple-Choice-Quiz
- **Schreibweise/Tippen** mit deaktiviertem Autocorrect, Live-Diff, Tippfehler-/Akzentbewertung, stufenweisen Hinweisen und sprachabhÃ¤ngiger Sonderzeichenleiste
- Gemischte Sessions mit 0 / 50 / 100 % Tipp-Anteil
- Kamera-Import mit Raster, Blitz, Crop und On-Device-OCR (Google ML Kit)
- Galerie- und Textimport, immer mit Review vor dem Speichern
- Optionaler KI-Pass fÃ¼r strukturierte Vokabelpaare Ã¼ber konfigurierbare Anbieter
- KI-Konfiguration Ã¼ber Anzeigename, **Base URL**, Modell, API-Version, Extra-Header, Org-/Project-ID und Secure-Storage-Key
- Echter Verbindungstest: OpenAI-kompatibel Ã¼ber `POST {baseUrl}/chat/completions`, Google Gemini nativ Ã¼ber `generativelanguage.googleapis.com/v1beta`
- Drift/SQLite lokal, Riverpod fÃ¼r State, go_router fÃ¼r Navigation
- Material 3 mit Dynamic Color, Surface-Container-Tiefe, asymmetrischen Formen und federnden Transitions
- Hell/Dunkel/System und Dynamic Color
- Set-Export und -Import als JSON
- Demo-Set **Englisch Basics**, damit Lernen und Tippen nach dem Start sofort ausprobiert werden kÃ¶nnen

## Screenshots

Screenshots liegen bzw. kÃ¶nnen abgelegt werden unter:

`docs/screenshots/`

## Setup

Voraussetzungen:

- Flutter stable (Projektstand: Flutter 3.47.x / Dart 3.13.x oder kompatibel)
- Android Studio mit Android SDK fÃ¼r Android-Builds

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
flutter analyze
flutter test
flutter run
```

### Kamera / OCR

Foliant ist Android-only. `CAMERA` und `INTERNET` sind im Android-Manifest gesetzt; Galerieauswahl nutzt den systemeigenen Picker. Das Projekt setzt `minSdk 23`, passend zur verwendeten CameraX-Integration.

## KI-Anbieter

KI ist **optional**. Manuelles Lernen, Drift-Datenbank und On-Device-OCR funktionieren ohne Netz und ohne API-Key.

API-Keys werden ausschlieÃŸlich Ã¼ber `flutter_secure_storage` gespeichert. Sie gehÃ¶ren weder in Shared Preferences noch in Logs, `.env` oder Git.

### OpenAI

- Base URL: `https://api.openai.com/v1`
- Modell z. B.: `gpt-4o-mini` oder `gpt-4.1-mini`
- API-Key in der App unter **Mehr â†’ KI-Anbieter**

### OpenRouter

- Base URL: `https://openrouter.ai/api/v1`
- Modell: eine OpenRouter-Modell-ID
- Optional kÃ¶nnen notwendige Header im JSON-Feld **Extra-Header** ergÃ¤nzt werden.

### Google Gemini

- In **Mehr â†’ KI-Anbieter** das Preset **Google Gemini** auswÃ¤hlen.
- Base URL: `https://generativelanguage.googleapis.com/v1beta`
- Modell-Voreinstellung: `gemini-2.5-flash` (frei Ã¤nderbar)
- Foliant verwendet dafÃ¼r nativ `models/{model}:generateContent` und Ã¼bergibt den API-Key Ã¼ber `x-goog-api-key`.
- JSON-Import nutzt bei Gemini `responseMimeType: application/json`.

### Ollama / lokale Bridge

Foliant erwartet standardmÃ¤ÃŸig einen OpenAI-kompatiblen `chat/completions`-Endpunkt. Mit einer Ollama-/LM-Studio-Bridge kann z. B. eine lokale Base URL eingetragen werden. Auf einem echten Smartphone muss die URL vom GerÃ¤t aus erreichbar sein; `localhost` zeigt dort auf das Smartphone selbst.

### Antwortformat beim Vokabel-Import

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

Unsichere Ergebnisse werden im Review markiert. Der System-Prompt verlangt ausdrÃ¼cklich, keine fehlenden Paare zu erfinden.

## Architektur

Feature-first unter `lib/features/`:

- `learning/` â€“ Session, Tipp-Engine, Diff und SRS
- `library/` â€“ Sets
- `import/` â€“ Kamera, Crop, OCR, Textimport, Review
- `ai/` â€“ Provider-Konfiguration, OpenAI-kompatibler Client und nativer Google-Gemini-Adapter
- `settings/` â€“ persistente Lern-/Darstellungsregeln und JSON-Transfer
- `onboarding/` â€“ Sprache, Richtung, Tipp-Anteil, optionale KI

Gemeinsame Infrastruktur liegt unter `lib/core/`, Drift unter `lib/data/local/`. UI-Strings werden Ã¼ber Flutter ARB/l10n vorbereitet (`lib/l10n/`).

## Datenschutz / Secrets

- Kein API-Key wird committed.
- `.env` und typische Secret-/Keystore-Dateien sind in `.gitignore` ausgeschlossen.
- `.env.example` enthÃ¤lt nur Dokumentationswerte und wird von der App nicht als Key-Speicher verwendet.
- OCR lÃ¤uft lokal auf dem GerÃ¤t. Nur wenn der Nutzer bewusst einen KI-Pass ausfÃ¼hrt, wird der eingegebene/erkannte Text an den konfigurierten Anbieter gesendet.

## Release

Nach erfolgreichem lokalen Build und Tests:

```bash
gh auth status

gh repo create David-x3d/foliant \
  --public \
  --source=. \
  --remote=origin \
  --description "Foliant â€” Vokabeln aus Buchseiten. Karteikarten, Tipp-Schreibweise, KI-Import." \
  --push

git tag -a v0.1.0 -m "Foliant 0.1.0 â€” erste nutzbare Version"
git push origin v0.1.0
```

Release:

```bash
gh release create v0.1.0 \
  --title "Foliant 0.1.0" \
  --notes-file RELEASE_NOTES.md
```

## English

Foliant is a Flutter vocabulary app with flashcards, active typing practice, an SM-2-like SRS, camera/gallery import with on-device OCR, review-before-save, JSON backup/restore and optional configurable AI through an OpenAI-compatible Base URL. The app remains fully usable offline without an API key.

## Lizenz

MIT â€“ siehe [LICENSE](LICENSE).

**Autor:** David-x3d


