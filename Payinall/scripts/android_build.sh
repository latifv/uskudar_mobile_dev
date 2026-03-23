#!/bin/bash
# Android build için kullanın ana dizinde çalıştırın: sh scripts/android_build.sh
# Macos cihazlarda gradlew clean yapılınca hata verebiliyor önemli olan çıktı vermesi!

ANDROID_DIR="android"

clean_flutter() {
    if [ -f "pubspec.yaml" ]; then
        echo "Flutter temizliği yapılıyor..."
        flutter clean
        rm -f pubspec.lock
    else
        echo "Flutter projesi bulunamadı!"
        exit 1
    fi
}

clean_android() {
    echo "Android temizliği yapılıyor..."
    
    if [ -d "$ANDROID_DIR" ]; then
        cd "$ANDROID_DIR"
        ./gradlew clean
        
        cd ".."
    else
        echo "Android klasörü bulunamadı!"
        exit 1
    fi
}

prompt_version_info() {
    echo "Version Number ve Version Name pubspec.yaml'den ayarlayınız"
}

prompt_build_type() {
    echo "Hangi derleme ortamını kullanmak istiyorsunuz?"
    echo "1) Debug (Development)"
    echo "2) Profile (Test)"
    echo "3) Release (Production)"
    read choice
    
    case $choice in
        1)
            buildType="debug"
            flavor="development"
            ;;
        2)
            buildType="profile"
            flavor="qa"
            ;;
        3)
            buildType="release"
            flavor="production"
            ;;
        *)
            echo "Geçersiz seçim. Varsayılan olarak Debug (Development) kullanılacak."
            buildType="debug"
            flavor="development"
            ;;
    esac
}

prompt_output_type() {
    echo "Hangi çıktı tipini kullanmak istiyorsunuz?"
    echo "1) APK"
    echo "2) AAB"
    read outputChoice
        
    case $outputChoice in
        1)
            outputType="apk"
            ;;
        2)
            outputType="aab"
            ;;
        *)
            echo "Geçersiz seçim. Varsayılan olarak APK kullanılacak."
            outputType="apk"
            ;;
    esac
}

build_flutter() {
    echo "Flutter pub get yapılıyor..."
    flutter pub get
    
    if [ $? -ne 0 ]; then
        echo "Flutter pub get başarısız! Script sonlandırılıyor."
        exit 1
    fi
    
    echo "Flutter Android $buildType ($flavor) build başlatılıyor..."
    
    if [ "$outputType" == "aab" ]; then
        if [ "$buildType" == "release" ]; then
            echo "Google Play Store için production build oluşturuluyor..."
            flutter build appbundle --release --flavor $flavor --dart-define=ENVIRONMENT=production
        else
            flutter build appbundle --$buildType --flavor $flavor --dart-define=ENVIRONMENT=${buildType}
        fi
    else
        if [ "$buildType" == "release" ]; then
            flutter build apk --release --flavor $flavor --dart-define=ENVIRONMENT=production
        else
            flutter build apk --$buildType --flavor $flavor --dart-define=ENVIRONMENT=${buildType}
        fi
    fi
    
    if [ $? -ne 0 ]; then
        exit 1
    fi
}

show_output_path() {
    local base_path="build/app/outputs"
    
    if [ "$outputType" == "apk" ]; then
        echo "APK yolu: $base_path/flutter-apk/app-$flavor-$buildType.apk"
    elif [ "$outputType" == "aab" ]; then
        echo "AAB yolu: $base_path/bundle/$flavor$buildType/app-$flavor-$buildType.aab"
    fi
}

main() {
    clean_flutter
    clean_android
    prompt_version_info
    prompt_build_type
    prompt_output_type
    build_flutter
    show_output_path
}

main
