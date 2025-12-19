# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Flutter learning project for image picking and editing ("Edit Snap"). Uses fvm for Flutter version management.

- Flutter 3.38.1 / Dart 3.10.0
- Localization: Japanese (l10n with ARB files)

## Common Commands

```bash
# Run the app
fvm flutter run

# Get dependencies
fvm flutter pub get

# Generate localization files
fvm flutter gen-l10n

# Analyze code
fvm flutter analyze
```

## Architecture

Simple two-screen Flutter app:
- `main.dart` - App entry point with MaterialApp and l10n configuration
- `start_screen.dart` - Initial screen with navigation to image selection
- `iamge_select_screen.dart` - Image picker with resize functionality using `image` package

## Localization

- Template ARB file: `lib/l10n/app_ja.arb`
- Generated class: `L10n` (non-nullable getter)
- Access via `L10n.of(context)`
- Run `fvm flutter gen-l10n` after modifying ARB files

## Key Dependencies

- `image_picker` - Device image selection
- `image` - Image processing/resizing
- `flutter_localizations` / `intl` - i18n support

**ファイル参照機能**
Flutterアプリのルール @flutter_app/CLAUDE.md
