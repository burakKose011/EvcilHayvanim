#!/bin/bash

echo "Xcode projesine dosyalar ekleniyor..."

# Dosya listesi - güncellenmiş yollar
files=(
    "EvcilHayvanim/Models/Models.swift"
    "EvcilHayvanim/Controllers/MainTabBarController.swift"
    "EvcilHayvanim/Controllers/DashboardViewController.swift"
    "EvcilHayvanim/Controllers/PetListViewController.swift"
    "EvcilHayvanim/Controllers/HealthRecordsViewController.swift"
    "EvcilHayvanim/Controllers/AppointmentsViewController.swift"
    "EvcilHayvanim/Controllers/SettingsViewController.swift"
    "EvcilHayvanim/Controllers/PetFormViewController.swift"
    "EvcilHayvanim/Controllers/HealthRecordFormViewController.swift"
    "EvcilHayvanim/Controllers/AppointmentFormViewController.swift"
    "EvcilHayvanim/Controllers/PetDetailViewController.swift"
    "EvcilHayvanim/Controllers/HealthRecordDetailViewController.swift"
    "EvcilHayvanim/Controllers/AppointmentDetailViewController.swift"
    "EvcilHayvanim/Controllers/SplashViewController.swift"
    "EvcilHayvanim/Controllers/ViewController.swift"
)

echo "Toplam ${#files[@]} dosya eklenecek..."

# Her dosyayı kontrol et
for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file bulundu"
    else
        echo "❌ $file bulunamadı!"
    fi
done

echo ""
echo "Şimdi Xcode'da manuel olarak dosyaları eklemeniz gerekiyor:"
echo "1. Xcode'da Project Navigator'ı açın (⌘+1)"
echo "2. EvcilHayvanim klasörüne sağ tıklayın"
echo "3. 'Add Files to EvcilHayvanim' seçin"
echo "4. Yukarıdaki dosyaları tek tek ekleyin"
echo "5. 'Add to target' işaretleyin"
echo ""
echo "Veya Finder'da tüm .swift dosyalarını seçip Xcode'a sürükleyin." 