# StuffWithFantasy Flutter App

## Project Overview

Flutter app for the StuffWithFantasy fantasy book discovery platform. The branding, colors, typography, and component patterns are pulled from the main website (stuffwithfantasy.com).

## Style & Branding

Run `/styleguide` to see the full visual style guide covering colors, typography, component patterns, spacing, and do/don't rules.

Key files:
- `lib/src/theme/swf_colors.dart` — all brand color constants
- `lib/src/theme/swf_typography.dart` — font stack (Playfair Display + Inter via google_fonts)
- `lib/src/theme/app_theme.dart` — light/dark ThemeData
- `assets/images/swf_logo_cream.svg` — brand logo (cream, transparent background)
- `assets/images/swf_logo_plum.svg` — brand logo (cream on plum background)

## Architecture

- Feature-based structure under `lib/src/` (e.g., `catalog/`, `home/`)
- Each feature has `models/`, `data/` (repositories), `presentation/`, and `presentation/widgets/`
- Theme config lives in `lib/src/theme/`
- Networking layer lives in `lib/src/api/`
- Entry point: `lib/main.dart` → `lib/src/app.dart`

## Networking

The app talks to the stuffwithfantasy.com API. The networking layer follows this stack:

```
Widget → Repository → ApiClient → http
```

### Key files
- `lib/src/api/api_client.dart` — HTTP client with envelope parsing, typed errors
- `lib/src/api/api_result.dart` — `ApiResult<T>` sealed union (Success | Failure)
- `lib/src/api/paginated.dart` — `Paginated<T>` wrapper for paginated responses
- `lib/src/api/api_config.dart` — base URL config (override via `--dart-define=API_BASE_URL=...`)
- `lib/src/api/service_locator.dart` — simple DI, initialized in `main()`

### Patterns
- **All API calls return `ApiResult<T>`** — never throw, always pattern-match with `.when()`
- **Repositories own business logic** — widgets never call ApiClient directly
- **Taxonomy is fetched once and cached** in `BookRepository` — ObjectId→name lookup
- **Pagination** — catalog uses infinite scroll via `Paginated<Book>` from POST `/api/filter/books/all`
- **JSON parsing** — manual `fromJson` factories on models, no code generation
- **The API envelope** is `{ success: true, data: T }` / `{ error: "message" }` — ApiClient handles this

### API base URL
- Production: `https://stuffwithfantasy.com` (default)
- Dev: override with `flutter run --dart-define=API_BASE_URL=http://localhost:3000`

## Commands

- `flutter analyze` — lint check
- `flutter test` — run widget tests
- `flutter run` — launch app
- `flutter run --dart-define=API_BASE_URL=http://localhost:3000` — run against local backend

## Conventions

- Use `SwfColors.*` constants — never hardcode hex values
- Use `theme.textTheme.*` — never construct TextStyle from scratch
- Prefer `const` constructors where possible
- Use package imports (`package:swf_app/...`) not relative imports
- All widgets should support both light and dark themes
- All API calls return `ApiResult<T>` — handle both branches
- Repositories are the only layer that talks to `ApiClient`
- Models have `fromJson` factories — keep parsing logic out of repositories/widgets
