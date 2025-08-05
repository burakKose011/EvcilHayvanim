# Evcil Hayvan Sağlık Takibi Uygulaması - PRD (Product Requirements Document)

## 1. Ürün Özeti

### 1.1 Ürün Adı
**EvcilHayvanim** - Evcil Hayvan Sağlık Takip Uygulaması

### 1.2 Ürün Açıklaması
EvcilHayvanim, evcil hayvan sahiplerinin hayvanlarının sağlık durumunu takip etmelerine, veteriner randevularını yönetmelerine ve sağlık geçmişini kaydetmelerine olanak sağlayan kapsamlı bir iOS uygulamasıdır.

### 1.3 Hedef Kitle
- Evcil hayvan sahipleri (kedi, köpek, kuş, balık vb.)
- Veteriner hekimler (sınırlı özellikler)
- Pet shop sahipleri

## 2. Temel Özellikler

### 2.1 Evcil Hayvan Profili Yönetimi
- **Çoklu Hayvan Desteği**: Kullanıcılar birden fazla evcil hayvan ekleyebilir
- **Detaylı Profil**: 
  - Hayvan türü, ırkı, yaşı, cinsiyeti
  - Doğum tarihi ve ağırlık bilgileri
  - Fotoğraf galerisi
  - Mikroçip numarası
  - Sahip bilgileri

### 2.2 Sağlık Takibi
- **Aşı Takibi**: 
  - Aşı türleri ve tarihleri
  - Gelecek aşı hatırlatmaları
  - Aşı sertifikası fotoğrafı
- **Kilo Takibi**: 
  - Düzenli kilo ölçümleri
  - Grafik görünümü
  - İdeal kilo hedefleri
- **İlaç Takibi**:
  - Aktif ilaç listesi
  - Dozaj bilgileri
  - İlaç alma hatırlatmaları
- **Semptom Takibi**:
  - Günlük davranış notları
  - Hastalık belirtileri
  - Acil durum işaretleri

### 2.3 Veteriner Randevu Yönetimi
- **Randevu Oluşturma**: Tarih, saat, veteriner seçimi
- **Randevu Hatırlatmaları**: 24 saat öncesi bildirim
- **Veteriner Notları**: Randevu sonrası notlar
- **Geçmiş Randevular**: Tüm randevu geçmişi

### 2.4 Beslenme Takibi
- **Yemek Programı**: Günlük beslenme planı
- **Kalori Takibi**: Günlük kalori alımı
- **Su Tüketimi**: Günlük su içme miktarı
- **Besin Alerjileri**: Alerji bilgileri

### 2.5 Aktivite Takibi
- **Egzersiz Kayıtları**: Günlük aktivite süresi
- **Yürüyüş Takibi**: Rota ve mesafe
- **Oyun Zamanı**: Günlük oyun aktiviteleri

## 3. Teknik Gereksinimler

### 3.1 Platform
- **iOS 14.0+** desteği
- **UIKit** framework kullanımı
- **Core Data** veri yönetimi
- **UserNotifications** bildirim sistemi

### 3.2 Mimari
- **MVC** (Model-View-Controller) mimarisi
- **Core Data** ile yerel veri saklama
- **UserDefaults** ile kullanıcı tercihleri
- **FileManager** ile dosya yönetimi

### 3.3 Veri Modeli
```swift
// Evcil Hayvan Modeli
struct Pet {
    let id: UUID
    var name: String
    var type: PetType
    var breed: String
    var birthDate: Date
    var weight: Double
    var gender: Gender
    var microchipNumber: String?
    var photoURL: URL?
}

// Sağlık Kaydı Modeli
struct HealthRecord {
    let id: UUID
    let petId: UUID
    let date: Date
    let type: HealthRecordType
    let description: String
    let veterinarian: String?
    let attachments: [URL]
}

// Randevu Modeli
struct Appointment {
    let id: UUID
    let petId: UUID
    let date: Date
    let veterinarian: String
    let reason: String
    let notes: String?
    let status: AppointmentStatus
}
```

## 4. Kullanıcı Arayüzü

