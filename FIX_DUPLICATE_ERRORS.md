# Duplicate Dosya Hatalarını Düzeltme Rehberi

## 🔍 **Resimdeki Hataların Nedenleri:**

### **1. "Skipping duplicate build file" Hatası:**
- **Neden:** `HealthRecordFormView...` dosyası Xcode projesine birden fazla kez eklenmiş
- **Çözüm:** Duplicate dosyaları Xcode'dan silmek

### **2. "'Appointment' is ambiguous" Hatası:**
- **Neden:** `Appointment` modeli birden fazla dosyada tanımlanmış
- **Çözüm:** Tüm model tanımlarını `Models.swift`'te toplamak

### **3. "'contentEdgeInsets' was deprecated" Uyarısı:**
- **Neden:** iOS 15'ten itibaren `contentEdgeInsets` kullanımdan kaldırıldı
- **Çözüm:** `UIButton.Configuration` kullanmak

### **4. "Cannot infer contextual base" Hatası:**
- **Neden:** `formatted(date: .abbreviated, time: .shortened)` iOS 15+ gerektiriyor
- **Çözüm:** `DateFormatter` kullanmak

## 🚀 **Çözüm Adımları:**

### **Adım 1: Xcode'da Duplicate Dosyaları Temizle**

1. **Xcode'da Project Navigator'ı açın** (`⌘+1`)
2. **EvcilHayvanim klasörünü genişletin**
3. **Duplicate dosyaları bulun** (aynı isimde birden fazla dosya)
4. **Duplicate dosyaları silin:**
   - Sağ tıklayın → "Delete"
   - "Move to Trash" seçin

### **Adım 2: Build Phases'da Duplicate Dosyaları Kontrol Et**

1. **Project Navigator'da proje adına tıklayın**
2. **Target → EvcilHayvanim → Build Phases**
3. **Compile Sources** bölümünde duplicate dosyalar var mı kontrol edin
4. **Duplicate dosyaları silin**

### **Adım 3: Build Folder'ı Temizle**

1. **Product → Clean Build Folder** (`⌘+Shift+K`)
2. **Product → Build** (`⌘+B`)

### **Adım 4: Derived Data'yı Temizle**

1. **Xcode'u kapatın**
2. **Terminal'de şu komutu çalıştırın:**
   ```bash
   rm -rf ~/Library/Developer/Xcode/DerivedData
   ```
3. **Xcode'u yeniden açın**

## 📋 **Kontrol Listesi:**

- [ ] Duplicate dosyalar temizlendi
- [ ] Build Phases'da duplicate yok
- [ ] Build folder temizlendi
- [ ] Derived Data temizlendi
- [ ] Build başarılı

## ✅ **Beklenen Sonuç:**

- ✅ **"Skipping duplicate build file"** hatası kaybolacak
- ✅ **"'Appointment' is ambiguous"** hatası kaybolacak
- ✅ **"'contentEdgeInsets' was deprecated"** uyarısı kaybolacak
- ✅ **"Cannot infer contextual base"** hatası kaybolacak
- ✅ **Uygulama çalışacak**

## 🆘 **Sorun Devam Ederse:**

1. **Xcode'u tamamen kapatın**
2. **Derived Data'yı silin**
3. **Xcode'u yeniden açın**
4. **Clean Build Folder yapın**
5. **Build edin** 