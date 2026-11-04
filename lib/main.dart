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
            child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            'assets/logo_foto_produk_update.png',
            width: 54,
            height: 54,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Text(
            'STUDIO IKLAN PRODUK',
            style: TextStyle(
              color: Color(0xFFDCD3FF),
              fontSize: 10,
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
    const SizedBox(height: 8),
    const Text(
      'Produk Anda,\ntampil lebih menarik.',
      style: TextStyle(
        color: Colors.white,
        fontSize: 24,
        height: 1.15,
        fontWeight: FontWeight.w800,
      ),
    ),
    const SizedBox(height: 8),
    const Text(
      'Pilih foto, atur gaya, lalu bagikan ke media sosial.',
      style: TextStyle(color: Colors.white70, fontSize: 12),
    ),
  ],
),