### 4.1 Ana Ekranlar
1. **Dashboard**: Genel sağlık durumu özeti
2. **Pet List**: Evcil hayvan listesi
3. **Health Records**: Sağlık kayıtları
4. **Appointments**: Randevu yönetimi
5. **Settings**: Uygulama ayarları

### 4.2 Tasarım Prensipleri
- **iOS Human Interface Guidelines** uyumlu
- **Accessibility** desteği
- **Dark Mode** desteği
- **Responsive** tasarım

## 5. Özellik Detayları

### 5.1 Dashboard
- Günlük sağlık özeti
- Yaklaşan randevular
- Aşı hatırlatmaları
- İlaç alma zamanları
- Hızlı not ekleme

### 5.2 Sağlık Kayıtları
- Kategorize edilmiş kayıtlar
- Fotoğraf ekleme
- PDF rapor yükleme
- Arama ve filtreleme
- İstatistik görünümü

### 5.3 Bildirimler
- Aşı hatırlatmaları
- Randevu bildirimleri
- İlaç alma hatırlatmaları
- Veteriner kontrolü hatırlatmaları

## 6. Güvenlik ve Gizlilik

### 6.1 Veri Güvenliği
- Yerel veri şifreleme
- Face ID/Touch ID desteği
- Veri yedekleme (iCloud)

### 6.2 Gizlilik
- Kişisel veri koruması
- GDPR uyumluluğu
- Veri paylaşım kontrolü

## 7. Performans Gereksinimleri

### 7.1 Hız
- Uygulama açılış süresi < 3 saniye
- Sayfa geçişleri < 1 saniye
- Veri kaydetme < 500ms

### 7.2 Bellek Kullanımı
- Maksimum 100MB RAM kullanımı
- Optimize edilmiş görsel yükleme
- Lazy loading implementasyonu

## 8. Test Stratejisi

### 8.1 Test Türleri
- **Unit Tests**: Model ve iş mantığı
- **Integration Tests**: Core Data entegrasyonu
- **UI Tests**: Kullanıcı arayüzü
- **Performance Tests**: Bellek ve hız testleri

### 8.2 Test Senaryoları
- Evcil hayvan ekleme/silme
- Sağlık kaydı oluşturma
- Randevu yönetimi
- Bildirim sistemi
- Veri yedekleme/geri yükleme

## 9. Geliştirme Fazları

### Faz 1 (MVP - 4 hafta)
- Temel evcil hayvan profili
- Basit sağlık kayıtları
- Randevu yönetimi
- Temel bildirimler

### Faz 2 (4 hafta)
- Gelişmiş sağlık takibi
- Fotoğraf galerisi
- İstatistik görünümleri
- Arama ve filtreleme

### Faz 3 (3 hafta)
- Beslenme takibi
- Aktivite kayıtları
- Gelişmiş bildirimler
- iCloud senkronizasyonu

### Faz 4 (2 hafta)
- Performans optimizasyonu
- UI/UX iyileştirmeleri
- Test ve hata düzeltme
- App Store hazırlığı

## 10. Başarı Kriterleri

### 10.1 Teknik Kriterler
- %99 crash-free rate
- < 3 saniye uygulama açılış süresi
- %100 test coverage (kritik fonksiyonlar)

### 10.2 Kullanıcı Deneyimi
- Intuitive kullanıcı arayüzü
- Hızlı veri girişi
- Güvenilir bildirim sistemi
- Veri kaybı olmaması

## 11. Risk Analizi

### 11.1 Teknik Riskler
- Core Data performans sorunları
- Bildirim sistemi güvenilirliği
- Veri yedekleme başarısızlığı

### 11.2 Çözüm Stratejileri
- Performans testleri
- Fallback mekanizmaları
- Kapsamlı hata yakalama

## 12. Gelecek Özellikler

### 12.1 Kısa Vadeli (3-6 ay)
- Veteriner entegrasyonu
- Sosyal özellikler
- Gelişmiş analitikler

### 12.2 Uzun Vadeli (6-12 ay)
- AI destekli sağlık önerileri
- IoT cihaz entegrasyonu
- Çoklu platform desteği

---

**Doküman Versiyonu**: 1.0  
**Son Güncelleme**: 5 Ağustos 2025  
**Hazırlayan**: Geliştirme Ekibi 