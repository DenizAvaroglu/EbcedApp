@echo off
echo ============================================
echo  Havvas Hesaplama - Flutter Proje Kurulumu
echo  (Ebced + Yildizname + Vefk)
echo ============================================
echo.
echo Bu script mevcut lib/ kodlarini koruyarak
echo Flutter proje yapisini olusturur.
echo.
echo Oncelikle Flutter SDK kurulu olmali:
echo https://docs.flutter.dev/get-started/install
echo.
pause

REM Gecici klasorde flutter create yap
cd /d "%~dp0"
cd ..
flutter create --org com.example --project-name ebced_app EbcedApp_temp

REM Gerekli dosyalari kopyala (lib/ haric)
xcopy /E /Y "EbcedApp_temp\android" "EbcedApp\android\"
xcopy /E /Y "EbcedApp_temp\ios" "EbcedApp\ios\"
xcopy /E /Y "EbcedApp_temp\web" "EbcedApp\web\"
xcopy /E /Y "EbcedApp_temp\test" "EbcedApp\test\"
copy /Y "EbcedApp_temp\.gitignore" "EbcedApp\"
copy /Y "EbcedApp_temp\.metadata" "EbcedApp\"

REM Gecici klasoru sil
rmdir /S /Q EbcedApp_temp

REM Paketleri indir
cd EbcedApp
flutter pub get

echo.
echo ============================================
echo  Kurulum tamamlandi!
echo  Simdi "flutter run" ile calistirabilirsiniz.
echo ============================================
pause
