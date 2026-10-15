import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val signingProperties = Properties()
val signingFile = rootProject.file("key.properties")
if (signingFile.isFile) {
    signingFile.inputStream().use { signingProperties.load(it) }
}
val requiredSigningKeys = listOf("storeFile", "storePassword", "keyAlias", "keyPassword")
val hasReleaseSigning = requiredSigningKeys.all {
    !signingProperties.getProperty(it).isNullOrBlank()
}

// Release artifacts must never silently use the Android debug signing key.
val validateReleaseSigning = tasks.register("validateReleaseSigning") {
    doLast {
        check(hasReleaseSigning) {
            "Release signing is not configured. Complete android/key.properties " +
                "using key.properties.example and your private upload key. Use debug builds for local previews."
        }
        val keyFile = rootProject.file(signingProperties.getProperty("storeFile"))
        check(keyFile.isFile && keyFile.name != "debug.keystore") {
            "Release storeFile must point to your existing private upload keystore, not debug.keystore."
        }
        check(signingProperties.getProperty("keyAlias") != "androiddebugkey") {
            "The Android debug key cannot be used for release."
        }
    }
}

android {
    namespace = "dev.finstep.finstep"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // Confirm ownership/availability in Play Console before first publishing.
        applicationId = "dev.finstep.finstep"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (hasReleaseSigning) {
            create("release") {
                storeFile = rootProject.file(signingProperties.getProperty("storeFile"))
                storePassword = signingProperties.getProperty("storePassword")
                keyAlias = signingProperties.getProperty("keyAlias")
                keyPassword = signingProperties.getProperty("keyPassword")
            }
        }
    }

    buildTypes {
        release {
            signingConfig = if (hasReleaseSigning) signingConfigs.getByName("release") else null
        }
    }
}

tasks.matching { it.name == "preReleaseBuild" }.configureEach {
    dependsOn(validateReleaseSigning)
}

flutter {
    source = "../.."
}
