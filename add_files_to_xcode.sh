#!/bin/bash

# Xcode projesine dosyaları eklemek için script
echo "Xcode projesine dosyalar ekleniyor..."

# Proje dosyasının yolu
PROJECT_FILE="EvcilHayvanim.xcodeproj/project.pbxproj"

# Eklenecek dosyalar
FILES=(
    "EvcilHayvanim/Models.swift"
    "EvcilHayvanim/MainTabBarController.swift"
    "EvcilHayvanim/DashboardViewController.swift"
    "EvcilHayvanim/PetListViewController.swift"
    "EvcilHayvanim/HealthRecordsViewController.swift"
    "EvcilHayvanim/AppointmentsViewController.swift"
    "EvcilHayvanim/SettingsViewController.swift"
    "EvcilHayvanim/PetFormViewController.swift"
    "EvcilHayvanim/HealthRecordFormViewController.swift"
    "EvcilHayvanim/AppointmentFormViewController.swift"
    "EvcilHayvanim/PetDetailViewController.swift"
    "EvcilHayvanim/HealthRecordDetailViewController.swift"
    "EvcilHayvanim/AppointmentDetailViewController.swift"
)

echo "Toplam ${#FILES[@]} dosya eklenecek..."

# Her dosya için kontrol et
for file in "${FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file mevcut"
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