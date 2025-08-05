# Xcode'da Dosyaları Ekleme Rehberi

## 🚀 Hızlı Çözüm

### Adım 1: Xcode'u Açın
- Xcode'da `EvcilHayvanim.xcodeproj` dosyasını açın

### Adım 2: Project Navigator'ı Açın
- `⌘ + 1` tuşlarına basın
- Sol tarafta proje dosyaları görünecek

### Adım 3: Dosyaları Ekleyin

#### Yöntem A: Tek Tek Ekleme
1. **EvcilHayvanim** klasörüne sağ tıklayın
2. **"Add Files to 'EvcilHayvanim'"** seçin
3. Aşağıdaki dosyaları tek tek ekleyin:

```
✅ Models.swift
✅ MainTabBarController.swift
✅ DashboardViewController.swift
✅ PetListViewController.swift
✅ HealthRecordsViewController.swift
✅ AppointmentsViewController.swift
✅ SettingsViewController.swift
✅ PetFormViewController.swift
✅ HealthRecordFormViewController.swift
✅ AppointmentFormViewController.swift
✅ PetDetailViewController.swift
✅ HealthRecordDetailViewController.swift
✅ AppointmentDetailViewController.swift
```

#### Yöntem B: Toplu Ekleme
1. **Finder'da** `EvcilHayvanim` klasörüne gidin
2. **Tüm .swift dosyalarını seçin** (`⌘ + A`)
3. **Xcode'a sürükleyin**
4. **"Add to target"** işaretleyin

### Adım 4: Ayarları Kontrol Edin
Her dosya için:
- ✅ **"Add to target"** işaretli olmalı
- ✅ **"Copy items if needed"** işaretli olmalı
- ✅ **"Create groups"** seçili olmalı

### Adım 5: Build Edin
- `⌘ + B` ile build edin
- Hatalar kaybolacak

## 📋 Eksik Dosya Listesi

Aşağıdaki dosyalar Xcode projesine eklenmeli:

1. **Models.swift** - Tüm model tanımları
2. **MainTabBarController.swift** - Ana tab bar controller
3. **DashboardViewController.swift** - Ana sayfa
4. **PetListViewController.swift** - Evcil hayvan listesi
5. **HealthRecordsViewController.swift** - Sağlık kayıtları
6. **AppointmentsViewController.swift** - Randevular
7. **SettingsViewController.swift** - Ayarlar
8. **PetFormViewController.swift** - Evcil hayvan formu
9. **HealthRecordFormViewController.swift** - Sağlık kaydı formu
10. **AppointmentFormViewController.swift** - Randevu formu
11. **PetDetailViewController.swift** - Evcil hayvan detayı
12. **HealthRecordDetailViewController.swift** - Sağlık kaydı detayı
13. **AppointmentDetailViewController.swift** - Randevu detayı

## ✅ Başarı Kontrolü

Dosyaları ekledikten sonra:
- ✅ Build hatası yok
- ✅ "Cannot find" hataları kayboldu
- ✅ Uygulama çalışıyor
- ✅ Tab bar görünüyor

## 🆘 Sorun Giderme

Eğer hala hata alıyorsanız:
1. **Clean Build Folder** (`⌘ + Shift + K`)
2. **Build** (`⌘ + B`)
3. **Run** (`⌘ + R`) 