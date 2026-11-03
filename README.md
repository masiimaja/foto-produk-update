# Foto Produk Update — Android Release Candidate v0.4.1

Paket ini berisi kode sumber Flutter dan alur otomatis untuk membangun APK Android.

## Status penting
- Ini **belum merupakan file APK**. APK harus dikompilasi dengan Flutter SDK + Android SDK.
- Lingkungan kerja saat ini tidak memiliki Flutter SDK maupun Android SDK, sehingga APK tidak dapat dikompilasi atau diuji di sini.
- Halaman AI Studio masih berupa antarmuka/kerangka konfigurasi. Model AI lokal dan server AI cloud belum diintegrasikan.
- Fitur inti editor yang ada: pilih foto dari galeri/kamera, teks nama/harga/promo/kontak, 10 variasi template grafis, format sosial, ekspor PNG, dan berbagi.
- Gratis untuk pengguna adalah target kebijakan produk; pemrosesan cloud tetap membutuhkan infrastruktur dan biaya pengelola.

## Cara termudah membangun APK lewat GitHub Actions
1. Buat repository GitHub baru.
2. Ekstrak ZIP ini, lalu unggah seluruh isi folder `foto_produk_update` ke repository (termasuk folder `.github`).
3. Pastikan branch bernama `main`.
4. Buka tab **Actions** di repository.
5. Pilih workflow **Build Android APK**, lalu tekan **Run workflow**. Workflow juga berjalan otomatis setelah push ke `main`.
6. Setelah selesai, buka hasil run dan unduh artifact bernama `foto-produk-update-android-apk`.
7. Ekstrak artifact; file di dalamnya bernama `app-release.apk`.
8. Pindahkan APK ke HP Android dan instal. Android mungkin meminta izin “Install unknown apps” untuk aplikasi pengelola file/browser yang digunakan.

## Cara membangun di komputer Windows
1. Instal Flutter SDK dan Android Studio (termasuk Android SDK).
2. Ekstrak ZIP.
3. Buka folder `foto_produk_update`.
4. Klik dua kali `BUILD_APK_WINDOWS.bat`, atau jalankan:
   - `flutter create --platforms=android --org id.fotoprodukupdate .`
   - `flutter pub get`
   - `flutter build apk --release`
5. APK akan berada di `build/app/outputs/flutter-apk/app-release.apk`.

## Sebelum rilis publik
- Buat dan amankan backend AI; jangan menaruh API key di aplikasi.
- Tambahkan model segmentasi lokal dengan lisensi yang sesuai.
- Tambahkan kebijakan privasi, persetujuan upload, retensi/penghapusan foto.
- Uji kamera, galeri, ekspor, dan share pada beberapa versi Android.
- Siapkan signing key milik pemilik aplikasi untuk rilis jangka panjang/Play Store. Jangan bagikan file keystore atau password.
- Uji APK pada perangkat nyata sebelum menyebutnya siap produksi.

## Identitas aplikasi
Nama: Foto Produk Update
Package ID awal: `id.fotoprodukupdate.foto_produk_update` (dihasilkan Flutter dari org dan nama proyek).
Memulai proses build APK Foto Produk Update
