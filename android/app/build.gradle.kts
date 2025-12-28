plugins {
    id("com.android.application")
    id("kotlin-android")
    // Flutter Gradle 插件必须在 Android 和 Kotlin 插件之后应用
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    // 这里的 namespace 需与你项目实际一致
    namespace = "com.example.my_diary_demo"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    // 【核心修复内容】：开启 buildConfig 字段生成功能
    buildFeatures {
        buildConfig = true
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.my_diary_demo"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}