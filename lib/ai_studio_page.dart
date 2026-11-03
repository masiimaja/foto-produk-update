import 'package:flutter/material.dart';

class AiStudioPage extends StatefulWidget {
  const AiStudioPage({super.key});
  @override
  State<AiStudioPage> createState() => _AiStudioPageState();
}

class _AiStudioPageState extends State<AiStudioPage> {
  bool localEnabled = true;
  bool cloudEnabled = true;
  String task = 'Hapus background';
  String quality = 'Seimbang';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Studio', style: TextStyle(fontWeight: FontWeight.w800))),
      body: ListView(padding: const EdgeInsets.all(18), children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF21164B), Color(0xFF7657E8)]), borderRadius: BorderRadius.circular(22)),
          child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(Icons.auto_awesome, color: Color(0xFFFFD66B), size: 32),
            SizedBox(height: 10),
            Text('AI STUDIO HYBRID', style: TextStyle(color: Color(0xFFFFD66B), fontSize: 10, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
            SizedBox(height: 6),
            Text('Studio produk lebih cerdas.', style: TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.w800)),
            SizedBox(height: 6),
            Text('Gunakan pemrosesan di HP untuk tugas ringan dan layanan cloud untuk tugas AI berat.', style: TextStyle(color: Colors.white70, fontSize: 12)),
          ]),
        ),
        const SizedBox(height: 20),
        const Text('Mesin pemrosesan', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
        const SizedBox(height: 10),
        _engineCard(icon: Icons.phone_android, title: 'AI Lokal di HP', subtitle: 'Bekerja offline untuk koreksi gambar, filter, resize, kompresi, dan model on-device jika sudah dipasang.', value: localEnabled, color: const Color(0xFF159B63), onChanged: (v) => setState(() => localEnabled = v)),
        const SizedBox(height: 10),
        _engineCard(icon: Icons.cloud_outlined, title: 'AI Cloud', subtitle: 'Untuk hapus background berbasis model, generasi latar, dan analisis visual. Membutuhkan internet dan server pengelola.', value: cloudEnabled, color: const Color(0xFF3478D4), onChanged: (v) => setState(() => cloudEnabled = v)),
        const SizedBox(height: 20),
        const Text('Pilih pekerjaan AI', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
        const SizedBox(height: 9),
        DropdownButtonFormField<String>(value: task, decoration: _decoration('Tugas'), items: const [
          DropdownMenuItem(value: 'Hapus background', child: Text('Hapus background produk')),
          DropdownMenuItem(value: 'Buat latar studio', child: Text('Buat latar studio produk')),
          DropdownMenuItem(value: 'Tingkatkan kualitas', child: Text('Tingkatkan kualitas foto')),
          DropdownMenuItem(value: 'Buat variasi iklan', child: Text('Buat variasi desain iklan')),
        ], onChanged: (v) => setState(() => task = v ?? task)),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(value: quality, decoration: _decoration('Prioritas'), items: const [
          DropdownMenuItem(value: 'Hemat data', child: Text('Hemat data')),
          DropdownMenuItem(value: 'Seimbang', child: Text('Seimbang')),
          DropdownMenuItem(value: 'Kualitas tinggi', child: Text('Kualitas tinggi')),
        ], onChanged: (v) => setState(() => quality = v ?? quality)),
        const SizedBox(height: 16),
        FilledButton.icon(onPressed: () => _showStatus(context), icon: const Icon(Icons.play_arrow), label: const Text('Siapkan proses AI')),
        const SizedBox(height: 16),
        Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: const Color(0xFFFFF5DF), borderRadius: BorderRadius.circular(14)), child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(Icons.info_outline, color: Color(0xFF986A10)), SizedBox(width: 9), Expanded(child: Text('Status prototipe: halaman AI Studio dan pilihan mesin sudah tersedia. Model AI lokal, endpoint cloud, penyimpanan hasil, dan autentikasi server belum dihubungkan. Tombol ini belum menjalankan pemrosesan AI sungguhan.', style: TextStyle(fontSize: 11, color: Color(0xFF75551B), height: 1.4))),
        ])),
      ]),
    );
  }

  Widget _engineCard({required IconData icon, required String title, required String subtitle, required bool value, required Color color, required ValueChanged<bool> onChanged}) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE8E6EF))),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(width: 42, height: 42, decoration: BoxDecoration(color: color.withOpacity(.10), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: color)),
      const SizedBox(width: 11),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w700)), const SizedBox(height: 4), Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.black54, height: 1.35))])),
      Switch(value: value, onChanged: onChanged),
    ]),
  );

  InputDecoration _decoration(String label) => InputDecoration(labelText: label, filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(13), borderSide: const BorderSide(color: Color(0xFFE5E2ED))), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(13), borderSide: const BorderSide(color: Color(0xFFE5E2ED))));

  void _showStatus(BuildContext context) {
    final local = localEnabled ? 'aktif' : 'nonaktif';
    final cloud = cloudEnabled ? 'aktif' : 'nonaktif';
    showDialog(context: context, builder: (_) => AlertDialog(
      title: const Text('Konfigurasi AI Studio'),
      content: Text('Tugas: $task\nPrioritas: $quality\nAI lokal: $local\nAI cloud: $cloud\n\nMesin AI belum terhubung. Pilihan ini disimpan sebagai rancangan alur; pemrosesan nyata memerlukan model lokal dan server cloud.'),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Mengerti'))],
    ));
  }
}
