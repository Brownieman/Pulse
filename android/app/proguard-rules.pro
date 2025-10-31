# ProGuard rules for Pulse App
# This file helps reduce app size by removing unused code and obfuscating classes

# Keep Flutter-specific classes and methods
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep Firebase classes
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-keep interface com.google.android.gms.** { *; }

# Keep Supabase classes
-keep class com.supabase.** { *; }
-keep class io.supabase.** { *; }

# Keep GetX classes
-keep class com.core.get.** { *; }

# Keep model classes (add your app's model package)
-keep class com.example.pulse_main.models.** { *; }
-keep class com.example.pulse_main.controllers.** { *; }
-keep class com.example.pulse_main.services.** { *; }

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep view constructors for inflation from XML
-keepclasseswithmembers class * {
    public <init>(android.content.Context, android.util.AttributeSet);
}

# Keep R classes
-keepclassmembers class **.R$* {
    public static <fields>;
}

# Remove logging
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
    public static *** i(...);
}

# Optimization flags
-optimizationpasses 5
-dontusemixedcaseclassnames
-verbose

# Remove unused resources
-dontshrink

# Keep Dart runtime classes
-keep class dart.** { *; }

# JSON parsing (if using any JSON libraries)
-keep class com.google.gson.** { *; }

# Keep exception classes
-keep public class * extends java.lang.Exception
-keep public class * extends java.lang.Throwable

# Keep classes with annotations
-keepclasseswithmembers class * {
    @*.** <methods>;
}
