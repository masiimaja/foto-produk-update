@echo off
setlocal
where flutter >nul 2>nul
if errorlevel 1 (
  echo Flutter SDK belum terpasang atau belum masuk PATH.
  echo Pasang Flutter SDK dan Android Studio, lalu buka terminal baru.
  pause
  exit /b 1
)
flutter create --platforms=android --org id.fotoprodukupdate .
if errorlevel 1 exit /b 1
flutter pub get
if errorlevel 1 exit /b 1
flutter build apk --release
if errorlevel 1 exit /b 1
echo.
echo APK berhasil dibuat di:
echo buildpp\outputslutter-apkpp-release.apk
pause
