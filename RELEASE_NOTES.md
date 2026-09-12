# Foliant 0.1.1

This update fixes the crash after photographing a book page, improves Gemini support, and makes German learning controls easier to read.

## Fixed
- Fixed the Android crash when opening the crop screen after taking a photo or selecting an image.
- Camera initialization, capture and cleanup now run in sequence, including when the app is paused or resumed.
- Capture and flash errors are handled in the app, with a retry option.
- Cancelling the crop screen stops the import.
- Fixed Gemini connection tests running out of output tokens before producing an answer.
- Gemini imports now ignore thought summaries and report truncated, blocked, malformed and timed-out responses clearly.
- Base URLs and full API URLs are accepted without duplicating endpoint paths.
- Fixed release APK shrinking with the optional ML Kit recognizers.

## Changed
- Integrated full-screen camera with live preview, framing grid, flash and shutter controls. Photos are taken inside Foliant.
- AI settings now contain only four fields: API endpoint, URL, model and API key. Existing Gemini settings and saved keys are preserved.
- German flashcard ratings now read "Nicht gewusst", "Unsicher" and "Gewusst".
- Learning mode choices wrap as whole buttons instead of breaking their labels across several lines.

## Installation
Download Foliant-0.1.1.apk below and install it over version 0.1.0. Requires Android 7.0 or later. The APK uses the existing development signing key.

## Validation
- Flutter static analysis and 34 automated tests passed.
- Gemini requests and responses were tested with simulated API responses; no live API key was provided.
