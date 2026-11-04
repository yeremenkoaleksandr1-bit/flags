import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val keyProperties = Properties().apply {
    val keyFile = file("key.properties")
    if (keyFile.exists()) {
        load(FileInputStream(keyFile))
    }
}

val envProperties = Properties().apply {
    val envFile = rootProject.file("../.env")
    if (envFile.exists()) {
        envFile.inputStream().use(::load)
    }
}

val storeFileStr = keyProperties["storeFile"] as String?
val configuredStoreFile = if (storeFileStr != null) file(storeFileStr) else null
val fallbackStoreFile = rootProject.file("keys/app")
val signingStoreFile =
    when {
        configuredStoreFile != null && configuredStoreFile.exists() -> configuredStoreFile
        fallbackStoreFile.exists() -> fallbackStoreFile
        else -> fallbackStoreFile
    }

android {
    namespace = "com.forceman.flagsup"
    compileSdk = 37
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
        create("release") {
            storeFile = signingStoreFile
            storePassword = keyProperties["storePassword"] as String? ?: ""
            keyAlias = keyProperties["keyAlias"] as String? ?: ""
            keyPassword = keyProperties["keyPassword"] as String? ?: ""
        }
    }

    buildTypes {
        getByName("release") {
            // нет настоящего ключа (android/keys/app) — тестовый APK
            // подписывается отладочным ключом; для Google Play нужен настоящий
            signingConfig =
                if (signingStoreFile.exists()) {
                    signingConfigs.getByName("release")
                } else {
                    logger.warn("Release keystore not found: signing with DEBUG key (test build only)")
                    signingConfigs.getByName("debug")
                }
            isMinifyEnabled = false
            isShrinkResources = false
        }

        getByName("debug") {
            // using default debug signing
        }
    }
}

flutter {
    source = "../.."
}
