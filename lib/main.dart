import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://cyhrdhttgtdbgwlbtbnw.supabase.co',
    anonKey: 'Sb_publishable_LIOI2vJC5XPa0Jxd1VXEEg_lxkuJWRh',
  );
  runApp(const RuyamApp());
}

class RuyamApp extends StatelessWidget {
  const RuyamApp({super.key});
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
  String _secilenIslem = 'Fön';

  Future<void> randevuKaydet() async {
    try {
      await Supabase.instance.client.from('RuyamDB').insert({
        'Ad': _adController.text,
        'Tel': _telController.text,
        'islem': _secilenIslem,
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Randevu Kaydedildi!')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hata: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rüyam Randevu'), backgroundColor: Colors.pink.shade100),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(controller: _adController, decoration: const InputDecoration(labelText: 'Ad Soyad')),
            TextField(controller: _telController, decoration: const InputDecoration(labelText: 'Telefon')),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: randevuKaydet, child: const Text('Randevu Al')),
          ],
        ),
      ),
    );
  }
}
