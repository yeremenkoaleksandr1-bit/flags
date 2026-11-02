import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// key.properties is not committed (see .gitignore). When it is missing
// (e.g. on CI or a fresh clone) builds fall back to the default debug key.
val keyPropertiesFile = file("key.properties")
val keyProperties = Properties().apply {
    if (keyPropertiesFile.exists()) {
        keyPropertiesFile.inputStream().use(::load)
    }
}
val hasReleaseKey = keyPropertiesFile.exists()

val envProperties = Properties().apply {
    val envFile = rootProject.file("../.env")
    if (envFile.exists()) {
        envFile.inputStream().use(::load)
    }
}

android {
    namespace = "com.forceman.flagsup"
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_1_8.toString()
    }

    defaultConfig {
        applicationId = "com.forceman.flagsup"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        manifestPlaceholders["admobAppId"] =
            envProperties.getProperty(
                "ADMOB_ANDROID_APP_ID",
                "ca-app-pub-3940256099942544~3347511713",
            )
    }

    signingConfigs {
        if (hasReleaseKey) {
            create("release") {
                val configuredStoreFile = file(keyProperties["storeFile"] as String)
                val fallbackStoreFile = rootProject.file("keys/app")
                storeFile =
                    if (configuredStoreFile.exists() || !fallbackStoreFile.exists()) {
                        configuredStoreFile
                    } else {
                        fallbackStoreFile
                    }
                storePassword = keyProperties["storePassword"] as String
                keyAlias = keyProperties["keyAlias"] as String
                keyPassword = keyProperties["keyPassword"] as String
            }
        }
    }

    // Store native libs (libflutter.so, libapp.so) compressed inside the APK.
    // AGP stores them uncompressed by default, which makes the APK ~10 MB bigger;
    // Android extracts them on install instead.
    packaging {
        jniLibs {
            useLegacyPackaging = true
        }
    }

    buildTypes {
        val appSigning =
            if (hasReleaseKey) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }

        getByName("release") {
            signingConfig = appSigning
            isMinifyEnabled = false
            isShrinkResources = false
        }

        getByName("debug") {
            signingConfig = appSigning
        }
    }
}

flutter {
    source = "../.."
}
