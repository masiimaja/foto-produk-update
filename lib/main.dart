import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'ai_studio_page.dart';

void main() => runApp(const FotoProdukApp());

class FotoProdukApp extends StatelessWidget {
  const FotoProdukApp({super.key});

  @override
  Widget build(BuildContext context) {
    const ink = Color(0xFF172033);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Foto Produk Update',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF7657E8)),
        scaffoldBackgroundColor: const Color(0xFFF6F7FB),
        fontFamily: 'Roboto',
      ),
      home: const StudioPage(),
    );
  }
}

enum DesignStyle { mewah, minimalis, modern, elegan }

extension DesignStyleLabel on DesignStyle {
  String get label {
    switch (this) {
      case DesignStyle.mewah: return 'Mewah';
      case DesignStyle.minimalis: return 'Minimalis';
      case DesignStyle.modern: return 'Modern';
      case DesignStyle.elegan: return 'Elegan';
    }
  }
  IconData get icon {
    switch (this) {
      case DesignStyle.mewah: return Icons.workspace_premium_outlined;
      case DesignStyle.minimalis: return Icons.crop_square;
      case DesignStyle.modern: return Icons.bolt;
      case DesignStyle.elegan: return Icons.auto_awesome_outlined;
    }
  }
}

class StudioPage extends StatefulWidget {
  const StudioPage({super.key});
  @override
  State<StudioPage> createState() => _StudioPageState();
}

class _StudioPageState extends State<StudioPage> {
  final picker = ImagePicker();
  final productName = TextEditingController(text: 'Nama Produk Anda');
  final price = TextEditingController(text: 'Rp 99.000');
  final promo = TextEditingController(text: 'PROMO SPESIAL');
  final contact = TextEditingController(text: 'Hubungi kami sekarang');
  final List<File> photos = [];
  DesignStyle style = DesignStyle.mewah;
  String format = 'Status 9:16';
  bool busy = false;

  Future<void> choosePhotos() async {
    try {
      final files = await picker.pickMultiImage(imageQuality: 92);
      if (files.isEmpty) return;
      setState(() {
        photos
          ..clear()
          ..addAll(files.map((e) => File(e.path)));
      });
    } catch (e) {
      if (mounted) showMessage('Tidak dapat membuka galeri: $e');
    }
  }

