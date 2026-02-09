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
      title: 'Rüyam Exclusive',
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
  String _secilenIslem = 'Fön';

  Future<void> randevuKaydet() async {
    if (_adController.text.isEmpty || _telController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lütfen alanları doldurun!')));
      return;
    }
    try {
      await Supabase.instance.client.from('RuyamDB').insert({
        'Ad': _adController.text,
        'Tel': _telController.text,
        'Islem': _secilenIslem,
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Randevunuz Başarıyla Alındı! ✅'), backgroundColor: Colors.green));
      _adController.clear(); _telController.clear();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hata: $e'), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rüyam Exclusive'), backgroundColor: Colors.pink.shade100, centerTitle: true),
      body: Container(
        decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.pink.shade50, Colors.white])),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.auto_fix_high, size: 50, color: Colors.pink),
                    const SizedBox(height: 20),
                    TextField(controller: _adController, decoration: const InputDecoration(labelText: 'Ad Soyad', border: OutlineInputBorder())),
                    const SizedBox(height: 15),
                    TextField(controller: _telController, decoration: const InputDecoration(labelText: 'Telefon', border: OutlineInputBorder()), keyboardType: TextInputType.phone),
                    const SizedBox(height: 15),
                    DropdownButtonFormField<String>(
                      value: _secilenIslem,
                      decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'İşlem'),
                      onChanged: (v) => setState(() => _secilenIslem = v!),
                      items: ['Fön', 'Boya', 'Kesim', 'Makyaj'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: randevuKaydet,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.pink, minimumSize: const Size(double.infinity, 50)),
                      child: const Text('Randevu Al', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
