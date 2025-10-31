# Quick Theme Reference Card

## 🚀 Quick Start

### Get Theme Colors
```dart
final colorScheme = Theme.of(context).colorScheme;
```

### Or Use Helper (Easier!)
```dart
// Import the helper
import 'package:talkzy_beta1/utils/theme_colors_helper.dart';

// Use it
Container(
  color: context.colors.background,
  child: Text('Hello', style: context.colors.heading1),
)
```

## 📋 Common Replacements

### Background & Surface
```dart
// ❌ Before
color: const Color(0xFF0A1021)
color: const Color(0xFF1C2439)

// ✅ After
color: colorScheme.background
color: colorScheme.surface
```

### Text Colors
```dart
// ❌ Before
color: Colors.white
color: const Color(0xFF90CAF9)
color: const Color(0xFF64748B)

// ✅ After
color: colorScheme.onBackground
color: colorScheme.onBackground.withOpacity(0.7)
color: colorScheme.onSurface.withOpacity(0.5)
```

### Primary/Accent Color
```dart
// ❌ Before
color: const Color(0xFF2196F3)
color: const Color(0xFF9C27B0)

// ✅ After
color: colorScheme.primary  // Changes with user selection!
```

### Borders & Dividers
```dart
// ❌ Before
border: Border.all(color: const Color(0xFF2D3548))
Divider(color: const Color(0xFF2C2C30))

// ✅ After
border: Border.all(color: colorScheme.onSurface.withOpacity(0.1))
Divider(color: colorScheme.onSurface.withOpacity(0.2))
```

## 🎨 Color Palette

### Available Colors
| Color | Usage |
|-------|-------|
| `colorScheme.background` | Main screen background |
| `colorScheme.surface` | Cards, dialogs, surfaces |
| `colorScheme.primary` | Accent color (user selectable) |
| `colorScheme.onBackground` | Text on background |
| `colorScheme.onSurface` | Text on cards/surfaces |
| `colorScheme.onPrimary` | Text on primary (white) |

### Opacity Levels
| Opacity | Usage | Example |
|---------|-------|---------|
| 1.0 (100%) | Primary text | Headings, important text |
| 0.7 (70%) | Secondary text | Subtitles, descriptions |
| 0.5 (50%) | Tertiary text | Hints, placeholders |
| 0.3 (30%) | Borders (primary) | Focused borders |
| 0.2 (20%) | Borders (normal) | Card borders |
| 0.1 (10%) | Subtle borders | Dividers |

## 🔧 Common Patterns

### Scaffold
```dart
Scaffold(
  backgroundColor: colorScheme.background,
  appBar: AppBar(
    backgroundColor: colorScheme.background,
    foregroundColor: colorScheme.onBackground,
  ),
)
```

### Card
```dart
Container(
  decoration: BoxDecoration(
    color: colorScheme.surface,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: colorScheme.onSurface.withOpacity(0.1),
    ),
  ),
)
```

### Text Field
```dart
TextFormField(
  style: TextStyle(color: colorScheme.onSurface),
  decoration: InputDecoration(
    fillColor: colorScheme.surface,
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: colorScheme.primary, width: 2),
    ),
  ),
)
```

### Button with Gradient
```dart
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [
        colorScheme.primary,
        colorScheme.primary.withOpacity(0.8),
      ],
    ),
    borderRadius: BorderRadius.circular(12),
  ),
)
```

## 🎯 Using the Helper

### Import
```dart
import 'package:talkzy_beta1/utils/theme_colors_helper.dart';
```

### Quick Access
```dart
// Colors
context.colors.background
context.colors.surface
context.colors.primary
context.colors.textPrimary
context.colors.textSecondary
context.colors.border

// Decorations
context.colors.cardDecoration()
context.colors.primaryCardDecoration()
context.colors.gradientDecoration()

// Text Styles
context.colors.heading1
context.colors.heading2
context.colors.bodyLarge
context.colors.caption
```

## 📱 Test Your Changes

After updating colors:
1. Run the app
2. Go to Settings > App Theme
3. Switch between Light/Dark modes
4. Change accent colors
5. Verify your screen looks good in all combinations

## 🆘 Troubleshooting

### Colors not updating?
- Make sure you're using `colorScheme` from `Theme.of(context)`
- Don't use `const` with theme colors
- Rebuild the widget when theme changes

### Wrong colors showing?
- Check if you're using `onBackground` vs `onSurface`
- Verify opacity levels
- Ensure you're not mixing hardcoded colors

### Theme not persisting?
- Check `ThemeController` is initialized
- Verify SharedPreferences is working
- Look for errors in console

## 💡 Pro Tips

1. **Use the helper** - `context.colors` is faster than `Theme.of(context).colorScheme`
2. **Test both themes** - Always check light and dark mode
3. **Use semantic names** - `primary` not `blue`, `surface` not `card`
4. **Consistent opacity** - Stick to 0.7, 0.5, 0.3, 0.2, 0.1
5. **Avoid const** - Theme colors can't be const

## 📚 More Info

- Full guide: `THEME_GUIDE.md`
- Implementation details: `THEME_IMPLEMENTATION_SUMMARY.md`
- Helper code: `lib/utils/theme_colors_helper.dart`

---

**Quick Example - Before & After:**

```dart
// ❌ BEFORE (Hardcoded)
Container(
  color: const Color(0xFF1C2439),
  child: Text(
    'Hello',
    style: const TextStyle(color: Colors.white),
  ),
)

// ✅ AFTER (Theme-aware)
Container(
  color: colorScheme.surface,
  child: Text(
    'Hello',
    style: TextStyle(color: colorScheme.onSurface),
  ),
)

// 🚀 BEST (Using helper)
Container(
  color: context.colors.surface,
  child: Text('Hello', style: context.colors.heading2),
)
```
