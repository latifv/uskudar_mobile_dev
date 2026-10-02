#!/bin/bash
# Ana dizinde çalıştırın: sh scripts/android_deep_clean.sh

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

setup_dependencies() {
    echo "Dependencies kuruluyor..."
    
    if [ -f "pubspec.yaml" ]; then
        flutter pub get
    else
        echo "Flutter projesi bulunamadı!"
        exit 1
    fi
}

main() {
    clean_flutter
    clean_android
    setup_dependencies
}

main