# Foto Produk Update — AI Studio v0.4 (prototipe)

## Isi versi ini
- Halaman AI Studio terhubung dari ikon bintang di halaman utama.
- Pilihan mesin AI Lokal dan AI Cloud (toggle rancangan).
- Pilihan tugas: hapus background, latar studio, peningkatan kualitas, dan variasi iklan.
- Pilihan prioritas kualitas/data.
- Proyek dasar pemilih foto, editor informasi produk, template, pratinjau, ekspor PNG, dan berbagi tetap disertakan.

## Status fitur AI — harap dibaca
AI Studio pada v0.4 adalah **kerangka UI dan arsitektur**, bukan layanan AI yang sudah aktif. Belum ada model ML on-device, endpoint cloud, atau kredensial penyedia AI. Tombol "Siapkan proses AI" hanya menampilkan konfigurasi yang dipilih dan tidak mengubah foto.

## Menjalankan Android
1. Pasang Flutter SDK dan Android Studio.
2. Ekstrak ZIP, buka folder proyek.
3. Jalankan `flutter pub get`.
4. Jalankan `flutter run` dengan perangkat Android/emulator.
5. Untuk APK: `flutter build apk --release`.

## Arsitektur yang direkomendasikan
### A. AI lokal (offline)
- Flutter mengirim gambar ke lapisan `LocalImageProcessor`.
- Tugas ringan: resize, kompresi, koreksi warna/pencahayaan, crop, dan filter dapat dijalankan sepenuhnya di perangkat.
- Untuk segmentasi/penghapusan background offline, tambahkan model segmentasi yang kompatibel dengan TensorFlow Lite atau ONNX Runtime Mobile, lalu uji ukuran model, RAM, kecepatan, dan lisensi model.
- Model harus dibundel atau diunduh secara eksplisit dengan versi dan checksum; sediakan fallback jika perangkat tidak kompatibel.

### B. AI cloud (online)
- Aplikasi mengunggah gambar melalui HTTPS ke backend milik pengelola.
- Backend mengautentikasi permintaan, memvalidasi tipe/ukuran file, membatasi penyalahgunaan, memanggil penyedia/model AI, lalu mengembalikan hasil.
- Jangan pernah menaruh API key penyedia AI di APK. Simpan rahasia hanya di server.
- Terapkan batas ukuran, timeout, antrean, penghapusan file sementara, enkripsi saat transit, dan kebijakan retensi yang jelas.

## Infrastruktur untuk layanan gratis bagi pengguna
Gratis bagi pengguna **tidak berarti biaya operasional nol**. Agar berkelanjutan:
1. Utamakan pemrosesan lokal untuk fitur rutin.
2. Jalankan cloud pada infrastruktur yang dikelola sendiri atau penyedia dengan kuota/biaya yang dapat dikendalikan.
3. Siapkan pemantauan penggunaan, proteksi bot, rate limit per perangkat/akun, dan antrean pekerjaan.
4. Mulai dengan uji coba tertutup dan anggaran bulanan maksimum. Jangan menjanjikan AI cloud tanpa batas sebelum kapasitas dan biaya terukur.
5. Sediakan mode offline bila server tidak tersedia.

## Komponen produksi yang masih perlu dibuat
- Model segmentasi lokal + integrasi runtime mobile.
- Backend API cloud (contoh kontrak: `POST /v1/remove-background`, `POST /v1/generate-background`, `POST /v1/enhance`).
- Adapter model/provider di server dan manajemen rahasia.
- Upload progres, retry, antrean, cache, dan penyimpanan hasil.
- Persetujuan pengguna untuk upload foto, kebijakan privasi, penghapusan data, dan pengujian keamanan.
- Pengujian perangkat Android kelas bawah/menengah dan build APK release bertanda tangan.

## Prinsip produk
Aplikasi ditujukan gratis bagi pengguna. Ketersediaan dan kuota cloud harus mengikuti kapasitas infrastruktur yang benar-benar disediakan pengelola; hindari klaim "AI cloud gratis tanpa batas" sebelum biaya dan kapasitas dijamin.