  Future<void> chooseCamera() async {
    try {
      final file = await picker.pickImage(source: ImageSource.camera, imageQuality: 92);
      if (file != null) setState(() {
        photos
          ..clear()
          ..add(File(file.path));
      });
    } catch (e) {
      if (mounted) showMessage('Kamera tidak dapat dibuka: $e');
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> exportAndShare(GlobalKey key, int index) async {
    try {
      setState(() => busy = true);
      await Future.delayed(const Duration(milliseconds: 80));
      final boundary = key.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3);
      final data = await image.toByteData(format: ui.ImageByteFormat.png);
      if (data == null) throw Exception('Gagal membuat gambar');
      final Uint8List bytes = data.buffer.asUint8List();
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/foto_produk_iklan_${index + 1}.png');
      await file.writeAsBytes(bytes);
      await Share.shareXFiles([XFile(file.path)], text: 'Desain iklan dari Foto Produk Update');
    } catch (e) {
      if (mounted) showMessage('Belum berhasil mengekspor desain: $e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  void dispose() {
    productName.dispose();
    price.dispose();
    promo.dispose();
    contact.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: Row(children: [
          ClipRRect(borderRadius: BorderRadius.circular(9), child: Image.asset('assets/logo_foto_produk_update.png', width: 38, height: 38, fit: BoxFit.cover)),
          const SizedBox(width: 9),
          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Foto Produk Update', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            Text('Studio desain iklan produk', style: TextStyle(fontSize: 10, color: Colors.black54)),
          ])),
        ]),
        actions: [
          IconButton(tooltip: 'AI Studio', onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AiStudioPage())), icon: const Icon(Icons.auto_awesome)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF30205E), Color(0xFF7957E8)]),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.asset('assets/logo_foto_produk_update.png', width: 54, height: 54, fit: BoxFit.cover)),
                const SizedBox(width: 10),
                const Expanded(child: Text('STUDIO IKLAN PRODUK', style: TextStyle(color: Color(0xFFDCD3FF), fontSize: 10, letterSpacing: 1.5, fontWeight: FontWeight.bold))),
              ]),
              SizedBox(height: 8),
              Text('Produk Anda,\ntampil lebih menarik.', style: TextStyle(color: Colors.white, fontSize: 24, height: 1.15, fontWeight: FontWeight.w800)),
              SizedBox(height: 8),
              Text('Pilih foto, atur gaya, lalu bagikan ke media sosial.', style: TextStyle(color: Colors.white70, fontSize: 12)),
            ]),
          ),
          const SizedBox(height: 22),
          sectionTitle('1. Foto produk', 'Pilih satu atau beberapa foto'),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: actionTile(Icons.photo_library_outlined, 'Galeri', choosePhotos)),
            const SizedBox(width: 10),
            Expanded(child: actionTile(Icons.camera_alt_outlined, 'Kamera', chooseCamera)),
          ]),
          if (photos.isNotEmpty) ...[
            const SizedBox(height: 10),
            SizedBox(
              height: 82,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: photos.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) => ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(photos[i], width: 82, height: 82, fit: BoxFit.cover),
                ),
              ),
            ),
            Text('${photos.length} foto dipilih', style: const TextStyle(fontSize: 11, color: Colors.black54)),
          ],
          const SizedBox(height: 22),
          sectionTitle('2. Informasi iklan', 'Bisa diubah kapan saja'),
          const SizedBox(height: 10),
          inputField('Nama produk', productName),
          const SizedBox(height: 9),
          Row(children: [
            Expanded(child: inputField('Harga', price, keyboard: TextInputType.text)),
            const SizedBox(width: 9),
            Expanded(child: inputField('Label promo', promo)),
          ]),
          const SizedBox(height: 9),
          inputField('Kontak / ajakan', contact),
          const SizedBox(height: 22),
          sectionTitle('3. Pilih gaya desain', 'Empat karakter visual'),
          const SizedBox(height: 10),
          Wrap(spacing: 8, runSpacing: 8, children: DesignStyle.values.map((s) {
            final selected = style == s;
            return ChoiceChip(
              avatar: Icon(s.icon, size: 17, color: selected ? Colors.white : const Color(0xFF6650B8)),
              label: Text(s.label),
              selected: selected,
              onSelected: (_) => setState(() => style = s),
            );
          }).toList()),
          const SizedBox(height: 22),
          sectionTitle('4. Ukuran media sosial', 'Pilih format keluaran'),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: format,
            decoration: fieldDecoration(),
            items: const [
              DropdownMenuItem(value: 'Status 9:16', child: Text('Status WA / Reels / TikTok — 9:16')),
              DropdownMenuItem(value: 'Feed 1:1', child: Text('Instagram Feed — 1:1')),
              DropdownMenuItem(value: 'Feed 4:5', child: Text('Facebook / Instagram — 4:5')),
            ],
            onChanged: (v) => setState(() => format = v ?? format),
          ),
          const SizedBox(height: 22),
          sectionTitle('5. Hasil desain', 'Pratinjau beberapa variasi'),
          const SizedBox(height: 8),
          if (photos.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
              child: const Column(children: [
                Icon(Icons.image_search_outlined, size: 42, color: Color(0xFF9B91BC)),
                SizedBox(height: 8),
                Text('Foto produk akan tampil di sini', style: TextStyle(fontWeight: FontWeight.w600)),
                SizedBox(height: 4),
                Text('Pilih foto dari galeri atau kamera untuk mulai.', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.black54)),
              ]),
            )
          else
            ...List.generate(photos.length, (photoIndex) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  Row(children: [
                    Text('Foto ${photoIndex + 1} • 10 variasi desain', style: const TextStyle(fontWeight: FontWeight.bold)),
                    const Spacer(),
                    Text('10 template', style: const TextStyle(color: Colors.black54, fontSize: 12)),
                  ]),
                  const SizedBox(height: 10),
                  ...List.generate(10, (variant) {
                    final key = GlobalKey();
                    final variantStyle = DesignStyle.values[(style.index + variant) % DesignStyle.values.length];
                    final exportIndex = photoIndex * 10 + variant;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                        Row(children: [
                          Text('Variasi ${variant + 1}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                          const Spacer(),
                          Text(variantStyle.label, style: const TextStyle(color: Colors.black54, fontSize: 11)),
                        ]),
                        const SizedBox(height: 6),
                        Center(child: RepaintBoundary(
                          key: key,
                          child: AdPreview(
                            photo: photos[photoIndex],
                            name: productName.text,
                            price: price.text,
                            promo: promo.text,
                            contact: contact.text,
                            style: variantStyle,
                            format: format,
                            variant: variant,
                          ),
                        )),
                        const SizedBox(height: 6),
                        OutlinedButton.icon(
                          onPressed: busy ? null : () => exportAndShare(key, exportIndex),
                          icon: const Icon(Icons.share_outlined),
                          label: Text(busy ? 'Memproses...' : 'Ekspor & bagikan variasi ${variant + 1}'),
                        ),
                      ]),
                    );
                  }),
                ]),
              );
            }),
          if (photos.isNotEmpty)
            FilledButton.icon(
              onPressed: busy ? null : () {
                FocusScope.of(context).unfocus();
                setState(() {});
                showMessage('Pratinjau diperbarui. Ekspor setiap desain melalui tombol di bawahnya.');
              },
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Perbarui pratinjau'),
            ),
          const SizedBox(height: 14),
          const Text('10 variasi ini merupakan template grafis otomatis berbasis foto dan teks, bukan hasil generasi AI. Penghapus background otomatis dan latar generatif masih memerlukan integrasi model AI atau layanan khusus.',
            style: TextStyle(fontSize: 11, color: Colors.black54, height: 1.4)),
        ],
      ),
    );
  }

  Widget sectionTitle(String title, String subtitle) => Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
      Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.black54)),
    ])),
  ]);

  Widget actionTile(IconData icon, String label, VoidCallback onTap) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(15),
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: const Color(0xFFE7E5EF))),
      child: Column(children: [
        Icon(icon, color: const Color(0xFF7056D8), size: 25),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
      ]),
    ),
  );

  InputDecoration fieldDecoration() => InputDecoration(
    filled: true, fillColor: Colors.white, contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(13), borderSide: const BorderSide(color: Color(0xFFE5E2ED))),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(13), borderSide: const BorderSide(color: Color(0xFFE5E2ED))),
  );

  Widget inputField(String label, TextEditingController controller, {TextInputType? keyboard}) => TextField(
    controller: controller, keyboardType: keyboard, onChanged: (_) => setState(() {}),
    decoration: fieldDecoration().copyWith(labelText: label),
  );
}

