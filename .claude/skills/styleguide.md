---
name: styleguide
description: StuffWithFantasy visual style guide — brand colors, typography, component patterns, and design rules for the Flutter app.
user_invocable: true
---

# StuffWithFantasy Style Guide

Use this guide when building or reviewing any UI in the swf-app Flutter project. All new screens, widgets, and components must follow these rules to maintain visual consistency with the stuffwithfantasy.com website.

---

## Brand Origin

This app mirrors the branding of **stuffwithfantasy.com**, a fantasy book discovery platform. The visual identity is dark, romantic, and warm — built around deep navy and plum backgrounds with rose-pink and bronze-gold accents on cream-colored cards.

---

## Color Palette

All colors live in `lib/src/theme/swf_colors.dart`. Always use `SwfColors.*` constants — never hardcode hex values.

### Core Palette

| Token             | Hex       | Role                                      |
|-------------------|-----------|-------------------------------------------|
| `color1`          | `#3F3F3F` | General text (light mode)                 |
| `color2`          | `#382532` | Deep plum — app bars, nav bars, brand dark |
| `color3`          | `#59324C` | Dark purple — hover states, selected nav  |
| `color4`          | `#B96D9A` | Rose pink — **primary CTA**, links, focus  |
| `color5`          | `#DBD4CE` | Warm beige — card backgrounds (dark mode) |
| `color6`          | `#BC8D60` | Bronze/gold — **secondary accent**, KU badge, text buttons |
| `color7`          | `#1E364B` | Dark navy — **scaffold background** (dark mode) |
| `color8`          | `#EFEDE9` | Off-white/cream — **scaffold background** (light mode), text on dark |

### Grays

| Token         | Hex       | Role                  |
|---------------|-----------|---------------------- |
| `gray`        | `#2F2E2E` | Primary text (light)  |
| `mediumGray`  | `#464646` | Secondary text        |
| `lightGray`   | `#7E7E7E` | Tertiary/muted text   |

### Extended / Accent

| Token    | Hex       | Usage                          |
|----------|-----------|--------------------------------|
| `blue`   | `#82B1A1` | Tertiary accent                |
| `purple` | `#AF65AF` | Decorative accent              |
| `violet` | `#7C54C5` | Cover gradients, decorative    |
| `orange` | `#F3BD75` | Warm highlight                 |

### Semantic Aliases

Use these instead of raw `colorN` names when intent matters:

- `SwfColors.primaryBackground` → `color7` (dark navy)
- `SwfColors.lightBackground` → `color8` (cream)
- `SwfColors.cardBackground` → `color5` (beige)
- `SwfColors.primaryButton` → `color4` (rose pink)
- `SwfColors.secondaryAccent` → `color6` (bronze/gold)
- `SwfColors.brandDark` → `color2` (deep plum)
- `SwfColors.brandPurple` → `color3` (dark purple)

### Tag/Pill Backgrounds

| Token               | Hex       | Usage                     |
|----------------------|-----------|---------------------------|
| `spicinessPill`      | `#F5D0E8` | Spice level chips         |
| `representationPill` | `#D4E4F0` | Representation/age chips  |
| `tropePill`          | `#E8D5F0` | Trope/subgenre chips      |

---

## Typography

Defined in `lib/src/theme/swf_typography.dart`.

### Font Stack

| Role                     | Font              | Notes                          |
|--------------------------|-------------------|--------------------------------|
| Display / Headings       | Playfair Display  | Standing in for Adobe **Yana** |
| Titles / Body / Labels   | Inter             | Standing in for Adobe **Urbane Rounded** |

The website's primary fonts (Yana, Urbane Rounded) are Adobe Typekit licensed. We use Playfair Display and Inter via `google_fonts` as close stand-ins. If the `.ttf` files are added to `assets/fonts/`, update `pubspec.yaml` (commented-out font config is already there) and swap the `GoogleFonts.*` calls in `swf_typography.dart`.

### Text Style Mapping

| Material Style    | Font             | Weight | Usage                              |
|-------------------|------------------|--------|------------------------------------|
| `displayLarge`    | Playfair Display | 700    | Hero headings                      |
| `displayMedium`   | Playfair Display | 700    | Page titles                        |
| `displaySmall`    | Playfair Display | 600    | Section headings                   |
| `headlineLarge`   | Playfair Display | 600    | Feature headings                   |
| `headlineMedium`  | Playfair Display | 600    | Card headings                      |
| `headlineSmall`   | Playfair Display | 500    | App bar title, subtitles           |
| `titleLarge`      | Inter            | 600    | Card titles, list headers          |
| `titleMedium`     | Inter            | 600    | Book cover overlay text            |
| `titleSmall`      | Inter            | 500    | Book tile title, section labels    |
| `bodyLarge`       | Inter            | 400    | Primary body text                  |
| `bodyMedium`      | Inter            | 400    | Secondary body text                |
| `bodySmall`       | Inter            | 400    | Captions, author names (mediumGray)|
| `labelLarge`      | Inter            | 600    | Button text                        |
| `labelMedium`     | Inter            | 400    | Chip labels, metadata (mediumGray) |
| `labelSmall`      | Inter            | 400    | Badges, fine print (lightGray)     |

### Rules

- Always use `theme.textTheme.*` — never construct `TextStyle` from scratch.
- Override color with `.copyWith(color: ...)` when the semantic default doesn't match (e.g., light text on dark cover).
- Use `maxLines` + `TextOverflow.ellipsis` for any user-generated content.

---

## Theme Structure

Defined in `lib/src/theme/app_theme.dart`. Two variants: `AppTheme.light()` and `AppTheme.dark()`.

### Dark Mode (primary — matches the website)

