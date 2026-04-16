---
description: How to detect new assets and register them in the image resource resolver
---

# Asset Detection and Registration Workflow

This workflow guides you through detecting new assets in the project and properly registering them
in the image resource resolver system.

## Step 1: Detect New Assets

### Check the assets directory for new files:

```bash
ls -lh assets/images/
ls -lh assets/icons/
```

### Identify new assets by:

- File modification dates
- Files not yet registered in `ImageResourceResolver`
- User mentions of new assets

## Step 2: Determine Asset Type

### Identify the file extension:

- **PNG files** → Use `PNGImageResource`
- **SVG files** → Use `SVGImageResource`
- **Other formats** → May need new resource class

### Categorize the asset purpose:

- **Icons** → Place in `assets/icons/`
- **Images** → Place in `assets/images/`
- **Backgrounds** → Place in `assets/images/`
- **Logos/Branding** → Place in `assets/images/`

## Step 3: Register Asset in ImageResourceResolver

### Open the image resource resolver:

```
lib/core/resources/asset_resolver/image_resource_resolver.dart
```

### Add the asset getter following the existing pattern:

#### For PNG Images:

```dart
static PNGImageResource get assetName =>
    const PNGImageResource('$imageBasePath/filename.png');
```

#### For SVG Images:

```dart
static SVGImageResource get assetName =>
    SVGImageResource('$iconBasePath/filename.svg');
```

### Naming Conventions:

- Use **camelCase** for getter names
- Use descriptive names (e.g., `pregnancyCareBg`, `icNutrition`)
- Prefix icons with `ic` (e.g., `icFever`, `icHeartEcg`)
- Suffix backgrounds with `Bg` (e.g., `babyCareBg`, `parentCareBg`)

### Group Related Assets:

Add comments to organize assets by category:

```dart
// Care Category Backgrounds
static SVGImageResource get pregnancyCareBg =>
    SVGImageResource('$imageBasePath/pregnancy_care_bgare.svg');

static SVGImageResource get babyCareBg =>
    SVGImageResource('$imageBasePath/baby_care_bg.svg');
```

## Step 4: Use the Registered Asset

### Import the resolver:

```dart
import 'package:fit_care_360/core/resources/asset_resolver/image_resource_resolver.dart';
```

### Access the asset:

```dart
final backgroundImage = ImageResourceResolver.pregnancyCareBg;
```

### Display the asset:

```dart
// As a widget
ImageResourceResolver.pregnancyCareBg.getImageWidget(
  width: 100,
  height: 100,
  boxFit: BoxFit.cover,
)

// Get the path
final path = ImageResourceResolver.pregnancyCareBg.getPath;
```

## Step 5: Common Use Cases

### Background Images with Opacity:

```dart
Positioned(
  top: 0,
  right: 0,
  child: SizedBox(
    width: MediaQuery.of(context).size.width * 0.5,
    height: double.infinity,
    child: Opacity(
      opacity: 0.1, // 10% opacity
      child: ImageResourceResolver.pregnancyCareBg.getImageWidget(
        boxFit: BoxFit.cover,
      ),
    ),
  ),
)
```

### Icons with Custom Color:

```dart
ImageResourceResolver.icNutrition.getImageWidget(
  width: 24,
  height: 24,
  color: AppColors.primary,
)
```

### Full-width Images:

```dart
ImageResourceResolver.fitCareTextLogo.getImageWidget(
  width: double.infinity,
  boxFit: BoxFit.contain,
)
```

## Step 6: Verify Registration

### Run Flutter analyze:

```bash
fvm flutter analyze --no-fatal-infos
```

### Check for:

- No unused imports
- No undefined references
- Proper asset paths

### Test in the app:

- Hot reload/restart the app
- Verify assets display correctly
- Check for any runtime errors

## Asset Path Constants

The resolver uses these base paths:

```dart
const String assetBasePath = 'assets';
const String imageBasePath = '$assetBasePath/images';
const String iconBasePath = '$assetBasePath/icons';
```

## Example: Complete Asset Registration

### 1. New asset added:

```
assets/images/pregnancy_care_bgare.svg
```

### 2. Register in ImageResourceResolver:

```dart
// Care Category Backgrounds
static SVGImageResource get pregnancyCareBg =>
    SVGImageResource('$imageBasePath/pregnancy_care_bgare.svg');
```

### 3. Use in component:

```dart
SVGImageResource _getBackgroundImage() {
  switch (category.type) {
    case CareCategoryType.pregnancy:
      return ImageResourceResolver.pregnancyCareBg;
    // ...
  }
}

// In build method
backgroundImage.getImageWidget(boxFit: BoxFit.cover)
```

## Best Practices

1. **Always use ImageResourceResolver** - Never hardcode asset paths
2. **Group related assets** - Use comments to organize by feature/category
3. **Follow naming conventions** - Consistent naming makes assets easy to find
4. **Test immediately** - Verify assets work after registration
5. **Clean up unused assets** - Remove old assets that are no longer needed
6. **Document special assets** - Add comments for complex usage patterns

## Troubleshooting

### Asset not displaying:

- Check file path matches exactly (case-sensitive)
- Verify file exists in assets directory
- Run `fvm flutter clean` and rebuild
- Check pubspec.yaml includes asset directory

### Import errors:

- Ensure ImageResourceResolver is imported
- Check for typos in getter name
- Verify asset type (PNG vs SVG)

### Runtime errors:

- Check asset file is not corrupted
- Verify SVG is valid (use online validator)
- Ensure PNG dimensions are reasonable