class AdPreview extends StatelessWidget {
  const AdPreview({super.key, required this.photo, required this.name, required this.price, required this.promo, required this.contact, required this.style, required this.format, required this.variant});
  final File photo;
  final String name, price, promo, contact, format;
  final DesignStyle style;
  final int variant;

  @override
  Widget build(BuildContext context) {
    final ratio = format == 'Feed 1:1' ? 1.0 : (format == 'Feed 4:5' ? 4 / 5 : 9 / 16);
    final colors = switch (style) {
      DesignStyle.mewah => (const Color(0xFF17131D), const Color(0xFFD7B66D), Colors.white),
      DesignStyle.minimalis => (Colors.white, const Color(0xFF252525), const Color(0xFF222222)),
      DesignStyle.modern => (const Color(0xFF3020A0), const Color(0xFFFFD84D), Colors.white),
      DesignStyle.elegan => (const Color(0xFFF0E9E0), const Color(0xFF8C5F54), const Color(0xFF332925)),
    };
    return ClipRRect(
      borderRadius: BorderRadius.circular(17),
      child: AspectRatio(
        aspectRatio: ratio,
        child: Container(
          width: 310,
          constraints: const BoxConstraints(maxWidth: 310),
          color: colors.$1,
          child: Stack(fit: StackFit.expand, children: [
            Positioned.fill(child: Image.file(photo, fit: BoxFit.cover)),
            Positioned.fill(child: DecoratedBox(decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
                colors: [Colors.black.withOpacity(.03), Colors.black.withOpacity(.04), colors.$1.withOpacity(.92)],
                stops: const [0, .48, 1]),
            ))),
            Positioned(left: variant.isEven ? 17 : null, right: variant.isEven ? 17 : null, top: 18, child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: variant % 3 == 0 ? colors.$2 : colors.$1.withOpacity(.72), borderRadius: BorderRadius.circular(30), border: Border.all(color: colors.$2.withOpacity(.8))), child: Text(promo.toUpperCase(), textAlign: TextAlign.center, style: TextStyle(color: variant % 3 == 0 ? colors.$1 : colors.$2, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.3)))),
            Positioned(left: 17, right: 17, bottom: 20, child: Container(padding: EdgeInsets.all(variant % 2 == 0 ? 0 : 10), decoration: BoxDecoration(color: variant % 2 == 0 ? Colors.transparent : colors.$1.withOpacity(.78), borderRadius: BorderRadius.circular(12), border: variant % 2 == 0 ? null : Border.all(color: colors.$2.withOpacity(.45))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
              Text(name, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: colors.$3, fontWeight: FontWeight.w900, fontSize: 23, height: 1.05)),
              const SizedBox(height: 7),
              Text(price, style: TextStyle(color: colors.$2, fontWeight: FontWeight.w900, fontSize: 20)),
              const SizedBox(height: 8),
              Container(height: 1, color: colors.$2.withOpacity(.65)),
              const SizedBox(height: 8),
              Text(contact, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: colors.$3, fontSize: 10, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text('FOTO PRODUK UPDATE', style: TextStyle(color: colors.$2, fontSize: 8, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
            ]))),
            if (variant % 3 == 1) Positioned(right: 15, top: 58, child: Icon(Icons.auto_awesome, color: colors.$2.withOpacity(.9), size: 24)),
            if (variant % 3 == 2) Positioned(left: 0, right: 0, bottom: 0, child: Container(height: 5, color: colors.$2)),
          ]),
        ),
      ),
    );
  }
}