- Scaffold: navy (`color7`)
- App bar / nav: deep plum (`color2`)
- Cards: warm beige (`color5`)
- Text on scaffold: cream (`color8`)
- Text on cards: dark charcoal (`gray`)

### Light Mode

- Scaffold: cream (`color8`)
- App bar / nav: deep plum (`color2`) — stays consistent
- Cards: white
- Text on scaffold: dark charcoal (`gray`)

### Shared Across Modes

- Primary CTA: rose pink (`color4`) — `ElevatedButton`, focus rings, links
- Secondary accent: bronze/gold (`color6`) — `TextButton`, KU badge, secondary actions
- Card radius: `12`
- Button radius: `8`
- Chip radius: `20` (fully rounded)
- Input border radius: `8`
- Input focus border: rose pink, 2px
- All navigation surfaces: deep plum (`color2`) background

---

## Component Patterns

### Book Tile (`BookTile`)

- `Card` with `Clip.antiAlias`
- 2:3 aspect ratio cover area with gradient placeholder (use brand color pairs from `_coverGradient`)
- When real images are available, use `Image.network` with a gradient fallback
- **KU badge**: top-right, bronze/gold (`color6`) background, white bold `labelSmall`
- **Audiobook badge**: top-left, `Colors.black45` background, white headphone icon (14px)
- Below cover: title (`titleSmall`, 2-line max), author (`bodySmall`, 1-line max), spice indicator + primary subgenre

### Spice Indicator

- Uses `Icons.local_fire_department` in rose pink (`color4`)
- Count = `SpiceLevel.index` (0 shows outlined/muted icon, 1-4 shows filled fire icons)
- Size: 14px per icon

### Filter Chips

- Use Material `FilterChip` with brand-specific `selectedColor`:
  - Spice filters: `spicinessPill` (`#F5D0E8`)
  - Trope/subgenre filters: `tropePill` (`#E8D5F0`)
  - Representation/age filters: `representationPill` (`#D4E4F0`)
- `checkmarkColor` should contrast with the pill background (use `color3` or `color4`)
- Quick-filter chips use `VisualDensity.compact`

### Bottom Sheets

- `DraggableScrollableSheet` with `initialChildSize: 0.85`
- Container with `surface` color, top border radius of 20
- Sticky header row: title (`titleLarge`), Reset `TextButton`, close `IconButton`
- Sticky bottom: full-width `ElevatedButton` with shadow, `32` bottom padding (safe area)
- Filter sections: title (`titleSmall`, weight 600), 8px gap, then `Wrap` of `FilterChip`s

### Empty States

- Centered column: 64px icon (muted `onSurfaceVariant`), title (`titleMedium`), optional action button
- If filters are active: show "Clear Filters" `OutlinedButton`

### Grid Layouts

- Responsive column count: 2 (phone), 3 (tablet >=600), 4 (desktop >=900)
- `childAspectRatio: 0.52` for book tiles
- Grid spacing: 12px cross-axis, 12px main-axis
- Outer padding: 16px horizontal, 24px bottom

---

## Spacing & Layout

| Value | Usage                              |
|-------|------------------------------------|
| `4`   | Tight inline spacing               |
| `8`   | Between related elements, chip gaps |
| `10`  | Card internal padding (tile info)  |
| `12`  | Grid gaps, between sections        |
| `16`  | Standard horizontal page padding, between buttons |
| `20`  | Card content padding, sheet section padding |
| `24`  | Between major sections             |
| `32`  | Page-level vertical padding, major breaks |
| `48`  | Large visual breaks                |

---

## Gradients

### Cover Placeholders

Six brand-pair gradients from `topLeft` to `bottomRight`:

1. `color2` → `color3` (plum → purple)
2. `color7` → `color3` (navy → purple)
3. `darkNavy` → `color4` (dark navy → rose)
4. `color3` → `violet` (purple → violet)
5. `color7` → `blue` (navy → teal)
6. `color2` → `color6` (plum → gold)

### Page Background Gradient (optional, for special screens)

```dart
LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    colorScheme.surface,
    colorScheme.surfaceContainerHighest,
    colorScheme.primaryContainer.withValues(alpha: 0.65),
  ],
)
```

---

## Iconography

- Use Material Icons (`Icons.*`) — the website does not use a custom icon set
- Icon sizes: 14px (inline/badges), 16px (chip avatars), 18px (list items), 20px (search/filter bar), 28px (card headers), 64px (empty states)
- Primary action icons: rose pink (`color4`)
- Secondary/decorative icons: bronze/gold (`color6`)
- Muted/inactive icons: `lightGray` or `colorScheme.outline`

---

## Logo

- Cream (transparent bg): `assets/images/swf_logo_cream.svg`
- Plum background: `assets/images/swf_logo_plum.svg`
- Render with `SvgPicture.asset` from `flutter_svg`
- App bar: height `38`
- Splash/hero usage: height `100-120`

---

## Do / Don't

**Do:**
- Use `Theme.of(context)` to pull colors and text styles
- Use `colorScheme.*` for semantic color access in widgets
- Use `SwfColors.*` when you need a specific brand constant (badges, gradients, overrides)
- Support both light and dark themes — test both
- Keep card content concise: truncate with `maxLines` + `TextOverflow.ellipsis`
- Use `LayoutBuilder` for responsive grid column counts

**Don't:**
- Hardcode hex color values in widget files
- Use `Colors.purple`, `Colors.pink` etc. — always use brand tokens
- Use Material default blue/indigo anywhere
- Create custom `TextStyle` from scratch — extend the theme's `textTheme`
- Use `Container` when `DecoratedBox` or `Padding` alone will do
- Add drop shadows to cards beyond the theme's `elevation: 2`
