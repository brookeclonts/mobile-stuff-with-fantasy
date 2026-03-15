# StuffWithFantasy

A fresh Flutter baseline for the StuffWithFantasy product.

## Included

- Flutter 3.41 / Dart 3.11 starter scaffold
- Material 3 app shell with light and dark themes
- Stricter analyzer settings on top of `flutter_lints`
- A widget test to protect the initial UX

## Run it

```bash
flutter pub get
flutter run
```

## Structure

- `lib/main.dart`: thin entrypoint
- `lib/src/app.dart`: app wiring
- `lib/src/theme/`: brand colors, typography, and theme configuration
- `lib/src/home/presentation/home_page.dart`: starter screen

## Backend

- The backend for this app lives in the sibling repository at `../stuffwithfantasy`.
- The mobile app is expected to drive its catalog, taxonomy, and filtering behavior from that backend contract rather than from hardcoded local data.
- If changes are needed there, treat them as backend changes in a different workspace/repo even though they support this app directly.
