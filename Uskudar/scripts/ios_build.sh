#!/bin/bash
# iOS build için kullanın ana dizindeyken çalıştırın: sh scripts/ios_build.sh
# xcrun yüklü olmalı Yükleyin!

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
    
    echo "Flutter pub get yapılıyor..."
    flutter pub get
    
    if [ -d "$IOS_DIR" ]; then
        cd "$IOS_DIR"
        rm -rf Pods
        rm -f Podfile.lock
        
        if [ -f "Podfile" ]; then
            pod deintegrate 2>/dev/null || echo "Pod deintegrate tamamlandı"
        fi

        echo "Pod setup yapılıyor..."
        pod setup
        
        echo "Pod install yapılıyor..."
        pod install

        cd ".."
    else
        echo "iOS klasörü bulunamadı!"
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
            configuration="Debug-development"
            ;;
        2)
            buildType="profile"
            configuration="Profile-qa"
            ;;
        3)
            buildType="release"
            configuration="Release-production"
            ;;
        *)
            echo "Geçersiz seçim. Varsayılan olarak Debug (Development) kullanılacak."
            buildType="debug"
            configuration="Debug-development"
            ;;
    esac
}

prompt_output_type() {
    echo "Hangi çıktı tipini kullanmak istiyorsunuz?"
    echo "1) Runner.app"
    echo "2) IPA"
    read outputChoice
        
    case $outputChoice in
        1)
            outputType="app"
            ;;
        2)
            outputType="ipa"
            ;;
        *)
            echo "Geçersiz seçim. Varsayılan olarak Runner.app kullanılacak."
            outputType="app"
            ;;
        esac
}

build_flutter() {
    echo "Flutter iOS $buildType ($configuration) build başlatılıyor..."
    
    if [ "$outputType" == "ipa" ]; then
        if [ "$buildType" == "release" ]; then
            echo "App Store için production build oluşturuluyor..."
            flutter build ipa --release --dart-define=ENVIRONMENT=production
        else
            flutter build ipa --$buildType --dart-define=ENVIRONMENT=${buildType}
        fi
    else
        if [ "$buildType" == "debug" ]; then
            flutter build ios --debug --simulator --dart-define=ENVIRONMENT=development
        else
            flutter build ios --$buildType --simulator --dart-define=ENVIRONMENT=${buildType}
        fi
    fi
    
    if [ $? -ne 0 ]; then
        exit 1
    fi
}

prompt_upload_to_appstore() {
    local ipa_path="$1"
    apple_id="yigithan.yaramis@erpa.com.tr"
    app_password="sexn-engc-hfef-ybdq"
    
    echo "App Store Connect'e yüklemek istiyor musunuz?"
    echo "1) Evet (xcrun ile otomatik yükle)"
    echo "2) Hayır (Manuel yükleme)"
    read upload_choice
    
    case $upload_choice in
        1)
            echo "App Store Connect'e yükleniyor..."
            echo "Apple ID ve App-Specific Password otomatik alınıyor"
            echo ""
            
            xcrun altool --upload-app -f "$ipa_path" -u "$apple_id" -p "$app_password" --type ios
            
            if [ $? -eq 0 ]; then
                echo "Başarıyla yüklendi!"
            else
                echo "Yükleme başarısız. Manuel yükleme yapabilirsiniz."
            fi
            ;;
        2)
            echo "Manuel yükleme için:"
            echo "2. Xcode Organizer → Import → Distribute App"
            ;;
        *)
            echo "Manuel yükleme yapabilirsiniz."
            ;;
    esac
}

show_output_path() {
    local base_path="build/ios"
    
    if [ "$outputType" == "ipa" ]; then
        local actual_ipa_path="$(find $base_path/ipa -name "*.ipa" -type f | head -n 1)"
        
        if [ -n "$actual_ipa_path" ]; then
            local target_ipa_path="$base_path/ipa/Runner.ipa"
            mv "$actual_ipa_path" "$target_ipa_path"
            echo "IPA yolu: $target_ipa_path"
            
            if [ "$buildType" == "release" ]; then
                echo ""
                echo "Production IPA oluşturuldu!"
                echo ""
                prompt_upload_to_appstore "$target_ipa_path"
            fi
        else
            echo "IPA dosyası bulunamadı!"
            exit 1
        fi
    elif [ "$outputType" == "app" ]; then
        echo "App yolu: $base_path/iphonesimulator/Runner.app"
    fi
    
    echo ""
}

main() {
    clean_flutter
    clean_ios
    prompt_version_info
    prompt_build_type
    prompt_output_type
    build_flutter
    show_output_path
}

main