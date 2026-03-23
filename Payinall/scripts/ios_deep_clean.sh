#!/bin/bash
# Ana dizinde çalıştırın: sh scripts/ios_deep_clean.sh

IOS_DIR="ios"

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

clean_ios() {
    echo "iOS temizliği yapılıyor..."
    
    if [ -d "$IOS_DIR" ]; then
        cd "$IOS_DIR"
        rm -rf Pods
        rm -f Podfile.lock
        
        if [ -f "Podfile" ]; then
            pod deintegrate 2>/dev/null || echo "Pod deintegrate tamamlandı"
        fi
        
        cd ".."
    else
        echo "iOS klasörü bulunamadı!"
        exit 1
    fi
}

setup_dependencies() {
    echo "Dependencies kuruluyor..."
    
    flutter pub get
    
    if [ -d "$IOS_DIR" ]; then
        cd "$IOS_DIR"
        echo "Pod setup ve install yapılıyor..."
        pod setup
        pod install
        cd ".."
    else
        echo "iOS klasörü bulunamadı!"
        exit 1
    fi
}

main() {
    clean_flutter
    clean_ios
    setup_dependencies
}

main