import java.io.File
import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Load local.properties to detect SDK dir and whether requested NDK exists
val localProps = Properties().apply {
    val f = rootProject.file("local.properties")
    if (f.exists()) f.inputStream().use { this.load(it) }
}
val sdkDirFromLocal = localProps.getProperty("sdk.dir")
val requestedNdkVersion = flutter.ndkVersion

android {
    namespace = "com.example.new_task_manage"
    compileSdk = flutter.compileSdkVersion
    // Only pin the NDK if the requested version folder actually exists.
    // This avoids build failures on machines without the NDK installed.
    val sdkDir: File? = sdkDirFromLocal?.let { File(it) }
    val ndkFolder: File? = sdkDir?.let { File(it, "ndk/$requestedNdkVersion") }
    ndkFolder?.let { folder ->
        if (folder.resolve("source.properties").exists()) {
            ndkVersion = requestedNdkVersion
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.new_task_manage"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
