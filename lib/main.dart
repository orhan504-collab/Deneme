import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://cyhrdhttgtdbgwlbtbnw.supabase.co',
    anonKey: 'sb_publishable_LIOI2vJC5XPa0Jxd1VXEEg_lxkuJWRh',
  );
  runApp(const RuyamMusteriApp());
}

class RuyamMusteriApp extends StatelessWidget {
  const RuyamMusteriApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink), useMaterial3: true),
      home: const RandevuSayfasi(),
    );
  }
}

class RandevuSayfasi extends StatefulWidget {
  const RandevuSayfasi({super.key});
  @override
  State<RandevuSayfasi> createState() => _RandevuSayfasiState();
}

class _RandevuSayfasiState extends State<RandevuSayfasi> {
  final _adController = TextEditingController();
  final _telController = TextEditingController();
  String? _secilenIslem;

  // Veritabanından canlı ayarları çeker
  Stream<List<Map<String, dynamic>>> get _ayarlariGetir =>
      Supabase.instance.client.from('WebAyarlari').stream(primaryKey: ['id']);

  Future<void> randevuKaydet() async {
    if (_telController.text.isEmpty || _secilenIslem == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lütfen gerekli alanları doldurun!')));
      return;
    }
    try {
      await Supabase.instance.client.from('RuyamDB').insert({
        'Ad': _adController.text.isEmpty ? 'İsimsiz Müşteri' : _adController.text,
        'Tel': _telController.text,
        'Islem': _secilenIslem,
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Randevunuz Alındı! ✅'), backgroundColor: Colors.green));
      _adController.clear(); _telController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hata: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rüyam Exclusive'), centerTitle: true),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _ayarlariGetir,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          
          final ayarlar = snapshot.data!;
          final servislerRaw = ayarlar.firstWhere((e) => e['anahtar'] == 'servisler')['deger'] as String;
          final servisListesi = servislerRaw.split(',');
          final isimAktif = ayarlar.firstWhere((e) => e['anahtar'] == 'isim_aktif')['deger'] == 'true';
          _secilenIslem ??= servisListesi.first;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network('https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=1000', height: 200, width: double.infinity, fit: BoxFit.cover),
                ),
                const SizedBox(height: 20),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        if (isimAktif) ...[
                          TextField(controller: _adController, decoration: const InputDecoration(labelText: 'Ad Soyad', border: OutlineInputBorder())),
                          const SizedBox(height: 15),
                        ],
                        TextField(controller: _telController, decoration: const InputDecoration(labelText: 'Telefon', border: OutlineInputBorder())),
                        const SizedBox(height: 15),
                        DropdownButtonFormField<String>(
                          value: _secilenIslem,
                          items: servisListesi.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                          onChanged: (v) => setState(() => _secilenIslem = v),
                          decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'İşlem Seçin'),
                        ),
                        const SizedBox(height: 25),
                        ElevatedButton(onPressed: randevuKaydet, child: const Text('Randevu Al')),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
