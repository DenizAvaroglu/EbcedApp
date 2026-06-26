# Ebced Hesaplama - Flutter Mobil Uygulama

Arapça metinlerin ebced değerlerini hesaplayan ve isim oluşturan mobil uygulama.

## Kurulum

1. Flutter SDK kurulu olmalı: https://docs.flutter.dev/get-started/install
2. Terminalde proje klasörüne git:
   ```
   cd C:\Users\deniz\Desktop\EbcedApp
   ```
3. Bağımlılıkları indir:
   ```
   flutter pub get
   ```
4. Çalıştır:
   ```
   flutter run
   ```

## APK Oluşturma (Android)

```
flutter build apk --release
```

Çıktı: `build/app/outputs/flutter-apk/app-release.apk`

## iOS Build

```
flutter build ios --release
```

## Özellikler

- **Ebced Hesaplama**: Ayet girişi, kelime bazlı ebced hesaplama ve isim oluşturma
- **Özel Hesaplama**: Rakam listesi ile özel isim hesaplama, kombine esma
- **Sure/Ayet/Esma**: 3 modlu hesaplama
  - Sure: Tüm ayetlerin ebcedi, okuma adedi = ayet sayısı
  - Ayet: Kelime bazlı, okuma adedi = kelime sayısı × ana ebced
  - Esma: 5 isim hesaplama (ebced, ebced×gezegen, ebced×harf, ebced², toplam)
- **İsim Türleri**: Şahıs (in), Ulvi (-41, ayil), Sufli (-316, yuşin), Şer (-319, tayşin)
- **361 Kuralı**: Negatif değer oluşursa otomatik 361 ekleme
- **Aynı Değer Bölme**: Tekrar eden değerler 2/5-3/5, 1/3-2/3 veya 3/7-4/7 oranında bölünür
- **Dosya Kaydetme & Paylaşma**: Sonuçları TXT olarak kaydet veya paylaş
