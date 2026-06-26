# Havass Hesaplama - Build & Paketleme Rehberi

## Gereksinimler

- Flutter SDK (3.0+) — https://docs.flutter.dev/get-started/install
- Android Studio (Android için)
- Xcode (iOS için, sadece macOS'ta)

---

## 1. Projeyi Hazırlama

```bash
# Proje klasörüne git
cd C:\Users\deniz\Desktop\EbcedApp

# Flutter paketlerini yükle
flutter pub get

# Her şeyin doğru olduğunu kontrol et
flutter doctor
```

---

## 2. Android APK Oluşturma

### Debug APK (Test için)
```bash
flutter build apk --debug
```
Çıktı: `build/app/outputs/flutter-apk/app-debug.apk`

### Release APK (Dağıtım için)
```bash
flutter build apk --release
```
Çıktı: `build/app/outputs/flutter-apk/app-release.apk`

### Split APK (Daha küçük dosya boyutu)
```bash
flutter build apk --split-per-abi
```
Çıktılar:
- `app-arm64-v8a-release.apk` (modern telefonlar)
- `app-armeabi-v7a-release.apk` (eski telefonlar)
- `app-x86_64-release.apk` (emülatör)

### Android App Bundle (Google Play Store için)
```bash
flutter build appbundle --release
```
Çıktı: `build/app/outputs/bundle/release/app-release.aab`

---

## 3. Android'e Yükleme

### USB ile Doğrudan Yükleme
1. Telefonda **Geliştirici Seçenekleri** aktifleştirin (Ayarlar > Telefon Hakkında > Yapı Numarasına 7 kez dokunun)
2. **USB Hata Ayıklama** açın
3. Telefonu USB ile bilgisayara bağlayın
4. Çalıştırın:
```bash
flutter install
```

### APK'yı Manuel Yükleme
1. APK dosyasını telefona kopyalayın (USB/e-posta/cloud)
2. Telefonda "Bilinmeyen kaynaklar"a izin verin
3. APK'ya dokunarak yükleyin

---

## 4. iOS Build (macOS gerekli)

### Ön Hazırlık
1. Xcode yükleyin (App Store'dan)
2. Apple Developer hesabı oluşturun (ücretsiz test için yeterli)
3. Xcode'da projeyi açın:
```bash
open ios/Runner.xcworkspace
```
4. Signing & Capabilities'de Team seçin

### Debug Build (Test için)
```bash
flutter build ios --debug
```

### Release Build
```bash
flutter build ios --release
```

### iPhone'a Yükleme (Xcode ile)
1. iPhone'u Mac'e USB ile bağlayın
2. Xcode'da cihazı seçin
3. Run (▶) butonuna basın

### TestFlight ile Dağıtım
1. `flutter build ipa` çalıştırın
2. Çıkan `.ipa` dosyasını Transporter ile App Store Connect'e yükleyin
3. TestFlight'tan test edin

---

## 5. İmzalama (Signing)

### Android Keystore Oluşturma
```bash
keytool -genkey -v -keystore ~/ebced-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias ebced
```

`android/key.properties` dosyası oluşturun:
```properties
storePassword=SIFRENIZ
keyPassword=SIFRENIZ
keyAlias=ebced
storeFile=C:/Users/deniz/ebced-key.jks
```

`android/app/build.gradle` dosyasında signing config ekleyin.

### iOS Signing
- Xcode'da otomatik signing kullanın (ücretsiz hesapla 7 gün geçerli)
- Dağıtım için Apple Developer Program ($99/yıl) gerekli

---

## 6. Google Play Store'a Yükleme

1. [Google Play Console](https://play.google.com/console) hesabı açın ($25 tek seferlik)
2. Yeni uygulama oluşturun
3. `.aab` dosyasını yükleyin
4. Store listesi bilgilerini doldurun (başlık, açıklama, ekran görüntüleri)
5. İncelemeye gönderin

---

## 7. App Store'a Yükleme

1. [App Store Connect](https://appstoreconnect.apple.com) hesabı açın
2. Apple Developer Program'a katılın ($99/yıl)
3. `.ipa` dosyasını Transporter ile yükleyin
4. App bilgilerini doldurun
5. İncelemeye gönderin

---

## 8. Hızlı Test Komutları

```bash
# Emülatörde çalıştır
flutter run

# Bağlı cihazda çalıştır
flutter run -d <device_id>

# Cihazları listele
flutter devices

# Hot reload ile geliştirme
flutter run --hot
```

---

## 9. Sorun Giderme

```bash
# Flutter ortamını kontrol et
flutter doctor -v

# Cache temizle
flutter clean
flutter pub get

# Android bağımlılıklarını güncelle
cd android && ./gradlew clean && cd ..

# iOS pod yükle (macOS)
cd ios && pod install && cd ..
```

---

## Uygulama İkonu Değiştirme

`pubspec.yaml`'a ekleyin:
```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.13.0

flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icon.png"
```

Sonra çalıştırın:
```bash
dart run flutter_launcher_icons
```

---

## Splash Screen

`pubspec.yaml`'a ekleyin:
```yaml
dev_dependencies:
  flutter_native_splash: ^2.3.0

flutter_native_splash:
  color: "#1a237e"
  image: "assets/splash.png"
```

Sonra:
```bash
dart run flutter_native_splash:create
```
