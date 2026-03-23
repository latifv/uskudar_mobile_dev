import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

val keystoreProperties = Properties().apply {
    val keystorePropertiesFile = rootProject.file("key.properties")
    if (keystorePropertiesFile.exists()) {
        load(FileInputStream(keystorePropertiesFile))
    }
}

android {
    namespace = "com.erpapay.payinall"
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    packagingOptions {
        pickFirst("lib/x86/libc++_shared.so")
        pickFirst("lib/x86_64/libc++_shared.so")
        pickFirst("lib/armeabi-v7a/libc++_shared.so")
        pickFirst("lib/arm64-v8a/libc++_shared.so")
        resources.excludes.add("META-INF/*")
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.erpapay.payinall"
        minSdk = flutter.minSdkVersion
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties.getProperty("keyAlias")
            keyPassword = keystoreProperties.getProperty("keyPassword")
            storeFile = file(keystoreProperties.getProperty("storeFile"))
            storePassword = keystoreProperties.getProperty("storePassword")
        }
    }

    buildTypes {
        getByName("debug") {
            isDebuggable = true
            signingConfig = signingConfigs.getByName("release")
            // proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
            resValue("string", "app_type", "debug")
        }
        
        getByName("profile") {
            // isMinifyEnabled = true
            isMinifyEnabled = false
            signingConfig = signingConfigs.getByName("release")
            // proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
            matchingFallbacks += listOf("debug")
            resValue("string", "app_type", "profile")
        }

        getByName("release") {
            // isMinifyEnabled = true
            isMinifyEnabled = false
            // isShrinkResources = true
            isShrinkResources = false
            // proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
            signingConfig = signingConfigs.getByName("release")
            resValue("string", "app_type", "release")
        }
    }

    flavorDimensions += "environment"
    productFlavors {
        create("development") {
            dimension = "environment"
            versionNameSuffix = "-dev"
            resValue("string", "app_env", "development")
        }
        
        create("qa") {
            dimension = "environment"
            versionNameSuffix = "-qa"
            resValue("string", "app_env", "qa")
        }
        
        create("production") {
            dimension = "environment"
            resValue("string", "app_env", "production")
        }
    }

    lintOptions {
        disable.addAll(setOf("InvalidPackage", "Instantiatable"))
        isCheckReleaseBuilds = false
        isAbortOnError = false
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
    implementation(kotlin("stdlib"))
    implementation("androidx.multidex:multidex:2.0.1")
    implementation("com.arksigner:liveauth:2.3.2.1@aar") { isTransitive = true }
    implementation("androidx.constraintlayout:constraintlayout:2.1.4")
    implementation("com.airbnb.android:lottie:6.2.0")

    constraints {
        implementation("com.huawei.hms:ml-computer-vision-face:3.17.11.303")
        implementation("com.huawei.hms:ml-computer-vision-face-base:3.17.11.303")
        implementation("com.huawei.hms:ml-computer-vision-face-feature-model:3.17.11.303")
        implementation("com.huawei.hms:ml-computer-vision-face-emotion-model:3.17.11.303")
        implementation("com.huawei.hms:ml-computer-vision-face-shape-point-model:3.17.11.303")
        implementation("com.huawei.hms:ml-computer-vision-ocr:3.17.11.304")
        implementation("com.huawei.hms:ml-computer-vision-ocr-base:3.17.11.304")
        implementation("com.huawei.hms:ml-computer-vision-ocr-latin-model:3.17.11.304")
    }
}
