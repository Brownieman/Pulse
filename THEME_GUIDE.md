# Theme System Guide

## Overview
The app now has a fully functional theme system that supports:
- **Light Mode**: Bright, clean interface
- **Dark Mode**: Easy on the eyes
- **System Default**: Automatically follows device settings
- **Custom Accent Colors**: Blue, Purple, Green, Orange

## How to Use Theme Colors in Your Code

### ✅ DO: Use Theme Colors

Instead of hardcoded colors like `Color(0xFF2196F3)`, always use theme colors:

```dart
// Get the color scheme
final colorScheme = Theme.of(context).colorScheme;

// Use theme colors
Container(
  color: colorScheme.background,
  child: Text(
    'Hello',
    style: TextStyle(color: colorScheme.onBackground),
  ),
)
```

### Available Theme Colors

#### Background Colors
- `colorScheme.background` - Main background color
- `colorScheme.surface` - Card/surface background color

#### Text Colors
- `colorScheme.onBackground` - Text on background
- `colorScheme.onSurface` - Text on surface/cards
- `colorScheme.onPrimary` - Text on primary color (usually white)

#### Accent Colors
- `colorScheme.primary` - Main accent color (changes with user selection)
- `colorScheme.secondary` - Secondary accent color

#### Opacity Variants
For subtle text or borders:
```dart
colorScheme.onSurface.withOpacity(0.7)  // 70% opacity
colorScheme.onSurface.withOpacity(0.5)  // 50% opacity
colorScheme.primary.withOpacity(0.3)    // 30% opacity for borders
```

### Common Patterns

#### 1. Scaffold Background
```dart
Scaffold(
  backgroundColor: colorScheme.background,
  // ...
)
```

#### 2. AppBar
```dart
AppBar(
  backgroundColor: colorScheme.background,
  foregroundColor: colorScheme.onBackground,
  iconTheme: IconThemeData(color: colorScheme.primary),
  // ...
)
```

#### 3. Cards/Containers
```dart
Container(
  decoration: BoxDecoration(
    color: colorScheme.surface,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: colorScheme.primary.withOpacity(0.3),
    ),
  ),
  // ...
)
```

#### 4. Text Fields
```dart
TextFormField(
  style: TextStyle(color: colorScheme.onSurface),
  decoration: InputDecoration(
    labelStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.7)),
    filled: true,
    fillColor: colorScheme.surface,
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: colorScheme.primary, width: 2),
    ),
  ),
)
```

#### 5. Buttons
```dart
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: colorScheme.primary,
    foregroundColor: Colors.white,
  ),
  // ...
)
```

#### 6. Gradients with Theme Colors
```dart
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [
        colorScheme.primary,
        colorScheme.primary.withOpacity(0.8),
      ],
    ),
  ),
)
```

## Using Theme Extensions

For convenience, you can use the `ThemeExtensions` helper:

```dart
import 'package:talkzy_beta1/utils/theme_extensions.dart';

// Then use context extensions
Container(
  color: context.backgroundColor,
  child: Text(
    'Hello',
    style: TextStyle(color: context.textColor),
  ),
)
```

Available extensions:
- `context.backgroundColor`
- `context.surfaceColor`
- `context.primaryColor`
- `context.textColor`
- `context.subtextColor`
- `context.isDarkMode`

## Changing Theme

Users can change the theme from Settings > App Theme:

### Programmatically Change Theme
```dart
final themeController = Get.find<ThemeController>();

// Change theme mode
themeController.setThemeMode(ThemeMode.dark);
themeController.setThemeMode(ThemeMode.light);
themeController.setThemeMode(ThemeMode.system);

// Change accent color
themeController.setAccentColor('blue');
themeController.setAccentColor('purple');
themeController.setAccentColor('green');
themeController.setAccentColor('orange');
```

## Migration Guide

### Converting Hardcoded Colors

❌ **Before:**
```dart
Container(
  color: const Color(0xFF0A1021),
  child: Text(
    'Hello',
    style: const TextStyle(color: Colors.white),
  ),
)
```

✅ **After:**
```dart
Container(
  color: colorScheme.background,
  child: Text(
    'Hello',
    style: TextStyle(color: colorScheme.onBackground),
  ),
)
```

### Common Color Replacements

| Hardcoded Color | Theme Equivalent |
|----------------|------------------|
| `Color(0xFF0A1021)` | `colorScheme.background` |
| `Color(0xFF1C2439)` | `colorScheme.surface` |
| `Color(0xFF2196F3)` | `colorScheme.primary` |
| `Colors.white` (on dark bg) | `colorScheme.onBackground` |
| `Color(0xFF90CAF9)` | `colorScheme.onBackground.withOpacity(0.7)` |
| `Color(0xFF64748B)` | `colorScheme.onSurface.withOpacity(0.5)` |

## Theme Configuration

The theme is configured in:
- **Controller**: `lib/controllers/theme_controller.dart`
- **Theme Definition**: `lib/utils/app_theme.dart`
- **Settings UI**: `lib/screens/settings/theme_settings_screen.dart`

### Adding New Accent Colors

1. Add color constant in `app_theme.dart`:
```dart
static const Color redAccent = Color(0xFFF44336);
```

2. Update `getAccentColor` method:
```dart
case 'red':
  return redAccent;
```

3. Add color option in `theme_settings_screen.dart`:
```dart
_buildColorOption(
  color: const Color(0xFFF44336),
  label: 'Red',
  value: 'red',
  currentValue: controller.accentColor,
  onTap: () => controller.setAccentColor('red'),
),
```

## Best Practices

1. **Always use theme colors** - Never hardcode colors
2. **Test both themes** - Ensure your UI looks good in light and dark mode
3. **Use opacity for hierarchy** - Use `.withOpacity()` for secondary text
4. **Respect user preferences** - Don't override theme colors
5. **Use semantic colors** - Use `primary` for actions, `surface` for cards, etc.

## Troubleshooting

### Theme not updating?
- Make sure you're using `Obx()` or `GetBuilder()` for reactive updates
- Check that `ThemeController` is initialized in `main.dart`

### Colors look wrong?
- Verify you're using `colorScheme` from `Theme.of(context)`
- Check if you're using the correct color property (e.g., `onBackground` vs `onSurface`)

### System theme not working?
- Ensure `ThemeMode.system` is set
- Check device system settings

## Examples

See these files for complete examples:
- `lib/screens/auth_screen.dart` - Auth UI with theme
- `lib/screens/settings/theme_settings_screen.dart` - Theme settings
- `lib/screens/settings_screen.dart` - Settings with theme
