plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

android {
    namespace = "com.mycollege.app"
    compileSdk = 35
    // ИЗМЕНЕНИЕ 1: Указываем версию NDK явно
    ndkVersion = "27.0.12077973" // Было: flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.mycollege.app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.

        // ИЗМЕНЕНИЕ 2: Указываем minSdkVersion явно
        minSdk = 24

        targetSdk = 35
        versionCode = flutter.versionCode.toInt() // Добавил .toInt(), т.к. versionCode должен быть Int
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

dependencies {
    implementation(platform("com.google.firebase:firebase-bom:32.7.4"))
    implementation("com.google.firebase:firebase-analytics")
    // Убедитесь, что здесь есть зависимости Firebase, которые вы используете
    implementation("com.google.firebase:firebase-auth") // Например, Auth
    implementation("com.google.firebase:firebase-firestore") // Например, Firestore
    implementation("com.google.android.gms:play-services-auth:20.7.0")
}

flutter {
    source = "../.."
}